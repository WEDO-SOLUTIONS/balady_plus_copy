part of '../map_controls.dart';

class LayersControl extends StatelessWidget {
  final Function()? onTap;

  const LayersControl({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => MapButton(
        onTap: onTap,
        child: const AppIcons(iconData: SystemIcons.layers),
      );
}
