import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';

const momrahEmail = 'infoCS@momah.gov.sa';
const momrahPoneNumber = '199040';
const momrahTwitter = r'Balady_CS';

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
    super.dispose();
    _animationController.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ContentWrapper(color: context.color.surfaceBaseSecondary, children: [
            ContentRow(
              options: ContentRowOptions(
                leadingIcon: AppIcons(
                  iconData: SocialIcons.twitter,
                  color: context.color.textAndIconsStatusAccent,
                ),
                actionWidget: ContentRowActionOptions(
                  actionIcon: context.isLTR
                      ? SystemIcons.arrowCornerRightLarge.icon(
                          color: context.color.textAndIconsBaseSecondary,
                        )
                      : SystemIcons.arrowCornerLeftLarge.icon(
                          color: context.color.textAndIconsBaseSecondary,
                        ),
                ),
                // text hack for rtl @ symbol, it's not supported in flutter
                title: context.isLTR ? '@$momrahTwitter' : '$momrahTwitter@',
                subtitle: context.l10n.twitterAccount,
              ),
              onTap: () => CommonFunctions.launch('https://twitter.com/Balady_CS'),
            ),
            ContentRow(
              options: ContentRowOptions(
                leadingIcon: AppIcons(
                  iconData: switch (Directionality.of(context)) {
                    TextDirection.ltr => GeneralIcons.phoneLTR,
                    TextDirection.rtl => GeneralIcons.phoneRTL,
                  },
                  color: context.color.textAndIconsStatusAccent,
                ),
                title: momrahPoneNumber,
                subtitle: context.l10n.profileContactInformation,
              ),
              onTap: () => CommonFunctions.call(momrahPoneNumber),
            ),
            AnimatedBuilder(
              animation: _animationController,
              builder: (_, __) => ContentRow(
                options: ContentRowOptions(
                  actionWidget: ContentRowActionOptions(
                      actionPressed: () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          ToastMessageFactory.toastWithIconAction(
                            onPressed: () {
                              ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            },
                            icon: SystemIcons.close,
                            text: context.l10n.emailHasBeenCopied,
                            context: context,
                          ),
                        );

                        if (_animationController.status == AnimationStatus.completed) {
                          await _animationController.reverse();
                        } else {
                          await _animationController.forward();
                        }
                        await Clipboard.setData(
                          const ClipboardData(text: momrahEmail),
                        );
                        // copied successfully
                      },
                      actionIcon: AppIcons(
                        iconData: SystemIcons.copy,
                        color: _animation.value,
                      )),
                  leadingIcon: AppIcons(
                    iconData: GeneralIcons.mail,
                    color: context.color.textAndIconsStatusAccent,
                  ),
                  title: momrahEmail,
                  subtitle: context.l10n.email,
                ),
                onTap: () => CommonFunctions.email(momrahEmail),
              ),
            ),
          ]),
        ],
      );
}
