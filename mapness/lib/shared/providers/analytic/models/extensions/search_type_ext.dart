import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dgis_map/library.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_entity.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';

extension SearchResultListExt on SearchResultMessage {
  BssSearchResultList toBss() => BssSearchResultList(
    size: itemMarkerInfos?.length ?? 0,
    searchType: searchResultType.toBss(),
    firstResultClass: searchResultType.toBss(),
  );
}

extension ResultClassEnumExt on SearchResultTypeMessage? {
  ResultClassEnum toBss() => switch (this) {
    SearchResultTypeMessage.recovery => ResultClassEnum.orgRecovery,
    SearchResultTypeMessage.discovery => ResultClassEnum.orgDiscovery,
    _ => ResultClassEnum.unclassified,
  };
}

extension HistoryItemExt on SearchHistoryItem {
  BssHistoryItem toBss(BssHistoryHandlingType handlingType) => BssHistoryItem(
    text: title,
    handlingType: handlingType,
    entity: BssEntity(
      id: objectId ?? '',
      type: '',
    ),
  );
}

extension SearchHistoryDirectoryObjectMessageExt on SearchHistoryDirectoryObjectMessage {
  BssHistoryItem toBss(BssHistoryHandlingType handlingType) => BssHistoryItem(
    text: title,
    handlingType: handlingType,
    entity: BssEntity(
      id: id?.objectId.toString() ?? '',
      type: '',
    ),
  );

  String get hashKey =>
      'history-${id?.objectId ?? 0}-${id?.entranceId ?? 0}-${sha1.convert(utf8.encode(title))}-${sha1.convert(utf8.encode(address))}';
}

extension SuggestItemExt on SuggestMessage {
  BssSuggestItem toBss(BssHistoryHandlingType handlingType) {
    final objectHandler = handler.objectHandler;
    if (objectHandler == null) {
      throw Exception('Object handler is null');
    }
    final item = objectHandler.item;
    if (item.id == null) {
      throw Exception('Id is null');
    }
    return BssSuggestItem(
      text: title.text,
      entity: BssEntity(
        id: item.id!.objectId.toString(),
        type: suggestedType.name,
      ),
      handlingType: handlingType,
      org: item.orgInfo != null ? item.orgInfo!.id.toString() : null,
    );
  }
}
