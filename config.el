;;; config.el --- -*- lexical-binding: t; -*-
(setq user-full-name "Stevan Markovic"
      user-mail-address "smarkovi@akamai.com")

(setq doom-theme 'doom-one
      doom-font (font-spec :family "JetBrains Mono" :size 13 :weight 'light)
      ;; doom-font (font-spec :family "Iosevka" :size 14)
      ;; doom-variable-pitch-font (font-spec :family "Iosevka" :size 14)
      ;; doom-big-font (font-spec :family "Iosevka" :size 20)
      )

(after! doom-modeline
  (setq display-time-default-load-average nil)
  (setq doom-modeline-time t)
  (display-time-mode 1))

(custom-set-faces!
  '(font-lock-function-call-face :slant normal))

;; Frame size
(add-to-list 'default-frame-alist '(fullscreen . fullheight))
(add-to-list 'default-frame-alist '(width . 145))
(add-to-list 'default-frame-alist '(top . 5))
(add-to-list 'default-frame-alist '(left . 5))

(setq display-line-numbers-type nil)

(remove-hook 'doom-first-buffer-hook #'smartparens-global-mode)

(let ((secrets-file (doom-path doom-user-dir "secrets.el")))
  (when (file-exists-p secrets-file)
    (load secrets-file)))

;; (use-package! chatgpt-shell)
(use-package! gptel)
 
;; set default backend and model. 
(setq gptel-model 'claude-opus-4-6
      gptel-backend (gptel-make-anthropic "Claude" :stream t :key chatgpt-shell-anthropic-key))

(gptel-make-xai "xAI" 
  :stream t
  :key xAi-key)

;;register openai, can be selected in menu
(gptel-make-openai "ChatGPT" :key chatgpt-shell-openai-key)

(use-package! gt)
(setq gt-langs '(en es sr))
(setq gt-default-translator (gt-translator :engines (gt-google-engine)
                                           :taker (gt-taker :prompt t :text 'paragraph)
                                           :render (gt-insert-render)))

(setq org-directory "~/org/")
(setq org-log-done 'time)

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
  (setq org-agenda-files my/org-agenda-files-work) 
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
     ("%c")
     ("%h")))
  (tramp-async-args
   (("-q")))
  (tramp-direct-async t)
  (tramp-remote-shell "/bin/sh")
  (tramp-remote-shell-login
   ("-l"))
  (tramp-remote-shell-args
   ("-c"))))
  (setq tramp-debug-to-file t)
  ;; Include the remote shell's $PATH so pip-installed tools (e.g. in
  ;; ~/.local/bin) are visible to eglot language servers over tramp.
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

;; Python formatter.
(use-package! yapfify)
(yas-global-mode 1)
(add-hook `yas-minor-mode-hook (lambda () (yas-activate-extra-mode 'fundamental-mode)))

;;;
;;; Protocol buffers mode
;;; (use-package! protobuf-mode)

;; Map key <escape> but _only_ after god-mode is initialized.
(map! :after god-mode "<escape>" #'god-local-mode)

(setq lsp-clients-clangd-args '("--background-index"
                                "--clang-tidy"
                                "--completion-style=detailed"
                                "--header-insertion=never"
                                "--header-insertion-decorators=0"))
(after! lsp-clangd (set-lsp-priority! 'clangd 2))

(after! lsp-mode
  (lsp-register-client
   (make-lsp-client
    :new-connection (lsp-tramp-connection "clangd")
    :major-modes '(c-mode c++-mode)
    :remote? t
    :server-id 'clangd-remote)))

(after! eglot
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode c-ts-mode c++-ts-mode)
                 "clangd"
                 "--background-index"
                 "--clang-tidy"
                 "--completion-style=detailed"
                 "--header-insertion=never"
                 "--header-insertion-decorators=0"))
  (setq eglot-connect-timeout 60))

(after! consult
  (setq consult-async-min-input 4
        consult-async-refresh-delay 0.5
        consult-async-input-debounce 0.3))

;; In support of faster remote editing, we can disable some features that are
;; slow over TRAMP. For example, we can disable VC (version control) checks on
;; remote files, which can significantly speed up operations when working with
;; files over SSH or other remote protocols.

;; Don't let VC (git checks) touch remote files — big speedup
(setq remote-file-name-inhibit-cache nil
      vc-ignore-dir-regexp (format "%s\\|%s"
                                   vc-ignore-dir-regexp
                                   tramp-file-name-regexp))

(after! projectile
    (setq projectile-enable-caching t
        projectile-indexing-method 'alien
        projectile-mode-line-function (lambda () " Proj")
        projectile-generic-command
           "rg -0 --files --color=never --hidden -g!.git -g!.svn -g!.cache"))

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
;; darwin only, since copilot is only on my macbook, not on linux remote servers.
(when (eq system-type 'darwin) 
  (use-package! copilot
    :hook (prog-mode . copilot-mode)
    :bind (:map copilot-completion-map
                ("<tab>" . 'copilot-accept-completion)
                ("TAB" . 'copilot-accept-completion)
                ("C-TAB" . 'copilot-accept-completion-by-word)
                ("C-<tab>" . 'copilot-accept-completion-by-word))))

(use-package! exec-path-from-shell
  :config
  (exec-path-from-shell-initialize))

(defvar-local my/dict-languages '("en")
  "Languages for spell-fu and cape-dict. Default is English only.
Override per buffer via file-local variables, e.g.:
  my/dict-languages: (\"en\" \"sr-Latn\")")
(put 'my/dict-languages 'safe-local-variable #'listp)

(defun my/build-cape-dictionary ()
  "Build or return cached combined word list for languages in my/dict-languages."
  (let* ((key (string-join (sort (copy-sequence my/dict-languages) #'string<) "-"))
         (dict-dir (expand-file-name "dicts" doom-data-dir))
         (combined (expand-file-name (format "words-%s.txt" key) dict-dir))
         (word-files (delq nil
                           (mapcar (lambda (lang)
                                     ;; spell-fu registers English as "default" (line 385 of spell-fu.el:
                                     ;; `(or ispell-local-dictionary ispell-dictionary "default")`).
                                     (let* ((dict (spell-fu-get-ispell-dictionary
                                                   (if (string= lang "en") "default" lang)))
                                            (f (spell-fu--words-file dict)))
                                       (when (file-exists-p f) f)))
                                   my/dict-languages))))
    (when (= (length word-files) (length my/dict-languages))
      (unless (file-exists-p combined)
        (make-directory dict-dir t)
        (with-temp-buffer
          (dolist (f word-files)
            (insert-file-contents f)
            (goto-char (point-max)))
          (let ((process-environment (cons "LC_ALL=C" process-environment)))
            (call-process-region (point-min) (point-max) "sort" t t nil "-u"))
          (write-region (point-min) (point-max) combined)))
      combined)))

;; Use hack-local-variables-hook so my/dict-languages is read after file-local
;; variables are applied — mode hooks fire before that, so they see the default.
(after! spell-fu
  (add-hook 'hack-local-variables-hook
            (lambda ()
              (when spell-fu-mode
                (dolist (lang my/dict-languages)
                  (unless (string= lang "en")
                    (spell-fu-dictionary-add (spell-fu-get-ispell-dictionary lang))))))))

;; after! spell-fu only (not cape): cape loads lazily on first completion trigger,
;; so after! (spell-fu cape) would miss the hook on the first buffer visit after a
;; fresh Emacs start. If the combined dict file is not auto-created, call
;; (my/build-cape-dictionary) manually, then revert the buffer.
(after! spell-fu
  (add-hook 'hack-local-variables-hook
            (lambda ()
              (when (derived-mode-p 'text-mode)
                (when-let (dict (my/build-cape-dictionary))
                  (setq-local cape-dict-file dict)
                  (add-hook 'completion-at-point-functions #'cape-dict nil t))))))

;; ispell-completion-at-point duplicates what cape-dict already provides but
;; ignores my/dict-languages, always completing from the global ispell dictionary
;; (English by default). This causes English words to appear in non-English
;; buffers even when cape-dict-file is set to a language-specific word list.
;; Removed in hack-local-variables-hook (not with-eval-after-load) because mode
;; hooks add it after ispell loads, so earlier removal has no effect.
(after! spell-fu
  (add-hook 'hack-local-variables-hook
            (lambda ()
              (when (derived-mode-p 'text-mode)
                (remove-hook 'completion-at-point-functions
                             #'ispell-completion-at-point t)))))
