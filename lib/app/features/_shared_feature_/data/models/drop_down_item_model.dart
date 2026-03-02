import '../../../../core/utils/utils_exports.dart' show JsonConversion;
import '../../shared_feature_exports.dart' show DropDownItem, DropDownItems;

const _name = 'name';
const _value = "value";
const _code = "code";
const _order = "order";
const _id = "id";

class DropDownItemModel extends DropDownItem {
  const DropDownItemModel({
    required super.name,
    required super.value,
    required super.code,
    required super.order,
    required super.id,
  });

  factory DropDownItemModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return DropDownItem.emptyState().toModel;
    return DropDownItemModel(
      name: map[_name]?.toString() ?? '',
      value: map[_value]?.toString() ?? '',
      code: map[_code] ?? '',
      order: map[_order]?.toInt() ?? 0,
      id: map[_id],
    );
  }

  factory DropDownItemModel.fromEntity(DropDownItem entity) {
    return DropDownItemModel(
      name: entity.name,
      value: entity.value,
      code: entity.code,
      order: entity.order,
      id: entity.id,
    );
  }

  Map<String, dynamic> toMap() => {
        _name: name,
        _value: value,
        _code: code,
        _order: order,
        if (id != null) _id: id,
      };

  String toJson() => toMap().toJson();

  factory DropDownItemModel.fromJson(String source) => DropDownItemModel.fromMap(source.fromJson());
}

class DropDownItemsModel extends DropDownItems {
  const DropDownItemsModel({required List<DropDownItemModel> items}) : super(items: items);

  factory DropDownItemsModel.itemsFromMap(List<dynamic> list) => DropDownItemsModel(
        items: list.map((item) => DropDownItemModel.fromMap(item)).toList(),
      );
}

extension DropDownEntityModelConversion on DropDownItem {
  DropDownItemModel get toModel => DropDownItemModel(
        name: name,
        value: value,
        code: code,
        order: order,
        id: id,
      );
}
