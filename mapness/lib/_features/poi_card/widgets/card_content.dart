import 'package:flutter/material.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';

class CardContent extends StatelessWidget {
  final Widget child;

  const CardContent({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(12),
            ),
          ),
          shadows: [
            BoxShadow(
              color: colorShadow,
              blurRadius: 22,
              offset: Offset(0, 4),
              spreadRadius: 0,
            )
          ],
        ),
        child: child,
      ),
    );
  }
}
