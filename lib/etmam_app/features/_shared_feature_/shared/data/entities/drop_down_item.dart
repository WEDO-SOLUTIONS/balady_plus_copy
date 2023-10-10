import 'package:equatable/equatable.dart' show Equatable;

class DropDownItem extends Equatable {
  final String name;

  /// Value which returned or posted to server
  final String value;
  final String code;
  final int order;

  const DropDownItem({
    required this.name,
    required this.value,
    required this.code,
    this.order = 0,
  });

  factory DropDownItem.emptyState() =>
      const DropDownItem(name: "", value: "", code: "");

  bool get isEmpty => name.isEmpty && value.isEmpty && code.isEmpty;

  @override
  List<Object?> get props => [name, value, code, order];

  DropDownItem copyWith({
    String? name,
    String? value,
    String? code,
    int? order,
  }) {
    return DropDownItem(
      name: name ?? this.name,
      value: value ?? this.value,
      code: code ?? this.code,
      order: order ?? this.order,
    );
  }

  @override
  String toString() {
    return 'DropDownItem(name: $name, value: $value, code: $code, order: $order)';
  }
}

class DropDownItems extends Equatable {
  final List<DropDownItem> items;

  const DropDownItems({required this.items});

  @override
  List<Object?> get props => [items];

  DropDownItems copyWith({
    List<DropDownItem>? items,
  }) {
    return DropDownItems(
      items: items ?? this.items,
    );
  }

  @override
  String toString() => 'DropDownItems(items: $items)';
}
