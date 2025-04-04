import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/features/saudi_pass/providers/offer_redeem_provider.dart';
import 'package:mapness/shared/hooks/stateless_botomsheet_controller_hook.dart';

class OfferCodeSheet extends HookConsumerWidget {
  final String code;
  final String offerId;
  final String title;
  final String description;

  const OfferCodeSheet({
    required this.code,
    required this.offerId,
    required this.title,
    required this.description,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final redeemState = ref.watch(offerRedeemProvider(offerId));

    final bottomSheetController = useStatelessBottomsheetController(
      onClose: (_) {
        Navigator.of(context).pop(ref.read(offerRedeemProvider(offerId)) == OfferRedeemState.redeemed);
      },
    );

    return StatelessBottomSheet(
      draggerColor: context.colorsV3.backgroundSurface2,
      backgroundColor: context.colorsV3.backgroundSurface2,
      content: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: context.textStyleV3.h2SemiBold.copyWith(color: context.colorsV3.foregroundDefault),
                          ),
                          Spacing.$1x.heightBox,
                          Text(
                            description,
                            style:
                                context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV3.foregroundSoft),
                          ),
                        ],
                      ),
                    ),
                    Spacing.$3x.widthBox,
                    AppButton(
                      buttonColorScheme: ButtonColorScheme.secondary,
                      size: ButtonSize.small,
                      onTap: bottomSheetController.close,
                      primaryIcon: SystemIcons.close,
                      iconColor: context.colorsV3.neutralOnContainer,
                    ),
                  ],
                ),
                SizedBox(
                  height: 101,
                  child: switch (redeemState) {
                    OfferRedeemState.redeemed => Padding(
                      padding: const EdgeInsets.symmetric(vertical: Spacing.$4x),
                      child: Container(
                        decoration: BoxDecoration(
                          color: context.colorsV3.neutralContainerDefault,
                          borderRadius: const BorderRadius.all(Radius.circular(RadiusBorder.l)),
                        ),
                        height: 69,
                        alignment: Alignment.center,
                        child: Text(
                          code,
                          style: context.textStyleV3.h3SemiBold.copyWith(color: context.colorsV3.neutralOnContainer),
                        ),
                      ),
                    ),
                    OfferRedeemState.loading => Center(
                        child: Loading.large(),
                      ),
                    _ => const SizedBox.shrink(),
                  },
                ),
              ],
            ),
          ),
        ),
      ],
      scrollController: bottomSheetController,
    );
  }
}
