import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/debug_state.dart';
import 'package:mapness/widgets/profile/contact_info.dart';

import '../../shared/config/package_config.dart';

@RoutePage()
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
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: context.l10n.helpCenter,
                colorEnabled: context.color.textAndIconsStatusAccent,
                leading: ActionModel(
                  onPressed: () => context.router.popForced(),
                  icon: SystemIcons.arrowCornerLeftLarge,
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
                          onTap: () => context.router.push(const MomraWebsiteRoute()),
                          options: ContentRowOptions(
                            title: context.l10n.baladyWebsite,
                            leadingIcon: SvgPicture.asset('assets/icons/svg/profile/website.svg', height: 24, width: 24, package: PackageConfig.packageName,),
                            actionWidget: ContentRowActionOptions(
                              actionIcon: SystemIcons.arrowCornerRightLarge.icon(
                                color: context.color.textAndIconsBaseSecondary,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Spacing.$4x.heightBox,
                    ContactInfo(
                      colorBegin: context.color.textAndIconsBaseSecondary,
                      colorEnd: context.color.textAndIconsStatusAccent,
                    ),
                    Spacing.$2x.heightBox,
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
      );
}
