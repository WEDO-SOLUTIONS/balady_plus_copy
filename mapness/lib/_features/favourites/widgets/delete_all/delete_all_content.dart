import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class DeleteAllContent extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const DeleteAllContent({
    Key? key,
    required this.onConfirm,
    required this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = GoogleFonts.inter(
      color: Colors.white,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    );
    const color = Color(0xff4ba5b4);

    return Material(
      color: Colors.black.withOpacity(0.8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            Text(
              context.l10n.areYouSureYouWantToDeleteAllFavorites,
              style: textStyle,
              textDirection: TextDirection.ltr,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: onConfirm,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              child: Text(context.l10n.delete, style: textStyle),
            ),
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              child: Text(
                context.l10n.cancel,
                style: textStyle.copyWith(color: color),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
