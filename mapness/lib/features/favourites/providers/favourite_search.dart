import 'package:flutter/material.dart';
import 'package:mapness/features/favourites/domain/favourite_search_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favourite_search.g.dart';

@riverpod
class FavouritesSearch extends _$FavouritesSearch {
  @override
  List<FavouriteSearchItem> build() {
    return List.generate(10, (index) {
      return FavouriteSearchItem(
        distance: '$index km',
        name: 'item $index',
        address: 'address $index',
        workingHours: 'work until $index:00',
        workingHoursColor: Colors.black,
      );
    });
  }
}
