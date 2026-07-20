import 'package:app_settings/app_settings.dart';
import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

class AccessibilityInfo extends StatelessWidget {
  final Map<String, String> settingsText;

  const AccessibilityInfo(this.settingsText, {super.key});

  @override
  Widget build(BuildContext context) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark,
    child: Material(
      color: context.colors.backgroundSurface4,
      child: Padding(
        padding: const EdgeInsets.only(top: Spacing.$4x),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: Scaffold(
            persistentFooterButtons: [
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                  primaryLabel: 'navigate'.tr(),
                  size: ButtonSize.large,
                  buttonColorScheme: ButtonColorScheme.accent,
                  onTap: () => AppSettings.openAppSettings(type: AppSettingsType.accessibility),
                ),
              ),
            ],
            appBar: BaladyTopBar(
              systemUiOverlayStyle: SystemUiOverlayStyle.dark,
              title: 'voiceReader'.tr(),
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
              padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 36),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Semantics(
                        label: 'a11yImage'.tr(),
                        image: true,
                        child: ExcludeSemantics(
                          child: Image(image: const AssetImage('assets/images/voice_reader.webp')),
                        ),
                      ),
                    ),
                    Spacing.$5x.heightBox,
                    Text(
                      'stepsToAccessFeature'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                        color: context.colors.foregroundDefault,
                      ),
                    ),
                    Spacing.$5x.heightBox,
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: settingsText.length,
                      shrinkWrap: true,
                      separatorBuilder: (_, _) => Spacing.$4x.heightBox,
                      itemBuilder: (context, index) => Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            height: 24,
                            width: 24,
                            decoration: BoxDecoration(
                              color: context.colors.accentDefault,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                  color: context.colors.accentOnAccent,
                                ),
                              ),
                            ),
                          ),
                          Spacing.$4x.widthBox,
                          Flexible(
                            child: Text(
                              settingsText.values.elementAt(index).tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: context.colors.foregroundDefault,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
