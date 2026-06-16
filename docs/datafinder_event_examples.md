# Balady DataFinder — Event Examples

| | |
|---|---|
| **Document Title** | Balady DataFinder — Event Examples |
| **Document Date** | 2026-06-16 |
| **Document Version** | 1.0 |
| **Document Writer** | Shadi Al-Jaradat |

> Companion to **Balady User Behavior Tracking Metrics – BRD V0.1**, section *Event Information*.
> Events are listed in the **same order as the BRD**. For each event the BRD's
> *Metrics* section is shown here as a real **Example** payload.
>
> **How examples are captured:** the app runs on the iOS Simulator in dry-run
> mode. Each event prints locally with a `[DataFinder][DRY-RUN]` prefix (not sent
> to BytePlus from the simulator). The printed payload is pasted below.
>
> **Source of truth:** https://wedosolutionssa-my.sharepoint.com/:w:/g/personal/majid_ahmed_wedosolutions_sa/IQAK9uPoI0d0TYs6izBCs1zHAdEZ-BjLMEEVq9WtEiIMpYM?rtime=O_VbDcHK3kg

> ### Two rules that apply to every event
> 1. **Exposure events are reported PER ITEM, not as an array.** If 20 results
>    are visible, 20 separate `search_results_exposure` events fire — one per
>    result, with that result's fields flat in the event. Same for
>    `suggestion_exposure`. (No `results`/`suggestions` array, no `result_count`.)
> 2. **`event_source` = the surface where the journey STARTED** (Map / Explore /
>    Routes / Free Roam), combined with the live navigation state. The 8 values
>    and how they are decided are in **Appendix A**.

---

## 1. favorite_add

- **Event Name:** `favorite_add`
- **Event Trigger:** Triggered when the user adds a POI to favorites.
- **Notes:**
  - Carries `poi_addr` / `poi_type` / `poi_distance` (sourced from the POI card).
  - `favorite_type` is `Home`, `Work`, or `Not Specified`.
  - When a favorite is added from a search result, BOTH `search_results_click`
    (`click_action: "Add to Favorites"`) AND `favorite_add` fire, with the
    **same** `event_source` (the BRD lists these search→favorite flows).

```json
{
  "event_source": "Explore-Main Page",
  "favorite_type": "Not Specified",
  "poi_id": "20000004740961831",
  "poi_name": "Al Sadhan Mall",
  "poi_addr": "Al Rabwah, Riyadh Region",
  "poi_type": "branch",
  "poi_distance": 8.03
}
```

---

## 2. quick_search_click

- **Event Name:** `quick_search_click`
- **Event Trigger:** Triggered when the user taps a quick-search button or selects a favorite item.

```json
{
  "event_source": "Explore-Main Page",
  "search_text": "Eat out"
}
```

---

## 3. search_box_click

- **Event Name:** `search_box_click`
- **Event Trigger:** Triggered when the search box gains focus.
- **Notes:** `is_first_click` is `true` on the first focus after the search opens,
  `false` on later genuine taps. A focus return after a dialog closes does **not** fire it.

```json
{
  "event_source": "Explore-Main Page",
  "is_first_click": true
}
```

---

## 4. search_box_input

- **Event Name:** `search_box_input`
- **Event Trigger:** Triggered on each keystroke in the search box.
- **Notes:** `operation_type` is `Manual` (typed) or `History` (filled from a history tap).
  One event per keystroke — typing "mall" produces four events.

**Manual (typed):**

```json
{ "operation_type": "Manual", "input_text": "m" }
{ "operation_type": "Manual", "input_text": "ma" }
{ "operation_type": "Manual", "input_text": "mal" }
{ "operation_type": "Manual", "input_text": "mall" }
```

**History (one event, filled from a tapped history item):**

```json
{ "operation_type": "History", "input_text": "tg" }
```

---

## 5. search_button_click

- **Event Name:** `search_button_click`
- **Event Trigger:** Triggered when the user taps the search button on the keyboard.

```json
{
  "event_source": "Explore-Main Page",
  "search_text": "mall",
  "trigger_method": "Keyboard"
}
```

---

## 6. suggestion_exposure

- **Event Name:** `suggestion_exposure`
- **Event Trigger:** Reported individually for **every** suggestion item fully
  rendered on the screen. If 10 items are shown, 10 separate events fire — one per item.
- **Format:** ONE flat event per suggestion (no array). All events from the same
  suggestion list share `request_id` and `suggestion_session_id`.
- **Example:** one event (the 1st of N — e.g. a 10-item list fires 10 of these):

```json
{
  "request_id": "7375ba85-692f-40e1-915f-a1832fd3da46",
  "suggestion_session_id": "ef05c393-0af3-450b-bfa1-9a0a9243f74e",
  "search_text": "mall",
  "search_param": "q=mall&viewpoint1=24.719391831174107,46.6767758410424&viewpoint2=24.74525846350589,46.68971615843475&suggest_type=object&page_size=20&location=24.724282,46.683246",
  "suggestion_name": "Al Sadhan Mall",
  "suggestion_type": "branch",
  "suggestion_poi_id": "20000004740961831",
  "suggestion_poi_addr": "Al Rabwah, Riyadh Region",
  "suggestion_distance": 8.03,
  "suggestion_rank": 1
}
```

The next event in the same list is identical except for the item fields:

```json
{
  "request_id": "7375ba85-692f-40e1-915f-a1832fd3da46",
  "suggestion_session_id": "ef05c393-0af3-450b-bfa1-9a0a9243f74e",
  "search_text": "mall",
  "search_param": "q=mall&...&page_size=20&location=24.724282,46.683246",
  "suggestion_name": "Hayat Mall",
  "suggestion_type": "branch",
  "suggestion_poi_id": "70000001068177661",
  "suggestion_poi_addr": "Mohammed Hamd Al Fqi street, King Fahd district, Riyadh, Riyadh Region",
  "suggestion_distance": 1.93,
  "suggestion_rank": 3
}
```

---

## 7. suggestion_click

- **Event Name:** `suggestion_click`
- **Event Trigger:** Triggered when the user taps a specific suggestion item.

```json
{
  "event_source": "Explore-Main Page",
  "request_id": "7375ba85-692f-40e1-915f-a1832fd3da46",
  "suggestion_session_id": "ef05c393-0af3-450b-bfa1-9a0a9243f74e",
  "search_text": "mall",
  "suggestion_type": "branch",
  "suggestion_name": "Al Sadhan Mall",
  "suggestion_rank": 1,
  "poi_id": "20000004740961831",
  "poi_name": "Al Sadhan Mall",
  "poi_addr": "Al Rabwah, Riyadh Region",
  "poi_type": "branch",
  "poi_distance": 8.03
}
```

---

## 8. search_results_exposure

- **Event Name:** `search_results_exposure`
- **Event Trigger:** Reported individually for **every** result item fully
  rendered on the screen. If 10 items are shown, 10 separate events fire — one per item.
- **Format:** ONE flat event per result (no array). All events from the same
  search share `request_id` and `search_session_id`.
- **Notes:** `search_type` is one of `Quick search`, `History`, `Click suggestion`,
  `Manual`, `Search in this area`.
- **Example:** one event (the 1st of N — e.g. a 20-result list fires 20 of these):

```json
{
  "event_source": "Explore-Main Page",
  "request_id": "a48e1a93-04a3-40e1-a95b-c674d6421ccd",
  "search_session_id": "93f64765-cfb9-46c3-a4b3-3c1f8cff5a54",
  "search_text": "mall",
  "search_type": "Manual",
  "search_param": "q=mall&viewpoint1=24.719391831174107,46.6767758410424&viewpoint2=24.74525846350589,46.68971615843475&page_size=20&location=24.724282,46.683246",
  "poi_id": "20000004740961831",
  "poi_name": "Al Sadhan Mall",
  "poi_addr": "Al Rabwah, Riyadh Region",
  "poi_type": "branch",
  "poi_distance": 8.03,
  "poi_rank": 1
}
```

The next event in the same search is identical except for the item fields:

```json
{
  "event_source": "Explore-Main Page",
  "request_id": "a48e1a93-04a3-40e1-a95b-c674d6421ccd",
  "search_session_id": "93f64765-cfb9-46c3-a4b3-3c1f8cff5a54",
  "search_text": "mall",
  "search_type": "Manual",
  "search_param": "q=mall&...&page_size=20&location=24.724282,46.683246",
  "poi_id": "70000001068177661",
  "poi_name": "Hayat Mall",
  "poi_addr": "Mohammed Hamd Al Fqi street, King Fahd district, Riyadh, Riyadh Region",
  "poi_type": "branch",
  "poi_distance": 1.93,
  "poi_rank": 3
}
```

---

## 9. search_results_click

- **Event Name:** `search_results_click`
- **Event Trigger:** Triggered when the user taps a specific POI on a search results page.
- **Notes:** `click_action` is one of `View POI Details`, `Initiate Navigation`,
  `Share POI`, `Add to Favorites`.

```json
{
  "event_source": "Explore-Main Page",
  "request_id": "a48e1a93-04a3-40e1-a95b-c674d6421ccd",
  "search_session_id": "93f64765-cfb9-46c3-a4b3-3c1f8cff5a54",
  "search_text": "mall",
  "click_action": "Add to Favorites",
  "poi_id": "20000004740961831",
  "poi_name": "Al Sadhan Mall",
  "poi_addr": "Al Rabwah, Riyadh Region",
  "poi_type": "branch",
  "poi_distance": 8.03,
  "poi_rank": 1
}
```

---

## Appendix A — `event_source` (the 8 values)

`event_source` is decided by the **origin surface** where the user started the
journey, combined with the live navigation state. Same action → different source
depending on where it started:

| `event_source` | Journey starts at |
|---|---|
| `Map-Main Page` | the **map** (tap a POI on the map → … ) |
| `Map-Direction-Path Changing` | map journey + editing a drawn route |
| `Explore-Main Page` | the **Explore tab** (search bar / quick filters) |
| `Explore-Free Roam` | **Free Roam** |
| `Explore-Direction` | Explore tab + navigation active |
| `Explore-Direction-Path Changing` | Explore tab + editing a drawn route |
| `Routes-Main Page` | the **Routes** tab |
| `Routes-Path Changing` | Routes flow + editing a drawn route |

Notes:
- A **map** journey stays `Map-Main Page` through Directions → Go → Search
  (only editing a drawn route → `Map-Direction-Path Changing`).
- An **explore** journey becomes `Explore-Direction` once navigation starts.
