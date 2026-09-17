#!/usr/bin/env python3
"""
Fold the image assets into index.html and write one self-contained file.

    python3 tools/build-standalone.py

Produces baloot-standalone.html next to index.html: a single file that opens
straight from disk, with no sibling assets to ship. The mini-app bundle keeps
using index.html plus the separate .webp files, which caches better.
"""
import base64, mimetypes, re
from pathlib import Path

HERE = Path(__file__).resolve().parent.parent
SRC = HERE / "index.html"
DST = HERE / "baloot-standalone.html"

html = SRC.read_text(encoding="utf-8")
inlined, missing, saved = {}, [], 0

def datauri(name: str) -> str:
    path = HERE / name
    if not path.exists():
        missing.append(name)
        return name
    if name not in inlined:
        mime = mimetypes.guess_type(name)[0] or "application/octet-stream"
        if name.endswith(".webp"):
            mime = "image/webp"
        inlined[name] = "data:%s;base64,%s" % (
            mime, base64.b64encode(path.read_bytes()).decode("ascii"))
    return inlined[name]

# every url("...") in the stylesheet that points at a file we ship
def sub(m):
    quote, name = m.group(1), m.group(2)
    if name.startswith("data:"):
        return m.group(0)
    return 'url(%s%s%s)' % (quote, datauri(name), quote)

html = re.sub(r'url\((["\']?)([^"\')]+\.(?:webp|png|jpg|jpeg|svg))\1\)', sub, html)

# an Ardah recording, if the folder carries one: the page reads it from
# ARDAH_SRC, so the single-file build gets it as a data URI
for audio in ("ardah.mp3", "ardah.m4a", "ardah.ogg"):
    if (HERE / audio).exists():
        html = html.replace('const ARDAH_SRC = "ardah.mp3";',
                            'const ARDAH_SRC = "%s";' % datauri(audio), 1)
        break

html = html.replace(
    "<title>", "<!-- built by tools/build-standalone.py: assets inlined -->\n<title>", 1)
DST.write_text(html, encoding="utf-8")

for n in sorted(inlined):
    print("inlined", n, len(inlined[n]) // 1024, "KB base64")
if missing:
    print("MISSING:", ", ".join(sorted(set(missing))))
print(DST.name, DST.stat().st_size // 1024, "KB")
