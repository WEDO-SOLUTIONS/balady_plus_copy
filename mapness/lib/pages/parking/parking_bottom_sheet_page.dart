import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/cupertino.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class ParkingBottomSheetPage extends StatefulWidget {
  const ParkingBottomSheetPage({super.key});

  @override
  State<ParkingBottomSheetPage> createState() => _ParkingBottomSheetPageState();
}

class _ParkingBottomSheetPageState extends State<ParkingBottomSheetPage> {
  late final StatelessBottomSheetController _controller = StatelessBottomSheetController();

  @override
  Widget build(BuildContext context) => SafeArea(
        child: StatelessBottomSheet(
          scrollController: _controller,
          header: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  context.l10n.automaticallyEnableParkinglayer,
                  style: context.textStyleV3.h3SemiBold,
                ),
                AppButton(
                  size: ButtonSize.small,
                  buttonColorScheme: ButtonColorScheme.tertiary,
                  primaryIcon: SystemIcons.close,
                  onTap: () {},
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
                      // primaryLabel: context.l10n.yes,
                      buttonColorScheme: ButtonColorScheme.primary,
                      onTap: () {},
                    ),
                  ),
                  Spacing.$2x.heightBox,
                  SizedBox(
                    width: double.infinity,
                    child: AppButton(
                      // primaryLabel: context.l10n.no,
                      buttonColorScheme: ButtonColorScheme.secondary,
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
