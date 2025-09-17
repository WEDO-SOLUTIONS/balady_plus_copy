part of 'bss_payload.dart';

/// Element of the list of suggestions
class BssSuggestItem {
  const BssSuggestItem({
    required this.entity,
    this.text,
    this.handlingType,
    this.resultClass,
    this.org,
  });

  /// The hint text returned by the search.
  final String? text;

  /// The object for object suggestions is always filled when it is defined.
  /// Even if id=0 Case: the search can find N streets with the same name.
  /// Now they are glued together into one hint. In this case, we know that they are looking for a street,
  /// but we don't know which one (case when the suggestor understood that they meant a street, but did not understand which one).
  final BssEntity? entity;

  /// Suggestion processing type, passed by search.
  /// searchSuggestedText - perform a search by text
  /// openRecord - open a card of a specific object
  final BssHistoryHandlingType? handlingType;

  /// The class to which the object found through the search belongs.
  final ResultClassEnum? resultClass;

  /// Unique company identifier
  final BssStringId? org;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'entity': entity?.toJson(),
    };
    if (text != null) {
      data['text'] = text;
    }
    if (handlingType != null) {
      data['handlingType'] = handlingType!.name;
    }
    if (resultClass != null) {
      data['resultClass'] = resultClass!.name;
    }
    if (org != null) {
      data['org'] = org;
    }
    return data;
  }
}
