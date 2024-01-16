import 'package:flutter/material.dart';

class ContentRow extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;

  const ContentRow({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(12));
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.white,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
