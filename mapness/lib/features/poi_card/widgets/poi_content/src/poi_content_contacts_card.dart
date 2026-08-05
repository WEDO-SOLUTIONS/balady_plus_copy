// ignore_for_file: deprecated_member_use

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/poi_content.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/tmp/content_row_expandable.dart';
import 'package:mapness/features/special_themes/modes/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/copy_to_clipboard.dart';

class PoiContentContactsCard extends StatelessWidget {
  final PoiContentContactsModel? data;

  const PoiContentContactsCard({required this.data, super.key});

  @override
  Widget build(BuildContext context) {
    final data = this.data;
    if (data == null) {
      return const SizedBox.shrink();
    }
    final bool hasEmails = data.emails != null && data.emails!.isNotEmpty;
    final bool hasPhones = data.phones != null && data.phones!.isNotEmpty;
    final bool hasSocialMedia = data.socialMediaList?.isNotEmpty == true;

    // Count total number of contact groups
    int totalGroups = 0;
    if (hasPhones) {
      totalGroups++;
    }
    if (hasEmails) {
      totalGroups++;
    }
    if (hasSocialMedia) {
      totalGroups++;
    }

    final bool shouldShowFullWidth = totalGroups <= 3;

    return ContentWrapper(
      color: context.colors.backgroundSurface1,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (hasPhones)
          _PhoneItemWidget(phones: data.phones!, onTap: data.onPhoneTap, showFullWidth: shouldShowFullWidth),
        if (hasPhones && hasEmails) Divider(color: context.colors.borderDefault, indent: Spacing.$12x, height: 1),
        if (hasEmails)
          _EmailItemWidget(emails: data.emails!, onTap: data.onEmailTap, showFullWidth: shouldShowFullWidth),
        if ((hasPhones || hasEmails) && hasSocialMedia && shouldShowFullWidth)
          Divider(color: context.colors.borderDefault, indent: Spacing.$12x, height: 1),
        if (hasSocialMedia) const SizedBox(width: double.maxFinite),
        if (hasSocialMedia)
          _SocialMediaItemWidget(
            socialMediaList: data.socialMediaList!,
            onTap: data.onSocialMediaTap,
            showFullWidth: shouldShowFullWidth,
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
    PoiContentSocialMediaTypes.twitter => SocialIcons.twitter,
    PoiContentSocialMediaTypes.tiktok => SocialIcons.youtube,
    // PoiContentSocialMediaTypes.tiktok => SocialIcons.tiktok,
  };
}

class _PhoneItemWidget extends StatelessWidget {
  final List<String> phones;
  final void Function(String phone) onTap;
  final bool showFullWidth;

  const _PhoneItemWidget({required this.phones, required this.onTap, this.showFullWidth = false});

  @override
  Widget build(BuildContext context) {
    if (phones.isEmpty) {
      assert(phones.isNotEmpty, 'Phones must not be empty');
      return const SizedBox.shrink();
    }
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final phoneIcon = isRtl ? GeneralIcons.phoneRTL : GeneralIcons.phoneLTR;

    // If showFullWidth is true, show all phones in separate rows
    if (showFullWidth) {
      return Column(
        children: [
          for (final phone in phones)
            GestureDetector(
              onLongPress: () async {
                await onCopyToClipboard(phone, toastText: context.l10n.phoneCopied);
              },
              child: ContentRow(
                onTap: () => onTap.call(phone),
                supportTitleRTL: false,
                crossAxisAlignment: CrossAxisAlignment.center,
                leading: phoneIcon.icon(color: context.colors.accentDefault),
                text: ContentRowTextOptions(
                  title: phone,
                  titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
                ),
              ),
            ),
        ],
      );
    }

    // Original logic for more than 3 groups
    if (phones.length == 1) {
      return ContentRow(
        supportTitleRTL: false,
        text: ContentRowTextOptions(
          title: phones.first,
          titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
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
        titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
      ),
      trailing: Text(
        '${phones.length}',
        style: context.textStyles.bodySmallSemiBold.copyWith(color: context.colors.foregroundMuted),
      ),
      content: Column(
        children: [
          for (final phone in phones.sublist(1))
            GestureDetector(
              onLongPress: () async {
                await onCopyToClipboard(phone, toastText: context.l10n.phoneCopied);
              },
              child: ContentRow(
                onTap: () => onTap.call(phone),
                crossAxisAlignment: CrossAxisAlignment.center,
                leading: phoneIcon.icon(color: context.colors.accentDefault),
                text: ContentRowTextOptions(
                  title: phone,
                  titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
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
  final bool showFullWidth;

  const _EmailItemWidget({required this.emails, required this.onTap, this.showFullWidth = false});

  @override
  Widget build(BuildContext context) {
    if (emails.isEmpty) {
      assert(emails.isNotEmpty, 'Emails must not be empty');
      return const SizedBox.shrink();
    }

    // If showFullWidth is true, show all emails in separate rows
    if (showFullWidth) {
      return Column(
        children: [
          for (final email in emails)
            GestureDetector(
              onLongPress: () async {
                await onCopyToClipboard(email, toastText: context.l10n.emailHasBeenCopied);
              },
              child: ContentRow(
                onTap: () => onTap.call(email),
                supportTitleRTL: false,
                leading: GeneralIcons.web.icon(color: context.colors.accentDefault),
                text: ContentRowTextOptions(
                  title: email,
                  titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
                ),
              ),
            ),
        ],
      );
    }

    // Original logic for more than 3 groups
    if (emails.length == 1) {
      return ContentRow(
        supportTitleRTL: false,
        text: ContentRowTextOptions(
          title: emails.first,
          titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
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
        titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
      ),
      trailing: Text(
        '${emails.length}',
        style: context.textStyles.bodySmallSemiBold.copyWith(color: context.colors.foregroundMuted),
      ),
      content: Column(
        children: [
          for (final email in emails.sublist(1))
            GestureDetector(
              onLongPress: () async {
                await onCopyToClipboard(email, toastText: context.l10n.emailHasBeenCopied);
              },
              child: ContentRow(
                onTap: () => onTap.call(email),
                leading: GeneralIcons.web.icon(color: context.colors.accentDefault),
                text: ContentRowTextOptions(
                  title: email,
                  titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ignore: unused_element
class _SocialItemWidget extends StatelessWidget {
  final String socialLink;
  final IconData icon;
  final void Function(String link) onTap;

  const _SocialItemWidget({required this.socialLink, required this.onTap, required this.icon});

  @override
  Widget build(BuildContext context) {
    if (socialLink.isEmpty) {
      assert(socialLink.isNotEmpty, 'Social link must not be empty');
      return const SizedBox.shrink();
    }

    return ContentRow(
      supportTitleRTL: false,
      text: ContentRowTextOptions(
        title: socialLink,
        titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
      ),
      leading: Icon(icon, color: context.colors.accentDefault, size: Spacing.$6x),
      onTap: () => onTap.call(socialLink),
    );
  }
}

class _SocialMediaItemWidget extends StatelessWidget {
  final List<PoiContentSocialMediaModel> socialMediaList;
  final void Function(String link) onTap;
  final bool showFullWidth;

  const _SocialMediaItemWidget({required this.socialMediaList, required this.onTap, this.showFullWidth = false});

  @override
  Widget build(BuildContext context) {
    if (showFullWidth) {
      // Show each social media in a separate row
      return Column(
        children: [
          for (final socialMedia in socialMediaList)
            ContentRow(
              supportTitleRTL: false,
              leading: _SocialMediaItemWidget.getIconData(socialMedia.type).icon(color: context.colors.accentDefault),
              text: ContentRowTextOptions(
                title: _getDisplayText(socialMedia),
                titleOptions: ContentRowTextOption(baseColor: context.colors.foregroundDefault),
              ),
              onTap: () => onTap.call(socialMedia.link),
            ),
        ],
      );
    }

    // Original logic: show as icons in Wrap
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$3x),
      child: Wrap(
        spacing: Spacing.$2x,
        runSpacing: Spacing.$2x,
        children: socialMediaList
            .map(
              (e) => _SocialMediaIconWidget(
                icon: _SocialMediaItemWidget.getIconData(e.type),
                onTap: () => onTap.call(e.link),
              ),
            )
            .toList(),
      ),
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
    PoiContentSocialMediaTypes.twitter => SocialIcons.twitter,
    PoiContentSocialMediaTypes.tiktok => SocialIcons.twitter,
    // PoiContentSocialMediaTypes.tiktok => SocialIcons.tiktok,
  };

  String _getDisplayText(PoiContentSocialMediaModel socialMedia) {
    // For website, show domain from link or displayText
    if (socialMedia.type == PoiContentSocialMediaTypes.website) {
      final link = socialMedia.link;
      if (link.isNotEmpty) {
        try {
          final uri = Uri.parse(link);
          final host = uri.host;
          if (host.isNotEmpty) {
            return host;
          }
        } catch (e) {
          // Ignore
        }
      }
      return socialMedia.displayText ?? (link.isNotEmpty ? link : 'Website');
    }

    // For social media, extract username
    String? username;

    // First, try to extract from displayText
    if (socialMedia.displayText != null && socialMedia.displayText!.isNotEmpty) {
      final displayText = socialMedia.displayText!;

      // If displayText is already a username (starts with @ or doesn't contain http)
      if (displayText.startsWith('@')) {
        return displayText;
      }

      // If displayText contains URL, try to extract username from it
      if (displayText.contains('http://') || displayText.contains('https://')) {
        username = _extractUsernameFromUrl(displayText);
      } else {
        // It's already a username without @
        return '@$displayText';
      }
    }

    // If no username from displayText, extract from link
    if (username == null || username.isEmpty) {
      final link = socialMedia.link;
      if (link.isNotEmpty) {
        username = _extractUsernameFromUrl(link);
      }
    }

    // Return username with @ prefix or fallback
    if (username != null && username.isNotEmpty) {
      return username.startsWith('@') ? username : '@$username';
    }

    // Fallback to social media name
    return _getSocialMediaName(socialMedia.type);
  }

  String? _extractUsernameFromUrl(String url) {
    try {
      // Remove @ prefix if present at the start
      final cleanUrl = url.startsWith('@') ? url.substring(1) : url;
      final uri = Uri.parse(cleanUrl);
      final pathSegments = uri.pathSegments;

      if (pathSegments.isNotEmpty) {
        // Get the last non-empty segment
        for (int i = pathSegments.length - 1; i >= 0; i--) {
          final segment = pathSegments[i];
          if (segment.isNotEmpty && segment != '/') {
            // Remove query parameters and fragments
            final cleanSegment = segment.split('?').first.split('#').first;
            if (cleanSegment.isNotEmpty) {
              return cleanSegment;
            }
          }
        }
      }

      // For Facebook, sometimes username is in the path like /pages/... or /profile.php?id=...
      // Try to get the first meaningful segment after domain
      if (pathSegments.isNotEmpty) {
        final firstSegment = pathSegments.first;
        if (firstSegment.isNotEmpty &&
            firstSegment != 'pages' &&
            firstSegment != 'profile.php' &&
            firstSegment != 'people') {
          return firstSegment;
        }
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  String _getSocialMediaName(PoiContentSocialMediaTypes type) => switch (type) {
    PoiContentSocialMediaTypes.website => 'Website',
    PoiContentSocialMediaTypes.instagram => 'Instagram',
    PoiContentSocialMediaTypes.facebook => 'Facebook',
    PoiContentSocialMediaTypes.youtube => 'YouTube',
    PoiContentSocialMediaTypes.linkedin => 'LinkedIn',
    PoiContentSocialMediaTypes.whatsapp => 'WhatsApp',
    PoiContentSocialMediaTypes.telegram => 'Telegram',
    PoiContentSocialMediaTypes.twitter => 'X',
    PoiContentSocialMediaTypes.tiktok => 'TikTok',
  };
}

class _SocialMediaIconWidget extends StatelessWidget {
  final IconData icon;
  final void Function() onTap;

  const _SocialMediaIconWidget({required this.icon, required this.onTap});

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
