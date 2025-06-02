import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/features/share_eta/models/eta_stream_payload.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaShareControlSheet extends ConsumerWidget {
  const EtaShareControlSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> _closeStream() async {
      // Close stream without clear storage
      await ref.read(shareEtaProvider.notifier).stopSharing();
    }

    Future<void> _stopShare() async {
      await _closeStream();
      context.router.popForced();
    }

    Future<void> _shareMore() async {
      ref.read(shareEtaProvider.notifier).shareCurrentStream(EtaStreamType.eta);
      context.router.popForced();
    }

    return Container(
      decoration: BoxDecoration(
        color: context.colorsV2.backgroundSurface4,
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
                padding: const EdgeInsets.only(bottom: Spacing.$4x),
                title: context.l10n.routeIsSharing,
                titleStyle: context.textStyleV3.h3SemiBold.copyWith(
                  color: context.colorsV2.foregroundDefault,
                ),
                customActionWidget: AppButton.close(
                  onTap: () => context.router.popForced(),
                  padding: EdgeInsets.zero,
                  textColor: context.colorsV2.neutralOnContainer,
                  color: context.colorsV2.neutralContainerDefault,
                  innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
                ),
              ),
            ),
            ContentWrapper(color: Colors.white, children: [
              ContentRow(
                onTap: _shareMore,
                options: ContentRowOptions(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.$4x,
                    vertical: Spacing.$3x,
                  ),
                  dividerEnabled: true,
                  title: context.l10n.shareMore,
                  titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                    color: context.colorsV2.foregroundDefault,
                  ),
                  leadingIcon: Icon(SystemIcons.share, color: context.colorsV2.foregroundSoft),
                ),
              ),
              ContentRow(
                onTap: _stopShare,
                options: ContentRowOptions(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.$4x,
                    vertical: Spacing.$3x,
                  ),
                  title: context.l10n.stopSharing,
                  titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                    color: context.colorsV2.foregroundDefault,
                  ),
                  leadingIcon: Icon(GeneralIcons.clearCircle, color: context.colorsV2.foregroundSoft),
                ),
              )
            ]),
            const SizedBox(
              height: Spacing.$8x,
            )
          ],
        ),
      ),
    );
  }
}
