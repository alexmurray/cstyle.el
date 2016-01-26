;;; cstyle.el --- Front-end for cstyle

;;; Commentary:
;;

;;; Code:
(require 'compile)

(defcustom cstyle-executable
  "~/cstyle/cstyle.py"
  "Name / path to the cstyle executable to use."
  :type 'string
  :group 'cstyle)

(defcustom cstyle-config
  "~/.cstyle"
  "Path to the configuration file to use."
  :type 'string
  :group 'cstyle)

(define-compilation-mode cstyle-mode "CS"
  "cstyle results compilation mode")

(define-key cstyle-mode-map (kbd "p") #'compilation-previous-error)
(define-key cstyle-mode-map (kbd "n") #'compilation-next-error)
(define-key cstyle-mode-map (kbd "k") '(lambda () (interactive)
                                         (let (kill-buffer-query-functions) (kill-buffer))))
(defun cstyle (filename)
  "Run cstyle on FILENAME."
  (interactive (read-file-name "File: "))
  (let ((command (mapconcat #'shell-quote-argument
                            (list (expand-file-name cstyle-executable)
                                  "--config" (expand-file-name cstyle-config)
                                  filename)
                            " ")))
    (compilation-start command #'cstyle-mode
                       #'(lambda (mode-name) (format "*%s:%s" mode-name filename)))))

(defun cstyle-buffer (&optional buffer)
  "Run cstyle on BUFFER."
  (interactive)
  (cstyle (buffer-file-name buffer)))

(provide 'cstyle)

;;; cstyle.el ends here
