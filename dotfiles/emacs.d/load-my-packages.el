(defun read-lines (file)
  (with-temp-buffer
    (insert-file-contents file)
    (split-string
     (buffer-string) "\n" t)
    ))

(defun load-my-packages (file)
  ; fetch the list of packages available 
  (when (not package-archive-contents)
    (package-refresh-contents))
  ; go through and install packages
  (dolist (pkg (read-lines file))
    (when (not (package-installed-p (intern pkg)))
               (message (concat "Installing package " pkg))
	       (package-install (intern pkg)))))

(load-my-packages my-packages-file)

;; when installing a file, add it to the "my-packages" file

(defun add-package-to-my-list (pkg pkglist)
  (with-temp-buffer
    (insert-file-contents pkglist)
    (insert (concat pkg "\n"))
    (write-file pkglist)
  ))

(defadvice package-install (before package-install-savepkg activate)
  (when (not (package-installed-p (ad-get-arg 0)))
    (add-package-to-my-list (symbol-name (ad-get-arg 0)) my-packages-file)
  ))
