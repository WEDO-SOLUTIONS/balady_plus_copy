import 'package:json_annotation/json_annotation.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

@JsonEnum(valueField: 'apiValue')
// some values mismatch with backend
enum FavoriteIconType {
  $default('building2'),
  home('home'),
  building('building'),
  city('city'),
  restaurant('restaurant'),
  heart('restaurant2'),
  coffee('coffee'),
  store('store'),
  shoppingBasket('shoppingBasket');

  final String apiValue;

  const FavoriteIconType(this.apiValue);

  static List<FavoriteIconType> get validValues => FavoriteIconType.values;

  SvgGenImage getIcon() => switch (this) {
    FavoriteIconType.$default => Assets.icons.svg.favorite.icFavorite0Default,
    FavoriteIconType.home => Assets.icons.svg.favorite.icFavorite1Home,
    FavoriteIconType.building => Assets.icons.svg.favorite.icFavorite2Building,
    FavoriteIconType.city => Assets.icons.svg.favorite.icFavorite3City,
    FavoriteIconType.restaurant => Assets.icons.svg.favorite.icFavorite5Restaurant,
    FavoriteIconType.heart => Assets.icons.svg.favorite.icFavorite10Heart,
    FavoriteIconType.coffee => Assets.icons.svg.favorite.icFavorite7Coffee,
    FavoriteIconType.store => Assets.icons.svg.favorite.icFavorite8Store,
    FavoriteIconType.shoppingBasket => Assets.icons.svg.favorite.icFavorite9ShoppingBasket,
  };
}
