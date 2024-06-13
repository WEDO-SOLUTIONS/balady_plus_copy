import 'package:balady_uikit/balady_uikit.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/ar_functions.dart';
import 'package:mapness/shared/lib/common_functions.dart';

import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:mapness/widgets/search/ui/search_tap_handler.dart';
import 'package:provider/provider.dart';

class SuggestItem extends ConsumerWidget {
  final SuggestMessage suggest;
  final GeoPointMessage? myLocation;
  final bool isLast;
  final Function(DirectoryObjectMessage) onObjectTap;

  const SuggestItem({
    required this.suggest,
    required this.onObjectTap,
    this.myLocation,
    this.isLast = false,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();

    final incompleteText = suggest.handler.incompleteTextHandler;
    final performSearch = suggest.handler.performSearchHandler;
    final object = suggest.handler.objectHandler;

    String? subtitle;
    double? distanceKm;
    if (object != null) {
      subtitle = object.item.makeAddress();
      if (object.item.markerPosition != null && myLocation != null) {
        distanceKm = CommonFunctions.distance(
          object.item.markerPosition!.latitude,
          object.item.markerPosition!.longitude,
          myLocation!.latitude,
          myLocation!.longitude,
        );
      }
    } else if (suggest.subtitle.text.isNotEmpty) {
      subtitle = brunchFromString(suggest.subtitle.text, context);
    }

    void _onSuggestTap() {
      if (incompleteText != null) {
        ref.read(searchQueryProvider(scope.value).notifier).update(incompleteText.queryText);
      } else if (performSearch != null) {
        ref.read(searchProvider(scope.value).notifier).searchByQuery(performSearch.searchQuery, suggest.title.text);
        final historyObject = SearchHistoryItem.fromQuery(query: suggest.title.text);
        ref.read(searchHistoryProvider(scope.value).notifier).put(historyObject);
      } else if (object != null) {
        final objectItem = object.item;
        final historyItem = SearchHistoryItem.fromDirectoryObject(objectItem);
        ref.read(searchHistoryProvider(scope.value).notifier).put(historyItem);
        onObjectTap(objectItem);
      }
    }

    return Material(
      color: Colors.transparent,
      child: SearchTapHandler(
        onTap: _onSuggestTap,
        splashColor: context.color.surfaceBaseSecondary,
        child: ContentRow(
          options: ContentRowOptions(
            leadingIcon: Icon(
              SystemIcons.search,
              size: 24,
              color: context.color.textAndIconsBaseTertiary,
            ),
            actionWidget: distanceKm != null
                ? ContentRowActionOptions(actionText: (distanceKm * 1000).formatDistance(context.l10n))
                : null,
            title: buildSuggestTitle(context, suggest),
            subtitle: subtitle,
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

String brunchFromString(String engString, BuildContext context) {
  final subtitleSplit = engString.split(' ');

  String? result;
  result ??= _stringWithOneWord(subtitleSplit, context);
  result ??= _stringWithSameFirstAndSecondWords(subtitleSplit, context);
  result ??= engString;

  return result;
}

/// In most cases we can see it in arabic search
/// Return null if condition is not true
String? _stringWithOneWord(List<String> subtitleSplit, BuildContext context) {
  if (subtitleSplit.length == 1 && int.tryParse(subtitleSplit[0]) != null) {
    final amountOfBrunches = int.parse(subtitleSplit[0]);
    final brunchLocalized_ = brunch(amountOfBrunches, context.l10n);
    return '$amountOfBrunches $brunchLocalized_';
  }
  return null;
}

/// In most cases we can see it in english search
/// Return null if condition is not true
String? _stringWithSameFirstAndSecondWords(List<String> subtitleSplit, BuildContext context) {
  if (subtitleSplit.length >= 2 && subtitleSplit[0] == subtitleSplit[1]) {
    final amountOfBrunches = int.tryParse(subtitleSplit[0]);
    if (amountOfBrunches != null) {
      final brunchLocalized_ = brunch(amountOfBrunches, context.l10n);
      return '$amountOfBrunches $brunchLocalized_';
    }

    subtitleSplit.removeAt(0);
    return subtitleSplit.join(' ');
  }
  return null;
}
