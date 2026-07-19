" vim-elisp — syntax highlighting for Emacs Lisp (the elisprs runtime)
"
" A standalone Emacs-Lisp grammar covering the surface elisprs implements:
" S-expressions, comments, strings, char literals, keyword symbols, the 18
" special forms, and the built-in subr set exposed by `elisp`'s LSP corpus
" (src/lsp.rs SPECIAL_FORMS + SUBRS). Everything links to standard highlight
" groups, so every colorscheme covers it.
"
" Verified against elisp 0.1.0 — Emacs Lisp on fusevm/JIT.

if exists('b:current_syntax')
  finish
endif

syntax case match
syntax sync minlines=100

" Treat '-' as a keyword char so hyphenated subr names highlight as one token.
syntax iskeyword @,48-57,_,192-255,-

" ---------------------------------------------------------------------------
" Comments / shebang
" ---------------------------------------------------------------------------
syntax keyword elispTodo contained TODO FIXME XXX NOTE HACK
syntax match   elispComment ";.*$" contains=elispTodo,@Spell
syntax match   elispShebang "\%^#!.*$"

" ---------------------------------------------------------------------------
" Numbers / chars
" ---------------------------------------------------------------------------
syntax match elispNumber "\<[-+]\?\d\+\>"
syntax match elispNumber "#[xX]\x\+"
syntax match elispNumber "#[oO]\o\+"
syntax match elispNumber "#[bB][01]\+"
syntax match elispFloat  "\<[-+]\?\d\+\.\d*\%([eE][-+]\?\d\+\)\?\>"
syntax match elispChar   "?\%(\\\%(C-\|M-\|S-\)*.\|\\[0-7]\+\|\\x\x\+\|.\)"

" ---------------------------------------------------------------------------
" Strings
" ---------------------------------------------------------------------------
syntax match  elispStringEscape contained "\\."
syntax region elispString start=+"+ skip=+\\"+ end=+"+ contains=elispStringEscape,@Spell

" ---------------------------------------------------------------------------
" Keyword symbols (:foo) and quote sugar
" ---------------------------------------------------------------------------
syntax match elispSymbolKeyword ":[-A-Za-z0-9*/+!?<>=_]\+"
syntax match elispQuote "#'\|[`',]\|,@"

" ---------------------------------------------------------------------------
" Constants
" ---------------------------------------------------------------------------
syntax keyword elispConstant t nil

" ---------------------------------------------------------------------------
" Special forms (src/lsp.rs SPECIAL_FORMS)
" ---------------------------------------------------------------------------
syntax keyword elispSpecial and cond defconst defmacro defun defvar function if lambda let let* or progn quote setq unless when while

" Common definers / binders elisprs also honors (for indent + highlight).
syntax keyword elispSpecial defsubst defcustom save-excursion save-restriction dolist dotimes catch unwind-protect condition-case prog1 prog2 ignore-errors with-current-buffer

" ---------------------------------------------------------------------------
" Built-in functions (src/lsp.rs SUBRS)
" ---------------------------------------------------------------------------
syntax keyword elispFunc eq eql equal null not consp listp atom symbolp stringp numberp integerp
syntax keyword elispFunc floatp vectorp zerop cons car cdr setcar setcdr list append reverse length
syntax keyword elispFunc nth format-time-string float-time current-time current-time-string decode-time encode-time vector make-vector aref aset symbol-name
syntax keyword elispFunc intern make-symbol set symbol-value boundp fboundp fset eval funcall apply identity concat
syntax keyword elispFunc format message princ prin1 number-to-string string-match string-match-p match-beginning match-end match-string match-data set-match-data
syntax keyword elispFunc replace-regexp-in-string regexp-quote save-match-data pcase mod floor ceiling round truncate float logand logior
syntax keyword elispFunc logxor lognot ash lsh expt sqrt exp log sin cos tan asin
syntax keyword elispFunc acos atan ldexp copysign frexp isnan fround ffloor fceiling ftruncate abs logcount
syntax keyword elispFunc logb random string-to-number type-of recordp cl-struct-p functionp char-or-string-p subrp macrop special-form-p char-uppercase-p
syntax keyword elispFunc special-variable-p char-equal makunbound intern-soft symbol-function indirect-function defvaralias indirect-variable func-arity subr-arity throw error
syntax keyword elispFunc user-error signal read read-from-string terpri print prin1-to-string substring split-string string-prefix-p string-suffix-p string-empty-p
syntax keyword elispFunc string-join char-to-string string-to-char make-string string string-search downcase upcase compare-strings string-distance fillarray vconcat
syntax keyword elispFunc string-to-vector string-to-list make-hash-table gethash puthash remhash clrhash hash-table-count hash-table-test hash-table-p hash-table-keys hash-table-values
syntax keyword elispFunc copy-hash-table sha1 md5 secure-hash base64-encode-string base64-decode-string base64url-encode-string base64url-decode-string url-hexify-string url-unhex-string sxhash sxhash-equal
syntax keyword elispFunc sxhash-eq sxhash-eql getenv setenv file-exists-p file-directory-p file-regular-p file-readable-p file-writable-p file-symlink-p file-executable-p write-region
syntax keyword elispFunc delete-file make-directory rename-file copy-file insert-file-contents shell-command-to-string call-process process-lines insert buffer-string buffer-size point
syntax keyword elispFunc point-min point-max goto-char erase-buffer char-after buffer-substring buffer-substring-no-properties delete-region forward-char backward-char beginning-of-line end-of-line
syntax keyword elispFunc line-beginning-position line-end-position pos-bol pos-eol bolp eolp bobp eobp forward-line search-forward re-search-forward looking-at
syntax keyword elispFunc looking-at-p replace-match char-before delete-char insert-char count-lines line-number-at-pos current-column search-backward re-search-backward skip-chars-forward skip-chars-backward
syntax keyword elispFunc forward-word backward-word intercept intercept-list intercept-remove intercept-clear intercept-proceed

" Internal subrs (-- name --) and arithmetic/comparison operator subrs.
syntax match elispFunc "\%(--current-directory--\|--invocation-file--\|--directory-files--\|--push-output-capture--\|--pop-output-capture--\)"
syntax match elispOperator "(\@<=\%(1+\|1-\|[-+*/%<>=]\+\)\%(\s\|)\)\@="

" ---------------------------------------------------------------------------
" Definitions — highlight the defined name
" ---------------------------------------------------------------------------
syntax match elispDefName "(\s*\%(defun\|defmacro\|defsubst\|defvar\|defconst\|defcustom\|defvaralias\)\s\+\zs[^ \t()]\+"

" ---------------------------------------------------------------------------
" Highlight links
" ---------------------------------------------------------------------------
highlight default link elispComment       Comment
highlight default link elispShebang       PreProc
highlight default link elispTodo          Todo
highlight default link elispNumber        Number
highlight default link elispFloat         Float
highlight default link elispChar          Character
highlight default link elispString        String
highlight default link elispStringEscape  SpecialChar
highlight default link elispSymbolKeyword Constant
highlight default link elispQuote         Special
highlight default link elispConstant      Constant
highlight default link elispSpecial       Statement
highlight default link elispFunc          Function
highlight default link elispOperator      Operator
highlight default link elispDefName       Identifier

let b:current_syntax = 'elisp'
