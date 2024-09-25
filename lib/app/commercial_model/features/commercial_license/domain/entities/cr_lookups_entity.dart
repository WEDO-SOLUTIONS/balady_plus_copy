import '../../../../../features/_shared_feature_/data/entities/drop_down_item.dart';

class CrLookupsEntity extends DropDownItem {
  final int lookupId;
  final String lookupMame;

  const CrLookupsEntity({
    required this.lookupId,
    required this.lookupMame,
  }) : super(name: lookupMame, id: lookupId);

  String? get text => lookupMame;
}
