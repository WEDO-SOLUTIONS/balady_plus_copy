import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/app/routes/profile.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/debug_state.dart';
import 'package:mapness/widgets/profile/contact_info.dart';

class HelpCenterPage extends ConsumerStatefulWidget {
  const HelpCenterPage({super.key});

  @override
  ConsumerState<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends ConsumerState<HelpCenterPage> {
  int tapsToGo = 7;

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Directionality(
          textDirection: Directionality.of(context),
          child: Material(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: Spacing.verticalBaseToTopModal),
              child: Scaffold(
                appBar: BaladyTopBar.iconAndText(
                  title: context.l10n.helpCenter,
                  colorEnabled: context.color.textAndIconsStatusAccent,
                  leading: ActionModel(
                    onPressed: () => context.pop(),
                    icon: context.isLTR ? SystemIcons.arrowCornerLeftL : SystemIcons.arrowCornerRightL,
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.only(
                    top: 12,
                    left: 12,
                    right: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ContentWrapper(
                        color: context.color.surfaceBaseSecondary,
                        children: [
                          ContentRow(
                            onTap: () => const MomraWebsitePageRoute().push(context),
                            options: ContentRowOptions(
                              title: context.l10n.baladyWebsite,
                              leadingIcon: GeneralIcons.globe.icon(
                                color: context.color.textAndIconsStatusAccent,
                              ),
                              actionWidget: ContentRowActionOptions(
                                actionIcon: context.isLTR
                                    ? SystemIcons.arrowCornerRightS.icon(
                                        color: context.color.textAndIconsBaseSecondary,
                                      )
                                    : SystemIcons.arrowCornerLeftS.icon(
                                        color: context.color.textAndIconsBaseSecondary,
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Spacing.verticalPaddingInsideWrapper.heightBox,
                      ContactInfo(
                        colorBegin: context.color.textAndIconsBaseSecondary,
                        colorEnd: context.color.textAndIconsStatusAccent,
                      ),
                      Spacing.verticalGapBetweenChips.heightBox,
                      GestureDetector(
                        onTap: () {
                          ///TODO: UNCOMMENT AFTER TESTING WHEN ADD VARIABLE TO CI
                          // if (const bool.fromEnvironment('URBI_DEBUG')) {
                            setState(() {
                              tapsToGo -= 1;
                            });
                            if (tapsToGo == 0) {
                              ref.read(debugStateProvider.notifier).enable();
                            }
                          // }
                        },
                        child: Text(context.l10n.foInquiriesAndTheLatestNews,
                            style: context.textStyle.caption.copyWith(
                              color: context.color.textAndIconsBaseTertiary,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
}
