import '../../../../../core/utils/nullable.dart';
import '../../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppStyle,
        CommonFunctions,
        DateForm,
        DateTimeExtension,
        Nullable;
import '../../../../events/domain/entities/events_category/events_category_item.dart';

class SearchCalendarParams {
  int? page;
  int? size;
  String? keyword;
  EventCategoryItem? selectedSeason;

  DateTime? dateFrom;
  DateTime? dateTo;
  SearchCalendarParams({
    this.page,
    this.size,
    this.keyword,
    this.selectedSeason,
    this.dateFrom,
    this.dateTo,
  });

  SearchCalendarParams copyWith({
    int? page,
    int? size,
    Nullable<String?>? keyword,
    Nullable<EventCategoryItem?>? selectedSeason,
    Nullable<DateTime?>? dateFrom,
    Nullable<DateTime?>? dateTo,
  }) {
    return SearchCalendarParams(
      page: page ?? this.page,
      size: size == 0 ? 1 : (size ?? this.size),
      keyword: keyword == null ? this.keyword : keyword.value,
      selectedSeason:
          selectedSeason == null ? this.selectedSeason : selectedSeason.value,
      dateFrom: dateFrom == null ? this.dateFrom : dateFrom.value,
      dateTo: dateTo == null ? this.dateTo : dateTo.value,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "pageIndex": page,
      "pageSize": size,
      if (keyword != null) "keyword": keyword,
      if (selectedSeason != null) "type": selectedSeason!.id,
      if (dateFrom != null) "from": dateFrom!.toFormattedDate1(),
      if (dateTo != null) "to": dateTo!.toFormattedDate1(),
    };
  }
}
