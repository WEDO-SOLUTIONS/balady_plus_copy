import 'package:dgis_map/library.dart';
import 'package:mapness/entities/search/models/search_history.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_entity.dart';
import 'package:mapness/shared/providers/analytic/models/payload/bss_payload.dart';

extension SearchResultListExt on SearchResultMessage {
  BssSearchResultList toBss() => BssSearchResultList(
        size: itemMarkerInfos?.length ?? 0,
        searchType: searchResultType.toBss(),
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
          // TODO: add type
          type: '',
        ),
      );
}

extension SuggestItemExt on SuggestMessage {
  BssSuggestItem toBss(BssHistoryHandlingType handlingType) => BssSuggestItem(
        text: title.text,
        entity: BssEntity(
          id: handler.objectHandler!.item.id?.objectId.toString() ?? '',
          type: suggestedType.name,
        ),
        handlingType: handlingType,
      );
}
