#!/bin/sh
# Builds a single self-contained HTML file from the split sources.
#
# The split version is what ships (the mini-app engine serves a folder), but a
# one-file build is handy for passing the game around: mail it, drop it in a
# chat, double-click it. Same code, just inlined.
#
#   ./build-single.sh            -> dist/ardah-standalone.html
set -e
cd "$(dirname "$0")"
OUT="${1:-dist/ardah-standalone.html}"
mkdir -p "$(dirname "$OUT")"

python3 - "$OUT" <<'PY'
import re, sys, pathlib
out = pathlib.Path(sys.argv[1])
root = pathlib.Path('.')
html = (root / 'index.html').read_text()

def inline_css(m):
    css = (root / m.group(1)).read_text()
    return '<style>\n' + css + '\n</style>'

def inline_js(m):
    js = (root / m.group(1)).read_text()
    # A literal </script> inside the source would close the tag early.
    js = js.replace('</script>', '<\\/script>')
    return '<script>\n' + js + '\n</script>'

html = re.sub(r'<link rel="stylesheet" href="([^"]+)">', inline_css, html)
html = re.sub(r'<script src="([^"]+)"></script>', inline_js, html)
out.write_text(html)
print(out, len(html), 'bytes')
PY
