import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart' show EdgeInsets, Widget;

class ExpansionPanelInfo extends Equatable {
  final double? expansionWidth;

  /// Maybe Widget or String or IconData
  final dynamic leading;
  final String? title;

  final Widget? header;
  final EdgeInsets? headerPadding;

  /// The body of expansion
  final Widget? body;
  final EdgeInsets? expandedPadding;
  final bool isExpanded;
  final bool underline;
  final void Function(bool)? onExpansionChanged;

  const ExpansionPanelInfo({
    this.expansionWidth,
    this.leading,
    this.title,
    this.header,
    this.headerPadding,
    this.body,
    this.expandedPadding,
    this.isExpanded = false,
    this.underline = true,
    this.onExpansionChanged,
  });

  @override
  List<Object?> get props => [
        leading,
        title,
        header,
        headerPadding,
        body,
        expansionWidth,
        expandedPadding,
        isExpanded,
        underline,
        onExpansionChanged,
      ];
}
