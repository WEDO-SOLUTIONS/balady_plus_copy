import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// unused for now but may be required after first demo
class _AdditionalManeuver extends StatelessWidget {
  final String instruction;
  final String iconPath;
  const _AdditionalManeuver(
      {super.key, required this.instruction, required this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
        color: Color(0xffEFEFEF),
      ),
      child: Column(
        children: [
          const SizedBox(height: 25.0),
          Row(
            children: [
              Text(
                instruction,
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                ),
              ),
              SvgPicture.asset(iconPath,
                  width: 28,
                  height: 28,
                  colorFilter: const ColorFilter.mode(
                    Color(0xff3588fd),
                    BlendMode.srcATop,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
