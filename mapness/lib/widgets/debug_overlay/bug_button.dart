import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class BugButton extends StatefulWidget {
  const BugButton({
    required this.onTap,
    super.key,
  });

  final void Function() onTap;

  @override
  State<BugButton> createState() => _BugButtonState();
}

class _BugButtonState extends State<BugButton> {
  Offset position = const Offset(100, 100);

  @override
  Widget build(BuildContext context) => Positioned(
        left: position.dx,
        top: position.dy,
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              position += details.delta;
            });
          },
          onTap: widget.onTap,
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.yellow.shade600,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.07),
                  blurRadius: 1,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8),
            child: SvgPicture.asset(
              Assets.icons.svg.icBug.keyName,
            ),
          ),
        ),
      );
}
