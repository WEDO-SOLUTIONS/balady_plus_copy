import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/metrics/events/metrics_event.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/double_ext.dart';
import 'package:mapness/shared/lib/ar_functions.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/analytic/models/extensions/search_type_ext.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';
import 'package:mapness/shared/providers/distance.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/metrics/metrics_repository.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/visibiity/balady_visibility_detector.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/routing/lib/duration_distance_fmt.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class SuggestItem extends ConsumerWidget {
  final SuggestMessage suggest;
  final int index;
  final BssSuggestList? suggestList;
  final BssSearchRequest? searchRequest;
  final GeoPointMessage? myLocation;
  final bool isLast;
  final Color? iconColor;
  final Color? tralingTextColor;
  final Function(DirectoryObjectMessage) onObjectTap;

  const SuggestItem({
    required this.suggest,
    required this.index,
    required this.onObjectTap,
    this.suggestList,
    this.searchRequest,
    this.myLocation,
    this.isLast = false,
    this.iconColor,
    this.tralingTextColor,
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
      subtitle = _brunchFromString(suggest.subtitle.text, context);
    }

    void _onSuggestTap() {
      BssHistoryHandlingType? handlingType;
      if (incompleteText != null) {
        ref.read(searchProvider(scope.value).notifier).fetchSuggest(incompleteText.queryText);
        handlingType = BssHistoryHandlingType.incompleteQuery;
      } else if (performSearch != null) {
        ref.read(searchProvider(scope.value).notifier).searchByQuery(performSearch.searchQuery, suggest.title.text);
        final historyObject = SearchHistoryItem.fromQuery(query: suggest.title.text);
        ref.read(searchHistoryProvider(scope.value).notifier).put(historyObject.toMessage());
        handlingType = BssHistoryHandlingType.searchSuggestedText;
      } else if (object != null) {
        final objectItem = object.item;
        final historyItem = SearchHistoryItem.fromDirectoryObject(objectItem);
        ref.read(searchHistoryProvider(scope.value).notifier).put(historyItem.toMessage());
        ref
            .read(urbiAnalyticsProvider.notifier)
            .trackWithPrint('${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.suggestionPressed}');
        handlingType = BssHistoryHandlingType.openRecord;
        onObjectTap(objectItem);
      }
      BssService.instance.sendEvent(
        BssRequest(
          eventType: BSSEventType.action,
          actionType: BSSActionType.tap,
          uiElement: BssUIElement(
            name: BssUIElementNames.suggestItem,
            ownerName: BssUIElementNames.suggestList,
            position: index + 1,
          ),
          payload: BssPayload(
            searchRequest: searchRequest,
            suggestList: suggestList,
            suggestItem: suggest.toBss(handlingType ?? BssHistoryHandlingType.searchSuggestedText),
          ),
        ),
      );
      _sendSuggestionClickEvent(ref, scope, object?.item);
    }

    return BaladyVisibilityDetector(
      visibilityKey: Key('SuggestItem: $index, ${suggest.title.text}, ${suggest.subtitle.text}'),
      onVisible: (isFirstTimeVisible) => _sendSuggestionExposureEvent(ref, scope, isFirstTimeVisible),
      child: ContentRow(
        crossAxisAlignment: CrossAxisAlignment.center,
        onTap: _onSuggestTap,
        isDividerEnabled: !isLast,
        leading: SystemIcons.search.icon(color: iconColor ?? context.colors.foregroundSoft),
        text: ContentRowTextOptions(
          title: suggest.title.text,
          titleOptions: ContentRowTextOption(
            baseColor: context.colors.foregroundDefault,
            // Have error to change colors in library
            // matchedParts: _getSpans(suggest.title),
          ),
          subtitle: subtitle,
          subtitleOptions: ContentRowTextOption(
            baseColor: context.colors.foregroundDefault,
            // Have error to change colors in library
            // matchedParts: _getSpans(suggest.subtitle),
          ),
        ),
        trailing: distanceKm != null
            ? ContentRowTextTrailingOptions(
                text: (distanceKm * 1000).formatDistance(context.l10n),
                textStyle: tralingTextColor != null
                    ? context.textStyles.bodySmallSemiBold.copyWith(color: tralingTextColor)
                    : null,
              )
            : null,
      ),
    );
  }

  Future<void> _sendSuggestionExposureEvent(WidgetRef ref, SearchScope scope, bool isFirstTimeVisible) async {
    if (!isFirstTimeVisible) {
      return;
    }
    final searchState = ref.read(searchProvider(scope.value));
    if (searchState is! SearchStateSuggest) {
      return logger.log(
        'failed to sendSuggestionExposureEvent: searchState is not SearchStateSuggest',
        logLevel: MapnessLogLevel.error,
      );
    }
    final object = suggest.handler.objectHandler?.item;
    final suggestionType = suggest.handler.objectHandler != null
        ? MetricsSuggestionExposureSuggestionType.poi
        : MetricsSuggestionExposureSuggestionType.poiGroup;

    double? distanceInKilometers;
    final objectId = object?.id;
    if (objectId != null) {
      final distanceInMeters = await ref.read(
        getDistanceToObjectProvider(objectId.objectId, entranceId: objectId.entranceId).future,
      );
      if (distanceInMeters != null) {
        distanceInKilometers = (distanceInMeters / 1000).roundDecimal(2);
      }
    }

    final location = ref.read(locationProvider);

    ref
        .read(metricsRepositoryProvider.notifier)
        .sendSuggestionExposureEvent(
          searchParam: {
            'suggest_type': suggest.suggestedType.name,
            if (location != null) 'location': '${location.latitude}, ${location.longitude}',
          },
          suggestionSessionId: searchState.suggestionSessionId,
          requestId: const Uuid().v4(),
          searchText: searchState.searchText,
          suggestionType: suggestionType,
          suggestionName: suggest.title.text,
          suggestionRank: index,
          suggestionPoiId: object?.id?.objectId.toString(),
          suggestionPoiAddress: object?.makeAddress(),
          suggestionDistance: distanceInKilometers?.toStringAsFixed(2),
        );
  }

  Future<void> _sendSuggestionClickEvent(WidgetRef ref, SearchScope scope, DirectoryObjectMessage? object) async {
    final searchState = ref.read(searchProvider(scope.value));
    if (searchState is! SearchStateSuggest) {
      return logger.log(
        'failed to sendSuggestionClickEvent: searchState is not SearchStateSuggest',
        logLevel: MapnessLogLevel.error,
      );
    }
    final suggestionType = suggest.handler.objectHandler != null
        ? MetricsSuggestionExposureSuggestionType.poi
        : MetricsSuggestionExposureSuggestionType.poiGroup;

    double? distanceInKilometers;
    final objectId = object?.id;
    if (objectId != null) {
      final distanceInMeters = await ref.read(
        getDistanceToObjectProvider(objectId.objectId, entranceId: objectId.entranceId).future,
      );
      if (distanceInMeters != null) {
        distanceInKilometers = (distanceInMeters / 1000).roundDecimal(2);
      }
    }

    final location = ref.read(locationProvider);

    ref
        .read(metricsRepositoryProvider.notifier)
        .sendSuggestionClickEvent(
          suggestionSessionId: searchState.suggestionSessionId,
          requestId: const Uuid().v4(),
          searchText: searchState.searchText,
          suggestionType: suggestionType,
          suggestionName: suggest.title.text,
          suggestionRank: index,
          poiId: objectId?.objectId.toString(),
          suggestionPoiAddress: object?.makeAddress(),
          poiDistance: distanceInKilometers?.toStringAsFixed(2),
          poiName: object?.title,
          poiType: object?.types.firstOrNull?.type.name ?? object?.subtitle,
        );
  }
}

String _brunchFromString(String engString, BuildContext context) {
  final subtitleSplit = engString.split(' ');

  String? result;
  result ??= _ifSubtitleWithOneWord(subtitleSplit, context);
  result ??= _ifSubtitleWithSameFirstAndSecondWords(subtitleSplit, context);
  result ??= engString;

  return result;
}

/// In most cases we can see it in arabic search
/// Return null if condition is not true
String? _ifSubtitleWithOneWord(List<String> subtitleSplit, BuildContext context) {
  if (subtitleSplit.length == 1 && int.tryParse(subtitleSplit[0]) != null) {
    final amountOfBrunches = int.parse(subtitleSplit[0]);
    final brunchLocalized = brunch(amountOfBrunches, context.l10n);
    return '$amountOfBrunches $brunchLocalized';
  }
  return null;
}

/// In most cases we can see it in english search
/// Return null if condition is not true
String? _ifSubtitleWithSameFirstAndSecondWords(List<String> subtitleSplit, BuildContext context) {
  if (subtitleSplit.length >= 2 && subtitleSplit[0] == subtitleSplit[1]) {
    final amountOfBrunches = int.tryParse(subtitleSplit[0]);
    if (amountOfBrunches != null) {
      final brunchLocalized = brunch(amountOfBrunches, context.l10n);
      return '$amountOfBrunches $brunchLocalized';
    }

    subtitleSplit.removeAt(0);
    return subtitleSplit.join(' ');
  }
  return null;
}
