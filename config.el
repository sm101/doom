;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Stevan Markovic"
      user-mail-address "smarkovi@akamai.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one
      doom-font (font-spec :family "JetBrains Mono" :size 12 :weight 'light)
)

;; (setq doom-theme 'doom-one
;;       doom-font (font-spec :family "Source Code Pro" :size 12 :weight 'light))

;; smartparens remap org-demote, org-promote keys M-LEFT SHIFT and M-RIGHT SHIFT
(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")
(setq org-log-done 'time)

(after! org
        (setq org-roam-directory "~/org")
        (setq org-agenda-include-diary t)
        (setq org-tag-alist '(("role" . ?r) ("management" . ?n) ("plan" . ?p)
   ("meeting" . ?m) ("engineer" . ?e) ("poor-org-omissions" . ?s)
   ("accomplish" . ?a) ("time-consuming-disruption" . ?t) ("people" . ?l)))
        )

;; (setq org-tag-alist '(("role" . ?r) ("management" . ?n) ("plan" . ?p)
;;    ("meeting" . ?m) ("engineer" . ?e) ("poor-org-omissions" . ?s)
;;    ("accomplish" . ?a) ("time-consuming-disruption" . ?t) ("people" . ?l)))

;;; org-protocol support
(use-package! org-protocol
  :config
  (setq org-capture-templates
        '(
          ("o" "Link capture" entry
           (file+headline "~/org/org-linkz/Linkz.org" "INBOX")
           "* %a %U"
           :immediate-finish t)
	  )
	)
  (setq org-protocol-default-template-key "o")
  (setq org-html-validation-link nil)
  )

;; Otherwise it opened stevan-pc auth dialog
;; (use-package! tramp
;;         :config
;;         (setq tramp-completion-use-auth-sources nil))
;;
(after! tramp
  (add-to-list 'tramp-methods
 '("gwsh"
  (tramp-login-program "gwsh")
  (tramp-login-args
    (
      ("-l" "testgrp")
     ;; ("-p" "%p")
     ("%c")
;; ("-e" "none")
     ("%h")))
   (tramp-async-args
    (("-q")))
   (tramp-direct-async t)
   (tramp-remote-shell "/bin/sh")
   (tramp-remote-shell-login
    ("-l"))
   (tramp-remote-shell-args
    ("-c"))))
  (setq tramp-debug-to-file t))


;; Python formatter.
(use-package! yapfify)

;; -- 4/25/2024 not supported anymore
;; (use-package lsp-grammarly
;;   :ensure t
;;   :hook (text-mode . (lambda ()
;;                        (require 'lsp-grammarly)
;;                        (lsp))))  ; or lsp-deferred

;; Activate snippets
(yas-global-mode 1)
(add-hook `yas-minor-mode-hook (lambda () (yas-activate-extra-mode 'fundamental-mode)))
;;;
;;; Protocol buffers mode
;;; (use-package! protobuf-mode)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)
;; Frame size
(add-to-list 'default-frame-alist '(height . 53))
(add-to-list 'default-frame-alist '(width . 120))

;; Map key <escape> but _only_ after god-mode is initialized.
(map! :after god-mode "<escape>" #'god-local-mode)

;; This has key map overlap
;;
;; (global-ede-mode t)
;; (ede-cpp-root-project "bbm"
;;    :name "bbm"
;;    :file "~/sources/ede.anchor"
;;    )

;; set clangd options and priority (in case ccls is also installed)
(setq lsp-clients-clangd-args '("-j=3"
				"--background-index"
				"--clang-tidy"
				"--completion-style=detailed"
				"--header-insertion=never"
				"--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))


(use-package! go-translate)
;; Move this to use-package config:
;;
;;(setq gt-langs '(en fr))
(setq gt-langs '(en sr))
(setq gt-default-translator (gt-translator :engines (gt-google-engine)
                                           :taker (gt-taker :prompt t :text 'paragraph)
                                           :render (gt-insert-render)))

;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted s    ymbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
