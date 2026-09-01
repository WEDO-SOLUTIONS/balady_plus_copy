# Favourites Widgets Notes

This subtree contains favourites UI and favourites search selection flows.

## Session Context

The current session identified a race in the QA flow:

1. unauthenticated user taps `Drive back home`;
2. app authenticates;
3. user selects a home address in favourites search;
4. routing starts immediately;
5. UI can disappear while the native map remains.

Part of the race was caused by favourites search widgets calling `repo.addItem`, `repo.setHome`, or `repo.setWork` with `unawaited(...)` and then immediately `pop(favItem)`. That lets route navigation continue before Hive cache/add-sync and provider state have settled.

## Rules For This Subtree

- When selecting a favourite from search/history/suggest lists, **await** `addItem`/`setHome`/`setWork` before `context.router.pop(favItem)`.
- Keep `context.mounted` and `context.router.canPop()` checks after async gaps.
- Do not optimize away these awaits. They intentionally serialize persistence before route stack changes.
- For home/work selection, preserving local state is more important than shaving a few milliseconds off closing the search sheet.

## Important Files

- `search/favourites_search_results.dart`
- `search/favourites_suggest_list.dart`
- `search/favourites_search_history.dart`

## Verification

```bash
rtk fvm dart format -l 120 mapness/lib/widgets/favourites/search/favourites_search_results.dart mapness/lib/widgets/favourites/search/favourites_suggest_list.dart mapness/lib/widgets/favourites/search/favourites_search_history.dart
rtk fvm flutter analyze --no-pub mapness/lib/widgets/favourites/search/favourites_search_results.dart mapness/lib/widgets/favourites/search/favourites_suggest_list.dart mapness/lib/widgets/favourites/search/favourites_search_history.dart
```
