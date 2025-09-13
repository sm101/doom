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
;; doom-one was default
(setq doom-theme 'doom-oceanic-next
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

;; Load secrets if file exists
(let ((secrets-file (doom-path doom-user-dir "secrets.el")))
  (when (file-exists-p secrets-file)
    (load secrets-file)))

(defvar my/org-agenda-files-work '("~/org/work")
  "Work org agenda files.")

(defvar my/org-agenda-files-personal '("~/org/personal")
  "Personal org agenda files.")

(defvar my/org-agenda-context 'work
  "Current org agenda context.")

(defun my/toggle-org-agenda-files ()
  "Toggle between work and personal org-agenda-files."
  (interactive)
  (if (eq my/org-agenda-context 'work)
      (progn
        (setq org-agenda-files my/org-agenda-files-personal)
        (setq my/org-agenda-context 'personal)
        (message "Switched to personal org-agenda-files"))
    (setq org-agenda-files my/org-agenda-files-work)
    (setq my/org-agenda-context 'work)
    (message "Switched to work org-agenda-files")))

(after! org
  (setq org-roam-directory "~/org")
  (setq org-agenda-include-diary t)
  (setq org-capture-templates
        `(("j" "Journal" entry
          (file+olp+datetree +org-capture-journal-file)
          "* %U %?\n%i\n%a" :prepend t))
        )
  (add-to-list 'org-latex-packages-alist '("" "minted"))
  (setq org-latex-listings-options '(("breaklines" "true")))
  (setq org-latex-src-block-backend 'minted)
  (setq org-latex-pdf-process
      '("pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"
        "pdflatex -shell-escape -interaction nonstopmode -output-directory %o %f"))
  (setq org-agenda-custom-commands
      '(("w" "Work Agenda"
         ((agenda "" ((org-agenda-files my/org-agenda-files-work))
          (tags "work-priority") )  ;; Add other custom views as needed
         ))
        ("p" "Personal Agenda"
         ((agenda "" ((org-agenda-files my/org-agenda-files-personal))
          (tags "home-priority") )  ;; Add other custom views as needed
         ))
        ))

  )

(map! :after org :map org-mode-map "C-c T" #'my/toggle-org-agenda-files)

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

(yas-global-mode 1)
(add-hook `yas-minor-mode-hook (lambda () (yas-activate-extra-mode 'fundamental-mode)))
;;;
;;; Protocol buffers mode
;;; (use-package! protobuf-mode)


(setq display-line-numbers-type nil)
;; Frame size
(add-to-list 'default-frame-alist '(fullscreen . fullheight))
(add-to-list 'default-frame-alist '(width . 145))
(add-to-list 'default-frame-alist '(top . 5))
(add-to-list 'default-frame-alist '(left . 5))

;; Map key <escape> but _only_ after god-mode is initialized.
(map! :after god-mode "<escape>" #'god-local-mode)

;; set clangd options and priority (in case ccls is also installed)
(setq lsp-clients-clangd-args '("-j=3"
                                "--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

(use-package! gt)
(setq gt-langs '(en es sr))
(setq gt-default-translator (gt-translator :engines (gt-google-engine)
                                           :taker (gt-taker :prompt t :text 'paragraph)
                                           :render (gt-insert-render)))
(use-package! chatgpt-shell)
(use-package! gptel
 :config
 (setq! gptel-api-key chatgpt-shell-openai-key))

(gptel-make-anthropic "Claude" :stream t :key chatgpt-shell-anthropic-key)

(use-package! dall-e-shell
  :config
  (setq dall-e-shell-openai-key chatgpt-shell-openai-key))

;; (if (string-equal (system-name) "fll-mpmn2")
;; mu4 settings
;; (add-to-list 'load-path "/opt/homebrew/Cellar/mu/1.12.9/share/emacs/site-lisp/mu/mue4")

(set-email-account! "Stevan Akamai"
                    '((mu4e-sent-folder       . "/Sent Items")
                      (mu4e-drafts-folder     . "/Drafts")
                      (mu4e-trash-folder      . "/Deleted items"))
                    t)
(setq +mu4e-backend 'offlineimap)

(after! mu4e
  (setq sendmail-program (executable-find "msmtp")
        send-mail-function #'smtpmail-send-it
        message-sendmail-f-is-evil t
        message-sendmail-extra-arguments '("--read-envelope-from")
        message-send-mail-function #'message-send-mail-with-sendmail
        mu4e-update-interval 15)
  )

(setq
 smtpmail-default-smtp-server "smtp.akamai.com"
 smtpmail-smtp-server         "smtp.akamai.com"
 smtpmail-local-domain        "akamai.com")

;; Setup motmuch
(setq notmuch-backend 'offlineimap)
(setq +notmuch-sync-backend 'offlineimap)

(org-babel-do-load-languages 'org-babel-load-languages
                             '((jq . t)))

;; https://github.com/copilot-emacs/copilot.el
(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))
(use-package! copilot-chat)
(use-package! exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

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
