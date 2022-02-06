(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(setq make-backup-files nil
      auto-save-default nil
      create-lockfiles nil)

(setq frame-title-format nil)
;; Question
(fset 'yes-or-no-p 'y-or-n-p)

(setq confirm-kill-emacs nil)
;; Give some breathing room
;; (set-fringe-mode 10)
(global-visual-line-mode 1)
(add-to-list 'default-frame-alist '(fullscreen . maximized))
;; (toggle-frame-fullscreen)

(global-set-key (kbd "M-p") 'previous-line)
(global-set-key (kbd "M-n") 'next-line)
(global-set-key (kbd "C-q") 'query-replace)

(setq inhibit-startup-message t
;;  ring-bell-function 'ignore
        inhibit-splash-screen t
        initial-scratch-message nil)

;; Disable the toolbar
(tool-bar-mode -1)
;; Disable visible scrollbar
(scroll-bar-mode -1)
;; Disable menu bar
(menu-bar-mode -1)
;; battery
(display-battery-mode t)
(column-number-mode -1)

(unless package-archive-contents
  (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
  (require 'use-package)
  (setq use-package-always-ensure t)

(use-package keycast
  :config

  (define-minor-mode keycast-mode
    "Show current command and its key binding in the mode line."
    :global t
    (if keycast-mode
        (add-hook 'pre-command-hook 'keycast--update t)
      (remove-hook 'pre-command-hook 'keycast--update)))
  (add-to-list 'global-mode-string '("" mode-line-keycast " "))
  (keycast-mode))

(use-package ivy
  ;;      :diminish
  :init
  (ivy-mode 1)
  :bind (("C-s" . swiper)
	 ("C-x b" . counsel-switch-buffer)
	 :map ivy-minibuffer-map
	 ("TAB" . ivy-alt-done)
	 ("M-j" . ivy-next-line)
	 ("M-k" . ivy-previous-line)
	 ("C-d" . ivy-switch-buffer-kill))
  :custom
  (ivy-use-virtual-buffers t)
  (ivy-truncate-lines t)
  (ivy-wrap t)
  (ivy-use-selectable-prompt t)
  (ivy-count-format "【%d/%d】")
  (enable-recursive-minibuffers t))

(use-package counsel
  ;;      :diminish
  :after ivy
  :bind
  (("C-x f" . counsel-recentf))
  :config (counsel-mode 1))


(use-package swiper
  ;;      :diminish
  :after ivy)

(use-package ivy-posframe
  ;;      :diminish
  :after ivy
  :custom
  (ivy-posframe-width 70)
  (ivy-posframe-height 25)
  (ivy-posframe-border-width 4)
  :config
  (setq ivy-posframe-display-functions-alist '((t . ivy-posframe-display-at-frame-center)))
  (ivy-posframe-mode 1))

(use-package ace-window
  :bind ("C-x o" . ace-window)
  :config
  (set-face-attribute
   'aw-leading-char-face nil
   :foreground "deep sky blue"
   :weight 'bold
   :height 3.0)
   (setq aw-keys '(?a ?s ?d ?f ?j ?k ?l)))

(use-package avy
:config
(setq avy-keys '(?a ?b ?c ?d ?e ?f ?g ?h ?i ?j ?k ?l ?m ?n ?o ?p ?q ?r ?s ?t ?u ?v ?w ?x ?y ?z ?.)))

(use-package doom-themes)
(load-theme 'doom-gruvbox t)

(use-package doom-modeline
 :hook
 (after-init . doom-modeline-mode))

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))

(defun org-setup ()
(org-indent-mode t))

(use-package org
  :hook (org-mode . org-setup)
  :custom					;
  (org-ellipsis " ▼")
  (org-hide-emphasis-markers t)
  :config
  (setq org-cycle-separator-lines 2
	org-src-fontify-natively t
	org-src-tab-acts-natively t
	org-src-preserve-indentation nil
	))

(use-package undo-tree
    :config
    (global-undo-tree-mode +1)
    (setq undo-tree-visualizer-timestamps t
          undo-tree-visualizer-diff nil))

(use-package hydra)
  (define-prefix-command 'hydra-map)
  (global-set-key (kbd "M-i") 'hydra-map)

(defhydra hydra-size (:color red)

    ("h" shrink-window-horizontally "shrink horizontally" :column "Sizing      ")
    ("l" enlarge-window-horizontally "enlarge horizontally")
    ("k" shrink-window "shrink window")
    ("j" enlarge-window "enlarge windows")
    ("0" balance-windows "balance window height")

    ("=" text-scale-increase "increase text" :column "Text scale")
    ("-" text-scale-decrease "deacrease text")

    ("q" nil "quit menu" :color blue :column nil))

(global-set-key (kbd "M-i s") 'hydra-size/body)

(defhydra hydra-text (:color red)
       ("k" scroll-up-line "scroll up" :column "Scroll          ")
       ("j" scroll-down-line "scroll down")

        ("l" avy-copy-line "copy line" :column "Copy  ")
        ("r" avy-copy-region "copy region")

        ("t" avy-move-line "move thread" :column "Move ")
        ("p" avy-move-region "move paragraph")

        ("f" isearch-forward-regexp "forward regexp" :column "Search ")
        ("b" isearch-backward-regexp "backward regexp")
        ("o" occur "ocurrencias")
        ("q" nil "quit menu" :color blue :column nil))

      (global-set-key (kbd "M-i m") 'hydra-text/body)

(use-package lsp-mode
  :commands lsp
  :hook ((rjsx-mode . lsp)
         (js2-mode . lsp)
         (mhtml-mode . lsp)
         (css-mode . lsp)
         ))

;;    (global-set-
(global-set-key (kbd "M-h") 'company-other-backend)
(global-set-key (kbd "M-y") 'company-yasnippet)

(use-package company-box
  :hook (company-mode . company-box-mode))

(use-package company
  :diminish company-mode
  :hook
  (after-init . global-company-mode)
  :bind
  (:map company-active-map
        ("C-n"     . nil)
        ("C-p"     . nil)
        ("M-j"     . company-select-next)
        ("M-k"     . company-select-previous)
        ("C-s"     . company-filter-candidates)
        ("TAB" . company-complete-common-or-cycle)
        ("<f1>"      . nil))
  (:map company-search-map  ; applies to `company-filter-map' too
        ("C-n"     . nil)
        ("C-p"     . nil)
        ("M-j"     . company-select-next-or-abort)
        ("M-k"     . company-select-previous-or-abort)
        ("C-s"     . company-filter-candidates)
        ([escape]  . company-search-abort))
  :init
  (setq company-tooltip-align-annotations nil
        company-tooltip-limit 12
        company-minimun-prefix-length 1
        company-idle-delay 0.1
        company-echo-delay 0
        company-show-numbers nil
        company-require-match nil
        company-selection-wrap-around t
        company-dabbrev-ignore-case t
        company-dabbrev-downcase t)
  :config
  (setq company-backends
        '((company-capf
           company-yasnippet
           company-files
           company-dabbrev
           company-dabbrev-code
           company-gtags
           company-etags
           company-keywords)))
  )

(use-package magit
 :ensure t)

(use-package git-gutter
  :ensure t
  :diminish
  :hook ((prog-mode org-mode) . git-gutter-mode )
  ;;✘
  :config
  (setq git-gutter:modified-sign "†")
  (setq git-gutter:added-sign "†")
  (setq git-gutter:deleted-sign "†")
  (set-face-foreground 'git-gutter:added "Green")
  (set-face-foreground 'git-gutter:modified "Gold")
  (set-face-foreground 'git-gutter:deleted "Red"))

(use-package blamer
  :ensure t
  :hook ((prog-mode org-mode) . blamer-mode )
  :custom
  (blamer-min-offset 5)
  :config
  (setq blamer-idle-time 0.3
        blamer-uncommitted-changes-message "NO COMMITTED"))

(use-package prettier
  :ensure t
  :diminish
  :hook ((mhtml-mode css-mode scss-mode rjsx-mode js2-mode ) . prettier-mode))

(use-package emmet-mode
  :ensure t
  :bind
  ("C-<tab>" . emmet-expand-line)
  :diminish
  :config
  (add-to-list 'emmet-jsx-major-modes 'your-jsx-major-mode)
  :custom
  (emmet-indentation 2)
  (emmet-move-cursor-between-quotes t)
  :hook ((mhtml-mode css-mode scss-mode rjsx-mode) . emmet-mode))

(use-package flycheck
  :ensure t
  :hook ((js2-mode jsx-mode  css-mode scss-mode) . flycheck-mode))

(use-package yasnippet
  :ensure t
  :functions hydra-yasnippet
  :bind ("M-i y" . hydra-yasnippet/body)
  :custom (yas-snippet-dirs '("~/.youtube.d/snippets/"))
  :hook
  ((prog-mode minibuffer-inactive-mode org-mode) . yas-minor-mode)
  :commands yas-reload-all
  :config
  (with-eval-after-load 'hydra
    (defhydra hydra-yasnippet (:hint nil)
      "
                             [_n_] New snippet
                             [_v_] Visit File
                             [_t_] Describe on table
                             [_q_] Quit
      "
      ("n" yas-new-snippet)
      ("v" yas-visit-snippet-file)
      ("t" yas-describe-tables)
      ("q" nil))))

(defun html-setup ()
  (sgml-electric-tag-pair-mode))

(use-package mhtml-mode
  :hook (mhtml-mode . html-setup)
  :config
  (setq-default sgml-basic-offset 2))

(use-package css-mode
  :mode "\\.css\\'")

(use-package rjsx-mode
  :mode "\\.jsx\\'"
  :bind
  (:map rjsx-mode-map
        ("C-c C-b" . rjsx-jump-opening-tag)
        ("C-c C-f" . rjsx-jump-closing-tag)
        ))

(use-package js2-mode
  :mode "\\.js\\'"
  :config
  (setq js-indent-level 2)
  (setq js2-indent-level 2)
  (setq js2-basic-offset 2)
  (setq js2-mode-show-strict-warnings t)
  (setq js2-strict-inconsistent-return-warning t)
  (setq js2-strict-missing-semi-warning t))