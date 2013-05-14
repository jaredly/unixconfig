(defun read-lines (file)
  (with-temp-buffer
    (message "hellO")
    (insert-file-contents file)
    (split-string
     (buffer-string) "\n" t)
    ))

(defun load-my-packages (file)
  (dolist (pkg (read-lines file))
    (message (concat "Checking: " pkg))
    (when (not (package-installed-p (intern pkg)))
               (message (concat "nstalling " pkg))
	       (package-install (intern pkg)))))

(load-my-packages my-packages-file)

;; when installing a file, add it to the "my-packages" file

(defun add-package-to-my-list (pkg pkglist)
  (with-temp-buffer
    (insert-file-contents pkglist)
    (point-max)
    (insert (concat "\n" pkg))
    (write-file pkglist)
    ))

(defadvice package-install (after package-install-savepkg)
  (add-package-to-my-list (ad-get-arg 0) my-packages-file))
