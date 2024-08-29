import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/features/share_eta/providers/eta_service_provider.dart';
import 'package:mapness/features/share_eta/providers/eta_websocket_provider.dart';

class EtaShareControlSheet extends ConsumerWidget {
  const EtaShareControlSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wsProvider = ref.read(etaWebsocketProvider.notifier);
    final streamProvider = ref.read(etaServiceProvider.notifier);

    Future<void> _stopShare() async {
      await wsProvider.stop();
      context.pop();
    }

    Future<void> _shareMore() async {
      await streamProvider.shareStream();
      context.pop();
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorsV2.neutralContainerDefault,
                  borderRadius: BorderRadius.circular(RadiusBorder.xs),
                ),
              ),
            ),
            ContentRow(
              options: ContentRowOptions(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                title: 'Route is sharing',
                titleStyle: context.textStyleV3.h3SemiBold.copyWith(
                  color: context.colorsV2.foregroundDefault,
                ),
                customActionWidget: AppButton.close(
                  onTap: () => context.pop(),
                  padding: EdgeInsets.zero,
                  textColor: context.colorsV2.neutralOnContainer,
                  color: context.colorsV2.neutralContainerDefault,
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
                  title: 'Share more',
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
                  title: 'Stop sharing',
                  titleStyle: context.textStyleV3.bodyLargeRegular.copyWith(
                    color: context.colorsV2.foregroundDefault,
                  ),
                  leadingIcon: Icon(GeneralIcons.clearCircle, color: context.colorsV2.foregroundSoft),
                ),
              )
            ]),
            const SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}
