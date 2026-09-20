import 'package:flutter_test/flutter_test.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/entities/favourites/favourites_state.dart';
import 'package:mapness/features/favourites/helpers/favourite_sync_merge.dart';
import 'package:mapness/shared/entities/coordinates.dart';

/// Locally created item: `id` is the entity id (see DirectoryObjectMessageExt.mapToFavourite).
FavouriteItem _local(String entityId, {String title = 'local'}) => FavouriteItem(
  id: entityId,
  title: title,
  subtitle: '',
  coordinates: Coordinates.zero,
  entity: FavouriteItemEntity(sourceType: EntitySourceType.urbi, id: entityId),
);

/// Server item: `id` is the server record id, the entity id is what the client sent.
FavouriteItem _server(String entityId, {String title = 'server'}) => FavouriteItem(
  id: 'srv-$entityId',
  title: title,
  subtitle: '',
  coordinates: Coordinates.zero,
  entity: FavouriteItemEntity(sourceType: EntitySourceType.urbi, id: entityId),
);

List<String> _keys(Iterable<FavouriteItem> items) => items.map(favouriteItemKey).toList();

void main() {
  group('favouriteItemKey', () {
    test('uses the entity id shared by local and server copies', () {
      expect(favouriteItemKey(_local('1-0')), favouriteItemKey(_server('1-0')));
      expect(favouriteItemKey(_local('1-0')), isNot(favouriteItemKey(_server('2-0'))));
    });
  });

  group('mergeFavouritesWithLocal (locale refresh)', () {
    test('keeps a local item the server response lacks and re-localises the rest', () {
      final local = FavouritesState(
        items: [
          _local('1', title: 'Old'),
          _local('2', title: 'Just added'),
        ],
      );
      final server = FavouritesState(items: [_server('1', title: 'قديم')]);

      final merged = mergeFavouritesWithLocal(server: server, local: local);

      expect(_keys(merged.items), ['1', '2']);
      expect(merged.items[0].title, 'قديم');
      expect(merged.items[0].id, 'srv-1');
      expect(merged.items[1].title, 'Just added');
    });

    test('appends server-only items', () {
      final merged = mergeFavouritesWithLocal(
        server: FavouritesState(items: [_server('1'), _server('3')]),
        local: FavouritesState(items: [_local('1')]),
      );

      expect(_keys(merged.items), ['1', '3']);
    });

    test('home/work: local slot survives an empty response, same place takes the server copy', () {
      final merged = mergeFavouritesWithLocal(
        server: FavouritesState(
          items: const [],
          work: _server('w', title: 'عمل'),
        ),
        local: FavouritesState(
          items: const [],
          home: _local('h', title: 'Home'),
          work: _local('w', title: 'Work'),
        ),
      );

      expect(merged.home?.title, 'Home');
      expect(merged.work?.title, 'عمل');
    });

    test('home/work: empty local slot takes the server value', () {
      final merged = mergeFavouritesWithLocal(
        server: FavouritesState(items: const [], home: _server('h')),
        local: const FavouritesState(items: []),
      );

      expect(merged.home?.id, 'srv-h');
    });
  });

  group('applyPendingFavouriteSync', () {
    test('adds pending items missing from the state without duplicating present ones', () {
      final result = applyPendingFavouriteSync(
        FavouritesState(items: [_server('1')]),
        pendingAdd: [_local('1'), _local('2')],
        pendingDelete: const [],
      );

      expect(_keys(result.items), ['1', '2']);
      expect(result.items[0].id, 'srv-1');
    });

    test('routes a pending item into the home/work slot by key', () {
      final result = applyPendingFavouriteSync(
        const FavouritesState(items: []),
        pendingAdd: [_local('h'), _local('w')],
        pendingDelete: const [],
        homeKey: 'h',
        workKey: 'w',
      );

      expect(result.items, isEmpty);
      expect(result.home?.id, 'h');
      expect(result.work?.id, 'w');
    });

    test('keeps the server copy of a pending home that the server already knows', () {
      final result = applyPendingFavouriteSync(
        FavouritesState(
          items: const [],
          home: _server('h', title: 'منزل'),
        ),
        pendingAdd: [_local('h', title: 'Home')],
        pendingDelete: const [],
        homeKey: 'h',
      );

      expect(result.home?.title, 'منزل');
    });

    test('hides pending deletions from the list and the home/work slots', () {
      final result = applyPendingFavouriteSync(
        FavouritesState(items: [_server('1'), _server('2')], home: _server('h')),
        pendingAdd: const [],
        pendingDelete: [_local('2'), _local('h')],
      );

      expect(_keys(result.items), ['1']);
      expect(result.home, isNull);
    });

    test('a deletion queued after an addition wins', () {
      final result = applyPendingFavouriteSync(
        const FavouritesState(items: []),
        pendingAdd: [_local('1')],
        pendingDelete: [_local('1')],
      );

      expect(result.items, isEmpty);
    });
  });
}
