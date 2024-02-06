import 'package:equatable/equatable.dart';

import 'filter_item.dart';

class Filter extends Equatable {
  final List<FilterItem>? filterItem;

  const Filter({
    this.filterItem,
  });

  factory Filter.fromJson(Map<String, dynamic> json) => Filter(
        filterItem: (json['data'] as List<dynamic>?)
            ?.map((e) => FilterItem.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'data': filterItem?.map((e) => e.toJson()).toList(),
      };

  @override
  List<Object?> get props {
    return [
      filterItem,
    ];
  }
}
