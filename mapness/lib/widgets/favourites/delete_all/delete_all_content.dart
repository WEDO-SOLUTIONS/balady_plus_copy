import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

@RoutePage()
class DeleteAllContentPage extends StatelessWidget {
  const DeleteAllContentPage({
    required this.onConfirm,
    required this.onCancel,
    super.key,
  });
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final textStyle = context.textStyle.heading2.copyWith(color: Colors.white);
    final color = context.colors.accentOnContainer;

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
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              ),
              child: Text(context.l10n.delete, style: textStyle),
            ),
            ElevatedButton(
              onPressed: onCancel,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
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
