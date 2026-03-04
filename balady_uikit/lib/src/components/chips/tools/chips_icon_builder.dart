import 'package:balady_uikit/src/layouts/size_constraint.dart';
import 'package:flutter/material.dart';

@Deprecated('Renamed. Use [ChipsIconBuilder] now')
typedef ChipsIconBuilderV2 = ChipsIconBuilder;
@Deprecated('Renamed. Use [ChipIconData] now')
typedef ChipIconDataV2 = ChipIconData;
@Deprecated('Renamed. Use [ChipIconWidget] now')
typedef ChipIconWidgetV2 = ChipIconWidget;

sealed class ChipsIconBuilder {
  Widget build(BuildContext context, {Color? color});
}

final class ChipIconData extends ChipsIconBuilder {
  ChipIconData(this.icon);

  final IconData icon;

  @override
  Widget build(BuildContext context, {Color? color}) => SizedBox(
        height: SizeConstraints.sizeIconChips,
        width: SizeConstraints.sizeIconChips,
        child: Icon(icon, color: color),
      );
}

final class ChipIconWidget extends ChipsIconBuilder {
  ChipIconWidget(this.widget);

  final Widget Function({Color? color}) widget;

  @override
  Widget build(BuildContext context, {Color? color}) => SizedBox(
        height: SizeConstraints.sizeIconChips,
        width: SizeConstraints.sizeIconChips,
        child: widget(color: color),
      );
}
