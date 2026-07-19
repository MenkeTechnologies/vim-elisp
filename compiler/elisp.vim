" vim-elisp — :compiler elisp
"
" Wires `:make` to evaluate the current Emacs Lisp program through the elisp
" binary (elisprs), so runtime errors land in the quickfix list. elisprs has
" no separate lint/parse mode — `elisp FILE.el` evaluates the file (lowered to
" fusevm bytecode and run), surfacing parse and eval errors alike.
"   elisp FILE.el            evaluate a file
"   elisp -e EXPR            evaluate an expression

if exists('current_compiler')
  finish
endif
let current_compiler = 'elisp'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

" `elisp %` evaluates the current file (there is no non-running lint mode).
CompilerSet makeprg=elisp\ %

" elisprs-style diagnostics: "elisp: file:line: message" and "file:line: message".
CompilerSet errorformat=%f:%l:%c:\ %m
CompilerSet errorformat+=%f:%l:\ %m
CompilerSet errorformat+=elisp:\ %f:%l:\ %m
CompilerSet errorformat+=elisp:\ %m
