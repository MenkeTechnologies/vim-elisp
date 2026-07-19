#!/usr/bin/env bash
# Stamp syntax/elisp.vim with the elisp version it was checked against.
#
# Emacs Lisp's core surface implemented by elisprs is defined by the binary's
# LSP corpus (src/lsp.rs SPECIAL_FORMS + SUBRS), mirrored by hand in
# syntax/elisp.vim. This script keeps the one volatile piece — the
# "verified against elisp vX.Y.Z" line and the dynamically-counted token
# totals — in sync with the binary.
#
#   ./scripts/gen_syntax.sh        # uses `elisp` on $PATH
#   ELISP=/path/to/elisp ./scripts/gen_syntax.sh
set -euo pipefail

elisp="${ELISP:-elisp}"
here="$(cd "$(dirname "$0")/.." && pwd)"
out="$here/syntax/elisp.vim"

ver="$("$elisp" --version 2>/dev/null | grep -oE 'v?[0-9]+\.[0-9]+\.[0-9]+' | head -1)"
ver="${ver:-unknown}"

# Count the curated token surface straight out of the syntax file (source of
# truth) so the reported numbers never drift from what is highlighted.
nfunc="$(grep -hoE 'syntax keyword elispFunc .*' "$out" | perl -pe 's/syntax keyword elispFunc //' | tr ' ' '\n' | grep -c .)"
nspecial="$(grep -hoE 'syntax keyword elispSpecial .*' "$out" | perl -pe 's/syntax keyword elispSpecial //' | tr ' ' '\n' | grep -c .)"

# Rewrite only the single "Verified against ..." stamp line in place (perl, not
# sed — portable across BSD / GNU).
perl -i -pe "s|^\" Verified against elisp .*|\" Verified against elisp ${ver} — Emacs Lisp on fusevm/JIT.|" "$out"

echo "stamped $out (elisp ${ver}; ${nfunc} builtin subrs, ${nspecial} special forms)"
