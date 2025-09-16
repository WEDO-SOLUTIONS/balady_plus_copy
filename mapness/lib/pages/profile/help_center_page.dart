import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/debug_state.dart';
import 'package:mapness/widgets/profile/contact_info.dart';

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
          color: context.colors.backgroundSurface4,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: context.l10n.helpCenter,
                textStyle: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
                leading: ActionModel(
                  onPressed: () => context.router.popForced(),
                  icon: SystemIcons.arrowCornerLeftLarge,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.$4x),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentWrapper(
                      color: context.colors.backgroundSurface1,
                      children: [
                        ContentRow(
                          onTap: () => context.router.push(const MomraWebsiteRoute()),
                          text: ContentRowTextOptions(title: context.l10n.baladyWebsite),
                          leading: AppIcons(
                            iconPath: Assets.icons.svg.profile.website.path,
                            color: context.colors.accentDefault,
                            package: Assets.package,
                          ),
                          trailing: ContentRowTextTrailingOptions(
                            icon: SystemIcons.arrowCornerRightSmall.icon(color: context.colors.foregroundSoft).iconData,
                            iconColor: context.colors.foregroundSoft,
                          ),
                        )
                      ],
                    ),
                    Spacing.$4x.heightBox,
                    ContactInfo(
                      colorBegin: context.colors.foregroundSoft,
                      colorEnd: context.colors.accentDefault,
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
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: Spacing.$4x),
                        child: Text(
                          context.l10n.foInquiriesAndTheLatestNews,
                          style: context.textStyles.captionMediumRegular.copyWith(
                            color: context.colors.foregroundSoft,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}
