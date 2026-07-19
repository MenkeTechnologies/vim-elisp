" vim-elisp — filetype-local settings for Emacs Lisp buffers

if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

" Emacs Lisp comments run ';' to end of line.
setlocal commentstring=;\ %s
setlocal comments=:;;;,:;;,:;

" Continue the comment leader on <Enter> / o / O.
setlocal formatoptions-=t
setlocal formatoptions+=croql

" Lisp-aware editing: '-' is part of a symbol; matched pairs for %.
setlocal iskeyword+=-
setlocal lisp

" Run the current Emacs Lisp program through elisp. `:make` uses the elisp
" compiler (compiler/elisp.vim); :ElispRun evaluates the buffer's file
" directly. Guard the :compiler call so the file still sources cleanly when
" the plugin dir is not yet on runtimepath (e.g. an isolated `:source` lint).
if !empty(globpath(&runtimepath, 'compiler/elisp.vim'))
  compiler elisp
else
  setlocal makeprg=elisp\ %
  setlocal errorformat=%f:%l:%c:\ %m,%f:%l:\ %m,%m
endif

if !exists(':ElispRun')
  command! -buffer -nargs=* -complete=file ElispRun
        \ echo system('elisp ' . shellescape(expand('%:p')) . ' ' . <q-args>)
endif

" <LocalLeader>r evaluates the current file via `elisp %`.
if !get(g:, 'vim_elisp_no_maps', 0)
  nnoremap <buffer> <silent> <LocalLeader>r :ElispRun<CR>
endif

" Restore on filetype change.
let b:undo_ftplugin = 'setlocal commentstring< comments< formatoptions< iskeyword< lisp<'
      \ . '| silent! nunmap <buffer> <LocalLeader>r'
      \ . '| silent! delcommand ElispRun'
