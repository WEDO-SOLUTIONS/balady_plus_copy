import 'package:flutter/cupertino.dart';

///SvgPicture.asset('assets/icons/
///assets/icons/svg
class AppIcons extends StatelessWidget {
  final IconData iconData;

  const AppIcons(this.iconData, {super.key});

  @override
  Widget build(BuildContext context) => Icon(iconData,);
}
