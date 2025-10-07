// ignore_for_file: deprecated_member_use

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/tmp/content_row_expandable.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/copy_to_clipboard.dart';

class PoiContentContactsCard extends StatelessWidget {
  final PoiContentContactsModel? data;

  const PoiContentContactsCard({
    required this.data,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final data = this.data;
    if (data == null) {
      return const SizedBox.shrink();
    }
    final bool hasEmails = data.emails != null && data.emails!.isNotEmpty;
    final bool hasPhones = data.phones != null && data.phones!.isNotEmpty;
    final bool hasSocialMedia = data.socialMediaList?.isNotEmpty == true;

    return ContentWrapper(
      color: context.colors.backgroundSurface1,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPhones)
          _PhoneItemWidget(
            phones: data.phones!,
            onTap: data.onPhoneTap,
          ),
        if (hasPhones && hasEmails)
          Divider(
            color: context.colors.borderDefault,
            indent: Spacing.$12x,
            height: 1,
          ),
        if (hasEmails)
          _EmailItemWidget(
            emails: data.emails!,
            onTap: data.onEmailTap,
          ),
        if (hasSocialMedia) const SizedBox(width: double.maxFinite),
        if (hasSocialMedia)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Spacing.$4x,
              vertical: Spacing.$3x,
            ),
            child: Wrap(
              spacing: Spacing.$2x,
              runSpacing: Spacing.$2x,
              children: data.socialMediaList!
                  .map((e) => _SocialMediaItemWidget(
                        icon: getIconData(e.type),
                        onTap: () => data.onSocialMediaTap.call(e.link),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  static IconData getIconData(PoiContentSocialMediaTypes type) => switch (type) {
    PoiContentSocialMediaTypes.website => GeneralIcons.web,
    PoiContentSocialMediaTypes.instagram => SocialIcons.instagram,
    PoiContentSocialMediaTypes.facebook => SocialIcons.facebook,
    PoiContentSocialMediaTypes.youtube => SocialIcons.youtube,
    PoiContentSocialMediaTypes.linkedin => SocialIcons.linkedin,
    PoiContentSocialMediaTypes.whatsapp => SocialIcons.whatsapp,
    PoiContentSocialMediaTypes.telegram => SocialIcons.telegram,
  };
}

class _PhoneItemWidget extends StatelessWidget {
  final List<String> phones;
  final void Function(String phone) onTap;

  const _PhoneItemWidget({required this.phones, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (phones.isEmpty) {
      assert(phones.isNotEmpty, 'Phones must not be empty');
      return const SizedBox.shrink();
    }
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final phoneIcon = isRtl ? GeneralIcons.phoneRTL : GeneralIcons.phoneLTR;
    if (phones.length == 1) {
      return ContentRow(
        supportTitleRTL: false,
        text: ContentRowTextOptions(
          title: phones.first,
          titleOptions: ContentRowTextOption(
            baseColor: context.colors.foregroundDefault,
          ),
        ),
        leading: phoneIcon.icon(color: context.colors.accentDefault),
        onTap: () => onTap.call(phones.first),
      );
    }
    return ContentRowExpandableTmp(
      expandIconColor: context.colors.foregroundMuted,
      supportTitleRTL: false,
      leading: phoneIcon.icon(color: context.colors.accentDefault),
      onTitleTap: () => onTap.call(phones.first),
      text: ContentRowTextOptions(
        title: phones.first,
        titleOptions: ContentRowTextOption(
          baseColor: context.colors.foregroundDefault,
        ),
      ),
      trailing: Text(
        '${phones.length}',
        style: context.textStyles.bodySmallSemiBold.copyWith(
          color: context.colors.foregroundMuted,
        ),
      ),
      content: Column(
        children: [
          for (final phone in phones.sublist(1))
            GestureDetector(
              onLongPress: () async {
                await onCopyToClipboard(
                  phone,
                  toastText: context.l10n.phoneCopied,
                );
              },
              child: ContentRow(
                onTap: () => onTap.call(phone),
                crossAxisAlignment: CrossAxisAlignment.center,
                leading: phoneIcon.icon(color: context.colors.accentDefault),
                text: ContentRowTextOptions(
                  title: phone,
                  titleOptions: ContentRowTextOption(
                    baseColor: context.colors.foregroundDefault,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmailItemWidget extends StatelessWidget {
  final List<String> emails;
  final void Function(String email) onTap;

  const _EmailItemWidget({required this.emails, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (emails.isEmpty) {
      assert(emails.isNotEmpty, 'Emails must not be empty');
      return const SizedBox.shrink();
    }
    if (emails.length == 1) {
      return ContentRow(
        supportTitleRTL: false,
        text: ContentRowTextOptions(
          title: emails.first,
          titleOptions: ContentRowTextOption(
            baseColor: context.colors.foregroundDefault,
          ),
        ),
        leading: GeneralIcons.web.icon(color: context.colors.accentDefault),
        onTap: () => onTap.call(emails.first),
      );
    }
    return ContentRowExpandableTmp(
      onTitleTap: () => onTap.call(emails.first),
      expandIconColor: context.colors.foregroundMuted,
      leading: GeneralIcons.web.icon(color: context.colors.accentDefault),
      text: ContentRowTextOptions(
        title: emails.first,
        titleOptions: ContentRowTextOption(
          baseColor: context.colors.foregroundDefault,
        ),
      ),
      trailing: Text(
        '${emails.length}',
        style: context.textStyles.bodySmallSemiBold.copyWith(
          color: context.colors.foregroundMuted,
        ),
      ),
      content: Column(
        children: [
          for (final email in emails.sublist(1))
            GestureDetector(
              onLongPress: () async {
                await onCopyToClipboard(
                  email,
                  toastText: context.l10n.emailHasBeenCopied,
                );
              },
              child: ContentRow(
                onTap: () => onTap.call(email),
                leading: GeneralIcons.web.icon(color: context.colors.accentDefault),
                text: ContentRowTextOptions(
                  title: email,
                  titleOptions: ContentRowTextOption(
                    baseColor: context.colors.foregroundDefault,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SocialMediaItemWidget extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;

  const _SocialMediaItemWidget({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => CupertinoButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        minSize: 0,
        child: Container(
          padding: const EdgeInsets.all(Spacing.$2x),
          decoration: BoxDecoration(
            color: SaudiNationalDay.isNow()
                ? context.colors.accentContainerDefault
                : context.colors.accentSecondaryContainerDefault,
            borderRadius: BorderRadius.circular(Spacing.$2x),
          ),
          child: Icon(
            icon,
            color: SaudiNationalDay.isNow() ? context.colors.accentDefault : context.colors.accentSecondaryDefault,
            size: Spacing.$6x,
          ),
        ),
      );
}
