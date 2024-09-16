import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

class CustomButtonIcon extends StatelessWidget {
  final String icon;
  final Function onPress;
  const CustomButtonIcon(
      {super.key, required this.icon, required this.onPress});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        height: 57,
        width: 57,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            color: const Color(0x1aFFFFFF)),
        child: SvgPicture.asset(
          icon,
          width: 20,
          height: 20,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}
