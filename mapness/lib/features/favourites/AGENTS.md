# Favourites Notes

This subtree owns the favourites domain state, remote sync, Hive cache models, provider state, and markers.

## Session Context

The current session fixed a restart/data-loss class of bugs where favourites could disappear after app restart or auth refresh. The root cause was not a single UI issue: the provider could fetch remote state while local auth/cache/sync state was still settling and then overwrite a valid local Hive cache with an empty or stale remote response.

Key decisions from the fix:

- Treat favourites as **local-first**. Read Hive cache before waiting on auth or remote fetch, and use the local cache as the safe fallback on auth timeout/null and network errors.
- Persist pending add/delete sync before the network request, not only after a network failure. This protects against app kill/restart between local UI update and remote completion.
- Keep pending sync queued when remote sync fails or returns an invalid response. A network or backend inconsistency should not silently drop local user intent.
- Do not overwrite non-empty local favourites with an empty remote response while pending sync exists.
- Add requests are considered successful only when the response includes the added item ids. If the response misses the added ids, keep local cache and keep add-sync queued.
- Delete requests remove matching add-sync entries first, then queue delete-sync before network. Remove delete-sync only after successful remote delete.
- Avoid direct fragile casts from Hive list values. Use safe list reading helpers because stale/corrupt Hive values should degrade to an empty queue, not crash the provider.

## Important Files

- `providers/favourite_cache.dart`: source of truth for favourites state, Hive cache, add/delete queues, remote fetch/sync.
- `data/models/favorite_cache_item.dart`: Hive models and type ids. Do not change type ids casually.
- `mappers/favorite_cache_item_mapper.dart`: domain <-> Hive mapping.
- `providers/favourite_markers.dart`: map marker integration depends on `favouriteCacheProvider`.

## Pitfalls

- Do not return `FavouritesState(items: [])` just because `authProvider.future` returns null/timeout. Use Hive local cache as fallback.
- Do not call remote fetch first on app start and blindly write it to Hive. Startup auth/profile restore can lag behind provider rebuilds.
- Do not remove `_keyAddSync`/`_keyDeleteSync` unless the corresponding remote mutation has definitely succeeded.
- Do not reintroduce `unawaited` writes from UI selection flows for home/work if the caller immediately pops/pushes routes. Route navigation can race with Hive/provider updates.

## Verification

Useful targeted checks:

```bash
rtk fvm dart format -l 120 mapness/lib/features/favourites/providers/favourite_cache.dart
rtk fvm flutter analyze --no-pub mapness/lib/features/favourites/providers/favourite_cache.dart
```
