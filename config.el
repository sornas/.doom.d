;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Gustav Sörnäs"
      user-mail-address "gustav@sornas.net")

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

(setq doom-font (font-spec :family "SF Mono" :size 16)
      doom-variable-pitch-font (font-spec :family "sans" :size 16)
      doom-big-font (font-spec :family "SF Mono" :size 22))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
(setq doom-theme 'doom-monokai-pro)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect.
;; + `nil'      -- No line numbers
;; + `t'        -- Normal line numbers
;; + `relative' -- Relative line numbers
(setq display-line-numbers-type t)

(global-display-fill-column-indicator-mode) ;; enable if ARG is omitted or nil
(mood-line-mode)

(autoload 'lyskom "lyskom" "Start LysKOM" t)
(defvar kom-server-aliases
  '(("kom.lysator.liu.se" . "LysKOM")))
(setq-default kom-default-language 'sv)
(setq kom-default-server "kom.lysator.liu.se"
      kom-default-user-name "Gustav Sörnäs")

(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((dot . t)))
  (setq org-capture-templates
        `(("t" "Personal todo" entry
           (file+headline +org-capture-todo-file "Inbox")
           "* TODO %?\n  %i\n  %a"
           :prepend t)
          ("n" "Personal notes" entry
           (file+headline +org-capture-notes-file "Inbox")
           "* %u %?\n  %i\n  %a"
           :prepend t)
          ("w" "Review: weekly review" entry
           (file+headline
            "~/org/reviews.org"
            ,(format-time-string "%Y"))
           (file "~/org/templates/weeklyreview.org")
           :immediate-finish t
           :jump-to-captured t
           :time-prompt t))))

;; doom-modeline
;(setq doom-modeline-height 25
;      doom-modeline-bar-width 3
;      doom-modeline-icon (display-graphic-p)
;      doom-modeline-major-mode-icon t
;      doom-modeline-major-mode-color-icon nil
;      doom-modeline-modal-icon t)

;;(doom-modeline-mode 1)
;;(after! doom-modeline
;;  (doom-modeline-def-modeline 'minimal
;;    '(bar matches buffer-info)
;;    '(parrot misc-info indent-info media-info lsp
;;      checker buffer-encoding major-mode))
;;  (doom-modeline-set-modeline 'minimal t))

(use-package! org-roam
  :defer t
  :config
  (setq org-roam-directory "~/org/roam/")
  (require 'org-protocol)
  (require 'org-roam-protocol))
(use-package! company-org-roam
  :defer t)

(setq ivy-use-selectable-prompt t)

(after! org-roam-server
  :config
  (setq org-roam-server-host "127.0.0.1"
        org-roam-server-port 8080
        org-roam-server-authenticate nil
        org-roam-server-export-inline-images t
        org-roam-server-serve-files nil
        org-roam-server-served-file-extensions '("pdf" "mp4" "ogv")
        org-roam-server-network-poll t
        org-roam-server-network-arrows nil
        org-roam-server-network-label-truncate t
        org-roam-server-network-label-truncate-length 60
        org-roam-server-network-label-wrap-length 20))

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
;; the highlighted symbol at press 'K'. This will open documentation for it,
;; including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(after! notmuch
  (defun evil-collection-notmuch-search-toggle-inbox-next-thread ()
    "Toggle inbox tag for message and go to next thread."
    (interactive)
    (evil-collection-notmuch-toggle-tag "inbox" "search" 'notmuch-search-next-thread))
  (map! :map notmuch-search-mode-map
        :n "i" 'evil-collection-notmuch-search-toggle-inbox-next-thread)

  (defun evil-collection-notmuch-search-toggle-inbox-prev-thread ()
    "Toggle inbox tag for message and go to previous thread."
    (interactive)
    (evil-collection-notmuch-toggle-tag "inbox" "search" 'notmuch-search-previous-thread))
  (map! :map notmuch-search-mode-map
        :n "I" 'evil-collection-notmuch-search-toggle-inbox-prev-thread)

  (setq send-mail-function 'sendmail-send-it
        sendmail-program "/usr/bin/msmtp"
        mail-specify-envelope-from t
        message-sendmail-envelope-from 'header
        mail-envelope-from 'header)

  (setq notmuch-fcc-dirs "sent +sent -new") ; store all sent messages with a tag

  (setq message-auto-save-directory "~/.mail/draft")
  (setq message-default-mail-headers "Cc: \nBcc: \n"))

(after! rust-mode
  (add-hook! 'flycheck-mode-hook #'flycheck-rust-setup))
(add-hook! 'rust-mode-hook #'lsp)
(add-hook! 'lsp-mode-hook #'lsp-enable-which-key-integration)

(map! :map doom-leader-map
      "o e" 'elfeed)
(map! :map elfeed-search-mode-map
      :n "R" #'elfeed-update)

(add-hook! 'c-mode-hook #'clang-format+-mode)

(after! rustic
  (setq rustic-lsp-server 'rls))

(defun doom/open-org ()
  "Browse your org dir."
  (interactive)
  (doom-project-find-file "~/org/"))
(map! :map doom-leader-map
      "f O" 'doom/open-org)

(setq projectile-indexing-method 'alien)
