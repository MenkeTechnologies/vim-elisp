" vim-elisp — filetype detection for Emacs Lisp (the elisprs runtime)
" Loaded automatically by pathogen / vim-plug / native packages via ftdetect/.

" By extension: every *.el file is elisp. This overrides Vim's built-in
" detection of *.el as filetype 'lisp' so the elisprs syntax / LSP / run
" wiring applies.
autocmd BufNewFile,BufRead *.el setfiletype elisp

" Emacs init files with no .el extension.
autocmd BufNewFile,BufRead .emacs,_emacs setfiletype elisp

" By shebang: `#!/usr/bin/env elisp` scripts with no .el extension.
autocmd BufNewFile,BufRead * call s:DetectElispShebang()

function! s:DetectElispShebang() abort
  if did_filetype() || &filetype ==# 'elisp'
    return
  endif
  if getline(1) =~# '^#!.*\<elisp\>'
    setfiletype elisp
  endif
endfunction
