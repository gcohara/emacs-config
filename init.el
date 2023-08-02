;;; package --- Summary
;;; Commentary:
;; Package manager stuff
;;; Code:
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;; PACKAGE ZONE ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))
(add-to-list 'package-archives
             '("gnu" . "https://elpa.gnu.org/packages/"))

;; (package-initialize)
;; (package-refresh-contents)
;; Change font
(set-frame-font "IBM Plex Mono-14" nil t)


;; USE-PACKAGE 
;; Package used for configuration, loading, and downloading of packages
;; :init to run code before loading,
;; :config to run code after loading
(eval-when-compile (require 'use-package))

;; ORG-MODE
(use-package org
  :bind ("C-c a" . org-agenda)
  (:map org-mode-map
        ("<M-right>" . nil)
        ("<M-left>" . nil)
        ("s-<left>" . org-metaleft)
        ("s-<right>" . org-metaright)
        ("C-S-<left>" . org-shiftleft)
        ("C-S-<right>" . org-shiftright)
        )
  (:map org-read-date-minibuffer-local-map
        ("C-S-<left>" . (lambda () (interactive)
                          (org-eval-in-calendar '(calendar-backward-day 1))))
        ("C-S-<right>" . (lambda () (interactive)
                           (org-eval-in-calendar '(calendar-forward-day 1))))
        ("C-S-<up>" . (lambda () (interactive)
                        (org-eval-in-calendar '(calendar-backward-week 1))))
        ("C-S-<down>" . (lambda () (interactive)
                          (org-eval-in-calendar '(calendar-forward-week 1)))))
  
  :config
  (setq
   org-log-done 'time
   org-startup-indented t
   org-startup-folded t
   org-log-state-notes-insert-after-drawers t
   org-log-state-notes-into-drawer t
   org-agenda-dim-blocked-tasks 'invisible
   org-insert-heading-respect-content t
   org-blank-before-new-entry '((heading . auto) (plain-list-item . nil))
   org-cycle-separator-lines -1
   org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t%s%b")
                              (todo . " %i %-12:c%b")
                              (tags . " %i %-12:c%b")
                              (search . " %i %-12:c%b"))
   org-agenda-breadcrumbs-separator ">"
   org-clock-mode-line-total 'current
   org-archive-location "~/org/archive::* From %s"))


(if (string-equal system-name "FJH6HCXTJN")
    ;; Work refile and agenda
    (setq org-agenda-files (list "~/org/organiser.org")
          org-agenda-todo-list-sublevels nil
          )
  ;; Home refile and agenda
  (setq org-refile-targets '(("repeated.org" :maxlevel . 1)
                             ("diary.org" :maxlevel . 1)
                             ("!todo.org" :maxlevel . 1)
                             ("zbacklog.org" :maxlevel . 1)
                             ("projects.org" :maxlevel . 1)
                             ("piano.org" :maxlevel . 1))
        org-refile-use-outline-path 'file))

;; ADAPTIVE-WRAP
;; Makes wrapped lines indented
(use-package adaptive-wrap :ensure)
(setq adaptive-wrap-extra-indent 2)
(adaptive-wrap-prefix-mode)

;; SIMPLECLIP
;; Make the Emacs kill ring and system clipboard independent
(use-package simpleclip :ensure
  :config
  (simpleclip-mode 1))
;; EXPAND-REGION
;; Provides us with a shortcut to increase a selected region by semantic
;; units, i.e by word, then sentence, then quotes, brackets etc
(use-package expand-region :ensure
  :bind ("C-=" . 'er/expand-region))
;; MAGIT
(use-package magit :ensure)
(use-package company :ensure)
;; MOE THEME
;; Provides us with the theme
(use-package moe-theme :ensure
  :config 'moe-dark)
;; EGLOT
;; LSP integration
(use-package eglot :ensure)
;; EXEC-PATH-FROM-SHELL
;; Include path in shell when using terminal in emacs
(use-package exec-path-from-shell :ensure
  :config (when (memq window-system '(mac ns x))
            (exec-path-from-shell-initialize))
  )

(use-package diff-hl :ensure
  :hook
  (dired-mode . diff-hl-dired-mode)
  (magit-pre-refresh . diff-hl-magit-pre-refresh)
  (magit-post-refresh . diff-hl-magit-post-refresh)
  (desktop-after-read . siren-diff-hl-set-render-mode)

  :custom
  (diff-hl-fringe-bmp-function 'siren-diff-hl-fringe-bmp-from-type)
  (diff-hl-fringe-face-function 'siren-diff-hl-fringe-face-from-type)
  (diff-hl-margin-symbols-alist
   '((insert . "┃")
     (delete . "┃")
     (change . "┃")
     (unknown . "?")
     (ignored . "i")))

  :preface
  (defgroup siren-diff-hl nil
    "Siren specific tweaks to diff-hl."
    :group 'diff-hl)

  (defface siren-diff-hl-insert
    '((default :inherit diff-hl-insert))
    "Face used to highlight inserted lines."
    :group 'siren-diff-hl)

  (defface siren-diff-hl-delete
    '((default :inherit diff-hl-delete))
    "Face used to highlight deleted lines."
    :group 'siren-diff-hl)

  (defface siren-diff-hl-change
    '((default :inherit diff-hl-change))
    "Face used to highlight changed lines."
    :group 'siren-diff-hl)

  (defun siren-diff-hl-fringe-face-from-type (type _pos)
    (intern (format "siren-diff-hl-%s" type)))

  (defun siren-diff-hl-fringe-bmp-from-type(type _pos)
    (intern (format "siren-diff-hl-%s" type)))

  (defun siren-diff-hl-set-render-mode ()
    (diff-hl-margin-mode (if window-system -1 1)))

  :config
  (siren-diff-hl-set-render-mode)
  (fringe-mode 3)
  (diff-hl-flydiff-mode 1)

  (define-fringe-bitmap 'siren-diff-hl-insert
    [#b11111111] nil nil '(center repeated))
  (define-fringe-bitmap 'siren-diff-hl-change
    [#b11111111] nil nil '(center repeated))
  (define-fringe-bitmap 'siren-diff-hl-delete
    [#b11111111] nil nil '(center repeated)))
(global-diff-hl-mode)

;; (use-package rustic
;;   :bind(:map rustic-mode-map
;;              ("M-j" . lsp-ui-imenu)
;;              ("M-?" . lsp-find-references)
;;              ("C-c C-c a" . lsp-execute-code-action)
;;              ("C-c C-c r" . lsp-rename)
;;              ("C-c C-c q" . lsp-workspace-restart)))

(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq eldoc-echo-area-use-multiline-p 1)
(setq lsp-ui-sideline-show-hover nil)
(setq lsp-ui-sideline-show-code-actions nil)
(setq lsp-ui-doc-enable nil)
(setq lsp-ui-sideline-enable nil)
(setq lsp-ui-doc-show-with-mouse nil)
(setq lsp-diagnostics-provider :flymake)
(setq lsp-signature-render-documentation nil)
(setq lsp-signature-auto-activate nil)
(setq lsp-rust-analyzer-experimental-proc-attr-macros t)
(setq lsp-log-io t)
(add-hook 'python-mode-hook #'lsp) ; Autostart LSP for Python buffers

;; ;; Allows us to move around windows using shift and arrow keys
(when (fboundp 'windmove-default-keybindings)
  (windmove-default-keybindings))

;; Setq-default sets for all buffers
(setq-default
 inhibit-startup-message t         ; Don't show the startup message...
 inhibit-startup-screen t          ; ... or screen
 cursor-in-non-selected-windows t  ; Hide the cursor in inactive windows
 echo-keystrokes 0.0               ; Show keystrokes right away
 initial-scratch-message nil       ; Empty scratch buffer
 initial-major-mode 'org-mode      ; Org mode by default
 sentence-end-double-space nil     ; Sentences should end in one space, come on!
 confirm-kill-emacs 'y-or-n-p      ; y and n instead of yes and no when quitting
 help-window-select t              ; Select help window so it's easy to quit it'q'
 fringe-mode 'minimal              ; Minimal fringes
 make-backup-files nil             ; Don't bother with backups
 truncate-lines t                  ; Truncate long lines rather than wrap around
 frame-title-format "%b (%f)"      ; Show full path in the title bar.
 tab-width 2                       ; Default tab width
 indent-tabs-mode nil              ; By default, never indent using tabs
 )

(setq
 highlight-indent-guides-method 'character
 highlight-indent-guides-responsive 'nil
 highlight-indent-guides-delay 100
 )
                                        ; Company mode
(setq company-dabbrev-downcase 0 
      company-idle-delay 0.0
      company-minimum-prefix-length 1)
;; C related
(setq c-default-style "linux"
      c-basic-offset 4
      c-basic-indent 4)
;; Parenthesis hightlighting
(setq show-paren-delay 0.0)
(setq show-paren-style 'expression)
;; Ido mode
(setq ido-enable-flex-matching t
      ido-everywhere t
      ido-auto-merge-work-directories-length -1)

(add-hook 'minibuffer-setup-hook 'turn-on-visual-line-mode)
(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'geiser-repl-mode-hook 'visual-line-mode)
(add-hook 'neotree-mode-hook 'disable-line-numbers)
;; (add-hook 'server-done-hook 'switch-back-focus)
(add-hook 'c-mode '(indent-tabs-mode 'only))
;; Highlight indent levels
(add-hook 'prog-mode-hook 'highlight-indent-guides-mode)
;; Com(lete)Any(thing)
(add-hook 'after-init-hook 'global-company-mode)

;; Ensures visual line mode is on.
(defun turn-on-visual-line-mode ()
  (visual-line-mode 1))
(defun disable-line-numbers ()
  (display-line-numbers-mode 0))

;; Hide toolbar and scroll bar
(tool-bar-mode -1)
(scroll-bar-mode -1)
(show-paren-mode t)
(ido-mode 1)
;; Electric brackets
(electric-pair-mode 1)
(delete-selection-mode 1) ;; delete selected text when typing

;; Move focus back to terminal after closing a server window
(defun switch-back-focus ()
  (shell-command "open -a iTerm"))

;; Ignore some buffers in Ido
(defun my-ido-ignore-func (name)
  "Ignore all non-user (a.k.a. *starred*) buffers except those listed in
   `my-unignored-buffers'."
  (and (string-match "^\*" name)
       (not (member name my-unignored-buffers))))
(setq my-unignored-buffers '("*terminal*"))
(setq ido-ignore-buffers '("\\` " my-ido-ignore-func "magit" ".DS_Store"))
(add-to-list 'ido-ignore-files '".DS_Store")

;; ;;  color package
;;  (let ((bg (face-attribute 'default :background)))
;;   (custom-set-faces
;;    `(company-tooltip ((t (:inherit default :background ,(color-lighten-name bg 2)))))
;;    `(company-scrollbar-bg ((t (:background ,(color-lighten-name bg 10)))))
;;    `(company-scrollbar-fg ((t (:background ,(color-lighten-name bg 5)))))
;;    `(company-tooltip-selection ((t (:inherit font-lock-function-name-face))))
;;    `(company-tooltip-common ((t (:inherit font-lock-constant-face))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;; KEYBINDING ZONE ;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; MODIFIER KEYS
;; Both command keys are 'Super'
(setq mac-right-command-modifier 'super
      mac-command-modifier 'super
      ;; Option or Alt is naturally 'Meta'
      mac-option-modifier 'meta
      mac-right-option-modifier 'meta)
;; Use ESC as universal get me out of here command
(global-set-key (kbd "s-a") 'mark-whole-buffer)       ;; select all
(global-set-key (kbd "s-z") 'undo)
(global-set-key (kbd "C-c C-;") 'comment-or-uncomment-region-or-line)
(global-set-key (kbd "C-a") 'smarter-move-beginning-of-line)
(global-set-key (kbd "M-6") 'xah-select-text-in-quote)
(global-set-key (kbd "M-7") 'xah-select-line)
(global-set-key (kbd "M-n") 'forward-paragraph)
(global-set-key (kbd "M-p") 'backward-paragraph)
(global-set-key (kbd "M-<delete>") 'kill-word)

(global-set-key (kbd "C-S-M-r") 'revert-buffer-all)

(defun comment-or-uncomment-region-or-line ()
  "Comments or uncomments the region or the current line if there's no active region."
  (interactive)
  (let (beg end)
    (if (region-active-p)
        (setq beg (region-beginning) end (region-end))
      (setq beg (line-beginning-position) end (line-end-position)))
    (comment-or-uncomment-region beg end)))
;; Smarter move from Bozhidar Batsov
(defun smarter-move-beginning-of-line (arg)
  (interactive "^p")
  (setq arg (or arg 1))
  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))
  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(defun xah-select-line ()
  "Select current line. If region is active, extend selection downward by line.
URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2017-11-01"
  (interactive)
  (if (region-active-p)
      (progn
        (forward-line 1)
        (end-of-line))
    (progn
      (end-of-line)
      (set-mark (line-beginning-position)))))

(defun xah-select-text-in-quote ()
  "Select text between the nearest left and right delimiters.
Delimiters here includes the following chars: '\"`<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）
This command select between any bracket chars, not the inner text of a bracket. For example, if text is

 (a(b)c▮)

 the selected char is “c”, not “a(b)c”.

URL `http://ergoemacs.org/emacs/modernization_mark-word.html'
Version 2020-03-11
Added a space into $skipChars - may cause trouble, may not - gcoh"
  (interactive)
  (let (
        
        ($skipChars " ^'\"`<>(){}[]“”‘’‹›«»「」『』【】〖〗《》〈〉〔〕（）〘〙")
        $p1
        )
    (skip-chars-backward $skipChars)
    (setq $p1 (point))
    (skip-chars-forward $skipChars)
    (set-mark $p1)))







(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(ansi-term-color-vector
   [unspecified "#2d2a2e" "#ff6188" "#a9dc76" "#ffd866" "#78dce8" "#ab9df2" "#ff6188" "#fcfcfa"] t)
 '(compilation-message-face 'default)
 '(cua-global-mark-cursor-color "#93E0E3")
 '(cua-normal-cursor-color "#DCDCCC")
 '(cua-overwrite-cursor-color "#F0DFAF")
 '(cua-read-only-cursor-color "#7F9F7F")
 '(custom-enabled-themes '(moe-dark))
 '(custom-safe-themes
   '("27a1dd6378f3782a593cc83e108a35c2b93e5ecc3bd9057313e1d88462701fcd" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "13a8eaddb003fd0d561096e11e1a91b029d3c9d64554f8e897b2513dbf14b277" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "e61752b5a3af12be08e99d076aedadd76052137560b7e684a8be2f8d2958edc3" "ae65ccecdcc9eb29ec29172e1bfb6cadbe68108e1c0334f3ae52414097c501d2" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "ae88c445c558b7632fc2d72b7d4b8dfb9427ac06aa82faab8d760fff8b8f243c" "18cd5a0173772cdaee5522b79c444acbc85f9a06055ec54bb91491173bc90aaa" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "f9aede508e587fe21bcfc0a85e1ec7d27312d9587e686a6f5afdbb0d220eab50" "d1ede12c09296a84d007ef121cd72061c2c6722fcb02cb50a77d9eae4138a3ff" "983eb22dae24cab2ce86ac26700accbf615a3f41fef164085d829fe0bcd3c236" "83ae405e25a0a81f2840bfe5daf481f74df0ddb687f317b5e005aa61261126e9" default))
 '(display-fill-column-indicator t)
 '(display-fill-column-indicator-character 124)
 '(display-fill-column-indicator-column 120)
 '(eglot-ignored-server-capabilities '(:documentHighlightProvider :hoverProvider))
 '(eglot-put-doc-in-help-buffer t)
 '(fci-rule-color "#4F4F4F")
 '(font-lock-support-mode 'jit-lock-mode)
 '(highlight-changes-colors '("#DC8CC3" "#bbb0cb"))
 '(highlight-symbol-colors
   '("#680f63eb5998" "#54db645064d0" "#6097535f5322" "#5c2859a95fa1" "#4ede55f24ea4" "#64dd5979525e" "#530060d16157"))
 '(highlight-symbol-foreground-color "#FFFFEF")
 '(highlight-tail-colors
   '(("#4F4F4F" . 0)
     ("#488249" . 20)
     ("#5dacaf" . 30)
     ("#57a2a4" . 50)
     ("#b6a576" . 60)
     ("#ac7b5a" . 70)
     ("#aa5790" . 85)
     ("#4F4F4F" . 100)))
 '(hl-bg-colors
   '("#b6a576" "#ac7b5a" "#9f5c5c" "#aa5790" "#85749c" "#57a2a4" "#5dacaf" "#488249"))
 '(hl-fg-colors
   '("#3F3F3F" "#3F3F3F" "#3F3F3F" "#3F3F3F" "#3F3F3F" "#3F3F3F" "#3F3F3F" "#3F3F3F"))
 '(hl-paren-background-colors '("#e8fce8" "#c1e7f8" "#f8e8e8"))
 '(hl-paren-colors '("#93E0E3" "#F0DFAF" "#8CD0D3" "#bbb0cb" "#7F9F7F"))
 '(indicate-empty-lines nil)
 '(ispell-program-name "hunspell")
 '(jit-lock-contextually t)
 '(latex-run-command "pdflatex -output-dir=poopoo")
 '(lsp-eldoc-enable-hover nil)
 '(lsp-imenu-sort-methods '(position name))
 '(lsp-rust-analyzer-diagnostics-disabled ["\"unresolved-proc-macro\""])
 '(lsp-rust-analyzer-proc-macro-enable t)
 '(lsp-ui-doc-border "#FFFFEF")
 '(neo-window-fixed-size nil)
 '(neo-window-width 15)
 '(nrepl-message-colors
   '("#CC9393" "#DFAF8F" "#F0DFAF" "#488249" "#95d291" "#57a2a4" "#93E0E3" "#DC8CC3" "#bbb0cb"))
 '(package-selected-packages
   '(adaptive-wrap diff-hl eglot tramp rustic feature-mode magit lsp-ui use-package lsp-mode dockerfile-mode docker revert-buffer-all protobuf-mode sml-mode imenu-list yaml-mode auctex cmake-mode expand-region haskell-mode origami modern-cpp-font-lock moe-theme color-theme bison-mode lexbind-mode markdown-preview-mode flatui-theme plan9-theme solarized-theme markdown-mode neotree exec-path-from-shell yasnippet monokai-alt-theme monokai-pro-theme dracula-theme highlight-indent-guides fill-column-indicator company simpleclip monokai-theme geiser))
 '(pos-tip-background-color "#4F4F4F")
 '(pos-tip-foreground-color "#FFFFEF")
 '(rust-indent-offset 4)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#7F9F7F" "#4F4F4F" 0.2))
 '(sml/active-background-color "#98ece8")
 '(sml/active-foreground-color "#424242")
 '(sml/inactive-background-color "#4fa8a8")
 '(sml/inactive-foreground-color "#424242")
 '(term-default-bg-color "#3F3F3F")
 '(term-default-fg-color "#DCDCCC")
 '(tex-directory "./poopoo")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#CC9393")
     (40 . "#df51b97ca1ae")
     (60 . "#e83dcc9aa8b1")
     (80 . "#F0DFAF")
     (100 . "#cadbca369f51")
     (120 . "#b7fbbf79973e")
     (140 . "#a52cb4cc8f3f")
     (160 . "#9260aa2d8754")
     (180 . "#7F9F7F")
     (200 . "#87dbb4dba003")
     (220 . "#8b6ebfadb0a1")
     (240 . "#8e96ca9fc17c")
     (260 . "#914ed5b0d293")
     (280 . "#93E0E3")
     (300 . "#90c5da6cdd6f")
     (320 . "#8f5dd735da39")
     (340 . "#8df4d401d704")
     (360 . "#8CD0D3")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#3F3F3F" "#4F4F4F" "#9f5c5c" "#CC9393" "#488249" "#7F9F7F" "#b6a576" "#F0DFAF" "#57a2a4" "#8CD0D3" "#aa5790" "#DC8CC3" "#5dacaf" "#93E0E3" "#DCDCCC" "#6F6F6F"))
 '(xterm-color-names
   ["#4F4F4F" "#CC9393" "#7F9F7F" "#F0DFAF" "#8CD0D3" "#DC8CC3" "#93E0E3" "#fffff6"])
 '(xterm-color-names-bright
   ["#3F3F3F" "#DFAF8F" "#878777" "#6F6F6F" "#DCDCCC" "#bbb0cb" "#FFFFEF" "#FFFFFD"])
 '(yas-global-mode t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(company-scrollbar-bg ((t (:background "#37b737b737b7"))))
 '(company-scrollbar-fg ((t (:background "#2aea2aea2aea"))))
 '(company-tooltip ((t (:inherit default :background "#233c233c233c"))))
 '(company-tooltip-common ((t (:inherit font-lock-constant-face))))
 '(company-tooltip-selection ((t (:inherit font-lock-function-name-face))))
 '(flymake-note ((t (:underline "gray"))))
 '(font-lock-builtin-face ((t (:foreground "cyan" :weight normal))))
 '(font-lock-comment-delimiter-face ((t (:foreground "Darkgoldenrod4" :slant normal))))
 '(font-lock-comment-face ((t (:foreground "DarkGoldenrod4" :slant italic))))
 '(font-lock-type-face ((t (:foreground "#66D9EF" :slant italic)))))
(put 'scroll-left 'disabled nil)
