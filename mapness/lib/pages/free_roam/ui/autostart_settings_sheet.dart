import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart' hide CloseButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/free_roam/free_roam_autostart_settings.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/buttons/app_close_button.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class AutostartSettingsSheetPage extends ConsumerStatefulWidget {
  const AutostartSettingsSheetPage({super.key});

  @override
  ConsumerState<AutostartSettingsSheetPage> createState() => AutostartSettingsSheetState();
}

class AutostartSettingsSheetState extends ConsumerState<AutostartSettingsSheetPage>
    with SingleTickerProviderStateMixin {
  static const duration = Duration(milliseconds: 250);
  static const showHideDuration = Duration(milliseconds: 150);

  static const curve = Curves.easeIn;

  late final ToggleSheetController sheetController = ToggleSheetController(
    onClose: (_) {
      ref.read(freeRoamStarterProvider.notifier).setShown();
      context.router.pop();
    },
  );

  @override
  void dispose() {
    super.dispose();
    sheetController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colors = context.colors;

    final textStyles = context.textStyles;
    return ToggleSheet(
      dragger: const SheetDragger(),
      backgroundColor: context.colors.backgroundSurface1,
      safeAreaColor: context.colors.backgroundSurface1,
      scrollController: sheetController,
      header: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.autostartNavigator,
                    style: textStyles.h4SemiBold.copyWith(color: colors.foregroundDefault),
                  ),
                  Spacing.$1x.heightBox,
                  Text(
                    context.l10n.disableStartingTheNavigator,
                    style: textStyles.bodySmallRegular.copyWith(color: colors.foregroundSoft),
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Spacing.$3x.widthBox,
            CustomCloseButton(onClose: _hideLayersPanel),
          ],
        ),
      ),
      content: [
        Spacing.$5x.heightBox,
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          size: ButtonSize.large,
          primaryLabel: l10n.switchOff,
          onTap: switchOff,
        ),
        Spacing.$2x.heightBox,
        AppButton(
          buttonColorScheme: ButtonColorScheme.accentSecondary,
          buttonType: ButtonType.secondary,
          size: ButtonSize.large,
          primaryLabel: l10n.continueAutorun,
          onTap: continueAutorun,
        ),
        Spacing.$4x.heightBox,
      ],
      contentPadding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
    );
  }

  void _hideLayersPanel() => sheetController.close();

  void switchOff() {
    ref.read(freeRoamAutostartSettingsProvider.notifier).setState(isAutostart: false);
    ref.read(freeRoamStarterProvider.notifier).setShown();
    if (context.mounted) {
      context.router.popUntilRouteWithName(BottomMenuRoute.name);
    }

    ToastOverlay.of(context).show(
      titleStyle: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundDefault),
      title: context.l10n.activateAutostartNavigator,
      icon: ToastIconAsset(Assets.icons.svg.icActionsContainer.keyName),
    );
  }

  void continueAutorun() {
    ref.read(freeRoamAutostartSettingsProvider.notifier).setState(isAutostart: true);
    if (context.mounted) {
      context.router.popUntilRouteWithName(BottomMenuRoute.name);
    }
  }
}

class ContentContainer extends StatelessWidget {
  final Widget child;

  const ContentContainer({required this.child, super.key});

  @override
  Widget build(BuildContext context) => DecoratedBox(
    decoration: BoxDecoration(
      color: context.colors.backgroundSurface1,
      borderRadius: BorderRadius.circular(RadiusBorder.xl),
    ),
    child: Padding(padding: const EdgeInsets.symmetric(vertical: 4.0), child: child),
  );
}
