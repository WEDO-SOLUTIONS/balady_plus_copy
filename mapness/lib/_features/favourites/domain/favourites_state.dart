import 'package:mapness/_features/favourites/domain/favourite_item.dart';

class FavouritesState {

  FavouritesState({required this.items, this.home, this.work});
  final List<FavouriteItem> items;
  final FavouriteItem? home;
  final FavouriteItem? work;

  FavouritesState copyWith({
    List<FavouriteItem>? items,
    FavouriteItem? home,
    FavouriteItem? work,
  }) => FavouritesState(
      items: items ?? this.items,
      home: home ?? this.home,
      work: work ?? this.work,
    );
}
