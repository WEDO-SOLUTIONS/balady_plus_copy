import '../../../../../core/utils/nullable.dart';
import '../events_category/events_category_item.dart';
import '../../../../../core/utils/utils_exports.dart' show DateTimeExtension;

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
  SearchEventsParams({
    this.page,
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
    this.selectedFees,
  });

  SearchEventsParams copyWith({
    int? page,
    int? size,
    Nullable<String?>? keyword,
    Nullable<EventCategoryItem?>? selectedCity,
    Nullable<EventCategoryItem?>? selectedSeason,
    Nullable<EventCategoryItem?>? selectedAudince,
    Nullable<EventCategoryItem?>? selectedCategory,
    Nullable<EventCategoryItem?>? selectedFees,
    Nullable<DateTime?>? dateFrom,
    Nullable<DateTime?>? dateTo,
    Nullable<bool?>? isFree,
    Nullable<String?>? sortBy,
  }) {
    return SearchEventsParams(
      page: page ?? this.page,
      size: size ?? this.size,
      keyword: keyword == null ? this.keyword : keyword.value,
      selectedCity: selectedCity == null ? this.selectedCity : selectedCity.value,
      selectedSeason: selectedSeason == null ? this.selectedSeason : selectedSeason.value,
      selectedAudince: selectedAudince == null ? this.selectedAudince : selectedAudince.value,
      selectedCategory: selectedCategory == null ? this.selectedCategory : selectedCategory.value,
      dateFrom: dateFrom == null ? this.dateFrom : dateFrom.value,
      dateTo: dateTo == null ? this.dateTo : dateTo.value,
      isFree: isFree == null ? this.isFree : isFree.value,
      sortBy: sortBy == null ? this.sortBy : sortBy.value,
      selectedFees: selectedFees == null ? this.selectedFees : selectedFees.value,
    );
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
