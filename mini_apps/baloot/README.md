# Baloot — mini-app (بلوت)

A complete, self-contained Baloot card game in a single HTML file: `index.html`.
No build step, no dependencies, no network calls — it runs offline by opening the
file in any browser, and it is meant to be served as a Balady+ mini-app.

```
mini_apps/baloot/
  index.html   the whole game (markup, styles, rules engine, AI, UI, host bridge)
  README.md    this file
```

## Running it

| Context | How |
|---|---|
| Browser | open `index.html` |
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

The mock-up's photographic majlis is not reproducible in a dependency-free page,
so the room is rendered procedurally — warm walls with lantern pools, an
arabesque lattice and a vignette — keeping its palette and composition.

Hints are a real suggestion: the bubble and the rail button both name the card
the bots would play from your seat, and the rail button plays it. They can be
turned off in the settings sheet.

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
