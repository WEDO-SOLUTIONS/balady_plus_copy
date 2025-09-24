part of 'bss_payload.dart';

class BssSearchRequest {
  const BssSearchRequest({
    this.text,
    this.entities,
  });

  /// The query text passed to one of the search modules.
  /// Depending on the event, it may mean: query text entered by the user in the search bar, hint text,
  /// keyword - tag in the organization's photo.
  final String? text;

  /// An array of entities passed to the search. For example, the id of a meta heading to expand, the id of a building to open a card.
  /// The format for transmitting data on geo and transport objects will differ due to the presence of
  /// different reference books in the structure of the unisearch object and data base.
  final List<BssEntity>? entities;

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (text != null) {
      data['text'] = text;
    }
    if (entities != null) {
      data['entities'] = entities!.map((e) => e.toJson()).toList();
    }
    return data;
  }
}
