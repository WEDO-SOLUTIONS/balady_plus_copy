part of '../chips.dart';

/// The wrapper for the chips. It contains the background color of the chips,
/// clipper and add the shadow for the map chips if necessary
class ChipsWrapper extends StatelessWidget {
  final Widget child;
  final ChipsType type;
  final bool isSelected;
  final Color backgroundColor;

  const ChipsWrapper({
    required this.child,
    required this.type,
    required this.isSelected,
    required this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    /// According to design we need to show shadow for map chips only when it is selected
    /// If we will have any other states for shadow we can add it here
    final shadow = type == ChipsType.map && !isSelected ? Shadows.s : null;

    return DecoratedSmoothRadius(
      shadow: shadow,
      borderRadius: RadiusBorder.m,
      color: backgroundColor,
      child: child,
    );
  }
}
