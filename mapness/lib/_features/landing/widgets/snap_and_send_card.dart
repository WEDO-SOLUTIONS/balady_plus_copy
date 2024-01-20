import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart' as mapness;
import 'package:mapness/shared/ui/buttons/labeled_elevated_button.dart';

class SnapAndSendCard extends StatelessWidget {
  const SnapAndSendCard({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.contributedToImproving,
              style: Theme.of(context)
                  .extension<ThemeTextStyles>()!
                  .accentL
                  .copyWith(
                    color: const Color(0xFF1E2A36),
                  ),
            ),
            const SizedBox(
              height: 12,
            ),
            Container(
              height: 189,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: const DecorationImage(
                  image: AssetImage(
                    'assets/images/snap_and_send_card.png',
                    package: PackageConfig.packageName,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            context.l10n.snapAndSendTitle,
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .accentL
                                .apply(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            context.l10n.snapAndSendDescription,
                            maxLines: 3,
                            style: Theme.of(context)
                                .extension<ThemeTextStyles>()!
                                .textXS
                                .apply(color: Colors.white),
                          ),
                          const SizedBox(
                            height: 23,
                          ),
                          LabeledElevatedButton(
                            label: context.l10n.snapAndSendButton,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            onPressed: () {
                              mapness.CommonFunctions.authOrOpen(context,
                                  callback: () {
                                CommonFunctions.openSnapAndSend();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/snap_and_send_phone.png',
                      package: PackageConfig.packageName,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}
