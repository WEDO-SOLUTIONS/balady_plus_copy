import 'package:flutter/cupertino.dart';

///SvgPicture.asset('assets/icons/
///assets/icons/svg
class AppIcons extends StatelessWidget {
  final IconData iconData;
  final Color? color;

  const AppIcons(this.iconData, {super.key, this.color});

  @override
  Widget build(BuildContext context) => Icon(
        iconData,
        color: color,
        // textDirection: Directionality.of(context),
      );
}
