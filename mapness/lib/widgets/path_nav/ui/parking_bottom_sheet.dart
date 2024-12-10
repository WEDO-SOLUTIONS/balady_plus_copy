import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/navigator_auto_enable_parking.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

class ParkingBottomSheetPage extends ConsumerWidget {
  final StatelessBottomSheetController bottomSheetController;

  const ParkingBottomSheetPage({
    required this.bottomSheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SafeArea(
        child: StatelessBottomSheet(
          startConfig: BottomSheetStart.closed,
          scrollController: bottomSheetController,
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    context.l10n.automaticallyEnableParkinglayer,
                    style: context.textStyleV3.h3SemiBold,
                  ),
                ),
                Spacing.$3x.widthBox,
                AppButton(
                  size: ButtonSize.small,
                  buttonColorScheme: ButtonColorScheme.tertiary,
                  primaryIcon: SystemIcons.close,
                  onTap: bottomSheetController.close,
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
                    style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundSoft),
                  ),
                  Spacing.$4x.heightBox,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      primaryLabel: context.l10n.yes,
                      buttonColorScheme: ButtonColorScheme.primary,
                      onTap: () {
                        ref.read(navigatorAutoEnableParkingProvider.notifier).toggleAutoEnableParking(value: true);
                        bottomSheetController.close();
                      },
                    ),
                  ),
                  Spacing.$2x.heightBox,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      primaryLabel: context.l10n.no,
                      buttonColorScheme: ButtonColorScheme.secondary,
                      onTap: () {
                        ToastOverlay.of(context).show(
                          title: context.l10n.youCanChangeAutomaticParking,
                          actionText: context.l10n.feedbackBreaksSheetClose,
                        );

                        ref.read(navigatorAutoEnableParkingProvider.notifier).toggleAutoEnableParking(value: false);
                        bottomSheetController.close();
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
