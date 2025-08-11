enum PoiContentFavouriteTypes {
  favourites,
  home,
  work,
}

class PoiContentFavouriteModel {
  final PoiContentFavouriteTypes type;
  final String title;
  final void Function() onTap;

  PoiContentFavouriteModel({
    required this.type,
    required this.title,
    required this.onTap,
  });
}
