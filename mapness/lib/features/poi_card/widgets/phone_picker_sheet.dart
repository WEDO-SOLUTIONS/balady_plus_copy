import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
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
          const Padding(padding: EdgeInsets.all(Spacing.$1_5x), child: SheetDragger()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.selectPhoneNumber,
                  style: ctx.textStyles.bodyLargeSemiBold.copyWith(color: ctx.colors.foregroundDefault),
                ),
                AppButton.close(onTap: () => Navigator.of(ctx).pop()),
              ],
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
        ],
      ),
    ),
  );
}
