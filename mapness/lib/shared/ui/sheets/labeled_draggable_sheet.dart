import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';

class LabeledDraggableSheet extends StatelessWidget {
  final VoidCallback onClose;
  final String title;
  final Widget child;

  const LabeledDraggableSheet({
    super.key,
    required this.onClose,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.only(top: 8, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 26,
              height: 3,
              decoration: ShapeDecoration(
                color: const Color(0xFFDCE4EE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(23),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    softWrap: true,
                    style: GoogleFonts.inter(
                      color: const Color(0xFF1D2A36),
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AppCloseButton(onPressed: onClose),
              ],
            ),
            const SizedBox(height: 16),
            Flexible(child: child),
          ],
        ),
      ),
    );
  }
}
