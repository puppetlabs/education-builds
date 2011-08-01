;; Initial loading
(mapc (lambda (x) (add-to-list 'load-path (expand-file-name x)))
      '("~/.emacs.d"
        ))

;; Global config
(menu-bar-mode 0)
(tool-bar-mode 0)
(setq-default indent-tabs-mode nil)
(setq indent-tabs-mode nil)
(setq make-backup-files nil)

;; Puppet settings
(add-to-list 'auto-mode-alist '("\\.pp$" . puppet-mode))

;; Automatic custom variables
(custom-set-variables
 '(require-final-newline t)
 '(scroll-conservatively 100000)
 '(scroll-down-aggressively 0.0)
 '(scroll-margin 4)
 '(scroll-step 1)
 '(scroll-up-aggressively 0.0))
