import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, CommonFunctions, DateForm, DateTimeExtension;
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
    String? keyword,
    EventCategoryItem? selectedSeason,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) {
    return SearchCalendarParams(
        page: page ?? this.page,
        size: size ?? this.size,
        keyword: keyword ?? this.keyword,
        selectedSeason: selectedSeason ?? this.selectedSeason,
        dateFrom: dateFrom ?? this.dateFrom,
        dateTo: dateTo ?? this.dateTo);
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
