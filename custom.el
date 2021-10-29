(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-visited-mode t)
 '(custom-safe-themes
   '("2f1518e906a8b60fac943d02ad415f1d8b3933a5a7f75e307e6e9a26ef5bf570" "99ea831ca79a916f1bd789de366b639d09811501e8c092c85b2cb7d697777f93" "dde8c620311ea241c0b490af8e6f570fdd3b941d7bc209e55cd87884eb733b0e" "a3b6a3708c6692674196266aad1cb19188a6da7b4f961e1369a68f06577afa16" "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" default))
 '(safe-local-variable-values
   '((eval face-remap-add-relative 'org-level-4
           '(default))
     (eval face-remap-add-relative 'org-level-3
           '(face-salient default))
     (eval face-remap-add-relative 'org-level-2
           '(face-strong face-salient))
     (org-html-link-org-files-as-html)
     (eval add-hook 'after-save-hook
           (lambda nil
             (org-html-export-to-html nil))
           t t))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(put 'narrow-to-region 'disabled nil)
