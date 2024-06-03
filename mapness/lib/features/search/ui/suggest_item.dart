import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';

import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/widgets/search/ui/search_tap_handler.dart';
import 'package:provider/provider.dart';

class SuggestItem extends ConsumerWidget {
  final SuggestMessage suggest;
  final bool isLast;
  final Function(DirectoryObjectMessage) onObjectTap;

  const SuggestItem({
    required this.suggest,
    required this.onObjectTap,
    this.isLast = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();

    final incompleteText = suggest.handler.incompleteTextHandler;
    final performSearch = suggest.handler.performSearchHandler;
    final object = suggest.handler.objectHandler;

    IconData? icon;
    if (incompleteText != null) {
      icon = GeneralIcons.placeHolder;
    } else if (performSearch != null) {
      icon = SystemIcons.search;
    } else if (object != null) {
      icon = GeneralIcons.pin;
    }

    void _onSuggestTap() {
      if (incompleteText != null) {
        ref
            .read(searchQueryProvider(scope.value).notifier)
            .update(incompleteText.queryText);
      } else if (performSearch != null) {
        ref
            .read(searchProvider(scope.value).notifier)
            .searchByQuery(performSearch.searchQuery, suggest.title.text);
        final historyObject =
            SearchHistoryItem.fromQuery(query: suggest.title.text);
        ref
            .read(searchHistoryProvider(scope.value).notifier)
            .put(historyObject);
      } else if (object != null) {
        final objectItem = object.item;
        final historyItem = SearchHistoryItem.fromDirectoryObject(objectItem);
        ref.read(searchHistoryProvider(scope.value).notifier).put(historyItem);
        onObjectTap(objectItem);
      }
    }

    final address = object?.item.makeAddress();

    return Material(
      color: Colors.transparent,
      child: SearchTapHandler(
        onTap: _onSuggestTap,
        splashColor: context.color.surfaceBaseSecondary,
        child: ContentRow(
          options: ContentRowOptions(
            leadingIcon: Icon(
              icon,
              size: 24,
              color: context.color.textAndIconsBaseTertiary,
            ),
            title: buildSuggestTitle(context, suggest),
            subtitle: address,
            dividerEnabled: !isLast,
          ),
        ),
      ),
    );
  }
}

const prefixMapping = {
  ', region': 'منطقة',
  ', governorate': 'محافظة',
  ', city': 'مدينة',
  ', district area': 'محافظة',
  ', district': 'حى',
  ', street': 'شارع',
  ', buildings': 'مبنى',
  ', park': 'بارك',
};

String buildSuggestTitle(BuildContext context, SuggestMessage suggest) {
  var title = suggest.title.text;
  prefixMapping.forEach((key, replacement) {
    if (title.contains(key)) {
      title = "$replacement ${title.replaceAll(key, "")}";
    }
  });

  return title;
}
