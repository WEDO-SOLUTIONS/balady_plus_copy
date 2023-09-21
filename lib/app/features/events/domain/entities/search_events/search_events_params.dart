class SearchEventsParams {
  int? page;
  int? size;
  String? category;
  String? city;
  String? season;
  String? audience;
  String? feesType;
  SearchEventsParams({
    this.page,
    this.size,
    this.category,
    this.city,
    this.season,
    this.audience,
    this.feesType,
  });

  SearchEventsParams copyWith({
    int? page,
    int? size,
    String? category,
    String? city,
    String? season,
    String? audience,
    String? feesType,
  }) {
    return SearchEventsParams(
      page: page ?? this.page,
      size: size ?? this.size,
      category: category ?? this.category,
      city: city ?? this.city,
      season: season ?? this.season,
      audience: audience ?? this.audience,
      feesType: feesType ?? this.feesType,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "page": page,
      "size": size,
      if (category != null) "category": category,
      if (city != null) "city": city,
      if (season != null) "season": season,
      if (audience != null) "audience": audience,
      if (feesType != null) "fees_type": feesType,
    };
  }
}
