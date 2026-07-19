# vim-elisp

```
██╗   ██╗██╗███╗   ███╗    ███████╗██╗     ██╗███████╗██████╗
██║   ██║██║████╗ ████║    ██╔════╝██║     ██║██╔════╝██╔══██╗
██║   ██║██║██╔████╔██║    █████╗  ██║     ██║███████╗██████╔╝
╚██╗ ██╔╝██║██║╚██╔╝██║    ██╔══╝  ██║     ██║╚════██║██╔═══╝
 ╚████╔╝ ██║██║ ╚═╝ ██║    ███████╗███████╗██║███████║██║
  ╚═══╝  ╚═╝╚═╝     ╚═╝    ╚══════╝╚══════╝╚═╝╚══════╝╚═╝
```

[![CI](https://github.com/MenkeTechnologies/vim-elisp/actions/workflows/ci.yml/badge.svg)](https://github.com/MenkeTechnologies/vim-elisp/actions/workflows/ci.yml)
[![Docs](https://img.shields.io/badge/docs-online-05d9e8.svg)](https://menketechnologies.github.io/vim-elisp/)
[![Syntax](https://img.shields.io/badge/syntax-standalone%20Emacs%20Lisp-ff2a6d.svg)](https://menketechnologies.github.io/vim-elisp/)
[![LSP](https://img.shields.io/badge/LSP%20%2F%20DAP-elisprs-39ff14.svg)](https://github.com/MenkeTechnologies/vim-elisp)
[![License: MIT](https://img.shields.io/badge/License-MIT-d300c5.svg)](https://opensource.org/licenses/MIT)

### `[VIM PLUGIN // NEON SYNTAX // STANDALONE EMACS LISP GRAMMAR // LSP + DAP]`

> *"Emacs Lisp, everywhere but Emacs — driven by the elisprs runtime."*

**vim-elisp** adds Vim / Neovim support for Emacs Lisp, targeting
[`elisprs`](https://github.com/MenkeTechnologies/elisprs) — an Emacs Lisp
implementation written in Rust that lowers `.el` to the
[`fusevm`](https://github.com/MenkeTechnologies/fusevm) bytecode VM with a
three-tier Cranelift JIT (the same engine behind `zshrs`, `stryke`, `arb`, and
`awkrs`).

### [`Read the Docs`](https://menketechnologies.github.io/vim-elisp/) &middot; [`Engineering Report`](https://menketechnologies.github.io/vim-elisp/report.html)

---

## [0x00] OVERVIEW

vim-elisp is a standalone runtime-files bundle — syntax, ftdetect, ftplugin,
indent, compiler, and LSP/DAP wiring — for editing Emacs Lisp with the
`elisp` binary as the language backend. The syntax grammar mirrors the
elisprs LSP corpus (`src/lsp.rs` `SPECIAL_FORMS` + `SUBRS`), so what Vim
highlights is exactly the surface the language server knows.

## [0x01] FEATURE MATRIX

| Capability            | Mechanism                                             |
| --------------------- | ----------------------------------------------------- |
| Filetype detection    | `*.el`, `.emacs`, `_emacs`, `elisp` shebang           |
| Syntax highlighting   | standalone `syntax/elisp.vim` (special forms + subrs) |
| Indentation           | Vim built-in `lisp` indenter + `lispwords`            |
| Run / `:make`         | `elisp %` (evaluate the file)                         |
| Language server       | vim-lsp / coc.nvim via `elisp --lsp`                  |
| Debug adapter         | nvim-dap via `elisp --dap`                            |

## [0x02] INSTALL

```vim
" vim-plug
Plug 'MenkeTechnologies/vim-elisp'
```

```sh
# native packages
git clone https://github.com/MenkeTechnologies/vim-elisp \
  ~/.vim/pack/plugins/start/vim-elisp
# then inside vim:  :Helptags
```

Install the backend binary:

```sh
brew install menketechnologies/menketech/elisprs
```

## [0x03] SYNTAX // TOKEN CATEGORIES

- Comments (`;`), shebang, `TODO`/`FIXME` markers
- Strings, char literals (`?a`, `?\C-x`), keyword symbols (`:foo`)
- Quote sugar: `'`, `` ` ``, `,`, `,@`, `#'`
- Numbers, including `#x` / `#o` / `#b` radices and floats
- The 18 special forms (`defun`, `let`, `cond`, `lambda`, ...)
- The built-in subr set exposed by the elisp LSP corpus
- Names introduced by `defun` / `defmacro` / `defvar` / `defconst`

## [0x04] RUN

```vim
:ElispRun            " evaluate the current file via elisp
:make                " same, into the quickfix list
```

`elisp FILE.el` evaluates the file (lowered to fusevm and run); there is no
separate lint mode, so evaluation surfaces both parse and runtime errors.

## [0x05] LANGUAGE SERVER

### vim-lsp

Registered automatically as `elisp --lsp` when vim-lsp is present.

### coc.nvim

```jsonc
{
  "languageserver": {
    "elisp": { "command": "elisp", "args": ["--lsp"], "filetypes": ["elisp"] }
  }
}
```

## [0x06] DEBUG ADAPTER

```lua
local dap = require('dap')
dap.adapters.elisp = { type = 'executable', command = 'elisp', args = { '--dap' } }
dap.configurations.elisp = {
  { type = 'elisp', request = 'launch', name = 'Run Emacs Lisp program', program = '${file}' },
}
```

## [0x07] OPTIONS

| Variable               | Effect                                   |
| ---------------------- | ---------------------------------------- |
| `g:vim_elisp_no_maps`  | skip the `<LocalLeader>r` mapping        |
| `g:vim_elisp_no_lsp`   | skip the vim-lsp server registration     |

## [0x08] LAYOUT

```
ftdetect/elisp.vim    filetype detection
ftplugin/elisp.vim    buffer-local settings, :ElispRun
indent/elisp.vim      lisp indentation (lispwords)
syntax/elisp.vim      standalone Emacs Lisp grammar
compiler/elisp.vim    :make wiring (elisp %)
plugin/elisp.vim      vim-lsp / coc / nvim-dap wiring
doc/elisp.txt         :help vim-elisp
```

## [0xFF] LICENSE

MIT.
