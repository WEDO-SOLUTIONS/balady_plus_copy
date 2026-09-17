# Baloot — mini-app (بلوت)

A complete, self-contained Baloot card game in a single HTML file: `index.html`.
No build step, no dependencies, no network calls — it runs offline by opening the
file in any browser, and it is meant to be served as a Balady+ mini-app.

```
mini_apps/baloot/
  index.html                 the whole game (markup, styles, rules engine, AI, UI, host bridge)
  room.webp                  the majlis scene, cut from the mock-up
  crest.webp                 the plaque, scroll and shield, emptied of their baked text
  btn-gold.webp              the primary button face, emptied of its label
  btn-outline.webp           the outlined button face, emptied of its label
  corner-{tl,tr,bl,br}.webp  the gold arabesque, one file per corner
  baloot-standalone.html     the same game as one file, assets inlined
  tools/extract-assets.py    re-cuts the images from the source mock-up
  tools/build-standalone.py  folds the images into the single-file build
  README.md                  this file
```

`baloot-standalone.html` is `index.html` with every image inlined as a data URI
— one 364 KB file that opens straight from disk with nothing beside it, handy
for sending to someone or dropping into a WebView that has no asset directory.
Rebuild it with `python3 tools/build-standalone.py` after changing `index.html`
or any asset, otherwise it goes stale. The mini-app bundle should keep using
`index.html` plus the separate `.webp` files, which cache far better.

The `.webp` files are cut out of the supplied `Baloot final.png` mock-up by
`tools/extract-assets.py` (about 190 KB in total). It does the work that makes
them reusable: repaints the two cards baked onto the table so live ones can be
dealt in front of it, wipes the baked title, deal number and button labels,
keys the backdrop out of the ornaments and drops the stray sparkles the crop
caught, and fades the scene's bottom edge into the cloth. Re-run it if the
source art changes; the pixel offsets in it were measured by hand against the
937x1679 original.

Both button faces are used as CSS `border-image`, so one file stretches to any
button width with its corners and bevel intact. The arabesque ships as four
rotations because a background layer cannot be cropped to one cell of a sprite;
together they frame the panels. Everything else in the page is still drawn in
CSS, and the game keeps working (plainer) if the images are missing.

## Running it

| Context | How |
|---|---|
| Browser | open `index.html`, or `baloot-standalone.html` for a single file |
| Self-check | open `index.html?test=1` — 30 rules assertions, results in the console and a toast |
| Deep link into a room | `index.html?room=UY9ED8` |
| Mini-app | ship the folder as a mini-app bundle; `CustomInAppLocalhostServer` serves `index.html` from the bundle's document root (see `lib/mini_apps_engine/`) |

Arabic (RTL) is the default, English is selectable in the settings sheet;
the initial language follows `navigator.language` and is remembered in `localStorage`.

## Implemented rules

- 32 cards, 4 players, 2 partnerships (seats 0/2 vs 1/3), 8 cards each.
- Bidding: 5 cards dealt, one turned face up. Round 1 is Hokum on that suit, Sun,
  or Pass, and **Sun outbids Hokum**. If everyone passes, round 2 allows any trump
  suit or Sun; the dealer takes the best suit rather than force a redeal.
  The bidder then receives the face-up card plus two, the others three.
- Ranking and points: Sun `A>10>K>Q>J>9>8>7`; trump `J>9>A>10>K>Q>8>7`
  (`J=20`, `9=14`). Last trick +10 — 130 raw in Sun, 162 in Hokum.
- Legal moves are enforced: follow suit; in Hokum trump when void unless the
  partner is already winning; over-trump when you can.
- Projects: Sra 20, Fifty 50, Hundred 100 (five-card run or four of a kind),
  Four Hundred 400 (four jacks), Baloot 20 (K+Q of trump). Only the team holding
  the single highest project scores them.
- Scoring: Sun ÷5 (remainder ≥3 rounds up) → 26 per round; Hokum ÷10
  (remainder ≥6 rounds up) → 16. Projects are added to the raw points *before*
  conversion, so a project is automatically worth twice as much in Sun — it is
  **not** multiplied again. Failed bid gives the defenders everything; kaboot is
  44 (Sun) / 25 (Hokum); a tie carries over. Game to 152.

House rules that vary by region are collected in the `CFG` object near the top of
the script (`target`, `kabootSun`, `kabootHokum`, `fourNines`).

## Look

The table follows a supplied mock-up: an ornate gold plaque header with the deal
counter and `Us / Them` in green and gold, a round wooden-rimmed table with the
trick laid on the cloth, a `WINNING` marker over whichever card currently leads,
a green "your turn" bubble naming a card worth playing, an arced hand fan, and a
gold-ornamented action rail (play the suggested card / toggle hints / invite).

The majlis, the plaque, the button faces and the arabesque are the mock-up's own artwork,
sliced out as three small WebP files (about 150 KB together). The scene carries
the table and the other players and fades into the cloth where the trick is
played, exactly as the mock-up stages it; seat plates are pinned to the painted
players in percentages of the picture, so they follow it as it scales.

Hints are a real suggestion: the bubble and the rail button both name the card
the bots would play from your seat, and the rail button plays it. They can be
turned off in the settings sheet.

## Parallax

The whole background moves, at different rates by depth: the scene pans inside
its own crop, the wall lattice and the cloth's own ornament travel a shorter
distance, and the header drifts least. On a phone a `deviceorientation` reading
drives it — Android starts listening straight away, iOS asks for permission on
the first press of the tilt pad. On a desktop the two arrows in the corner of
the table, or the `1` and `2` keys, stand in: hold to tilt, release and it
springs back.

The travel is a pixel budget, not a share of the crop: a tall narrow screen
crops the picture hard, and a percentage of that crop swings the scene right
across the display. `measure()` works out how wide the picture is drawn, widens
it when a short screen leaves nothing to pan, clamps the travel to 18–40 px and
publishes it as `--scene-pan`. Seat plates and lantern glows sit on things
painted in the picture, so they follow that value; the plates follow at a shade
less so a name near the edge is not pushed off screen.

The cloth below the table is a flat wash with nothing to parallax, so it carries
its own arabesque and a pool of the room's light — both panning — rather than a
blurred copy of the scene, which read as a smear.
`prefers-reduced-motion` turns the whole thing off and hides the pad.

## Light

The scene is a still photograph, so the light is added over it: one warm pool
per lamp in the picture, each breathing on its own cycle, a handful of embers
rising through them, and a slow highlight wandering across the cloth. The lamp
positions are percentages of the picture, measured off `room.webp`, so they
follow it as it scales. All of it honours `prefers-reduced-motion`.

## Friends & invitations

There is no "friends on map" feature in this repository. The closest existing
thing is the friends list inside the Balady Challenge gamification (add by player
number, gifts, leaderboards — see the `friends_*` / `game_friends` keys in
`assets/langs/`), so the invite flow is modelled on it and integrates through a
host bridge.

What works with no host at all: a room code, a share link, the native share
sheet / clipboard, and adding friends by player number (kept in `localStorage`).
Seats you fill with friends are played by a bot under that friend's name until
the host reports them as joined, so a game never blocks on an invitation.

Real-time play between devices needs a transport; the bridge below is the seam
where it plugs in.

### Game → host

Sent over every channel available (`flutter_inappwebview.callHandler('baloot', …)`,
`BaladyBridge.postMessage`, `ReactNativeWebView.postMessage`, `parent.postMessage`),
always shaped as `{source:"baloot", action, payload}`:

| action | payload | meaning |
|---|---|---|
| `ready` | `{version, room}` | mini-app booted |
| `getFriends` | `{}` | asking for the friends list |
| `invite` | `{room, deepLink, ids, seats}` | host should deliver the invitations |
| `share` | `{room, url, text}` | open the native share sheet |
| `matchResult` | `{scores, winner, rounds}` | for points / leaderboard |

### Host → game

Call these from Dart, e.g.
`controller.evaluateJavascript(source: "window.Baloot.onFriends($json)")`:

| call | argument |
|---|---|
| `window.Baloot.onFriends(list)` | `[{id, name, online}]` |
| `window.Baloot.onFriendJoined(f)` | `{id, name?, seat?}` |
| `window.Baloot.onRoom(r)` | `{room, seats:[{id,name,bot,joined}]}` |
| `window.Baloot.setLang(l)` | `"ar"` \| `"en"` |

`window.postMessage({source:"balady-host", action:"friends"|"friendJoined"|"lang", payload})`
works too, for an iframe host.

If nothing answers `getFriends` within 1.5 s the game falls back to the local
list, so an unaware host degrades gracefully instead of hanging.

## Verification

`index.html?test=1` runs 30 assertions over the deck, point totals, the two
rounding rules, trick resolution, every legality rule, project detection and
round scoring (including the failed-bid, kaboot and tie branches, and a guard
against double-counting projects in Sun).

The engine was additionally exercised over 400 simulated all-bot rounds: raw
points always totalled 130 (Sun) / 162 (Hokum), the AI never produced an illegal
move, no hand ended with cards left over and no round needed a redeal.
