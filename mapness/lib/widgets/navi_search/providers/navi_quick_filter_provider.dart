import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/ui/toast/app_locale.dart';
import 'package:mapness/widgets/navi_search/models/filter_item_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'navi_quick_filter_provider.g.dart';

@riverpod
List<FilterItemModel> naviQuickFilter(Ref ref) {
  final l10n = ref.watch(appLocaleProvider);
  final lang = ref.watch(appLanguageProvider);

  return NaviQuickFilterList().list
      .map(
        (filter) => FilterItemModel(
          title: filter.title(l10n),
          isSelected: false,
          query: filter.query[lang] ?? '',
          icon: filter.icon,
        ),
      )
      .toList();
}
