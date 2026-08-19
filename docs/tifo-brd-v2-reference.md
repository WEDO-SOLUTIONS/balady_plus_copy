# Balady TIFO — BRD V2 reference

Condensed, engineering-facing digest of **"BRD V2 - Balady Tifo"** (Confluence page id `632619009`).

- **Internal document version:** 0.2 · **Date:** 21 July 2026 · **Status:** Draft · **Author:** Wafeer Analysis Team.
- History: `0.1` (8 Jul 2026, first draft) → `0.2` (21 Jul 2026, **"Second Draft – Reflect confirmed changes"**).
- **This document SUPERSEDES `docs/tifo-brd-v1.2-reference.md`.** Where the two disagree, V2 wins.

> Derived summary for quick reference — the Confluence page is the source of truth. Values marked *To define* are not final.

---

## 0. Changed vs V1.2 — read this first

- **Gate order flipped: tutorial-first.** Onboarding routes to the first unmet step in order **tutorial started → team selected**; login is required only at **team confirmation** (US-04 AC-03) — not as the first gate. (But see inconsistency #1 below.)
- **Result screen: win/lose only** — **no scoreline, no draw**; the **win outcome gets a celebratory treatment** (US-14).
- **Building statuses reduced to two: Available / Blocked.** Cooldown removed from the UI (built, off at launch). Blocked is shown **via the disabled button itself** — label `"Hold on... this building is currently being played."` — not a status field (FR-10: "Building status (Available or Blocked) will be reflected in the button itself").
- **HUD reduced to 3 items:** Scored, Misses remaining, Score to beat (FD-48–50). "Attempted" and "Missed" counters dropped.
- **NEW: AFK prompt.** Idle for the configured window → "Are you still playing?" prompt. Confirm = play continues; **decline or timeout = session ends with the current score SAVED** and resolved normally.
- **NEW: voluntary exit.** Player may exit mid-session (with confirmation); **score SAVED**, resolves normally. **App close / connection loss still VOIDS** (no score, no refund).
- **Tutorial interruption resets the gate:** any session loss inside the tutorial (internet loss, manual app close, crash) → tutorial counts as **not started**, precondition unmet (US-03 AC-07/BR-06).
- **3 free first claims** for a new player — **claims of unclaimed buildings only, never challenges** (§5.4, §12.2).
- **Trip earning is flat +2 tokens** per qualifying trip with a **1 km minimum distance** — the V1.2 declining curve (+3/+2/+1) is gone.
- **Daily trip cap and maximum balance are OFF at launch** (built + instrumented, may be enabled if inflows run hot).
- **NEW inflow: manual operator grants** (e.g. tied to real-world results) — FR-19, US-16 BR-01, §12.4.
- **Season length confirmed: 1 month** at launch.
- **Map must be 2D:** "The map should be shown in 2D view (bird eye view)." (US-05 BR-05).
- **Support = replay tutorial + how-to-play only.** FAQs removed (FR-23, US-17).
- **All MSG texts removed** — §11 is an empty table, "to be defined if messages are part of the requirement". Do not reuse V1.2 MSG-01…19 strings.
- **FD/BT renumbered:** now **FD-01…53** and **BT-01…26** (V1.2 had 57/29). Do not map old ids 1:1.
- Copy changes: "Join Tifo"/"Start playing" → **"Dominate with your team"** (شجّع وهيمن!); district CTA → **"Take over the district"** (سيطر على الحيّ); welcome-bonus CTA → **"Claim the map"** (هيمن على الخريطة!); tabs are now **"Table"** (leaderboard) and **"Profile"** (dashboard).

---

## 0b. V2 internal inconsistencies (raised with analysts)

1. **Gate order contradiction:** FR-03 and US-02 BR-03 still say route order "logged in, tutorial started, team selected" (login-first), while every AC (US-01/02/05/06/08/09/10) and all buttons route **tutorial-first** with login only at team confirmation. Implement tutorial-first; flagged.
2. **Stale statuses:** FR-12 still enables challenge "disabled when the status is Cooldown or Live"; US-08 BR-03 says "one of three statuses" then lists only Available/Blocked. §12.2 has cooldown Off.
3. **Cap language vs §12.4:** FR-19 ("shall cap the balance"), US-15 BR-03, US-16 AC-04/AC-05/BR-03/BR-04 all assume a daily trip cap and max balance that §12.4 turns **Off** at launch. Treat as dormant logic behind config.
4. **US-16 AC-03 still says "trip earning curve"** — §12.4 is a flat +2.
5. **US-17 BR-01: "Support contains three elements"** — then lists two (Replay tutorial, How to play).
6. **US-10 BR-05 still says "Owned"** — the stat was renamed to "Claimed" elsewhere (AC-06, BR-04, FD-38).
7. **§5.5 mechanics table:** the "Qualifying trip requires a minimum distance" row has an **empty status cell** (everything else Confirmed).
8. **Exit vs app-close boundary:** US-12/13 AC-07 voids on "Connection lost mid-session / Application closed by player", while AC-10/AC-11 + BR-08 save the score on AFK-timeout/voluntary exit. Where a backgrounded/killed app falls needs confirmation.

---

## 1. What TIFO is

Location-based territory game layered on the Balady+ map. One football club per season; capture **individual buildings** across Riyadh via a short **penalty shootout vs an NPC keeper**. Districts tinted by the club owning the most buildings. Browsing open to everyone; **playing requires** logged in + tutorial started + team selected. Paced by a token economy (earned, never purchased, no cash value). Tunable without a release; runs in seasons with a full ownership reset.

---

## 2. System mechanics (§5) — all Confirmed unless noted

### 2.1 Buildings, districts & ownership
- Building = unit of competition; **launch coverage = every building in Riyadh** (Balady registry). One owner + a `saved score`.
- **"Ownership transfers only when a challenger's score strictly exceeds the saved score; a tie keeps the building with the holder."** Nothing else transfers ownership — not time, not inactivity.
- **No location lock** — claim/challenge from anywhere.

### 2.2 District standing
- Leader = club with the **most buildings (raw count)**. Neutral **only** at zero buildings held.
- **No tied districts** — incumbent retains on equal count; changes only on **strictly more**. Recalculated on every ownership change.

### 2.3 The penalty challenge
- Shootout vs NPC keeper; session ends on the configured miss count (**3**); score = goals before then. Single mechanism for claim and challenge.
- **AFK prompt:** idle for the AFK window → "Are you still playing?" for a set time. Confirm → continue. **Decline / auto-dismiss → session ends, "the current score is saved as the session score, resolving as a normal session end."**
- **Voluntary exit** (after confirmation) → same as AFK end: score saved, normal resolution.
- **Interruption** (connection loss) → **voided**: no score, ownership unchanged, no refund.
- Scores **server-validated** with anomaly detection; client never self-reports a trusted score.

### 2.4 Claiming & challenging
- **Claim** (unclaimed): score ≥ 1 goal takes it; score becomes saved score. **Challenge** (held): transfer only on **strictly higher**.
- Each attempt costs tokens, **deducted regardless of outcome**; claim and challenge costs may differ.
- **"A new player's first few claims of unclaimed buildings are free (the number is configured); the free claims apply to claims only, not challenges."** (§12.2: 3 free.)
- In-progress building is **Live**-locked to other challengers; auto-released after a timeout if the session drops.
- Per-building cooldown after a successful claim/challenge: **built, disabled at launch**.

### 2.5 Token economy
- Tokens are the only pacing brake; **no purchase, no cash value**.
- Inflows: **starting grant, daily allowance, trips (flat amount per qualifying trip), manual Game-Operator grants**. Outflow: attempts.
- Qualifying trip must meet a **minimum distance** (1 km). *(status cell empty in source — see inconsistency #7)*
- **No daily trip cap and no maximum balance at launch** — both built and instrumented but off. Passive holding reward and district production income: off at launch.

### 2.6 Fairness & balancing
- Raw building count, no per-player cap at launch (accepted to drive early coverage). Lopsidedness threshold off. Underdog assist / per-player cap built but off; **assist mechanic undefined/deferred**.

### 2.7 Seasons
- **Season = one month at launch** (configurable). Season start: reset all ownership → neutral + clear saved scores. Roster reconfirmed each season; club retained where it remains; **club locked in-season**. Recurring seasons not confirmed (1 at launch).

### 2.8 Integrity
- Trip validation (distance, time, plausibility) guards the trip token source.

---

## 3. Configurable parameters (§12)

Status = confirmation of the default **value** (Confirmed / Value to define).

### 12.1 Penalty challenge
| Key | Launch default | Range | Status |
|---|---|---|---|
| Misses allowed (session end) | `3` | 1–10 | Confirmed |
| AFK window | `To define` (s) | idle time before prompt | **To define** |
| AFK prompt timeout | `To define` (s) | prompt shown before auto-dismiss | **To define** |
| Keeper difficulty | Tunable curve | difficulty profile | Confirmed |

### 12.2 Claiming & challenging
| Key | Default | Range | Status |
|---|---|---|---|
| Minimum claim requirement | `1 goal` | ≥ 1 | Confirmed |
| Claim cost (unclaimed) | `2 tokens` | ≥ 0 | Confirmed |
| Challenge cost (held) | `1 token` | ≥ 0 | Confirmed |
| First free claims | `3` (unclaimed only) | count per new player | Confirmed |
| Failed-challenge refund | `None (0)` | 0 – full cost | Confirmed |
| Cooldown (after successful claim/challenge) | `Off` | On/Off | Confirmed |
| Cooldown duration | `n/a (off)` | if enabled | Confirmed |
| Live-lock timeout | `To define` (s) | auto-release after interrupt | **To define** |

*(§12.3 skipped in the source, same as V1.2.)*

### 12.4 Token economy
| Key | Default | Range | Status |
|---|---|---|---|
| Starting grant (one-time) | `15` | ≥ 0 | Confirmed |
| Daily free allowance | `10` | ≥ 0 | Confirmed |
| Trip earning | `+2` (flat) | per-trip | Confirmed |
| Trip validation distance | `1 km` minimum | per-trip | Confirmed |
| Daily trip cap | **`Off` at launch** | Off / ≥ 1 | Confirmed |
| Maximum balance | **`Off` at launch** | Off / ≥ 1 | Confirmed |
| Manual token gifting | `Enabled` | operator-granted | Confirmed |
| Passive holding reward | `Off` | On/Off | Confirmed |
| District production income | `Off` | On/Off | Confirmed |

### 12.5 Fairness & balancing
Raw building count · per-player cap `None` · underdog assist `Off` · "too lopsided" threshold `Off` — all Confirmed.

### 12.6 Seasons
Roster `5` teams · **season length `1 month`** · season prizes `Off` · club-selection lock `Locked in-season` — all Confirmed.

### 12.7 Fixed design rules (NOT configurable)
All Riyadh buildings at launch · one owner per building · no location lock · strictly-higher transfer, tie keeps holder · district incumbent retains, neutral only at zero · Live-lock always on · no real-money tokens · full ownership + score reset at season start.

**As always: trust `/config` at runtime, never hardcode defaults.**

---

## 4. Journey & user states (§8.4)

States: **Visitor (logged out)** → **Logged-in no-team** → **Logged-in team-selected**. Browse open in all; play needs logged in + tutorial started + team selected. Entire surface subject to the Tifo toggle.

**Gate order (route to first unmet): tutorial started → team selected** — per US-01 BR-01: routes "in the order: tutorial started, then team selected". Login is enforced at team confirmation (US-04: "A team can be confirmed only when the user is logged in"). *(FR-03/US-02 BR-03 still say login-first — inconsistency #1.)*

- **Entry popup:** intro + **"Dominate with your team"** + Close(X). CTA → first unmet step (or Landing, game active, if onboarded); Close → Landing.
- **Tutorial** ("Simulation"): mandatory, autoruns on first entry, **starting it clears the gate permanently** (complete or skip); skippable only after start; replayable from Support without re-gating; nothing persists. **Any session loss inside it → "will deem the tutorial as not started and this precondition not met."** (BR-06).
- **Team select:** 2 steps — (1) pick club + Confirm (Confirm enabled only when logged in), (2) welcome bonus → **"Claim the map"**. "Maybe Later" = browse-only. Club **locked for the season**.

---

## 5. Screens & required content

| Screen | Must contain (BRD V2) |
|---|---|
| **Landing / map** | Tifo overlay + toggle (default on, persists per user, off hides all Tifo); district coloring by leader; trophy → leaderboard; **"Dominate with your team" only when NOT play-ready** (hidden when play-ready); **2D bird-eye view** |
| **District details** | name + area, current owner + standing-since, control% (owner ÷ total), total/claimed/free, per-club breakdown (sums to claimed); CTA "Take over the district" (not play-ready → onboarding; play-ready → Landing) |
| **Building details** | name + area, ownership state, owner + standing-since (when claimed), score to beat (0 if unclaimed), contested-7d (info); **status via button**: "Challenge" enabled when Available, disabled `"Hold on... this building is currently being played."` when Blocked |
| **Leaderboard "Table"** | rank, club, districts owned, buildings owned, ownership% (÷ city total); sort buildings → districts → shared rank (standard competition ranking); no per-club drill-down |
| **Profile** (tab of same panel) | team block (crest/name/joined/rank \| "not selected" \| login prompt); token tiles (balance, next-daily countdown, trips today, all-time earned); matches Total/Won/Lose/**Claimed** (no Draw); recent activity + "View all" (history screen not designed) |
| **Game preview** | "Penalty Challenge" title, tokens needed (per config; free-claim = 0 when applicable), objective (score-to-beat / capture), misses rule; Start deducts token(s) |
| **Game HUD** | **Scored · Misses remaining (of configured) · Score to beat** — nothing else |
| **AFK prompt** | "Are you still playing?" — Yes = continue; No / auto-dismiss = session ends, **score recorded** |
| **Game result** | Win (**celebratory**) / Loss, **no scoreline**; dismiss → Building details (updated) |
| **Support** | Replay tutorial + How to play — **no FAQs** |

---

## 6. Functional requirements (§6, FR-01…26)

- **FR-01** Tifo overlay + on/off toggle; "the toggle state shall persist per user and default to on for new users."
- **FR-02** Any user browses all Tifo screens read-only without login/team.
- **FR-03** Play requires logged in + tutorial started + team selected; route to first unmet step. *(states login-first — inconsistency #1)*
- **FR-04** Entry popup introduces Tifo, routes by state.
- **FR-05** Mandatory first-run tutorial: autoruns, skippable after start, clears gate on start, replayable from Support without re-gating.
- **FR-06** One club per season, locked for the season.
- **FR-07** District tinted by leading club; neutral only at zero owned.
- **FR-08** Claimed building = colored polygon in owner club color; free buildings uncolored.
- **FR-09** District details: owner, standing duration, control%, counts (total/claimed/free) + per-club.
- **FR-10** Building details: ownership state, owner + standing, score to beat (0 if unclaimed), contested-7d (info); **"Building status (Available or Blocked) will be reflected in the button itself."**
- **FR-11** Challenge = shootout ending on configured misses; score = goals before then.
- **FR-12** Challenge only when Available. *(still says "disabled when Cooldown or Live" — inconsistency #2)*
- **FR-13** Claim unclaimed when final score ≥ 1; saved score = final score.
- **FR-14** Transfer held building only on strictly greater score.
- **FR-15** Live-lock during a session; auto-release after configurable timeout on interrupt.
- **FR-16** Void interrupted session: no score, no ownership change, **no refund**.
- **FR-17** Result = "win (building captured) or loss (not captured) with no numeric scoreline"; return to building details.
- **FR-18** Deduct configured tokens to start; never refund.
- **FR-19** Grants: one-time welcome bonus (team confirm), daily allowance, trips, **manual operator grants**; balance cap per config. *(cap Off at launch — inconsistency #3)*
- **FR-20** No token purchase; no cash value.
- **FR-21** Leaderboard: buildings → tie by districts → shared rank only when both equal; show districts/buildings/Map Dominance (÷ city total).
- **FR-22** Profile: team + rank, token info, matches (total/won/lose/claimed), recent activity + full history.
- **FR-23** Support: replay tutorial + how-to-play. **No FAQ.**
- **FR-24** Operator views/edits config params; live without release; validated ranges; operator-only.
- **FR-25** Operator creates/configures season (length, roster) and triggers reset (ownership → neutral, scores cleared).
- **FR-26** Localization AR + EN incl. **RTL**.

**NFR-01…07:** performance (no perceptible input lag in the challenge) · scalability (all Riyadh, concurrent city-wide) · availability (graceful transient loss → void handling) · reliability (consistent ownership/scores/balances, last-write-wins) · localization (AR/EN + RTL) · configurability (no release) · maintainability (mechanics vs tunables separated). *(V1.2's separate Security and Usability NFRs are folded/dropped.)*

---

## 7. User stories index + hard rules (§8)

Actor = Balady+ User unless noted. Same 19 stories as V1.2; US-18/19 remain *(To be revisited)*.

| US | Title | Feature | Prereq |
|---|---|---|---|
| US-01 | Discover and enter Tifo | Onboarding & Access | — |
| US-02 | Log in to play | Onboarding & Access | — |
| US-03 | Complete the walk-through tutorial | Onboarding & Access | — |
| US-04 | Choose my club | Onboarding & Access | Logged in; tutorial started |
| US-05 | View the district map | Map & Standings | — |
| US-06 | View district details | Map & Standings | — |
| US-07 | View buildings on the map | Map & Standings | — |
| US-08 | View building details | Map & Standings | — |
| US-09 | View the leaderboard "Table" | Map & Standings | — |
| US-10 | View my dashboard "Profile" | Map & Standings | — |
| US-11 | Preview a challenge | Gameplay | Logged in; tutorial; team |
| US-12 | Claim an unclaimed building | Gameplay | Logged in; tutorial; team |
| US-13 | Challenge a held building | Gameplay | Logged in; tutorial; team |
| US-14 | View my game result | Gameplay | Logged in; tutorial; team |
| US-15 | View my token balance | Token Economy | Logged in |
| US-16 | Earn tokens | Token Economy | Logged in |
| US-17 | Access support | Support & Help | — |
| US-18 | Configure game parameters *(revisit)* | Administration | Game Operator |
| US-19 | Manage seasons *(revisit)* | Administration | Game Operator |

Selected hard rules:
- **US-01 BR-01 (gate):** CTA routes "to the first unmet onboarding step in the order: tutorial started, then team selected"; all met → Landing with game active. Close(X) always → Landing.
- **US-03:** starting the tutorial clears the gate forever; **BR-06:** session loss "will deem the tutorial as not started".
- **US-04:** Confirm requires login; welcome bonus on confirmation; "Maybe Later" = browse-only; locked in-season.
- **US-05:** toggle default-on, per-user persistent; **BR-05: 2D bird-eye map**; no CTA when play-ready.
- **US-08:** "Challenge" enabled only when Available; Blocked → disabled button with the "Hold on..." label; claim uses the same flow vs score-to-beat = 0.
- **US-09:** rank buildings → districts → shared rank (two 2nds → next is 4th); ownership% doesn't sum to 100%.
- **US-10:** matches Total/Won/Lose/Claimed, **no Draw**; activity history screen not designed.
- **US-11:** preview shows cost/objective/misses (from config); Start deducts; **BR-06:** first configured claims can be free (cost 0).
- **US-12/13:** HUD = scored / misses-remaining / score-to-beat; claim ≥ 1, challenge strictly-greater; interrupt → void, no refund; **AFK decline/timeout → "the session will end, And the current score will be recorded"**; **exit → "the session will be ended, the score will be kept, and normal flow will continue"** (BR-08).
- **US-14:** win (celebratory) / loss only; "there is no draw"; **no scoreline** (FD-51: "Win (captured) or Lose; no scoreline"); interrupted session produces no result.
- **US-16:** inflows incl. manual operator grants; trips validated before granting.
- **US-17:** Support = replay tutorial + how-to-play; replay never re-gates.

---

## 8. Fields (§9, FD-01…53) — renumbered vs V1.2

`EN | AR | screen · notes`

- FD-01 Tifo intro title | عنوان تعريف تيفو | Popup
- FD-02 Intro image | صورة تعريفية | Popup
- FD-03 District ownership color | لون ملكية الحي | Landing · leading-club color; neutral when none
- FD-04 Claimed building polygon | مضلع المبنى المُطالَب به | Landing · owner-color polygon; none if free
- FD-05 Tifo on/off toggle state | حالة تفعيل تيفو | Landing · on by default, persists per user
- FD-06 District name | اسم الحي | District details
- FD-07 Area label | اسم المنطقة | District details
- FD-08 Current owner (club) | المالك الحالي (الفريق) | District details · neutral when none
- FD-09 Current standing since | مدة الصدارة الحالية | District details · resets on standing change
- FD-10 District control % | نسبة السيطرة على الحي | District details · owner ÷ total
- FD-11 Total buildings | إجمالي المباني | District details
- FD-12 Claimed count | عدد المباني المُطالَب بها | District details
- FD-13 Free count | عدد المباني المتاحة | District details
- FD-14 Per-club claimed list | قائمة المباني لكل فريق | District details · sum = claimed count
- FD-15 Building name | اسم المبنى | Building details
- FD-16 Area label | اسم المنطقة | Building details
- FD-17 Ownership state | حالة الملكية | Building details · Claimed / "No team owns this building yet"
- FD-18 Current owner (club) | المالك الحالي (الفريق) | Building details · when claimed
- FD-19 Current standing since | مدة الملكية الحالية | Building details · when claimed
- FD-20 Score to beat | النتيجة المطلوب تجاوزها | Building details · saved score, 0 if unclaimed
- FD-21 Contested count (7-day) | عدد المحاولات (آخر 7 أيام) | Building details · informational only *(no status field — status lives in the button)*
- FD-22 Rank | الترتيب | Table · ties share rank
- FD-23 Club | الفريق | Table
- FD-24 Districts owned | الأحياء المملوكة | Table
- FD-25 Buildings owned | المباني المملوكة | Table
- FD-26 Building ownership % | نسبة ملكية المباني | Table · club ÷ city total; not 100%
- FD-27 Team crest | شعار الفريق | Profile · when team selected
- FD-28 Team name | اسم الفريق | Profile · "Not selected" / login prompt
- FD-29 Date joined | تاريخ الانضمام | Profile
- FD-30 Team rank | ترتيب الفريق | Profile
- FD-31 Current tokens | الرموز الحالية | Profile
- FD-32 Next daily tokens countdown | العد التنازلي للرموز اليومية | Profile
- FD-33 Trips completed today | الرحلات المكتملة اليوم | Profile
- FD-34 All tokens earned | إجمالي الرموز المكتسبة | Profile · all-time
- FD-35 Matches played – Total | إجمالي المباريات | Profile
- FD-36 Matches played – Wins | المباريات الرابحة | Profile
- FD-37 Matches played – Losses | المباريات الخاسرة | Profile
- FD-38 Games played – Claimed | المباني المملوكة حالياً | Profile · buildings currently held
- FD-39 Recent activity item | عنصر النشاط الأخير | Profile · empty state when none
- FD-40 Club list (crest + name) | قائمة الفرق (الشعار والاسم) | Team selection
- FD-41 Season lock notice | تنبيه قفل الموسم | Team selection
- FD-42 Selected club indicator | مؤشر الفريق المختار | Team selection
- FD-43 Welcome bonus amount | قيمة مكافأة الانضمام | Team selection · step 2, on confirm
- FD-44 Title | العنوان | Game preview · "Penalty Challenge"
- FD-45 Tokens needed | تكلفة الرموز | Game preview · per attempt (configurable)
- FD-46 Objective | الهدف | Game preview · score-to-beat / Capture
- FD-47 Misses rule | قاعدة المحاولات الخاطئة | Game preview · configured misses
- FD-48 Scored | الأهداف المسجلة | Game · running score
- FD-49 Misses remaining | المحاولات المتبقية | Game · of configured; ends on final miss
- FD-50 Score to beat | النتيجة المطلوب تجاوزها | Game · persistent
- FD-51 Outcome state | حالة النتيجة | Game result · Win/Lose, **no scoreline**
- FD-52 Section title | عنوان القسم | Support
- FD-53 How to play item | عنصر كيفية اللعب | Support · content pending

---

## 9. Buttons (§10, BT-01…26) — renumbered vs V1.2

`EN | AR | screen · behavior`

- BT-01 Dominate with your team | شجّع وهيمن! | Popup · first unmet step (tutorial → team) / Landing if onboarded
- BT-02 Close (X) | إغلاق | Popup · dismiss → Landing
- BT-03 Dominate with your team | شجّع وهيمن! | Landing · only when NOT play-ready → first unmet step
- BT-04 Tifo toggle | مفتاح تيفو | Landing · on/off, hides/restores all Tifo
- BT-05 Trophy / Leaderboard | الكأس / لوحة الصدارة | Landing · open Leaderboard
- BT-06 Close (X) | إغلاق | District details → Landing
- BT-07 Take over the district | سيطر على الحيّ | District details · not play-ready → onboarding; play-ready → Landing
- BT-08 Close (X) | إغلاق | Building details → Landing
- BT-09 Hold on... this building is currently being played. | فضلًا انتظر..المبنى تحت المنافسة | Building details · when Blocked · **never enabled**, does nothing
- BT-10 Challenge | تحدَّ | Building details · when Available · not play-ready → onboarding; play-ready → Game preview
- BT-11 Table tab | تبويب لوحة الصدارة | Panel · default tab
- BT-12 Profile tab | تبويب اللوحة الشخصية | Panel · show Profile
- BT-13 Close (X) | إغلاق | Table → Landing
- BT-14 Dominate with your team | شجّع وهيمن! | Table · not play-ready → onboarding; play-ready → Landing
- BT-15 View all (activity) | عرض الكل | Profile · activity history (not designed)
- BT-16 Dominate with your team | شجّع وهيمن! | Profile · not play-ready → onboarding; play-ready → Landing
- BT-17 Login (prompt) | تسجيل الدخول | Profile · when logged out
- BT-18 Club card (select) | بطاقة الفريق | Team selection · select + confirm prompt
- BT-19 Confirm Team | تأكيد الفريق | Team selection · enabled only when logged in + club chosen → welcome bonus
- BT-20 Login | تسجيل الدخول | Team selection · when logged out
- BT-21 Maybe Later | ربما لاحقاً | Team selection / welcome bonus · exit without team (browse-only)
- BT-22 Claim the map | هيمن على الخريطة! | Welcome bonus step · enter play
- BT-23 Start | ابدأ | Game preview · deduct token(s) → Game
- BT-24 Dismiss / Continue | متابعة | Game result → Building details (updated)
- BT-25 Replay tutorial | إعادة الجولة التعريفية | Support · launch tutorial, no re-gating
- BT-26 Back | رجوع | Support → Landing

---

## 10. Messages (§11)

**Empty in V2** — table has one blank row; "This section needs to be defined if messages are part of the requirement." *(To be revisited.)* The V1.2 MSG-01…19 strings are **withdrawn**; the only fixed copy V2 provides is the BT-09 blocked-button label and the AFK prompt "Are you still playing?".

---

## 11. Assumptions & limitations (§4)

**Assumptions:** access via Balady+ app + Balady+ login; Riyadh building/address data from the Balady registry; users have location + connectivity; **club roster confirmed for the season**; Balady+ trips can be validated for token grants.

**Limitations:** Riyadh only at launch; play needs login + tutorial started + team (browse otherwise); no token purchase / no cash value; asynchronous only (vs saved scores, no real-time head-to-head); **recurring seasons not confirmed** — a single season is created at launch.

---

## 12. Open items

- *To be revisited:* US-18/US-19 (operator), all of §11 Messages.
- *Value to define:* AFK window, AFK prompt timeout, Live-lock timeout.
- Activity-history screen not designed; tutorial screens ("Simulation") static/representative.
- Underdog-assist mechanic undefined (must be designed before enabling).
- Inconsistencies #1–#8 above pending analyst confirmation — especially the **exit vs app-close voiding boundary**.
