import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class LoadingSheet extends StatelessWidget {
  final String? text;
  const LoadingSheet({Key? key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
        height: 265,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            Text(
              text ?? context.l10n.loading,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .textL
                  .copyWith(color: const Color(0xB21E2A36)),
            ),
          ],
        ),
      ),
    );
  }
}
