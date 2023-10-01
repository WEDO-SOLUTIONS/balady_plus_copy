import '../events_category/events_category_item.dart';
import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, DateForm, DateTimeExtension;

class SearchEventsParams {
  int? page;
  int? size;
  String? keyword;
  EventCategoryItem? selectedCity;
  EventCategoryItem? selectedSeason;
  EventCategoryItem? selectedAudince;
  EventCategoryItem? selectedCategory;
  EventCategoryItem? selectedFees;
  DateTime? dateFrom;
  DateTime? dateTo;
  bool? isFree;
  String? sortBy;
  SearchEventsParams(
      {this.page,
      this.size,
      this.keyword,
      this.selectedCity,
      this.selectedSeason,
      this.selectedAudince,
      this.selectedCategory,
      this.dateFrom,
      this.dateTo,
      this.isFree,
      this.sortBy,
      this.selectedFees});

  SearchEventsParams copyWith(
      {int? page,
      int? size,
      String? keyword,
      EventCategoryItem? selectedCity,
      EventCategoryItem? selectedSeason,
      EventCategoryItem? selectedAudince,
      EventCategoryItem? selectedCategory,
      EventCategoryItem? selectedFees,
      DateTime? dateFrom,
      DateTime? dateTo,
      bool? isFree,
      String? sortBy}) {
    return SearchEventsParams(
        page: page ?? this.page,
        size: size ?? this.size,
        keyword: keyword ?? this.keyword,
        selectedCity: selectedCity ?? this.selectedCity,
        selectedSeason: selectedSeason ?? this.selectedSeason,
        selectedAudince: selectedAudince ?? this.selectedAudince,
        selectedCategory: selectedCategory ?? this.selectedCategory,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo,
        isFree: isFree ?? this.isFree,
        sortBy: sortBy ?? this.sortBy,
        selectedFees: selectedFees ?? this.selectedFees);
  }

  Map<String, dynamic> toMap() {
    return {
      "page": page,
      "size": size,
      if (keyword != null) "keyword": keyword,
      if (selectedCity != null) "city": selectedCity!.id,
      if (selectedSeason != null) "season": selectedSeason!.id,
      if (selectedAudince != null) "audience": selectedAudince!.id,
      if (selectedCategory != null) "category": selectedCategory!.id,
      if (dateFrom != null) "from": dateFrom!.toFormattedDate1(),
      if (dateTo != null) "to": dateTo!.toFormattedDate1(),
      if (selectedFees != null) "fees-type": selectedFees!.id,
      if (sortBy != null) "sort-dir": "asc",
      if (sortBy != null) "sort-by": sortBy == "price" ? "Fees" : "StartDate",
    };
  }
}
