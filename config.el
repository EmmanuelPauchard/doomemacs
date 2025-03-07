;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "Emmanuel Pauchard"
      user-mail-address "emmanuel.pauchard@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;     doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(setq shell-file-name "/bin/zsh")

;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
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
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


;; Change other window binding to cycle through tabs
(global-set-key (kbd "C-<tab>") 'other-window)

;; Kill

(global-set-key (kbd "C-<backspace>") 'backward-kill-sexp)
(add-hook 'python-mode-hook 'blacken-mode)

;; number of characters until the fill column
(setq fill-column 80)

(add-hook! python-mode 'blacken-mode)
(add-hook! python-mode 'lsp-headerline-breadcrumb-mode)
(add-hook! before-save 'py-isort-before-save)
; Change other window binding to cycle through tabs
(global-set-key (kbd "C-<tab>") 'other-window)


;; org
(global-set-key (kbd "C-c l") #'org-store-link)
(global-set-key (kbd "C-c a") #'org-agenda)
(global-set-key (kbd "C-c c") #'org-capture)


(global-set-key (kbd "M-S-<up>") 'duplicate-thing)
(global-set-key (kbd "M-S-<down>") 'duplicate-thing)

(when (executable-find "ipython3")
  (setq python-shell-interpreter "ipython3"
        python-shell-interpreter-args "--simple-prompt"))

;; https://github.com/shuxiao9058/tabnine
(use-package! tabnine
  :hook ((prog-mode . tabnine-mode)
	 (kill-emacs . tabnine-kill-process))
  :config
  (add-to-list 'completion-at-point-functions #'tabnine-completion-at-point)
  (tabnine-start-process)
  :bind
  (:map  tabnine-completion-map
	("<tab>" . tabnine-accept-completion)
	("TAB" . tabnine-accept-completion)
	;; ("C-M-f" . tabnine-accept-completion-by-word) ;
	("M-<return>" . tabnine-accept-completion-by-line)
	("C-g" . tabnine-clear-overlay)
	("M-[" . tabnine-previous-completion)
	("M-]" . tabnine-next-completion)))

(require 'pyenv-mode)

(defun projectile-pyenv-mode-set ()
  "Set pyenv version matching project name."
  (let ((project (projectile-project-name)))
    (if (member project (pyenv-mode-versions))
        (pyenv-mode-set project)
      (pyenv-mode-unset))))

(add-hook 'projectile-after-switch-project-hook 'projectile-pyenv-mode-set)
(setq! python-pytest-executable "pyenv exec pytest -vv")

(setq! python-shell-interpreter "ipython3")
(setq! python-shell-interpreter-args "--simple-prompt")

(global-set-key (kbd "<f5>") 'python-pytest-function)
(map! :after python
      :map python-mode-map
      :prefix "C-x C-p"
      "t" #'python-pytest-function
      "f" #'python-pytest-file
      "r" #'python-pytest-repeat)

(after! dap-mode
  (setq dap-python-debugger 'debugpy))
