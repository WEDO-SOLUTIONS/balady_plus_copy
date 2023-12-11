import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class SnapAndSendCard extends StatelessWidget {
  const SnapAndSendCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: 16.0).copyWith(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.contributedToImproving,
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .accentL
                .apply(color: const Color(0xff1E2A36)),
          ),
          const SizedBox(
            height: 12,
          ),
          Stack(
            children: [
              Image.asset(
                'assets/images/snap_and_send_card.png',
                fit: BoxFit.fitWidth,
                package: 'mapness',
              ),
              Positioned(
                  top: 21,
                  right: 24,
                  child: Text(
                    context.l10n.photoAndVideo,
                    style: Theme.of(context)
                        .extension<ThemeTextStyles>()!
                        .accentL
                        .apply(color: Colors.white),
                  )),
              Positioned(
                bottom: 20,
                right: 21,
                child: LabeledElevatedButton(
                  label: context.l10n.sahm,
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
