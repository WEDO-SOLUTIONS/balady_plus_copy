import 'package:mapness/entities/favourites/favourite_item.dart';

class FavouritesState {
  final List<FavouriteItem> items;
  final FavouriteItem? home;
  final FavouriteItem? work;

  const FavouritesState({
    required this.items,
    this.home,
    this.work,
  });

  FavouritesState copyWith({
    List<FavouriteItem>? items,
    FavouriteItem? home,
    FavouriteItem? work,
  }) => FavouritesState(
    items: items ?? this.items,
    home: home ?? this.home,
    work: work ?? this.work,
  );

  FavouriteItemMarkerType getItemMarkerType(FavouriteItem item) {
    if (item.id == home?.id) {
      return FavouriteItemMarkerType.home;
    } else if (item.id == work?.id) {
      return FavouriteItemMarkerType.work;
    } else if (items
        .where(
          (e) => e.id == item.id,
        )
        .isNotEmpty) {
      return FavouriteItemMarkerType.place;
    } else {
      return FavouriteItemMarkerType.unknown;
    }
  }

  String? getItemTypeName(FavouriteItem item) => switch (getItemMarkerType(item)) {
    FavouriteItemMarkerType.home => 'Home',
    FavouriteItemMarkerType.work => 'Work',
    FavouriteItemMarkerType.unknown || FavouriteItemMarkerType.place => item.title,
  };
}
