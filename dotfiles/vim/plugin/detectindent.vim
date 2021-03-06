" Name:          detectindent (global plugin)
" Version:       1.0
" Author:        Ciaran McCreesh <ciaran.mccreesh at googlemail.com>
" Updates:       http://github.com/ciaranm/detectindent
" Purpose:       Detect file indent settings
"
" License:       You may redistribute this plugin under the same terms as Vim
"                itself.
"
" Usage:         :DetectIndent
"
"                " to prefer expandtab to noexpandtab when detection is
"                " impossible:
"                :let g:detectindent_preferred_expandtab = 1
"
"                " to set a preferred indent level when detection is
"                " impossible:
"                :let g:detectindent_preferred_indent = 4
"
" Requirements:  Untested on Vim versions below 6.2

if exists("loaded_detectindent")
    finish
endif
let loaded_detectindent = 1

fun! <SID>IsCommentStart(line)
    " &comments isn't reliable
    if &ft == "c" || &ft == "cpp"
        return -1 != match(a:line, '/\*')
    else
        return 0
    endif
endfun

fun! <SID>IsCommentEnd(line)
    if &ft == "c" || &ft == "cpp"
        return -1 != match(a:line, '\*/')
    else
        return 0
    endif
endfun

fun! <SID>DetectIndent()
    let l:has_leading_tabs            = 0
    let l:has_leading_spaces          = 0
    let l:shortest_leading_spaces_run = 0
    let l:longest_leading_spaces_run  = 0
    let l:max_lines                   = 1024
    if exists("g:detectindent_max_lines_to_analyse")
      let l:max_lines = g:detectindent_max_lines_to_analyse
    endif

    let l:idx_end = line("$")
    let l:idx = 1
    while l:idx <= l:idx_end
        let l:line = getline(l:idx)

        " try to skip over comment blocks, they can give really screwy indent
        " settings in c/c++ files especially
        if <SID>IsCommentStart(l:line)
            while l:idx <= l:idx_end && ! <SID>IsCommentEnd(l:line)
                let l:idx = l:idx + 1
                let l:line = getline(l:idx)
            endwhile
            let l:idx = l:idx + 1
            continue
        endif

        " Skip lines that are solely whitespace, since they're less likely to
        " be properly constructed.
        if l:line !~ '\S'
            let l:idx = l:idx + 1
            continue
        endif

        let l:leading_char = strpart(l:line, 0, 1)

        if l:leading_char == "\t"
            let l:has_leading_tabs = 1

        elseif l:leading_char == " "
            " only interested if we don't have a run of spaces followed by a
            " tab.
            if -1 == match(l:line, '^ \+\t')
                let l:has_leading_spaces = 1
                let l:spaces = strlen(matchstr(l:line, '^ \+'))
                if l:shortest_leading_spaces_run == 0 ||
                            \ l:spaces < l:shortest_leading_spaces_run
                    let l:shortest_leading_spaces_run = l:spaces
                endif
                if l:spaces > l:longest_leading_spaces_run
                    let l:longest_leading_spaces_run = l:spaces
                endif
            endif

        endif

        let l:idx = l:idx + 1

        let l:max_lines = l:max_lines - 1

        if l:max_lines == 0
            let l:idx = l:idx_end + 1
        endif

    endwhile

    if l:has_leading_tabs && ! l:has_leading_spaces
        " tabs only, no spaces
        setl noexpandtab
        if exists("g:detectindent_preferred_indent")
            let &l:shiftwidth  = g:detectindent_preferred_indent
            let &l:tabstop     = g:detectindent_preferred_indent
        endif

    elseif l:has_leading_spaces && ! l:has_leading_tabs
        " spaces only, no tabs
        setl expandtab
        let &l:shiftwidth  = l:shortest_leading_spaces_run
        let &l:softtabstop = l:shortest_leading_spaces_run

    elseif l:has_leading_spaces && l:has_leading_tabs
        " spaces and tabs
        setl noexpandtab
        let &l:shiftwidth = l:shortest_leading_spaces_run

        " mmmm, time to guess how big tabs are
        if l:longest_leading_spaces_run < 2
            let &l:tabstop = 2
        elseif l:longest_leading_spaces_run < 4
            let &l:tabstop = 4
        else
            let &l:tabstop = 8
        endif

    else
        " no spaces, no tabs
        if exists("g:detectindent_preferred_indent") &&
                    \ exists("g:detectindent_preferred_expandtab")
            setl expandtab
            let &l:shiftwidth  = g:detectindent_preferred_indent
            let &l:softtabstop = g:detectindent_preferred_indent
        elseif exists("g:detectindent_preferred_indent")
            setl noexpandtab
            let &l:shiftwidth  = g:detectindent_preferred_indent
            let &l:tabstop     = g:detectindent_preferred_indent
        elseif exists("g:detectindent_preferred_expandtab")
            setl expandtab
        else
            setl noexpandtab
        endif

    endif
endfun

command! -nargs=0 DetectIndent call <SID>DetectIndent()

