import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:mapness/entities/favourites/favourite_item.dart';
import 'package:mapness/pages/routing/ui/routing_favourites.dart';

class RoutingHeaderDelegate extends SliverPersistentHeaderDelegate {
  RoutingHeaderDelegate({required this.onFavouritesTap});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) => FlexibleSpaceBar.createSettings(
    maxExtent: maxExtent,
    minExtent: minExtent,
    currentExtent: maxExtent,
    child: Padding(
      padding: const EdgeInsets.only(bottom: Spacing.$3x),
      child: RoutingFavourites(showBookmark: true, onFavouriteTap: onFavouritesTap),
    ),
  );

  final void Function(FavouriteItem point) onFavouritesTap;

  @override
  double get maxExtent => 64;

  @override
  double get minExtent => 64;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}
