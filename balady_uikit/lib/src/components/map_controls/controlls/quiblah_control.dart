part of '../map_controls.dart';

class QuiblahControl extends StatelessWidget {
  final Function()? onTap;

  const QuiblahControl({
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => MapButton(
        onTap: onTap,
        child: PlacesIcons.qibla.icon(),
      );
}
