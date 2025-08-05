import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/features/share_eta/ui/pulse_indicator.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaSharingSheet extends StatelessWidget {
  final VoidCallback onLiveLocationPressed;
  final VoidCallback onCurrentLocationPressed;

  const EtaSharingSheet({required this.onLiveLocationPressed, required this.onCurrentLocationPressed, super.key});

  @override
  Widget build(BuildContext context) => EtaShareSheet(
        title: context.l10n.sharing,
        contentBuilder: (context) => [
          ContentRow(
            onTap: onLiveLocationPressed,
            options: ContentRowOptions(
              dividerEnabled: true,
              leadingIcon: const PulseIndicator(),
              title: context.l10n.liveLocation,
              titleStyle: context.textStyles.bodyLargeRegular.copyWith(
                color: context.colors.foregroundDefault,
              ),
            ),
          ),
          ContentRow(
            onTap: onCurrentLocationPressed,
            options: ContentRowOptions(
              leadingIcon: SvgPicture.asset(
                Assets.icons.svg.currentLocationIcon.keyName,
                colorFilter: ColorFilter.mode(
                  context.colors.foregroundSoft,
                  BlendMode.srcIn,
                ),
              ),
              title: context.l10n.currentLocation,
              titleStyle: context.textStyles.bodyLargeRegular.copyWith(
                color: context.colors.foregroundDefault,
              ),
            ),
          )
        ],
      );
}
