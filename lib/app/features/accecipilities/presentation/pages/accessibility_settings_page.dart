import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/accecipilities/accessibility_controller.dart';
import 'package:balady_plus/app/features/accecipilities/presentation/pages/accessibility_info.dart';
import 'package:balady_plus/app/features/accecipilities/presentation/pages/text_size_preview_page.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart' as p;

class AccessibilitySettingsPage extends ConsumerStatefulWidget {
  const AccessibilitySettingsPage({super.key});

  @override
  ConsumerState<AccessibilitySettingsPage> createState() => _AccessibilitySettingsPageState();
}

class _AccessibilitySettingsPageState extends ConsumerState<AccessibilitySettingsPage> {
  @override
  Widget build(BuildContext context) {
    final controller = p.Provider.of<AccessibilityController>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: ref.watch(uiDirectionProvider),
        child: Material(
          color: context.colors.backgroundSurface4,

          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: context.l10n.accessibility,
                onLeadingPressed: () => context.router.pop(),
                leading: Semantics(
                  label: 'a11yBack'.tr(),
                  button: true,
                  child: ExcludeSemantics(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: Spacing.$4x),
                        Icon(SystemIcons.arrowCornerLeftLarge, color: context.colors.accentDefault),
                        const SizedBox(width: Spacing.$4x),
                      ],
                    ),
                  ),
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 12, left: 12, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContentWrapper(
                      color: context.colors.backgroundSurface1,
                      children: [
                        ContentRow(
                          onTap: () => Navigator.of(
                            context,
                          ).push(MaterialPageRoute(builder: (context) => const TextSizePreviewPage())),
                          leading: AppIcons(
                            iconData: GeneralIcons.messageTextLTR,
                            color: context.colors.accentDefault,
                            size: 24,
                          ),
                          text: ContentRowTextOptions(title: 'fontSize'.tr()),
                          trailing: ContentRowTextTrailingOptions(
                            icon: SystemIcons.arrowCornerRightLarge,
                            iconColor: context.colors.foregroundSoft,
                          ),
                        ),
                      ],
                    ),
                    Spacing.$4x.heightBox,
                    ContentWrapper(
                      color: context.colors.backgroundSurface1,
                      children: [
                        ContentRow(
                          onTap: () => controller.toggleGrayscale(!controller.grayscale),
                          leading: AppIcons(
                            iconData: Icons.color_lens_outlined,
                            color: context.colors.accentDefault,
                            size: 24,
                          ),
                          text: ContentRowTextOptions(title: 'grayScaleMode'.tr()),
                          // Kept as a custom trailing so the switch stays the
                          // CupertinoSwitch this screen already showed.
                          trailing: ContentRowCustomTrailingOptions(
                            builder: (_) => CupertinoSwitch(
                              value: controller.grayscale,
                              onChanged: controller.toggleGrayscale,
                              activeTrackColor: context.colors.accentDefault,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacing.$4x.heightBox,
                    ContentWrapper(
                      color: context.colors.backgroundSurface1,
                      children: [
                        ContentRow(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AccessibilityInfo({
                                "0": "accessibilityStepOpenSettings",
                                "1": "accessibilityStepAccessibility",
                                "2": "accessibilityStepScreenReader",
                                "3": "accessibilityStepEnableReader",
                                // "4": "accessibilityStepFinishSetup",
                              }),
                            ),
                          ),
                          leading: SvgPicture.asset(
                            'assets/icons/svg/voice_reader_icon.svg',
                            width: 24,
                            height: 24,
                            colorFilter: ColorFilter.mode(context.colors.accentDefault, BlendMode.srcIn),
                          ),
                          text: ContentRowTextOptions(title: 'voiceReader'.tr()),
                          trailing: ContentRowTextTrailingOptions(
                            icon: SystemIcons.arrowCornerRightLarge,
                            iconColor: context.colors.foregroundSoft,
                          ),
                        ),
                      ],
                    ),
                    Spacing.$2x.heightBox,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
