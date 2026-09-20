#!/usr/bin/env python3
"""Fold the mini-app into the concept demo, so the four gathering mechanics
open from a single file with nothing beside them.

    python3 tools/build-demo-standalone.py

Reads demo/index.html and baloot-standalone.html (rebuild that one first) and
writes baloot-demo-standalone.html. The game is carried as a string and handed
to the iframe as a blob, so the bridge still runs between two documents."""
import json, os, sys

HERE = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
demo = os.path.join(HERE, "demo", "index.html")
game = os.path.join(HERE, "baloot-standalone.html")
out  = os.path.join(HERE, "baloot-demo-standalone.html")

for f in (demo, game):
    if not os.path.exists(f):
        sys.exit("missing " + f)

html = open(demo, encoding="utf-8").read()
inner = open(game, encoding="utf-8").read()

# a JSON string is a valid JS string; </ is escaped so the payload cannot close the tag
payload = json.dumps(inner).replace("</", "<\\/")
tag = "<script>window.BALOOT_INLINE = %s;</script>\n" % payload

marker = "<script>\n/* ============================================================\n   the schematic city"
if marker not in html:
    marker = "<script>"
html = html.replace(marker, tag + marker, 1)

# the phone and the panel explain themselves; say where the game came from
html = html.replace("<b>What is real:</b>",
                    "<b>One file:</b> the game is carried inside this page and handed to the frame "
                    "as a blob, so there is nothing to serve. <b>What is real:</b>", 1)

open(out, "w", encoding="utf-8").write(html)
print(os.path.basename(out), str(round(os.path.getsize(out) / 1024)) + " KB")
