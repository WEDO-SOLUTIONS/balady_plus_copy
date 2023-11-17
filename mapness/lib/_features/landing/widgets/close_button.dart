import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({super.key, required this.onTap});

  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE7ECF3),
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: SvgPicture.asset(
          "assets/icons/svg/ic_close.svg",
          semanticsLabel: 'MinApps Screen',
          package: "mapness",
          colorFilter: const ColorFilter.mode(
            Color(0x802B588A),
            BlendMode.srcIn,
          ),
        ),
      ),
    );
  }
}
