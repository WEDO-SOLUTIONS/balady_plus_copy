# Baloot — mini-app (بلوت)

A complete, self-contained Baloot card game in a single HTML file: `index.html`.
No build step, no dependencies, no network calls — it runs offline by opening the
file in any browser, and it is meant to be served as a Balady+ mini-app.

```
mini_apps/baloot/
  index.html                 the whole game (markup, styles, rules engine, AI, UI, host bridge)
  room.webp                  the majlis scene, cut from the mock-up
  crest.webp                 the plaque, scroll and shield — the title card on the way in
  btn-gold.webp              the primary button face, emptied of its label
  btn-outline.webp           the outlined button face, emptied of its label
  corner-{tl,tr,bl,br}.webp  the gold arabesque, one file per corner
  ardah.mp3                  optional: an Ardah recording to loop instead of the synthesised drums
  baloot-standalone.html     the same game as one file, assets inlined
  demo/index.html            a mock Balady+ shell that drives this game over the bridge
  baloot-demo-standalone.html  the demo and the game folded into one file
  tools/extract-assets.py    re-cuts the images from the source mock-up
  tools/build-standalone.py  folds the images into the single-file build
  tools/build-demo-standalone.py  folds the game into the demo, for one sendable file
  README.md                  this file
```

Storage is a convenience, never a dependency: a sandboxed frame, a blob
document or a browser with site data blocked denies `localStorage` outright, so
every read and write goes through a small `Store` helper and the game falls back
to its defaults instead of failing to boot.

`baloot-standalone.html` is `index.html` with every image inlined as a data URI
— one 398 KB file that opens straight from disk with nothing beside it, handy
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

The two button faces are no longer loaded by the page. They were stretched as
nine-slice `border-image`, and a border thinner than the slice squeezes the
corner pieces while the middle band keeps its own gradient, so the seams showed
as bands across every button and the disabled main button drained to olive. The
faces are now drawn in CSS from the colours sampled down the middle of those
same files — a fourteen-stop gradient for the gold one, a lit green face with
a gold rim for the secondary one — which scales to any size without a seam. The
files stay in the folder as the reference the gradients came from. The
arabesque ships as four rotations because a background layer cannot be cropped
to one cell of a sprite; together they frame the panels. Everything else in the
page is drawn in CSS too, and the game keeps working (plainer) if the images
are missing.

## Running it

| Context | How |
|---|---|
| Browser | open `index.html`, or `baloot-standalone.html` for a single file |
| Self-check | open `index.html?test=1` — 64 rules assertions, results in the console and a toast |
| Deep link into a room | `index.html?room=UY9ED8` |
| Full screen | the ⛶ button beside the table, or the `F` key |
| Mini-app | ship the folder as a mini-app bundle; `CustomInAppLocalhostServer` serves `index.html` from the bundle's document root (see `lib/mini_apps_engine/`) |

Arabic (RTL) is the default, English is selectable in the settings sheet;
the initial language follows `navigator.language` and is remembered in `localStorage`.

## Implemented rules

The reference is the Saudi Mind Sports Federation regulation
(«القوانين المعتمدة للبلوت في الاتحاد السعودي للرياضات الذهنية») together with
pagat.com's reading of the same tournament rules; the clause numbers below are
the regulation's own (البند الرابع ٤-٢ … ٤-١١, البند الخامس, البند السادس,
البند الثامن).

- 32 cards, 4 players, 2 partnerships (seats 0/2 vs 1/3), 8 cards each.
- Bidding: 5 cards dealt, one turned face up. Round 1 is Hokum on that suit, Sun,
  **Ashkal** or Pass, and **Sun outbids Hokum**. Ashkal is a Sun bought for the
  partner — only the third or fourth player may say it, only while nobody has
  bought, and it is the partner who takes the face-up card and becomes the buyer
  (البند الثامن). If everyone passes, round 2 allows any trump suit or Sun, with
  no Ashkal; the dealer takes the best suit rather than force a redeal.
  The buyer then receives the face-up card plus two, the others three, and the
  player to the dealer's right leads to the first trick whoever bought.
- Ranking and points: Sun `A>10>K>Q>J>9>8>7`; trump `J>9>A>10>K>Q>8>7`
  (`J=20`, `9=14`). Last trick +10 — 130 raw in Sun, 162 in Hokum.
- Legal moves are enforced: follow suit; in Hokum beat the trick with a trump
  when void and able — and when unable, anything goes, because throwing a trump
  underneath is allowed and never forced; over-trump a trump lead when you can;
  throw away freely when the partner is winning, *except* as third hand behind a
  partner's lead that can still be beaten. An Ace, or a lead that is the highest
  card of its suit still out (**Ekka**, announced automatically), frees the third
  hand from having to trump.
- Projects, in game points (البند السادس):

  | | Hokum | Sun |
  |---|---|---|
  | Sra — three in sequence | 2 | 4 |
  | Fifty — four in sequence | 5 | 10 |
  | Hundred — five in sequence, or four kings/queens/jacks/tens | 10 | 20 |
  | Four Hundred — four aces | 10 (scores as a Hundred) | 40 |
  | Baloot — K+Q of trumps | 2 | — |

  Only the team holding the single best project scores, and it scores every
  project it holds. A sequential Hundred outranks a Hundred of four equal cards
  (٥-٢) and sets of four run A, K, Q, J, 10 (٥-٣); equal projects go to the
  player nearest the dealer's right (٥-٧). No card serves two projects, so a
  hand of eight holds at most two — four kings out of `♦K ♥K ♠K ♣A-K-Q-J-10`
  leave a Sra, not a second Hundred. Four nines, eights or sevens are *not*
  projects. Baloot is scored independently by either team, unless it sits inside
  a Hundred that team showed (٥-٨).
- Doubling (البند السابع): before the first card a defender may say **دبل** on
  a Hokum and choose **مقفل** (locked) play, in which nobody may lead a trump
  unless their whole hand is trumps; the buyer may answer **ثري**, the doubler
  **فور** (locked or open), and the buyer finally **قهوة**, which wins the match
  outright. A Sun may only be doubled, and only by a side at 100 or less against
  a side past it (٧-٢); there is no ثري, فور or قهوة in Sun (٧-١). A doubled
  round is all or nothing: the winners take 16 or 26 × the multiplier plus twice
  the value of every project shown by either side — projects double and no more,
  even at ثري or فور (٥-٥) — Baloot stays a flat 2, and the losers take nothing.
  Bots double on the strongest tenth of hands and never call قهوة.
- Scoring (البند الرابع): **only one team counts its card points** — the
  defenders, or the buyer's team once a double has moved the count (٤-١٠). In Hokum that count is rounded
  to the nearest ten with a five rounding *down*, then divided by 10; in Sun it
  is rounded to the nearest ten unless it ends in five, in which case it is not
  rounded at all, then divided by 5 (٤-١١). The buyer's team is handed the rest
  of the round's 16 (Hokum) or 26 (Sun), which is why a round can never pay out
  more than it holds — converting both sides independently would give 9 and 8
  for 86/76 in Hokum, seventeen points from a round worth sixteen. Projects are
  added on top in game points. Level game points go to the side that gave up
  more in the rounding, and to the buyer's team if both gave up the same. A
  failed bid (خسارة) hands the defenders the whole round plus every project in
  it; kaboot is 44 (Sun) / 25 (Hokum) plus that team's own projects; game to 152.

  The regulation's own worked thresholds all fall out of this arithmetic and are
  asserted in the self-check: a Sun is lost at 66 defending points and a Hokum at
  82 (٤-٢, ٤-٣), with a Sra at 56 and 72 (٤-٤, ٤-٥), with a Fifty at 41 and 56
  (٤-٦, ٤-٧), with a Hundred at 16 and 32 (٤-٨, ٤-٩).

House rules that vary by region are collected in the `CFG` object near the top of
the script (`target`, `kabootSun`, `kabootHokum`).

Known gaps against the regulation, still open: projects are detected and awarded
automatically rather than declared before the second card and shown on it; the
bots are forced to buy in the second round where a human may pass and force a
redeal; and a kaboot pays 44/25 whatever the multiplier, following ٧-٧ literally
rather than pagat's doubled 88/50.

## On a phone, and on everything else

A phone-shaped window — 560px or narrower and at least half again as tall as
it is wide — gets the whole game, edge to edge. Every other window becomes the
room around it: the majlis is thrown out of focus behind a vignette and the
table is centred in it, framed like a handset, at

    --app-w: min(100vw, 452px, max((100vh - 34px) / 2.1, 300px))

with `--app-h` the lesser of `--app-w × 2.1` and the window. Nothing in the page
is measured against the window: `--vw` and `--vh` are one percent of that
column across and down, and the card size, the crest, the status line, the seat
plates and every part of the action rail are continuous functions of them. So
dragging a window edge scales the same layout instead of snapping to another
one — there is no width or height breakpoint left in the stylesheet apart from
the one that takes the frame off a phone. The ⛶ button in the corner, or the
`F` key, takes the page full screen; it is hidden on a touch screen.

## Sound

Two layers, both generated in the page: short blips for cards, bids and tricks,
and the **Ardah** rhythm (العرضة السعودية) under the game — the deep تخمير on
the downbeat, the tighter طار answering it, and the hands of the row between
them, at 76 BPM. The drums are synthesised with WebAudio rather than sampled,
so the file still runs offline with nothing licensed inside it. A kaboot, a
قهوة and the end of a match get a flourish: a roll that tightens into two hits.
The drums start on the tap that starts the game (browsers will not play audio
before one), stop when the tab is hidden, and have their own switch in the
settings sheet.

To use a real recording instead, drop `ardah.mp3` (or `.m4a` / `.ogg`) next to
`index.html`: the page prefers it and loops it, and `tools/build-standalone.py`
folds it into the single-file build as a data URI. Nothing else changes.

## Look

The table follows a supplied mock-up, with one departure: the ornate gold plaque
that headed it now greets you on the way in and leaves the table alone, so the
status line — deal number, target, `Us / Them` in green and gold — is the
header there. The plaque cost 99px of an 880px screen and the room wanted them:
the majlis is 399px tall now against 336 when it headed the table. Below that, a round wooden-rimmed table with the
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

## Light

The scene is a still photograph, so the light is added over it: one warm pool
per lamp in the picture, each breathing on its own cycle, a handful of embers
rising through them, and a slow highlight wandering across the cloth. The lamp
positions are percentages of the picture, measured off `room.webp`, so they
follow it as it scales. The cloth below the table carries its own arabesque and
a pool of that light. All of it honours `prefers-reduced-motion`.

The scene itself does not move. An earlier build panned it from the gyroscope,
with a tilt pad and a lock slider standing in on a desktop; it was removed
along with the `--tilt` / `--scene-pan` plumbing, so the picture now sits
still and every element is laid out once.

## Friends & invitations

"Friends on map" exists as a prototype on `feat/BE-213/friends-on-map`
(`mapness/lib/features/friends_on_map/`, one commit on top of `development`,
not merged): a `FriendsDataSource` with a one-shot `getFriendLocations()` and an
incremental `watchFriendLocationUpdates()` stream, a mock source behind a debug
panel, clustered markers on the native map and a `LayerType.friends` toggle in
the layers sheet. It carries no identities yet — `FriendLocation` is a user id,
a point, a timestamp and a battery level — so the invite flow here is modelled
on the shipped friends list inside the Balady Challenge gamification (the
`friends_*` / `game_friends` keys in `assets/langs/`) and integrates through a
host bridge. The friends list comes from the host only — there is no way to add
a player by number inside the mini-app, because the app owns who your friends
are. If BE-213 lands, the same
bridge can carry a friend's presence: `onFriends` already takes a list, and
`invite` already goes back to the host.

What works with no host at all: a room code, a share link and the native share
sheet / clipboard. Seats you fill with friends are played by a bot under that
friend's name until the host reports them as joined, so a game never blocks on
an invitation.

A bot never passes for a person. A bot seat carries a `Bot` tag in the lobby
list and the same tag on its nameplate at the table, in both languages, and the
lobby says so in a line under the seats. Any bot seat can be handed to a friend
before the deal with the `＋` button on its row, which opens the invite sheet;
the primary button reads *Start the game* as soon as one seat is a friend and
*Play with bots* only when none is. That is what makes "start with one friend
and fill the rest later" honest rather than a silent stand-in.

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

`window.postMessage({source:"balady-host", action:"friends"|"friendJoined"|"room"|"lang", payload})`
works too, for an iframe host — `demo/index.html` is exactly such a host.

If nothing answers `getFriends` within 1.5 s the game falls back to the local
list, so an unaware host degrades gracefully instead of hanging.

## Concept demo — how a table gets gathered

`demo/index.html` runs the four gathering mechanics from the
*Friends on map × Baloot* concept, end to end, in a browser. The phone on the
left is a mock of the Balady+ shell — the schematic map, the friends layer, the
sheets; the game inside it is this mini-app, unmodified, driven over the bridge
above. Every message in either direction is printed in a log beside it, so what
the app would have to implement is visible rather than described.

| mechanism | what the demo does |
|---|---|
| 1 · invite with a surplus | six invitations for three seats; acceptances land one by one and each one creates a seat, the late ones are told the table filled |
| 2 · a raised hand, not a lobby | pick a window, raise a hand, close the sheet; other hands go up nearby, the fourth triggers a push and the table opens full |
| 3 · the quorum on the map | a readiness chip on the layer, a table forming at 3/4, and the fourth seat taken from the map itself |
| 4 · start now, swap the bot later | start with one friend and two labelled bots, then hand a bot seat to a friend who arrives |

Every scenario prints a line under the phone saying what to press next, and the
button the demo expects next is the gold one beside the log.

Open it directly (`demo/index.html`) or through the mini-app server. For
sending it on, `python3 tools/build-demo-standalone.py` folds the game into the
page as one 461 KB `baloot-demo-standalone.html` — the frame is fed from a blob,
so the bridge still runs between two documents. Rebuild `baloot-standalone.html`
first, since the demo build reads it. What is
mocked: the map, the friends data and other players' acceptances. What is real:
the game, the bridge, the seats, the `Bot` labels and the swap. What is *not*
in it: live play between two devices — that needs a transport and a rooms
service, and every seat here is played out on one device.

## Verification

`index.html?test=1` runs 64 assertions over the deck, point totals, both
rounding rules, trick resolution, every legality rule including Ekka and locked
play, project detection and ranking, and round scoring with and without a double — among them pagat's worked examples of
the tournament scoring and the federation's own loss thresholds (٤-٢ … ٤-٩),
plus a sweep of all 293 possible card splits checking that a round hands out
exactly the points it holds.

The engine was additionally exercised over 1500 simulated all-bot rounds: raw
points always totalled 130 (Sun) / 162 (Hokum), the AI never produced an illegal
move, no hand ended with cards left over, no round needed a redeal, every round
paid out exactly its 16 or 26 plus projects, every failed bid paid the defenders
the whole round, and every doubled round paid the winners exactly
`16 × multiplier + 2 × projects` — with no trump ever led in a locked one.
