import 'package:flutter/material.dart';

/// Close button on bottom sheets
class SheetCloseButton extends StatelessWidget {
  /// @nodoc
  const SheetCloseButton({
    required this.onTap,
    super.key,
  });

  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 24,
        height: 24,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xff212121).withOpacity(0.2),
          ),
          child: const Icon(
            Icons.close,
            size: 16,
            color: Color(0xff212121),
          ),
        ),
      ),
    );
  }
}
