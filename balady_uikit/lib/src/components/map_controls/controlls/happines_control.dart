part of '../map_controls.dart';

class HappinesControl extends StatelessWidget {
  final Function()? onTap;

  const HappinesControl({super.key, this.onTap});

  @override
  Widget build(BuildContext context) => MapButton(
        onTap: onTap,
        child: AppIcons(
          iconData: Directionality.of(context) == TextDirection.rtl ? GeneralIcons.thumbUpRTL : GeneralIcons.thumbUpLTR,
          color: context.colors.foregroundDefault,
        ),
      );
}
