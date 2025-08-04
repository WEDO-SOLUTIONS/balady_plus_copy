import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/providers/map/navigator_auto_enable_parking.dart';
import 'package:mapness/shared/providers/map/parking_autoenabled_sheet_provider.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';
import 'package:sheetify/sheetify.dart';

class ParkingBottomSheetPage extends HookConsumerWidget {
  const ParkingBottomSheetPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parkingSheetProvider = ref.read(parkingAutoenabledSheetProvider.notifier);
    final bottomSheetController = useToggleSheetController(
        onClose: (controller) => parkingSheetProvider.showParkingAutoEnableSheet(value: false));

    ref.listen(
      parkingAutoenabledSheetProvider,
      (_, value) {
        value ? bottomSheetController.open() : bottomSheetController.close();
      },
    );

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: ToggleSheet(
        dragger: const SheetDragger(),
        backgroundColor: context.colors.backgroundSurface1,
        safeAreaColor: context.colors.backgroundSurface1,
        startConfig: ToggleSheetStart.closed,
        scrollController: bottomSheetController,
        header: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  context.l10n.automaticallyEnableParkinglayer,
                  style: context.textStyles.h3SemiBold,
                ),
              ),
              Spacing.$3x.widthBox,
              AppButton(
                size: ButtonSize.small,
                buttonColorScheme: ButtonColorScheme.neutral,
                primaryIcon: SystemIcons.close,
                onTap: () => parkingSheetProvider.showParkingAutoEnableSheet(value: false),
              ),
            ],
          ),
        ),
        content: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Column(
              children: [
                Spacing.$2x.heightBox,
                Text(
                  context.l10n.wouldYouLikeTheParkingLayer,
                  style: context.textStyles.bodySmallRegular.copyWith(color: context.colors.foregroundSoft),
                ),
                Spacing.$4x.heightBox,
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    primaryLabel: context.l10n.yes,
                    buttonColorScheme: ButtonColorScheme.accent,
                    onTap: () {
                      ref.read(navigatorAutoEnableParkingProvider.notifier).toggleAutoEnableParking(value: true);

                      parkingSheetProvider.showParkingAutoEnableSheet(value: false);
                    },
                  ),
                ),
                Spacing.$2x.heightBox,
                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    primaryLabel: context.l10n.no,
                    buttonColorScheme: ButtonColorScheme.accentSecondary,
                    onTap: () {
                      ToastOverlay.of(context).show(
                        title: context.l10n.youCanChangeAutomaticParking,
                        actions: [ToastAction(title: context.l10n.feedbackBreaksSheetClose)],
                      );

                      ref.read(navigatorAutoEnableParkingProvider.notifier).toggleAutoEnableParking(value: false);

                      parkingSheetProvider.showParkingAutoEnableSheet(value: false);
                    },
                  ),
                ),
                Spacing.$3x.heightBox
              ],
            ),
          ),
        ],
      ),
    );
  }
}
