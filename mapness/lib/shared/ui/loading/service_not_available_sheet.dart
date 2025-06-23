import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/extensions/string_ext.dart';

@RoutePage()
class ServiceNotAvailableSheetPage extends StatelessWidget {
  const ServiceNotAvailableSheetPage({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface1,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(RadiusBorder.xl),
            topRight: Radius.circular(RadiusBorder.xl),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: Spacing.$1_5x),
                  child: SheetDragger(),
                ),
              ),
              ContentRow(
                options: ContentRowOptions(
                  padding: EdgeInsets.zero,
                  titleStyle: context.textStyles.h3SemiBold.copyWith(
                    color: context.colors.foregroundDefault,
                  ),
                  customActionWidget: AppButton.close(
                    onTap: context.router.popForced,
                    padding: EdgeInsets.zero,
                    textColor: context.colors.neutralOnContainer,
                    color: context.colors.neutralContainerDefault,
                    innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                  ),
                ),
              ),
              Image.asset(
                Assets.images.regionNotAvailable.keyName,
                width: double.infinity,
                fit: BoxFit.fitWidth,
              ),
              const SizedBox(
                height: Spacing.$5x,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Column(
                  children: [
                    Text(
                      context.l10n.baladyNavigationTitleKey.multilines,
                      textAlign: TextAlign.center,
                      style: context.textStyles.h3SemiBold.copyWith(
                        color: context.colors.foregroundDefault,
                      ),
                    ),
                    const SizedBox(
                      height: Spacing.$3x,
                    ),
                    Text(
                      context.l10n.baladyNavigationDescriptionKey.multilines,
                      textAlign: TextAlign.center,
                      style: context.textStyles.bodyLargeRegular.copyWith(
                        color: context.colors.foregroundSoft,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: Spacing.$16x,
              ),
            ],
          ),
        ),
      );
}
