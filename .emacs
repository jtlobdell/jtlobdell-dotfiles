(require 'package)
(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/") t)

(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "https://elpa.gnu.org/packages/")))
(package-initialize)

(setq package-list '(helm-xref helm-projectile lua-mode highlight-symbol helm ggtags))

;; activate all the packages
(package-initialize)

;; fetch the list of packages available
(unless package-archive-contents
  (package-refresh-contents))

;; install missing packages
(dolist (package package-list)
  (unless (package-installed-p package)
	(package-install package)))


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(custom-enabled-themes (quote (wombat)))
 '(frame-background-mode (quote dark))
 '(package-selected-packages
   (quote
	(lua-mode highlight-symbol helm-xref helm-projectile))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(term-color-black ((t (:foreground "#161616"))))
 '(term-color-blue ((t (:foreground "#5283d7"))))
 '(term-color-cyan ((t (:foreground "#a8c6f2"))))
 '(term-color-green ((t (:foreground "#cae682"))))
 '(term-color-magenta ((t (:foreground "#b698d9"))))
 '(term-color-red ((t (:foreground "#e5786d"))))
 '(term-color-white ((t (:foreground "#f6f3e8"))))
 '(term-color-yellow ((t (:foreground "#ffe161")))))


;; Formatting rules for C-style codes
(c-add-style "my-c-style"
			 '("k&r"
			   (c-echo-syntactic-information-p 1)
			   (c-comment-only-line-offset . (0 . 0))
			   (c-offsets-alist . (
				   (topmost-intro . 0)
				   
				   ;; Function Symbols
				   (defun-open . 0)
				   (defun-block-intro . +)
				   (statement . 0)
				   (defun-close . -)
				   
				   ;; Class Symbols
				   (class-open . 0)
				   (inher-intro . +)
				   (inher-cont . 0)
				   (inclass . +)
				   (access-label . -) ;; counters inclass on previous line --> 0
				   (member-init-intro . +)
				   (member-init-cont . 0)
				   (inline-open . 0)
				   (template-args-cont . +)
				   (class-close . -)

				   ;; Conditional Constructs
				   (substatement-open . 0)
				   (statement-block-intro . +)
				   (block-close . 0)

				   ;; Switch Statements
				   (case-label . 0)
				   (case-label . +)
				   (statement-case-open . +)

				   ;; Brace List Symbols
				   (brace-list-open . 0)
				   (brace-list-intro . +)
				   (brace-list-entry . 0)
				   (brace-list-close . 0)

				   ;; External Scope Symbols
				   (extern-lang-open . 0)
				   (inextern-lang . 1)
				   (extern-lang-close . -)
				   (namespace-open . 0)
				   (innamespace . 0)
				   (namespace-close . 0)

				   ;; Parenthesis (Argument) List Symbols
				   (arglist-intro . +)
				   (arglist-cont-nonempty . c-lineup-arglist)
				   (arglist-cont . 0)
				   (arglist-close . 0)

				   ;; Literal Symbols
				   (func-decl-cont . 0)
				   (stream-op . +) ;; really want this to line up

				   ;; Multiline Macro Symbols

				   ;; Other bullshit languages
				   ;; K&R bullshit
				   )
				)
	       )
	     )

(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if
  ;; neither, we use the current indent-tabs-mode
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))

(defun my-c-mode-hook-fn ()
  (c-set-style "my-c-style")
  (setq indent-tabs-mode nil)
  (setq c-basic-offset 4)
  (infer-indentation-style)
)

(setq c-default-style "my-c-style")
(setq-default c-basic-offset 4)
(setq-default tab-width 4)
(setq-default c-auto-newline nil)

(add-hook 'c-mode-hook 'my-c-mode-hook-fn)
(add-hook 'c++-mode-hook 'my-c-mode-hook-fn)


;; Helm config

(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(global-set-key (kbd "M-x") 'helm-M-x)
(setq helm-M-x-fuzzy-match t) ;; optional fuzzy matching for helm-M-x

(global-set-key (kbd "M-y") 'helm-show-kill-ring)

(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

;; unset default 'buffer list' command. it's very annoying to accidentally
;; split the pane when I meant to use helm.
(global-unset-key (kbd "C-x C-b"))

(global-set-key (kbd "C-x C-f") 'helm-find-files)

(when (executable-find "ack-grep")
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
	helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t   ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     nil ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t   ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8   ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 40)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode t)

(setq helm-semantic-fuzzy-match t
      helm-imenu-fuzzy-match    t)

(add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages)

(helm-mode 1)


;; Helm Dash
(setq helm-dash-browser-func 'eww)


;; Code highlighting
(add-hook 'prog-mode-hook #'highlight-symbol-mode)
(setq highlight-symbol-idle-delay 0.5)

;; helm-projectile-grep hotkey ('opposite' of M-.)
(global-set-key (kbd "C-.") 'helm-projectile-grep)


;; Save/restore emacs state when quitting/starting
(desktop-save-mode 1)

;; Stop polluting my working directory
(setq backup-directory-alist `(("." . "~/.emacs.d/backups")))

;; org mode -- collapse section when tab is hit with cursor inside section
(setq org-cycle-emulate-tab 'white)

;; Unset these because I constantly minimize emacs when I'm saving
(global-unset-key "\C-z")
(global-unset-key "\C-xz")
(global-unset-key "\C-x\C-z")

;; Org-mode: Collapse a section while in that section
(setq org-cycle-emulate-tab 'white)
