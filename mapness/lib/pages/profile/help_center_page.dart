import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
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
import 'package:provider/provider.dart';

@RoutePage()
class HelpCenterPage extends ConsumerStatefulWidget {
  const HelpCenterPage({super.key});

  @override
  ConsumerState<HelpCenterPage> createState() => _HelpCenterPageState();
}

class _HelpCenterPageState extends ConsumerState<HelpCenterPage> {
  int tapsToGo = 7;

  @override
  Widget build(BuildContext context) {
    final isDGA =
        context.read<ThemeController>().currentTheme == BaladyAppThemes.darkDGA ||
            context.read<ThemeController>().currentTheme == BaladyAppThemes.lightDGA;

    return AnnotatedRegion<SystemUiOverlayStyle>(
    value: context.read<ThemeController>().systemOverlayStyle,
    child: Material(
      color: context.colors.backgroundSurface4,
      child: Padding(
        padding: const EdgeInsets.only(top: Spacing.$4x),
        child: Scaffold(
          appBar: BaladyTopBar(
            systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
            title: context.l10n.helpCenter,
            textStyle: context.textStyles.bodyLargeSemiBold.copyWith(color: context.colors.foregroundDefault),
            onLeadingPressed: () => context.router.pop(),
            leading: Semantics(
              label: context.l10n.a11yBack,
              button: true,
              child: ExcludeSemantics(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: Spacing.$4x),
                    Icon(
                      SystemIcons.arrowCornerLeftLarge,
                      color: context.colors.foregroundDefault,
                    ),
                    const SizedBox(width: Spacing.$4x),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.all(Spacing.$4x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ContentWrapper(
                  color: isDGA ? context.colors.accentSecondarySoft : context.colors.backgroundSurface1,
                  children: [
                    ContentRow(
                      onTap: () => context.router.push(const MomraWebsiteRoute()),
                      text: ContentRowTextOptions(title: context.l10n.baladyWebsite),
                      leading: Assets.icons.svg.profile.website.svg(
                        colorFilter: ColorFilter.mode(context.colors.accentDefault, BlendMode.srcIn),
                      ),
                      trailing: ContentRowTextTrailingOptions(
                        icon: SystemIcons.arrowCornerRightSmall.icon(color: context.colors.foregroundSoft).iconData,
                        iconColor: context.colors.foregroundSoft,
                      ),
                    ),
                  ],
                ),
                Spacing.$4x.heightBox,
                ContactInfo(colorBegin: context.colors.foregroundSoft, colorEnd: context.colors.accentDefault),
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
                      style: context.textStyles.captionMediumRegular.copyWith(color: context.colors.foregroundSoft),
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
}
