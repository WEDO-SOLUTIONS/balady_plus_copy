import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_contacts.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

void showPhonePickerSheet(
  BuildContext context,
  List<ContactsInfoModel> phones,
  void Function(String) onSelect,
) {
  final l10n = context.l10n;
  final isRtl = Directionality.of(context) == TextDirection.rtl;
  final phoneIcon = isRtl ? GeneralIcons.phoneRTL : GeneralIcons.phoneLTR;
  showModalBottomSheet<void>(
    context: context,
    backgroundColor: context.themeRead.colors.backgroundSurface1,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
            child: Text(
              l10n.selectPhoneNumber,
              style: ctx.textStyles.bodyLargeSemiBold.copyWith(color: ctx.colors.foregroundDefault),
            ),
          ),
          for (final phone in phones)
            ListTile(
              leading: Icon(phoneIcon, color: ctx.colors.accentDefault, size: Spacing.$6x),
              title: Text(
                phone.displayText ?? phone.value!,
                style: ctx.textStyles.bodyLargeRegular.copyWith(color: ctx.colors.foregroundDefault),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                onSelect(phone.value!);
              },
            ),
          ListTile(
            title: Text(
              l10n.cancel,
              textAlign: TextAlign.center,
              style: ctx.textStyles.bodyLargeMedium.copyWith(color: ctx.colors.foregroundMuted),
            ),
            onTap: () => Navigator.of(ctx).pop(),
          ),
        ],
      ),
    ),
  );
}
