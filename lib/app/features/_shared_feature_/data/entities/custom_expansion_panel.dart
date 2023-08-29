import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/material.dart' show Color, EdgeInsetsGeometry, Widget;

class ExpansionPanelInfo extends Equatable {
  final Color? bgColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;

  final double? expansionWidth;

  final Widget? header;
  final EdgeInsetsGeometry? headerPadding;

  /// Maybe Widget or String or IconData
  final dynamic leading;
  final String? title;
  final int titleMaxLines;

  /// The body of expansion
  final Widget? body;
  final EdgeInsetsGeometry? bodyPadding;
  final bool isExpanded;
  final bool underline;
  final void Function(bool)? onExpansionChanged;

  const ExpansionPanelInfo({
    this.bgColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.expansionWidth,
    this.headerPadding,
    this.header,
    this.leading,
    this.title,
    this.titleMaxLines = 2,
    this.body,
    this.bodyPadding,
    this.isExpanded = false,
    this.underline = true,
    this.onExpansionChanged,
  });

  @override
  List<Object?> get props => [
        bgColor,
        borderColor,
        borderWidth,
        borderRadius,
        expansionWidth,
        headerPadding,
        header,
        leading,
        title,
        titleMaxLines,
        body,
        bodyPadding,
        isExpanded,
        underline,
        onExpansionChanged,
      ];
}
