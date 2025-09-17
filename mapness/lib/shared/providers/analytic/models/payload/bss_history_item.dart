part of 'bss_payload.dart';

/// The type of suggestion processing is passed by the search.
enum BssHistoryHandlingType {
  /// Perform a text search
  searchSuggestedText,

  /// open a card of a specific object
  openRecord,

  /// insert placeholder text into the search bar
  incompleteQuery,

  /// expand an object (e.g. an object of the type category, metacategory, additional attribute)
  expandRecord,
}

/// Search history item
class BssHistoryItem {
  const BssHistoryItem({
    required this.text,
    this.handlingType,
    this.entity,
  });

  /// Search history item text
  final String text;

  /// The type of suggestion processing is passed by the search.
  final BssHistoryHandlingType? handlingType;

  /// Information about the object in history
  final BssEntity? entity;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'text': text,
    };
    if (handlingType != null) {
      data['handlingType'] = handlingType!.name;
    }
    if (entity != null) {
      data['entity'] = entity!.toJson();
    }
    return data;
  }
}
