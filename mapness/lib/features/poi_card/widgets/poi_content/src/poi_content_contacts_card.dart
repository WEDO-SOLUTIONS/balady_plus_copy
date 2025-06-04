import 'package:balady_uikit/balady_uikit.dart' hide PoiContentContacts, PoiContentSocialMediaType;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
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
      color: context.color.surfaceBasePrimary,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPhones)
          _PhoneItemWidget(
            phones: data.phones!,
            onTap: data.onPhoneTap,
          ),
        if (hasPhones && hasEmails)
          Divider(
            color: context.colorsV3.borderDefault,
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
                        icon: _getIconData(e.type),
                        onTap: () => data.onSocialMediaTap?.call(e.link),
                      ))
                  .toList(),
            ),
          ),
      ],
    );
  }

  IconData _getIconData(PoiContentSocialMediaTypes type) => switch (type) {
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
  final void Function(String phone)? onTap;

  const _PhoneItemWidget({required this.phones, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final phoneIcon = isRtl ? GeneralIcons.phoneRTL : GeneralIcons.phoneLTR;
    if (phones.length == 1) {
      return ContentRowV2(
        supportTitleRTL: false,
        text: ContentRowTextOptions(
          title: phones.first,
          titleOptions: ContentRowTextOption(
            baseColor: context.colorsV3.foregroundDefault,
          ),
        ),
        leading: phoneIcon.icon(color: context.colorsV3.accentDefault),
        onTap: () => onTap?.call(phones.first),
      );
    }
    return ContentRowExpandable(
      expandIconColor: context.colorsV3.foregroundMuted,
      options: ContentRowOptions(
        supportTitleRTL: false,
        title: phones.first,
        leadingIcon: phoneIcon.icon(color: context.colorsV3.accentDefault),
        actionWidget: ContentRowActionOptions(
          actionText: '${phones.length}',
        ),
      ),
      content: phones.length > 1
          ? Column(
              children: [
                for (final phone in phones.sublist(1))
                  GestureDetector(
                    onLongPress: () async {
                      await onCopyToClipboard(
                        phone,
                        toastText: context.l10n.phoneCopied,
                      );
                    },
                    child: ContentRowV2(
                      onTap: () => onTap?.call(phone),
                      leading: phoneIcon.icon(color: context.colorsV3.accentDefault),
                      text: ContentRowTextOptions(
                        title: phone,
                        titleOptions: ContentRowTextOption(
                          baseColor: context.colorsV3.foregroundDefault,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class _EmailItemWidget extends StatelessWidget {
  final List<String> emails;
  final void Function(String email)? onTap;

  const _EmailItemWidget({required this.emails, this.onTap});

  @override
  Widget build(BuildContext context) {
    if (emails.length == 1) {
      return ContentRowV2(
        supportTitleRTL: false,
        text: ContentRowTextOptions(
          title: emails.first,
          titleOptions: ContentRowTextOption(
            baseColor: context.colorsV3.foregroundDefault,
          ),
        ),
        leading: GeneralIcons.web.icon(color: context.colorsV3.accentDefault),
        onTap: () => onTap?.call(emails.first),
      );
    }
    // TODO: Refactoring of Expandable
    return ContentRowExpandable(
      expandIconColor: context.colorsV3.foregroundMuted,
      options: ContentRowOptions(
        title: emails.first,
        leadingIcon: GeneralIcons.web.icon(color: context.colorsV3.accentDefault),
        actionWidget: ContentRowActionOptions(
          actionText: '${emails.length}',
        ),
      ),
      content: emails.length > 1
          ? Column(
              children: [
                for (final email in emails.sublist(1))
                  GestureDetector(
                    onLongPress: () async {
                      await onCopyToClipboard(
                        email,
                        toastText: context.l10n.emailHasBeenCopied,
                      );
                    },
                    child: ContentRowV2(
                      onTap: () => onTap?.call(email),
                      leading: GeneralIcons.web.icon(color: context.colorsV3.accentDefault),
                      text: ContentRowTextOptions(
                        title: email,
                        titleOptions: ContentRowTextOption(
                          baseColor: context.colorsV3.foregroundDefault,
                        ),
                      ),
                    ),
                  ),
              ],
            )
          : const SizedBox.shrink(),
    );
  }
}

class _SocialMediaItemWidget extends StatelessWidget {
  final IconData icon;
  final void Function()? onTap;

  const _SocialMediaItemWidget({
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => CupertinoButton(
        onPressed: onTap,
        padding: EdgeInsets.zero,
        minSize: 0,
        child: Container(
          padding: const EdgeInsets.all(Spacing.$2x),
          decoration: BoxDecoration(
            color: context.colorsV3.accentSecondaryContainerDefault,
            borderRadius: BorderRadius.circular(Spacing.$2x),
          ),
          child: Icon(
            icon,
            color: context.colorsV3.accentSecondaryOnContainer,
            size: Spacing.$6x,
          ),
        ),
      );
}
