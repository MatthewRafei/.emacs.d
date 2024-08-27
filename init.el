;; Get Melpa Repo.
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(setq package-archives '(("gnu"   . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
                         ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")))

(setq ring-bell-function 'ignore)

(menu-bar-mode 0)
(tool-bar-mode 0)

(defun open-init-file ()
  "Open the init.el file located in ~/.emacs.d/ directory."
  (interactive)
  (find-file "~/.emacs.d/init.el"))

(defun untabify-except-makefiles ()
  "Replace tabs with spaces except in makefiles."
  (unless (derived-mode-p 'makefile-mode)
    (untabify (point-min) (point-max))))
(add-hook 'before-save-hook 'untabify-except-makefiles)

(setq split-width-threshold nil) ;; have windows open horizontally instead of vertically.

;; Clicker trained UwU
;;(setq ring-bell-function 'ignore)

;; !BASED
;(setq inhibit-startup-screen t)

(add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
(display-time-mode 1)
(setq-default indent-tab-mode nil)
(show-paren-mode 1)
(setq make-backup-files nil)
(delete-selection-mode 1)

;; (setq display-line-numbers-type 'relative)
(setq display-line-numbers-type 'absolute)(use-package exec-path-from-shell
  :ensure t
  :config
  (when (memq window-system '(mac ns x))
    (exec-path-from-shell-initialize)))

(global-auto-complete-mode t)
(scroll-bar-mode -1)
(global-display-line-numbers-mode)
(set-frame-font "Ubuntu Mono-14")

(ido-mode 1)
(ido-everywhere 1)
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")
(setq mc/always-run-for-all t)
;;(golden-ratio-mode)

(defun switch-to-compilation-buffer ()
  "Switch to the *compilation* buffer if it exists."
  (interactive)
  (let ((buf (get-buffer "*compilation*")))
    (if buf
        (switch-to-buffer buf)
      (message "Compilation buffer does not exist"))))

;; --- Keybindings ---
(global-set-key (kbd "<f12>") 'open-init-file)

(define-key ido-common-completion-map (kbd "C-n") 'ido-next-match)
(define-key ido-common-completion-map (kbd "C-p") 'ido-prev-match)

(global-set-key (kbd "C-<tab>") 'switch-to-compilation-buffer)
(global-set-key (kbd "C-c C-j") 'eval-print-last-sexp)
(global-set-key (kbd "C-c w") 'global-whitespace-mode)
(global-set-key (kbd "C-x C-j") 'dired-jump)
(global-set-key (kbd "C-.") 'mark-word)
(global-set-key (kbd "C-q") 'undo)
(global-set-key (kbd "C-x m") 'delete-other-windows)
(global-set-key (kbd "C-x '") 'vterm)
(global-set-key (kbd "C-c e") 'crux-eval-and-replace)
(global-set-key (kbd "M-k") 'crux-kill-whole-line)
(global-set-key (kbd "C-c d") 'crux-duplicate-current-line-or-region)
(global-set-key (kbd "C-c k") 'crux-kill-other-buffers)
(global-set-key (kbd "M-j") 'crux-top-join-line)
(global-set-key (kbd "C-x C-u") 'crux-upcase-region)
(global-set-key (kbd "C-x C-l") 'crux-downcase-region)

(global-set-key [(shift return)] #'crux-smart-open-line)
(global-set-key (kbd "M-s M-s") 'helm-swoop)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-tnis)
(global-set-key (kbd "C-?") 'mc/skip-to-next-like-this)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)
(global-set-key (kbd "C-x -") 'split-window-vertically)
(global-set-key (kbd "C-x /") 'split-window-horizontally)
(global-key-binding (kbd "M-x") #'smex)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c f") 'helm-imenu)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-c c") 'compile)
(global-set-key (kbd "C-c M-c") 'query-replace)
(global-set-key (kbd "C-x M-x") 'grep-find)
(global-set-key (kbd "M-g M-f") 'xref-find-definitions)
(global-set-key (kbd "M-g f") 'xref-find-references)

;; Earl mode
(defconst earl-mode-syntax-table
  (with-syntax-table (copy-syntax-table)
    (modify-syntax-entry ?- "w")
    (modify-syntax-entry ?* ". 23")
    (modify-syntax-entry ?\n "> b")
    (modify-syntax-entry ?# "< b")
    (syntax-table))
  "Syntax table for `earl-mode'.")

;; Function taken from:
;;  https://www.omarpolo.com/post/writing-a-major-mode.html
(defun earl-indent-line ()
  "Indent current line."
  (let (indent
        boi-p
        move-eol-p
        (point (point)))
    (save-excursion
      (back-to-indentation)
      (setq indent (car (syntax-ppss))
            boi-p (= point (point)))
      (when (and (eq (char-after) ?\n)
                 (not boi-p))
        (setq indent 0))
      (when boi-p
        (setq move-eol-p t))
      (when (or (eq (char-after) ?\))
                (eq (char-after) ?\}))
        (setq indent (1- indent)))
      (delete-region (line-beginning-position)
                     (point))
      (indent-to (* tab-width indent)))
    (when move-eol-p
      (move-end-of-line nil))))

(eval-and-compile
  (defconst earl-keywords
    '("if" "else" "while" "let" "void" "int"
      "str" "for" "fn" "return" "break"
      "struct" "char" "import" "in" "module"
      "class" "true" "false" "none" "match"
      "when" "constructor" "this" "enum"
      "full" "almost" "float" "tuple" "list"
      "bool" "to"
      ;; intrinsic functions
      "print" "println" "assert" "len" "open"
      "type" "unimplemented" "input"
      "some" "unwrap" "argv" "exit"
      "panic" "fprintln" "fprint"
      ;; private intrinsic functions
      "__internal_move__" "__internal_mkdir__"
      "__internal_ls__"
      ;; list member intrinsics
      "rev" "nth" "append" "pop"
      "filter" "foreach" "back"
      ;; str member intrinsics
      "split" "remove_lines" "substr"
      ;; char member intrinsics
      "ascii"
      ;; file member intrinsics
      "read" "close" "dump" "write"
      "writelines"
      ;; option member intrinsics
      "is_none" "is_some"
      ;; function attributes
      "world" "pub" "ref"
      ;; Stdlib Modules
      "IO" "List" "Math" "Stack" "Utils"
      "Str" "Tree" "Set" "Queue" "OS"
      )))

(defconst earl-highlights
  `((,(rx (group "#" (zero-or-more nonl))) . font-lock-comment-face)
    (,(regexp-opt earl-keywords 'symbols) . font-lock-keyword-face)))

;;;###autoload
(define-derived-mode earl-mode prog-mode "earl"
  "Major Mode for editing Earl source code."
  :syntax-table earl-mode-syntax-table
  (setq font-lock-defaults '(earl-highlights))
  (setq-local comment-start "#")
  (setq-local indent-tabs-mode nil)
  (setq-local tab-width 4)
  (setq-local indent-line-function #'earl-indent-line)
  (setq-local standard-indent 2))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.earl\\'" . earl-mode))

(provide 'earl-mode)
;; End Earl mode

;; OCaml
(add-to-list 'load-path "/home/oddstap/.opam/default/share/emacs/site-lisp")
(require 'ocp-indent)

;; C++
(add-hook 'c++-mode-hook
          (lambda ()
            (setq c-default-style "bsd")
            (setq c-basic-offset 4)))

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (read-only-mode -1) ; Disable read-only mode
  (ansi-color-apply-on-region compilation-filter-start (point))
  (read-only-mode 1)) ; Enable read-only mode
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(spacemacs-dark))
 '(custom-safe-themes
   '("d7bf35cbf07fe90b420ca85625d4e1baff08fd64282562dde9dc788ed89c8242" "bbb13492a15c3258f29c21d251da1e62f1abb8bbd492386a673dcfab474186af" "7fd8b914e340283c189980cd1883dbdef67080ad1a3a9cc3df864ca53bdc89cf" "e27c9668d7eddf75373fa6b07475ae2d6892185f07ebed037eedf783318761d7" default))
 '(package-selected-packages
   '(vterm crux dashboard expand-region helm-swoop magit multiple-cursors smex tuareg move-text gruber-darker-theme spacemacs-theme use-package golden-ratio exec-path-from-shell auto-complete))
 '(warning-suppress-types '((comp) (comp) (comp) (comp) (comp))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
