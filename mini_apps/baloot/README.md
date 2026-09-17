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
— one 405 KB file that opens straight from disk with nothing beside it, handy
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
| Self-check | open `index.html?test=1` — 64 rules assertions, results in the console and a toast |
| Deep link into a room | `index.html?room=UY9ED8` |
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
springs back. Under the arrows a hairline slider holds the camera at one angle,
so a demo can be aimed and left there; pressing either arrow, or double-clicking
the track, lets it go and recentres. A held arrow wins over the lock, and the
lock wins over the gyroscope.

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
