import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/_features/profile/widgets/contact_info.dart';
import 'package:mapness/_features/profile/widgets/expandable_cell.dart';
import 'package:mapness/app/routes/profile.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class HelpCenterPage extends ConsumerWidget {
  const HelpCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final direction = ref.watch(uiDirectionProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Material(
          color: Colors.white,
          child: ListView(
            children: [
              const SizedBox(
                width: 12,
              ),
              SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 40,
                        width: 40,
                        child: Material(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFFF5F7FA),
                          child: InkWell(
                            onTap: () {
                              context.pop();
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Padding(
                              padding: const EdgeInsets.all(8),
                              child: SvgPicture.asset(
                                direction == TextDirection.ltr
                                    ? 'assets/icons/svg/ic_chevron_left.svg'
                                    : 'assets/icons/svg/ic_chevron_right.svg',
                                height: 24,
                                width: 24,
                                package: PackageConfig.packageName,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF1E2A36),
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        context.l10n.helpCenter,
                        style: Theme.of(context)
                            .extension<ThemeTextStyles>()!
                            .accentM
                            .copyWith(color: const Color(0xFF1E2A36)),
                      ),
                      const Spacer(),
                      const SizedBox(
                        width: 40,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SizedBox(
                  height: 52,
                  child: Material(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color(0xFFF5F7FA),
                    child: InkWell(
                      onTap: () {
                        const MomraWebsitePageRoute().push(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 16.0,
                            ),
                            SvgPicture.asset(
                              'assets/images_svg/help_website.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E928F),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 12.0,
                            ),
                            Text(
                              context.l10n.baladyWebsite,
                              style: Theme.of(context)
                                  .extension<ThemeTextStyles>()!
                                  .textM
                                  .copyWith(color: const Color(0xFF1E2A36)),
                            ),
                            const Spacer(),
                            SvgPicture.asset(
                              direction == TextDirection.ltr
                                  ? 'assets/icons/svg/ic_chevron_right.svg'
                                  : 'assets/icons/svg/ic_chevron_left.svg',
                              height: 24,
                              width: 24,
                              package: PackageConfig.packageName,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF1E2A36),
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(
                              width: 16.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              ExpandableCell(
                title: context.l10n.contactInformation,
                icon: "assets/images_svg/help_contact.svg",
                content: const ContactInfo(),
              ),

              /// text for "balady portal is developed..."
              // const SizedBox(
              //   height: 8,
              // ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //   child: Row(
              //     children: [
              //       Expanded(
              //         child: Text(
              //           context.l10n.weAreHappyToConnectYouWithBaladyTeam,
              //           textDirection: direction,
              //           style: Theme.of(context)
              //               .extension<ThemeTextStyles>()!
              //               .textXS
              //               .copyWith(
              //                   color:
              //                       const Color(0xFF1E2A36).withOpacity(0.36)),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
