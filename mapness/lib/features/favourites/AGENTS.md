# Favourites Notes

This subtree holds the **legacy** protobuf favourites cache and the map markers. User-facing favourites (lists, Home/Work,
add/delete) live in `features/favorite_lists` and go through the `favorite_lists` REST API (BE-88).

## Role of `favouriteCacheProvider`

`providers/favourite_cache.dart` is a read-only legacy source. Nothing writes favourites through it anymore.
Remaining uses:

- One-time migration of existing users' favourites to the new API: `favorite_lists_migration.dart` and
  `home_work_favorites_migration.dart` read `favouriteCacheProvider.future`.
- `clear()` on logout/token expiry from `sso_auth/data/auth_provider.dart` (local Hive wipe only).
- `getFavouritesStateFromHive()` for the initial map notification in `entry_point.dart`.

The old local-first add/delete queues (`add_sync`/`delete_sync`), `_sync`, `forceRefresh` and the locale-refresh merge
(BALADY-3832) were removed in the BE-88 merge together with the write path. Do not reintroduce writes through this
provider; add new behaviour to `features/favorite_lists`.

## Important Files

- `providers/favourite_cache.dart`: legacy Hive cache + remote fetch (migration source), user-change cache reset.
- `data/models/favorite_cache_item.dart`: Hive models and type ids. Do not change type ids casually.
- `mappers/favorite_cache_item_mapper.dart`: domain <-> Hive mapping.
- `providers/favourite_markers.dart`: map marker integration, aggregates markers from the favourite lists.
- `helpers/favourite_entity_id.dart`: entity id parsing shared with the migrations.

## Pitfalls

- Do not return `FavouritesState(items: [])` just because `authProvider.future` returns null/timeout while a Hive cache
  exists: the migration would conclude there is nothing to migrate and set its "migrated" flag.
- Do not change Hive type ids: existing installs still hold the legacy cache that the migration reads.

## Verification

```bash
rtk fvm dart format -l 120 mapness/lib/features/favourites/providers/favourite_cache.dart
rtk fvm flutter analyze --no-pub mapness/lib/features/favourites/providers/favourite_cache.dart
```
