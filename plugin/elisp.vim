" vim-elisp — language-server / debug-adapter wiring for Emacs Lisp (elisprs)
"
" elisp CLI flags used here:
"   elisp FILE.el   evaluate a file (lowered to fusevm, run on fusevm)
"   elisp -e EXPR   evaluate an expression
"   --lsp           Language Server (JSON-RPC on stdio)
"   --dap           Debug Adapter (DAP on stdio)
"
" LSP / DAP: the wiring below registers `elisp --lsp` (Language Server,
" JSON-RPC on stdio) and documents `elisp --dap` (Debug Adapter, DAP on
" stdio). Each MUST be invoked with ONLY that flag (no appended `--stdio`);
" vim-lsp / nvim-dap clients must NOT add transport args. The wiring is guarded
" so the plugin still loads cleanly if the binary is absent.
"
" elisprs has no standalone lint mode, so there is no ALE linter registration —
" diagnostics come from the language server (`elisp --lsp`).
"
" Opt-out:
"   let g:vim_elisp_no_lsp = 1   " skip vim-lsp server registration

if exists('g:loaded_vim_elisp')
  finish
endif
let g:loaded_vim_elisp = 1

" ---------------------------------------------------------------------------
" vim-lsp
" ---------------------------------------------------------------------------
if !get(g:, 'vim_elisp_no_lsp', 0) && exists('*lsp#register_server')
  call lsp#register_server({
  \   'name': 'elisp',
  \   'cmd': ['elisp', '--lsp'],
  \   'allowlist': ['elisp'],
  \})
endif

" ---------------------------------------------------------------------------
" coc.nvim — add to coc-settings.json:
"   {
"     "languageserver": {
"       "elisp": {
"         "command": "elisp",
"         "args": ["--lsp"],
"         "filetypes": ["elisp"]
"       }
"     }
"   }
" ---------------------------------------------------------------------------

" ---------------------------------------------------------------------------
" nvim-dap — add to your Neovim config (debug adapter via `elisp --dap`):
"   local dap = require('dap')
"   dap.adapters.elisp = {
"     type = 'executable',
"     command = 'elisp',
"     args = { '--dap' },   -- no extra transport args; elisp rejects them
"   }
"   dap.configurations.elisp = {
"     { type = 'elisp', request = 'launch', name = 'Run Emacs Lisp program',
"       program = '${file}' },
"   }
" ---------------------------------------------------------------------------
