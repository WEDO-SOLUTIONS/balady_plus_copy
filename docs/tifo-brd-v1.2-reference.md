# Balady TIFO — BRD V1.2 reference

> **SUPERSEDED (2026-07-23) by [tifo-brd-v2-reference.md](tifo-brd-v2-reference.md)** — BRD V2 (page 632619009, 21 Jul 2026) changed the gate order to tutorial-first, confirmed the no-scoreline/no-draw result, reduced building statuses to Available/Blocked, and reshaped the token economy. Kept for history only.

Condensed, engineering-facing digest of **BRD V1.2 "Balady Tifo"** (Confluence space `BM`, page id `611549185`) cross-referenced with the backend contract **API v2.4** (`619446283`) and the **Solution Design Document** (`618594311`).

- **Document version:** 0.2 · **Date:** 8 July 2026 · **Status:** Draft · **Author:** Wafeer Analysis Team.
- History: `0.1` (29 Jun 2026, first draft) → `0.2` (8 Jul 2026, "Updated User Journey and Mechanics").
- Doc quirks to be aware of: title says "V1.2" but internal version is `0.2`; `§12.3` is skipped; `NFR-9` (not `-09`); US-04/BR-03 references "US-17" where it means US-19 (typo).

> This file is a **derived summary** for quick reference — the Confluence pages are the source of truth. Numbers marked *Your call* / *To define* / *Under discussion* are not final.

---

## 1. What TIFO is

Location-based territory game layered on the Balady+ map. A player joins one football club per season and captures **individual buildings** across Riyadh by playing a short **penalty shootout against an NPC keeper**. Districts are tinted by the club owning the most buildings in them. Browsing is open to everyone; **playing requires** logged in + tutorial started + team selected. Attempts are paced by a token economy (tokens are earned, never purchased, no cash value). Tunable without a release; runs in seasons with a full ownership reset.

**Business objectives:** engagement/time-in-app; habitual repeat visits via token economy + daily allowance + trips; emotional pull via real clubs + local geography; reward real-world activity (trips); post-launch tuning without releases; foundation for more cities/seasons/features.

---

## 2. System mechanics (§5)

### 2.1 Buildings, districts & ownership — *all Confirmed*
- A building is the unit of competition; **launch coverage = every building in Riyadh** (Balady building/address registry). Exactly one owner at a time + a `saved score`.
- **Ownership transfers only when a challenger's score strictly exceeds the saved score; a tie keeps the holder.** Nothing else (not time, not inactivity) transfers ownership.
- **No location lock** — claim/challenge from anywhere.

### 2.2 District standing — *all Confirmed*
- Leader = club holding the **most buildings (raw count)**. Neutral **only** when no club holds any building.
- **No tied districts** — incumbent retains on an equal count; changes only when another club holds **strictly more**. Recalculated on every ownership change.
- (`control%` is a district-details value = owner buildings ÷ total; not part of §5.2 wording.)

### 2.3 The penalty challenge — *Confirmed*
- Penalty shootout vs NPC keeper; **session ends on the player's 3rd miss** — **no kick limit**. Score = goals scored before the 3rd miss.
- Single mechanism for both claiming and challenging. Scores **server-validated** with anomaly detection; the client never self-reports a trusted score.

### 2.4 Claiming & challenging
- **Claim** (unclaimed): any result ≥ 1 goal takes it; score becomes the saved score.
- **Challenge** (held): ownership transfers only on **strictly higher** score; a tie keeps the holder.
- Each attempt costs tokens, **deducted regardless of outcome**. In-progress building is **Live**-locked; auto-released after a timeout if interrupted.
- **Interrupted session → voided:** no score, ownership unchanged, **token NOT refunded**.
- Post-challenge per-building cooldown is built but **Under discussion** (off by default).

### 2.5 Token economy — *all Confirmed (values in §12.4)*
- Tokens gate action frequency; **no purchase, no cash value**.
- Inflows: starting grant, daily allowance, trips (declining curve, daily cap). Outflow: attempts. Max balance caps hoarding.
- Passive holding reward and district-production income: **built, off at launch**.

### 2.6 Fairness & balancing — *all Confirmed*
- Raw building count, **no per-player cap at launch** (deliberate, for early map coverage). Lopsidedness instrumented vs a threshold; underdog assist / per-player cap **built but off**.

### 2.7 Seasons — *all Confirmed*
- Configurable length. At season start: **reset all ownership → neutral + clear saved scores**. Club selection and token balances **persist**. Roster reconfirmed each season; club **locked in-season**. Recurring not confirmed (1 season at launch).

### 2.8 Integrity & anti-abuse
- Server-side score validation + anomaly detection; multi-account controls (mitigated by required login); trip validation (distance, time, plausibility).

---

## 3. Configurable parameters (§12)

Status: **Confirmed** = default decided/tunable · **Your call** = default not yet decided.

### 12.1 Penalty challenge
| Key | Launch default | Range | Status |
|---|---|---|---|
| Misses allowed (session end) | `3` | `1–10` | Confirmed |
| Keeper difficulty | Tunable curve | Difficulty profile | Confirmed |

### 12.2 Claiming & challenging
| Key | Default | Range | Status |
|---|---|---|---|
| Claim cost (unclaimed) | `1 token` | `≥ 0` | **Your call** |
| Challenge cost (held) | `1 token` | `≥ 0 (can be < claim)` | **Your call** |
| Failed-challenge refund | `None (0)` | `0 – full cost` | **Your call** |
| Cooldown enabled | `Off` | On/Off | Confirmed |
| Cooldown duration | `n/a (off)` | if enabled | Confirmed |
| Live-lock timeout | `To define` | duration before auto-release | **Your call** |

*(§12.3 is missing in the source — skipped numbering.)*

### 12.4 Token economy
| Key | Default | Range | Status |
|---|---|---|---|
| Starting grant (one-time) | `10` | `≥ 0` | Confirmed |
| Daily free allowance | `5` | `≥ 0` | Confirmed |
| Trip earning curve | `+3 / +2 / +1 …` | per-trip | Confirmed |
| Daily trip cap | `10` | `≥ 0` | Confirmed |
| Maximum balance | `30` | `≥ 0` | Confirmed |
| Passive holding reward | `Off` | On/Off | Confirmed |
| District production income | `Off` | On/Off | Confirmed |

### 12.5 Fairness & balancing
| Key | Default | Range | Status |
|---|---|---|---|
| District scoring mode | `Raw building count` | Raw / per-player | Confirmed |
| Per-player building cap | `None` | None or ≥ 1 | Confirmed |
| Underdog assist | `Off` | On/Off | Confirmed |
| "Too lopsided" threshold | `To define` | data-driven | Confirmed |

### 12.6 Seasons
| Key | Default | Range | Status |
|---|---|---|---|
| Number of teams / roster | `5 (roster to confirm)` | set at season start | Confirmed |
| Season length | `To set` | set at season start | Confirmed |
| Season prizes | `Off` | On/Off | Confirmed |
| Club-selection lock | `Locked in-season` | Locked/unlocked | Confirmed |

### 12.7 Fixed design rules (NOT configurable)
All buildings in a district / all Riyadh buildings at launch · one owner per building · no location lock · strictly-higher-score transfer, tie keeps holder · district tie → incumbent retains, neutral only at zero · Live-lock always on · no real-money token purchase · full reset of ownership + saved scores at season start.

**Live-`/config` on staging (2026-07-20)** — already diverges from BRD defaults: `attemptCost 2, claimCost 2, challengeCost 1, startingGrant 15, dailyAllowance 10, missesAllowed 3, cooldownEnabled true/60s, liveLockTimeout 30s`. **Trust `/config`, never hardcode.**

---

## 4. Journey & user states (§8.4, US-01…04)

States: **Visitor (logged out)** → **Logged-in no-team** → **Logged-in team-selected**. Browse open in all; play needs all three.

Gate order (route to first unmet): **login → tutorial started → team selected**.
- **Entry popup** "Join Tifo" routes to the first unmet step (or Landing if onboarded); Close(X) → Landing.
- **Tutorial**: mandatory, autoruns on first entry, **starting it clears the gate forever** (skip allowed after start, replay from Support, nothing persists). Screens marked "Simulation", **not finalized**.
- **Team select**: 2 steps — (1) pick + Confirm (requires login), (2) welcome bonus → Start. "Maybe Later" = browse-only. Club **locked for the season**.

---

## 5. Screens & required content

| Screen | Must contain (BRD) |
|---|---|
| **Landing / map** | Tifo overlay + toggle (default on, persist per user, off hides all Tifo); district coloring by leader; trophy→leaderboard; "Start playing" only when not play-ready |
| **District details** | name + area, current owner + standing-since, control% (owner÷total), total/claimed/free, per-club breakdown; CTA "Start playing"/"View map" |
| **Building details** | name + area, ownership state ("No team owns this building yet"), owner + standing-since, score to beat (0 if free), contested-7d (info), status Available/Cooldown/Live; "Challenge" enabled only when Available |
| **Leaderboard** | rank, club, districts owned, buildings owned, ownership% (÷ city total); sort buildings→districts→shared rank |
| **Dashboard** | team block (crest/name/joined/rank | "not selected" | login prompt); token tiles (balance, next-daily countdown, trips today/cap, all-time); games Total/Won/Lose/Owned (no Draw); recent activity + "View all" (**screen not designed**) |
| **Game preview** | title "Penalty Challenge", token cost (1), objective (score-to-beat / capture), "3 misses"; Start deducts a token |
| **Game HUD** | Attempted (= scored+missed), Scored, Missed, **Misses remaining (of 3)**, Score to beat |
| **Game result** | Win / Loss, **no scoreline**; Continue → building details |
| **Support** | Replay tutorial, How to play, Quick FAQs (content pending) |

---

## 6. Functional requirements (§6)

- **FR-01** Tifo as overlay + on/off toggle, persisted per user, default on.
- **FR-02** Any user browses all Tifo screens read-only without login/team.
- **FR-03** Require logged in + tutorial started + team selected before any play; route to first unmet step.
- **FR-04** Entry popup introduces Tifo, routes by state.
- **FR-05** Mandatory first-run tutorial: autoruns, skippable after start, clears the gate on start, replayable from Support without re-gating.
- **FR-06** One club per season, locked for the season.
- **FR-07** Tint district by leading club; neutral only at zero owned.
- **FR-08** Claimed building = colored polygon in owner club color; free buildings uncolored.
- **FR-09** District details: owner, standing duration, control% (owner÷total), counts (total/claimed/free) + per-club.
- **FR-10** Building details: ownership state, owner + standing, score to beat (0 if unclaimed), contested-7d (info), status Available/Cooldown/Live.
- **FR-11** Challenge = penalty shootout ending on the 3rd miss; score = goals before then.
- **FR-12** Challenge allowed only when status Available; disabled on Cooldown/Live.
- **FR-13** Claim unclaimed when final score ≥ 1; saved score = final score.
- **FR-14** Transfer held building only on strictly greater score; else unchanged.
- **FR-15** Live-lock during a session; auto-release after configurable timeout if interrupted.
- **FR-16** Void interrupted session: no score, no ownership change, **no refund**.
- **FR-17** Server-side score validation with anomaly detection; no client-reported trusted score.
- **FR-18** Result as win/loss, **no numeric scoreline**; return to building details.
- **FR-19** Deduct one token to start; never refund.
- **FR-20** Earn via one-time welcome bonus (on team confirm) + daily allowance + trips (declining, daily cap); cap balance at max.
- **FR-21** No real-money token purchase; no cash value.
- **FR-22** Leaderboard: clubs by buildings owned, tie→districts owned, shared rank only when both equal; show districts/buildings/ownership%.
- **FR-23** Dashboard: team + rank, token info, games (total/won/lose/owned), recent activity + full history.
- **FR-24** Support: replay tutorial, how-to-play, FAQ.
- **FR-25** Operator can view/edit configurable params, validated vs ranges, no release, operator-only. *(To be revisited)*
- **FR-26** Operator can create/configure a season (length/roster/prizes) and trigger reset. *(To be revisited)*
- **FR-27** Localization AR + EN incl. **RTL**.

## 7. Non-functional (§7)
- **NFR-01** Performance (responsive map/views; no perceptible input lag in the challenge).
- **NFR-02** Scalability (all Riyadh buildings, citywide concurrent challenges).
- **NFR-03** Availability (graceful transient-connectivity loss → interrupted-session voiding).
- **NFR-04** Security & integrity (server-side scores/grants/trip validation; anomaly + multi-account + trip-plausibility).
- **NFR-05** Reliability (accurate/consistent ownership, scores, balances; last-write-wins where applicable).
- **NFR-06** Usability (follow Balady+ patterns).
- **NFR-07** Localization (AR + EN, correct RTL).
- **NFR-08** Configurability (balance params tunable without release).
- **NFR-9** Maintainability (mechanics vs tunables documented separately). *(sic: `NFR-9`)*

---

## 8. User stories index (§8)

Actor = **Balady+ User** unless noted. AC/BR detail lives in the BRD; key rules already captured in §2–§5 above.

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
| US-09 | View the leaderboard | Map & Standings | — |
| US-10 | View my dashboard | Map & Standings | — |
| US-11 | Preview a challenge | Gameplay | Logged in; tutorial; team |
| US-12 | Claim an unclaimed building | Gameplay | Logged in; tutorial; team |
| US-13 | Challenge a held building | Gameplay | Logged in; tutorial; team |
| US-14 | View my game result | Gameplay | Logged in; tutorial; team |
| US-15 | View my token balance | Token Economy | Logged in |
| US-16 | Earn tokens | Token Economy | Logged in |
| US-17 | Access support | Support & Help | — |
| US-18 | Configure game parameters *(To be revisited)* | Administration | Game Operator |
| US-19 | Manage seasons *(To be revisited)* | Administration | Game Operator |

Selected hard rules from AC/BR:
- US-04: two-step (confirm → welcome bonus); confirm requires login; "Maybe Later" = browse-only; team locked in-season.
- US-08: "Challenge" enabled only when Available; disabled on Cooldown/Live; claim uses the same flow vs score-to-beat = 0.
- US-09: rank by buildings → tie by districts → shared rank (standard competition ranking, e.g. two 2nds → next is 4th); ownership% doesn't sum to 100%.
- US-10: games Total/Won/Lose/Owned, **no Draw**; "Owned" = buildings currently held.
- US-11: preview shows cost/objective/3-misses; Start deducts the token.
- US-12/13: HUD = attempted/scored/missed/misses-remaining(of 3)/score-to-beat; claim ≥1, challenge strictly-greater; interrupted → voided (no refund).
- US-14: win/loss only, no scoreline, return to building details.

---

## 9. Fields (§9, FD-01…57)

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
- FD-21 Contested count (7-day) | عدد المحاولات (آخر 7 أيام) | Building details · informational
- FD-22 Building status | حالة المبنى | Building details · Available/Cooldown/Live
- FD-23 Rank | الترتيب | Leaderboard · ties share rank
- FD-24 Club | الفريق | Leaderboard
- FD-25 Districts owned | الأحياء المملوكة | Leaderboard
- FD-26 Buildings owned | المباني المملوكة | Leaderboard
- FD-27 Building ownership % | نسبة ملكية المباني | Leaderboard · club ÷ city total; not 100%
- FD-28 Team crest | شعار الفريق | Dashboard · when team selected
- FD-29 Team name | اسم الفريق | Dashboard · "Not selected"/login prompt
- FD-30 Date joined | تاريخ الانضمام | Dashboard
- FD-31 Team rank | ترتيب الفريق | Dashboard
- FD-32 Current tokens | الرموز الحالية | Dashboard
- FD-33 Next daily tokens countdown | العد التنازلي للرموز اليومية | Dashboard
- FD-34 Trips completed today | الرحلات المكتملة اليوم | Dashboard · x / cap
- FD-35 All tokens earned | إجمالي الرموز المكتسبة | Dashboard · all-time
- FD-36 Games played – Total | إجمالي المباريات | Dashboard
- FD-37 Games played – Won | المباريات الرابحة | Dashboard
- FD-38 Games played – Lose | المباريات الخاسرة | Dashboard
- FD-39 Games played – Owned | المباني المملوكة حالياً | Dashboard · currently held
- FD-40 Recent activity item | عنصر النشاط الأخير | Dashboard · empty state when none
- FD-41 Club list (crest + name) | قائمة الفرق (الشعار والاسم) | Team selection
- FD-42 Season lock notice | تنبيه قفل الموسم | Team selection
- FD-43 Selected club indicator | مؤشر الفريق المختار | Team selection
- FD-44 Welcome bonus amount | قيمة مكافأة الانضمام | Team selection · step 2, on confirm
- FD-45 Title | العنوان | Game preview · "Penalty Challenge"
- FD-46 Token cost | تكلفة الرموز | Game preview · 1/attempt (configurable)
- FD-47 Objective | الهدف | Game preview · score-to-beat / Capture
- FD-48 Misses rule | قاعدة المحاولات الخاطئة | Game preview · 3 misses
- FD-49 Attempted | المحاولات | Game · scored + missed
- FD-50 Scored | الأهداف المسجلة | Game · running score
- FD-51 Missed | المحاولات الخاطئة | Game
- FD-52 Misses remaining | المحاولات المتبقية | Game · of 3; ends on 3rd
- FD-53 Score to beat | النتيجة المطلوب تجاوزها | Game · persistent
- FD-54 Outcome state | حالة النتيجة | Game result · Win/Lose, no scoreline
- FD-55 Section title | عنوان القسم | Support
- FD-56 How to play item | عنصر كيفية اللعب | Support · content pending
- FD-57 FAQ item | عنصر الأسئلة الشائعة | Support · expandable, content pending

---

## 10. Buttons (§10, BT-01…29)

`EN | AR | screen · behavior`

- BT-01 Join Tifo | انضم إلى تيفو | Popup · route to first unmet step / Landing
- BT-02 Close (X) | إغلاق | Popup · dismiss → Landing
- BT-03 Start playing | ابدأ اللعب | Landing · when not play-ready → first unmet step
- BT-04 Tifo toggle | مفتاح تيفو | Landing · on/off, hides/restores all Tifo
- BT-05 Trophy / Leaderboard | الكأس / لوحة الصدارة | Landing · open Leaderboard
- BT-06 Close (X) | إغلاق | District details → Landing
- BT-07 Start playing | ابدأ اللعب | District details · not play-ready → onboarding
- BT-08 View map | عرض الخريطة | District details · play-ready → Landing
- BT-09 Close (X) | إغلاق | Building details → Landing
- BT-10 Start playing | ابدأ اللعب | Building details · not play-ready → onboarding
- BT-11 Challenge | تحدَّ | Building details · enabled only when Available → Game preview
- BT-12 Leaderboard tab | تبويب لوحة الصدارة | Leaderboard · default tab
- BT-13 Dashboard tab | تبويب لوحة المعلومات | Leaderboard · show Dashboard
- BT-14 Close (X) | إغلاق | Leaderboard → Landing
- BT-15 Start playing | ابدأ اللعب | Leaderboard · not play-ready → onboarding
- BT-16 View map | عرض الخريطة | Leaderboard · play-ready → Landing
- BT-17 View all (activity) | عرض الكل | Dashboard · open activity history (not designed)
- BT-18 Start playing | ابدأ اللعب | Dashboard · not play-ready → onboarding
- BT-19 View map | عرض الخريطة | Dashboard · play-ready → Landing
- BT-20 Login (prompt) | تسجيل الدخول | Dashboard · when logged out
- BT-21 Club card (select) | بطاقة الفريق | Team selection · select + confirm prompt
- BT-22 Confirm Team | تأكيد الفريق | Team selection · enabled when logged in + club chosen → welcome bonus
- BT-23 Login | تسجيل الدخول | Team selection · when logged out
- BT-24 Maybe Later | ربما لاحقاً | Team selection / welcome bonus · exit without team (browse-only)
- BT-25 Start (welcome bonus) | ابدأ | Team selection · welcome step → enter play
- BT-26 Start | ابدأ | Game preview · deduct 1 token → Game
- BT-27 Dismiss / Continue | متابعة | Game result → Building details (updated)
- BT-28 Replay tutorial | إعادة الجولة التعريفية | Support · launch tutorial, no re-gating
- BT-29 Back | رجوع | Support → Landing

---

## 11. Messages (§11, MSG-01…19) — *section "To be revisited"*

Placeholders `{time}/{amount}/{team}` filled at runtime; AR is indicative, pending review.

- MSG-01 Info | Log in to play. | سجّل الدخول للعب. | not-logged-in play attempt
- MSG-02 Info | Choose a team to start playing. | اختر فريقاً لبدء اللعب. | logged-in no-team play attempt
- MSG-03 Info | Complete the tutorial to continue. | أكمل الجولة التعريفية للمتابعة. | tutorial-not-started play attempt
- MSG-04 Info | Your team is locked for the season. | تم قفل فريقك لهذا الموسم. | attempt to change team in-season
- MSG-05 Confirmation | Ready to fight for Riyadh? | هل أنت مستعد للتنافس على الرياض؟ | team select before confirm
- MSG-06 Success | Welcome bonus: {amount} tokens for joining {team}. | مكافأة الانضمام: {amount} رمز للانضمام إلى {team}. | team confirmation
- MSG-07 Error | Not enough tokens. | لا توجد رموز كافية. | start with insufficient tokens
- MSG-08 Info | Challenge again in {time}. | يمكنك التحدي مجدداً بعد {time}. | building in Cooldown
- MSG-09 Info | This building is currently being challenged. | يتم التحدي على هذا المبنى حالياً. | building Live
- MSG-10 Info | No team owns this building yet. | لا يملك أي فريق هذا المبنى بعد. | unclaimed building
- MSG-11 Success | You won the challenge! | لقد فزت بالتحدي! | result – captured
- MSG-12 Info | You lost the challenge. | لقد خسرت التحدي. | result – not captured
- MSG-13 System | Connection lost. The session was cancelled and your token was not refunded. | انقطع الاتصال. تم إلغاء الجولة ولم تتم إعادة الرمز. | session interrupted
- MSG-14 Confirmation | Skip the tutorial? | هل تريد تخطي الجولة التعريفية؟ | skip after tutorial started
- MSG-15 Info | This is a tutorial. Your progress will not be saved. | هذه جولة تعريفية. لن يتم حفظ تقدمك. | during tutorial
- MSG-16 Info | Log in to view your dashboard. | سجّل الدخول لعرض لوحة معلوماتك. | logged-out dashboard
- MSG-17 Info | No activity yet. | لا يوجد نشاط بعد. | empty activity feed
- MSG-18 Info | Daily tokens in {time}. | الرموز اليومية بعد {time}. | dashboard token tile
- MSG-19 Info | Token balance is full. | رصيد الرموز ممتلئ. | earning would exceed max balance

---

## 12. Assumptions & limitations (§4)

**Assumptions:** access via Balady+ app + Balady+ login; building/address data from the Balady registry; users have location + connectivity; **club roster confirmed and licensed**; trips can be validated for token rewards.

**Limitations:** Riyadh only at launch; play needs login + tutorial started + team; no token purchase / no cash value; asynchronous (vs saved scores, no real-time head-to-head); **tutorial screens, activity-history screen and operator/admin UI not finalized**; **recurring seasons not confirmed** (1 season at launch).

---

## 13. Open items

- *To be revisited:* US-18/US-19 (operator), all of §11 Messages.
- *To define / To set:* tutorial screens, activity-history screen, Live-lock timeout, "too lopsided" threshold, season length, Support content.
- *Under discussion:* per-building cooldown.
- *Your call:* claim/challenge cost, failed-challenge refund.
- Roster = 5 (to confirm); club licensing is an assumption.
- **Team-id convention** (open in API v2.4 §8): slugs `al-hilal` here vs camelCase `alHilal` in "Buildings v2" — pick one project-wide. Backend currently serves slugs.

---

## 14. BRD ↔ current implementation (as of 2026-07-20, branch `feat/BE-233/tifo`)

**Done (capture loop):** penalty ends on 3rd miss (FR-11), claim ≥1 / challenge strictly-greater (FR-13/14), void + no-refund + 1 token (FR-16/19), server score from per-kick events (FR-17), challenge only when Available (FR-12), building status/scoreToBeat/contested (FR-10, partial), 2-step team select + Maybe Later + season-lock (US-04), play-gate login→tutorial→team (FR-03/US-02), data-driven `/clubs` + select/welcome, `tutorial/complete`.

**Partial / divergent:** free buildings painted green vs FR-08 (uncolored); flat-green `#1B8354` not rolled out across screens; **no district-tint-by-leader and no zoom LOD** (FR-07 + the zoom≥16 gate is missing — layer fetches at any zoom); Game HUD shows 5 pips instead of misses-remaining-of-3 + score-to-beat (FD-49–53); result is a snackbar, not a Win/Loss screen (FR-18/US-14).

**Missing entirely:** entry popup + production Tifo toggle (FR-01/04, only a debug toggle exists); Game preview (US-11); District details (US-06/FR-09); Leaderboard (US-09/FR-22); Dashboard + token UI (US-10/15/FR-23); earn-tokens UI — daily allowance claim, trips (US-16/FR-20); Support (US-17/FR-24); AR + RTL (FR-27/NFR-07); notifications (MSG-05); operator screens (US-18/19, out of scope).
