" vim-elisp — indentation for Emacs Lisp buffers
"
" Emacs Lisp is an S-expression language, so indentation is delegated to Vim's
" built-in Lisp indenter (`setlocal lisp`) rather than a brace-column rule.
" `lispwords` teaches it which forms indent their body by a fixed offset
" (defun, let, when, ...) — the elisprs special forms plus the common definers
" and binders elisprs honors.

if exists('b:did_indent')
  finish
endif
let b:did_indent = 1

setlocal autoindent
setlocal lisp

" Forms whose sub-expressions indent as a body (2 spaces), not aligned to the
" first argument. Mirrors the elisprs SPECIAL_FORMS plus common macros.
setlocal lispwords=
setlocal lispwords+=defun,defmacro,defsubst,defvar,defconst,defcustom,lambda
setlocal lispwords+=let,let*,when,unless,while,cond,progn,prog1,prog2
setlocal lispwords+=if,and,or,setq,quote,function
setlocal lispwords+=dolist,dotimes,catch,unwind-protect,condition-case
setlocal lispwords+=save-excursion,save-restriction,with-current-buffer,ignore-errors

let b:undo_indent = 'setlocal autoindent< lisp< lispwords<'
