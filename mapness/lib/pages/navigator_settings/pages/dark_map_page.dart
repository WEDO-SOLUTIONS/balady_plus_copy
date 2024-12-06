import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/pages/navigator_settings/components/dark_map_mode_row_widget.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:urbi_utils/urbi_utils.dart';

@RoutePage()
class DarkMapPage extends ConsumerStatefulWidget {
  const DarkMapPage({super.key});

  @override
  ConsumerState<DarkMapPage> createState() => _DarkMapPage();
}

class _DarkMapPage extends ConsumerState<DarkMapPage> {
  @override
  Widget build(BuildContext context) {
    final dark = ref.watch(darkModeProvider);
    final colorsV2 = context.colorsV2;
    final l10n = context.l10n;
    final textStyleV3 = context.textStyleV3;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: ref.watch(uiDirectionProvider),
        child: Material(
          color: colorsV2.backgroundSurface4,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: SystemUiOverlayStyle.dark,
                title: l10n.darkMap,
                textStyle: textStyleV3.bodyLargeSemiBold.copyWith(
                  color: colorsV2.foregroundDefault,
                ),
                leading: ActionModel(
                  onPressed: () => context.router.popForced(),
                  icon: SystemIcons.arrowCornerLeftLarge,
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(RadiusBorder.xl),
                        child: Image.asset(
                          dark.valueOrNull?.isDark ?? false
                              ? 'assets/images/dark_map_preview.jpg'
                              : 'assets/images/light_map_preview.jpg',
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                    ContentWrapper(
                      color: colorsV2.backgroundSurface1,
                      children: DarkMapStateEnum.values
                          .map<Widget>(
                            (e) => DarkMapModeRowWidget(
                              currentMode: e,
                            ),
                          )
                          .insertBetween(
                            Divider(
                              height: 0.5,
                              color: colorsV2.borderSoft,
                              thickness: 1,
                              indent: Spacing.$4x,
                              endIndent: 0,
                            ),
                          )
                          .toList(),
                    ),
                  ].insertBetween(Spacing.$4x.heightBox).toList(),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
