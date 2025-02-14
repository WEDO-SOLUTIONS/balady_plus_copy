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
  }) =>
      FavouritesState(
        items: items ?? this.items,
        home: home ?? this.home,
        work: work ?? this.work,
      );
}
