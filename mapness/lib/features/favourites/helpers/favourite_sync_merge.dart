import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/favourites/favourites_state.dart';

// Pure helpers for `favourite_cache.dart` (BALADY-3832): kept free of provider/network imports so they
// stay unit-testable in isolation.

/// Identity of a favourite across its local and server representations. Locally created items use the entity id as
/// [FavouriteItem.id], server items carry a server-side record id — the entity id is the key both sides share.
String favouriteItemKey(FavouriteItem item) => item.entity?.id ?? item.id;

/// Merges a freshly fetched [server] state into the [local] one for a locale refresh.
///
/// Every local item survives; the ones the server knows take the (re-localised) server copy, the ones it does not
/// are kept as they are. Server-only items are appended. Home/work: a set local slot wins, taking the server copy
/// when it refers to the same place; an empty local slot takes whatever the server has.
FavouritesState mergeFavouritesWithLocal({required FavouritesState server, required FavouritesState local}) {
  final serverByKey = {for (final item in server.items) favouriteItemKey(item): item};
  final localKeys = local.items.map(favouriteItemKey).toSet();

  FavouriteItem? mergeSlot(FavouriteItem? localSlot, FavouriteItem? serverSlot) {
    if (localSlot == null) {
      return serverSlot;
    }
    if (serverSlot != null && favouriteItemKey(serverSlot) == favouriteItemKey(localSlot)) {
      return serverSlot;
    }
    return localSlot;
  }

  return FavouritesState(
    items: [
      for (final item in local.items) serverByKey[favouriteItemKey(item)] ?? item,
      for (final item in server.items)
        if (!localKeys.contains(favouriteItemKey(item))) item,
    ],
    home: mergeSlot(local.home, server.home),
    work: mergeSlot(local.work, server.work),
  );
}

/// Applies the not-yet-synced queues on top of [state]: [pendingAdd] items missing from it are added (into the
/// home/work slot when their key matches [homeKey]/[workKey], into the list otherwise), [pendingDelete] items are
/// removed. Deletions are applied last — they are the user's later intent.
FavouritesState applyPendingFavouriteSync(
  FavouritesState state, {
  required List<FavouriteItem> pendingAdd,
  required List<FavouriteItem> pendingDelete,
  String? homeKey,
  String? workKey,
}) {
  final items = [...state.items];
  final keys = items.map(favouriteItemKey).toSet();
  var home = state.home;
  var work = state.work;

  for (final item in pendingAdd) {
    final key = favouriteItemKey(item);
    if (key == homeKey) {
      home = home != null && favouriteItemKey(home) == key ? home : item;
    } else if (key == workKey) {
      work = work != null && favouriteItemKey(work) == key ? work : item;
    } else if (keys.add(key)) {
      items.add(item);
    }
  }

  for (final item in pendingDelete) {
    final key = favouriteItemKey(item);
    items.removeWhere((e) => favouriteItemKey(e) == key);
    if (home != null && favouriteItemKey(home) == key) {
      home = null;
    }
    if (work != null && favouriteItemKey(work) == key) {
      work = null;
    }
  }

  return FavouritesState(items: items, home: home, work: work);
}
