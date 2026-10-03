enum PoiTabsType {
  info,
  reviews,
  photos,
  organizations,
  parking;

  static const cardTabsDefault = [info, photos, organizations];
  static const _cardTabsWithReviews = [info, reviews, photos, organizations];

  /// Tabs of the POI card header in display order; a `TabController` index is a position in this list.
  static List<PoiTabsType> cardTabs({required bool withReviews}) =>
      withReviews ? _cardTabsWithReviews : cardTabsDefault;
}
