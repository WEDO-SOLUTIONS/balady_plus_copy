import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

@RoutePage()
class DeleteParkingPage extends ConsumerWidget {
  const DeleteParkingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const iconAsset = 'packages/mapness/assets/icons/svg/ic_complete.svg';
    final controller = StatelessBottomSheetController();

    return StatelessBottomSheet(
      scrollController: controller,
      content: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
          child: Row(
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      context.l10n.youSureWantDelete,
                      style: context.textStyleV3.h4SemiBold,
                    ),
                    Spacing.$1x.heightBox,
                    Text(
                      context.l10n.currentParkingSpaceRemoved,
                      style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundSoft),
                    ),
                  ],
                ),
              ),
              Spacing.$3x.widthBox,
              AppButton(
                buttonColorScheme: ButtonColorScheme.tertiary,
                primaryIcon: SystemIcons.close,
                onTap: () => context.router.popForced(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(Spacing.$4x).copyWith(bottom: 0),
          child: AppButton(
            buttonColorScheme: ButtonColorScheme.primary,
            primaryLabel: context.l10n.accept,
            onTap: () {
              ref.read(parkingManageProvider.notifier).clearStore();
              ToastOverlay.of(context).show(
                title: context.l10n.parkingSpotDeleted,
                iconAsset: iconAsset,
              );
              context.router.popUntilRouteWithName(BottomMenuRoute.name);
            },
          ),
        ),
        Spacing.$2x.heightBox,
        Padding(
          padding: const EdgeInsets.all(Spacing.$4x).copyWith(top: 0),
          child: AppButton(
            buttonColorScheme: ButtonColorScheme.secondary,
            primaryLabel: context.l10n.cancel,
            onTap: () => context.router.popForced(),
          ),
        ),
      ],
    );
  }
}
