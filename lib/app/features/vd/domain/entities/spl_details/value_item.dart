import 'package:equatable/equatable.dart';

import '../../../../_shared_feature_/data/entities/drop_down_item.dart';

class ValueItem extends Equatable {
  ValueItem({this.addlFeildValue, this.fieldId, this.id});

  String? addlFeildValue;
  String? fieldId;
  String? id;

  DropDownItem? getDropDownItem() {
    return DropDownItem(
        id: id,
        name: addlFeildValue ?? "",
        value: addlFeildValue ?? "",
        code: "");
  }

  @override
  List<Object?> get props => [addlFeildValue, fieldId, id];
}
