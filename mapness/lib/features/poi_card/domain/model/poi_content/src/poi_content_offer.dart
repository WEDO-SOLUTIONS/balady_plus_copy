class PoiContentOfferModel {
  /// Title of the offer
  final String title;

  /// Discount of the offer
  final String? discount;

  /// If the organization does not provide an offer, the card will be hidden.
  /// Tapping on the card will navigate to the Saudi Pass scenario.
  final void Function() onTap;

  /// Business banner
  final PoiContentOfferImageModel? image;

  /// If there is no business banner, an image is placed instead in accordance with the group
  final PoiContentOfferFallbackImageModel fallbackImage;

  const PoiContentOfferModel({
    required this.title,
    required this.image,
    required this.fallbackImage,
    required this.onTap,
    this.discount,
  });
}

/// Image of the offer
class PoiContentOfferImageModel {
  /// URL of the image
  final String url;

  /// Headers of the image
  final Map<String, String> headers;

  const PoiContentOfferImageModel({
    required this.url,
    required this.headers,
  });
}

/// Asset image of the offer if there is no business banner
class PoiContentOfferFallbackImageModel {
  /// Path to the image
  final String path;

  /// Package of the image
  final String? package;

  const PoiContentOfferFallbackImageModel({
    required this.path,
    this.package,
  });
}
