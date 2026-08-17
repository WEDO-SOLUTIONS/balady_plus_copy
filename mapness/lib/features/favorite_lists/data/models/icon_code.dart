import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

@JsonEnum()
enum FavoriteIconCode {
  home,
  building,
  city,
  building2,
  restaurant,
  restaurant2,
  coffee,
  store,
  shoppingBasket,
  $default;

  static List<FavoriteIconCode> get validValues => FavoriteIconCode.values.where((element) => element != $default).toList();

  SvgGenImage getIcon() => switch (this) {
    FavoriteIconCode.home => Assets.icons.svg.favorite.icFavorite1Home,
    FavoriteIconCode.building => Assets.icons.svg.favorite.icFavorite2Building,
    FavoriteIconCode.city => Assets.icons.svg.favorite.icFavorite3City,
    FavoriteIconCode.building2 => Assets.icons.svg.favorite.icFavorite4Building,
    FavoriteIconCode.restaurant => Assets.icons.svg.favorite.icFavorite5Restaurant,
    FavoriteIconCode.restaurant2 => Assets.icons.svg.favorite.icFavorite6Restaurant,
    FavoriteIconCode.coffee => Assets.icons.svg.favorite.icFavorite7Coffee,
    FavoriteIconCode.store => Assets.icons.svg.favorite.icFavorite8Store,
    FavoriteIconCode.shoppingBasket => Assets.icons.svg.favorite.icFavorite9ShoppingBasket,
    FavoriteIconCode.$default => Assets.icons.svg.favorite.icFavorite0Default,
  };
}
