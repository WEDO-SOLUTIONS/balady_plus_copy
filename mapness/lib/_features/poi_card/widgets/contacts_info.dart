import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/_features/poi_card/extensions/contacts_info_ext.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_actions_provider.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:urbi_utils/urbi_utils.dart';

class ContactsInfo extends ConsumerWidget {
  const ContactsInfo({
    required this.data,
    super.key,
  });

  final List<ContactInfoMessage?> data;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = data
        .whereNotNull()
        .map(
          (e) => e.contactsInfo(),
        )
        .toList();

    final phone = list.firstWhereOrNull((element) => element.type == ContactsInfoType.phone);
    final socials = list.where((element) => element.type != ContactsInfoType.phone);

    if (data.isEmpty) {
      return const SizedBox.shrink();
    } else {
      final isLtr = Directionality.of(context) == TextDirection.ltr;
      return CardContent(
          padding: EdgeInsets.zero,
          child: ListView(
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              children: [
                if (phone != null)
                  ContentRow(
                    onTap: () {
                      ref.read(poiCardActionsProvider.notifier).callPhone(value: phone.value);
                    },
                    options: ContentRowOptions(
                      padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.horizontalPaddingInsideWrapper,
                        vertical: Spacing.verticalPaddingInsideCell,
                      ),
                      leadingIcon: phone.type.getIconResource(isLtr).icon(
                            color: context.color.textAndIconsStatusAccent,
                          ),
                      title: phone.type == ContactsInfoType.phone ? phone.displayText : null,
                    ),
                  ),
                Spacing.verticalGapBetweenStories.heightBox,
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: Spacing.verticalPaddingInsideCell,
                    left: Spacing.horizontalPaddingInsideWrapper,
                    right: Spacing.horizontalPaddingInsideWrapper,
                  ),
                  child: Row(
                    children: <Widget>[
                      ...socials
                          .map((e) => Material(
                                color: context.color.surfaceBaseSecondary,
                                borderRadius: BorderRadius.circular(CornerRadius.toastBorderRadius),
                                child: InkWell(
                                  highlightColor: context.color.surfaceOverlayPressed,
                                  splashColor: context.color.surfaceOverlayPressed,
                                  onTap: () {
                                    final value = e.value;
                                    if (value == null) {
                                      return;
                                    }
                                    if (e.type == ContactsInfoType.email) {
                                      ref.read(poiCardActionsProvider.notifier).sendEmail(value);
                                    } else {
                                      ref.read(poiCardActionsProvider.notifier).launch(value);
                                    }
                                  },
                                  borderRadius: BorderRadius.circular(CornerRadius.toastBorderRadius),
                                  child: SizedBox(
                                      height: 36,
                                      width: 36,
                                      child: Icon(
                                        e.type.getIconResource(isLtr),
                                        size: 24,
                                        color: context.color.textAndIconsStatusAccent,
                                      )),
                                ),
                              ))
                          .toList(),
                    ]
                        .insertBetween(
                          Spacing.verticalGapBetweenChips.widthBox,
                        )
                        .toList(),
                  ),
                )
              ]));
    }
  }
}
