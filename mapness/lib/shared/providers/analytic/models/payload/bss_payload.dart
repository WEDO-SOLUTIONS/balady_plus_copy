import 'package:mapness/shared/providers/analytic/models/extensions/type_defs.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_entity.dart';

part 'bss_place_item.dart';
part 'bss_suggest_list.dart';
part 'bss_suggest_item.dart';
part 'bss_search_result_list.dart';
part 'bss_search_request.dart';
part 'bss_map_marker.dart';
part 'bss_call_to_action.dart';
part 'bss_history_item.dart';
part 'bss_contacts.dart';
part 'bss_history_list.dart';

enum ResultClassEnum {
  /// The search didn't recognize request
  unclassified(value: 0),

  /// Recovery branch/organization
  orgRecovery(value: 1),

  /// Discovery branch/organization with rubric
  orgDiscovery(value: 2),

  /// Discovery branch uncategorized
  orgExtension(value: 32),

  /// Geo object
  regular(value: 39),

  /// Ontology (category, attribute, type transport routes, ...))
  ontological(value: 84),

  /// Special object (home, work, …)
  special(value: 85),

  /// Recovery geo object
  geo(value: 86),

  /// Recovery transport object
  transport(value: 87),

  /// Recovery product
  productRecovery(value: 88),

  /// Discovery product with heading
  productDiscovery(value: 89),

  /// Product category (heading)
  productCategory(value: 90),

  /// An object that does not belong to any particular group
  other(value: 91);

  final int value;

  const ResultClassEnum({
    required this.value,
  });
}

/// Block of additional attributes
class BssPayload {
  const BssPayload({
    this.placeItem,
    this.suggestList,
    this.suggestItem,
    this.searchRequest,
    this.searchResultList,
    this.searchResultItem,
    this.mapMarker,
    this.callToAction,
    this.historyItem,
    this.historyList,
    this.contact,
  });

  /// Information about the search results element of the Places tab (cards of branches, geographic objects and hybrids).
  final BssPlaceItem? placeItem;
  final BssSuggestList? suggestList;
  final BssSuggestItem? suggestItem;
  final BssSearchRequest? searchRequest;
  final BssSearchResultList? searchResultList;
  final BssSearchRequest? searchResultItem;
  final BssMapMarker? mapMarker;
  final BssCallToAction? callToAction;
  final BssHistoryItem? historyItem;
  final BssHistoryList? historyList;
  final BssContact? contact;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (placeItem != null) {
      data['placeItem'] = placeItem!.toJson();
    }
    if (suggestList != null) {
      data['suggestList'] = suggestList!.toJson();
    }
    if (suggestItem != null) {
      data['suggestItem'] = suggestItem!.toJson();
    }
    if (searchRequest != null) {
      data['searchRequest'] = searchRequest!.toJson();
    }
    if (searchResultList != null) {
      data['searchResultList'] = searchResultList!.toJson();
    }
    if (searchResultItem != null) {
      data['searchResultItem'] = searchResultItem!.toJson();
    }
    if (mapMarker != null) {
      data['mapMarker'] = mapMarker!.toJson();
    }
    if (callToAction != null) {
      data['callToAction'] = callToAction!.toJson();
    }
    if (historyItem != null) {
      data['historyItem'] = historyItem!.toJson();
    }
    if (contact != null) {
      data['contact'] = contact!.toJson();
    }
    return data;
  }
}
