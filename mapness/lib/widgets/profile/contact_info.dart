import 'dart:async';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/utils/copy_to_clipboard.dart';

const momrahEmail = 'infoCS@momah.gov.sa';
const momrahPoneNumber = '199040';
const momrahTwitter = r'Balady_saudi';

class ContactInfo extends StatefulWidget {
  final Color colorBegin;
  final Color colorEnd;

  const ContactInfo({
    required this.colorBegin,
    required this.colorEnd,
    super.key,
  });

  @override
  State<ContactInfo> createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Color?> _animation;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));

    _animation = TweenSequence<Color?>(
      <TweenSequenceItem<Color?>>[
        TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: widget.colorBegin,
            end: widget.colorEnd,
          ).chain(CurveTween(curve: Curves.fastEaseInToSlowEaseOut)),
          weight: 1.0,
        ),
        TweenSequenceItem<Color?>(
          tween: ColorTween(
            begin: widget.colorEnd,
            end: widget.colorBegin,
          ).chain(CurveTween(curve: Curves.ease)),
          weight: 1.0,
        ),
      ],
    ).animate(_animationController);

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (rootNavigatorKey.currentContext != null) {
      ScaffoldMessenger.of(rootNavigatorKey.currentContext!).hideCurrentSnackBar();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ContentWrapper(color: context.color.surfaceBaseSecondary, children: [
            ContentRowV2(
              onTap: () => CommonFunctions.launch('https://twitter.com/Balady_saudi'),
              leading: AppIcons(
                iconData: SocialIcons.twitter,
                color: context.color.textAndIconsStatusAccent,
              ),
              text: ContentRowTextOptions(
                // text hack for rtl @ symbol, it's not supported in flutter
                title: context.isLTR ? '@$momrahTwitter' : '$momrahTwitter@',
                subtitle: context.l10n.twitterAccount,
              ),
              trailing: const ContentRowTextTrailingOptions(
                icon: SystemIcons.arrowCornerRightLarge,
              ),
            ),
            ContentRowV2(
              leading: AppIcons(
                iconData: switch (Directionality.of(context)) {
                  TextDirection.ltr => GeneralIcons.phoneLTR,
                  TextDirection.rtl => GeneralIcons.phoneRTL,
                },
                color: context.color.textAndIconsStatusAccent,
              ),
              text: ContentRowTextOptions(
                title: momrahPoneNumber,
                subtitle: context.l10n.profileContactInformation,
              ),
              onTap: () => CommonFunctions.call(momrahPoneNumber),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) => ContentRowV2(
                onTap: () => CommonFunctions.email(momrahEmail),
                leading: AppIcons(
                  iconData: GeneralIcons.mail,
                  color: context.color.textAndIconsStatusAccent,
                ),
                text: ContentRowTextOptions(
                  title: momrahEmail,
                  subtitle: context.l10n.email,
                ),
                trailing: ContentRowTextTrailingOptions(
                  onPressed: _onCopyEmailTap,
                  icon: SystemIcons.copy,
                  iconColor: _animation.value,
                ),
              ),
            ),
          ]),
        ],
      );

  Future<void> _onCopyEmailTap() async {
    await onCopyToClipboard(
      momrahEmail,
      toastText: context.l10n.emailHasBeenCopied,
      afterCopy: () async {
        if (_animationController.status == AnimationStatus.completed) {
          unawaited(_animationController.reverse());
        } else {
          unawaited(_animationController.forward());
        }
      },
    );
  }
}
