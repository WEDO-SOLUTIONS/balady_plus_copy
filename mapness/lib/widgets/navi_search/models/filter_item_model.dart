import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

@immutable
class FilterItemModel extends Equatable {
  final String title;
  final bool isSelected;
  final String query;
  final IconData? icon;

  const FilterItemModel({
    required this.title,
    required this.isSelected,
    required this.query,
    this.icon,
  });

  FilterItemModel copyWith({String? title, bool? isSelected, String? query, IconData? icon}) => FilterItemModel(
        title: title ?? this.title,
        isSelected: isSelected ?? this.isSelected,
        query: query ?? this.query,
        icon: icon ?? this.icon,
      );

  @override
  List<Object?> get props => [title, isSelected, query, icon];
}
