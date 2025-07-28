import 'package:dgis_map/library.dart';
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
