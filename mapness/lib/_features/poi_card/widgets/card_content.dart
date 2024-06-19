import 'package:flutter/material.dart';

class CardContent extends StatelessWidget {
  const CardContent({
    required this.child,
    super.key,
    this.onTap,
    this.padding,
  });

  final Widget child;
  final void Function()? onTap;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(12));
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Material(
        color: Colors.white,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: padding??const EdgeInsets.all(16),
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                borderRadius: borderRadius,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
