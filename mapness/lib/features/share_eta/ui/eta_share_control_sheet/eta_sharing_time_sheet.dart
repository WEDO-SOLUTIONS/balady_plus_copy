import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mapness/features/share_eta/entities/share_eta_time_type.dart';
import 'package:mapness/features/share_eta/ui/eta_share_control_sheet/eta_share_sheet.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class EtaSharingTimeSheet extends HookWidget {
  final ValueChanged<ShareEtaTimeType> onConfirmTap;
  const EtaSharingTimeSheet({
    required this.onConfirmTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final selectedTimeType = useState(ShareEtaTimeType.fiveteenMinutes);

    const empty = SizedBox(
      height: 24.0,
      width: 24.0,
    );

    Widget _customCheckMarkBuilder(bool? init) => init ?? false
        ? AppIcons(size: 24, iconData: SystemIcons.checkmark, color: context.colors.accentDefault)
        : empty;

    return EtaShareSheet(
      title: context.l10n.shareLiveLocation,
      confirmBtnTitle: context.l10n.share_location_btn,
      onConfirmTap: () => onConfirmTap(selectedTimeType.value),
      contentBuilder: (context) => [
        ContentRow(
          onTap: () => selectedTimeType.value = ShareEtaTimeType.fiveteenMinutes,
          options: ContentRowOptions(
            dividerEnabled: true,
            actionWidget: ContentRowActionOptions(
              toggleInitialValue: selectedTimeType.value == ShareEtaTimeType.fiveteenMinutes,
              customToggleBuilder: ({required onToggle, initial}) => _customCheckMarkBuilder(initial),
            ),
            title: context.l10n.for15Minutes,
            titleStyle: context.textStyles.bodyLargeRegular.copyWith(
              color: context.colors.foregroundDefault,
            ),
          ),
        ),
        ContentRow(
          onTap: () => selectedTimeType.value = ShareEtaTimeType.oneHour,
          options: ContentRowOptions(
            dividerEnabled: true,
            actionWidget: ContentRowActionOptions(
              toggleInitialValue: selectedTimeType.value == ShareEtaTimeType.oneHour,
              customToggleBuilder: ({required onToggle, initial}) => _customCheckMarkBuilder(initial),
            ),
            title: context.l10n.for1Hour,
            titleStyle: context.textStyles.bodyLargeRegular.copyWith(
              color: context.colors.foregroundDefault,
            ),
          ),
        ),
        ContentRow(
          onTap: () => selectedTimeType.value = ShareEtaTimeType.eightHours,
          options: ContentRowOptions(
            actionWidget: ContentRowActionOptions(
              toggleInitialValue: selectedTimeType.value == ShareEtaTimeType.eightHours,
              customToggleBuilder: ({required onToggle, initial}) => _customCheckMarkBuilder(initial),
            ),
            title: context.l10n.for8Hours,
            titleStyle: context.textStyles.bodyLargeRegular.copyWith(
              color: context.colors.foregroundDefault,
            ),
          ),
        ),
      ],
    );
  }
}
