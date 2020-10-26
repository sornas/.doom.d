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

(setq doom-font (font-spec :family "SF Mono" :size 15)
      doom-variable-pitch-font (font-spec :family "sans" :size 16)
      doom-big-font (font-spec :family "SF Mono" :size 36))

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
(setq display-line-numbers-type nil)

(global-display-fill-column-indicator-mode) ;; enable if ARG is omitted or nil

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
  (setq message-default-mail-headers "Cc: \nBcc: \n")

  (gnus-alias-init)
  (add-hook 'message-setup-hook 'gnus-alias-determine-identity) ; check identity
  (setq gnus-alias-identity-alist
        '(("gmail"
           nil ; TODO
           "Gustav Sörnäs <gustav@sornas.net>"
           nil ; organization header
           nil ; extra headers
           nil ; extra body text
           "~/.mail/gmail/signature") ; signature file
          ("liu"
           nil
           "Gustav Sörnäs <gusso230@student.liu.se>"
           nil
           nil
           nil
           "~/.mail/liu/signature")
          ("lithekod"
           nil
           "Gustav Sörnäs <vordf@lithekod.se>"
           "LiTHe kod"
           nil
           nil
           "~/.mail/lithekod/signature")
          ("liu"
           nil
           "Gustav Sörnäs <gustav@icahasse.se>"
           nil
           nil
           nil
           "~/.mail/icahasse/signature")
          ("lysator"
           nil
           "Gustav Sörnäs <sornas@lysator.liu.se>"
           nil
           nil
           nil
           "~/.mail/lysator/signature"))
        gnus-alias-default-identity "gmail"
        gnus-alias-identity-rules
        '(("liu" ("any" "@\\(^\\.\\)*\\.liu\\.se" both) "liu")
          ("lithekod" ("any" "@lithekod\\.se" both) "lithekod")
          ("icahasse" ("any" "@icahasse\\.se" both) "icahasse")
          ("lysator" ("any" "sornas@lysator\\.liu\\.se" both) "lysator"))))

(map! :map doom-leader-map
      "o e" 'elfeed)
(map! :map elfeed-search-mode-map
      :n "R" #'elfeed-update)

(add-hook! 'c-mode-hook #'clang-format+-mode)

(after! rustic
        (setq rustic-lsp-server 'rls))

;;TODO get org dir from variable
;;TODO fuzzy search all files, not only first level
(defun doom/open-org ()
  "Browse your org dir."
  (interactive)
  (doom-project-find-file "~/org/"))
(map! :map doom-leader-map
      "f O" 'doom/open-org)

(setq projectile-indexing-method 'alien)
