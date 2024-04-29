import 'package:balady_plus/app/features/entry_point/entry_point_exports.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/_features/profile/providers/profile_image_provider.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/profile.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/widgets/profile/profile_image_widget.dart';
import 'package:mapness/widgets/profile/profile_menu.dart';

class AuthorizedWidget extends ConsumerWidget {
  const AuthorizedWidget({super.key, required this.userData});

  final SsoUserInfo userData;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Material(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        color: Colors.transparent,
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final textDirection = Directionality.of(context);
                /// top position of the profile image
                /// all "magic" numbers are calculated based on the design
                /// was found by selecting options
                final topPosition = constraints.maxWidth / 30;
                final isLTR = textDirection == TextDirection.ltr;
                final leftRightPosition = constraints.maxWidth / 30;
                final dimension = constraints.maxWidth / 3.5;
                return Stack(
                  fit: StackFit.passthrough,
                  children: [
                    Directionality(
                      textDirection: isLTR ? TextDirection.rtl : TextDirection.ltr,
                      child: SvgPicture.asset(
                        'assets/images_svg/profile_header_bg.svg',
                        matchTextDirection: true,
                        package: PackageConfig.packageName,
                        width: constraints.maxWidth,
                        color: context.color.surfaceBaseSecondary,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                    Positioned(
                      top: topPosition,
                      left: isLTR ? leftRightPosition : null,
                      right: isLTR ? null : leftRightPosition,
                      child: ProfileImageWidget(
                        dimension: dimension,
                      ),
                    ),
                    Positioned(
                      right: isLTR ? 0 : null,
                      left: isLTR ? null : 0,
                      child: Center(
                        child: ProfileMenu(
                          onTapLogout: () async {
                            await ref.read(authProvider.notifier).logOut();
                            context.pop();
                          },
                          onTapChangeAvatar: () async {
                            final picker = ImagePicker();
                            final image = await picker.pickImage(source: ImageSource.gallery);
                            if (image == null) {
                              return;
                            }
                            final bytes = await image.readAsBytes();
                            final Uint8List? croppedBytes = await ref.read(goRouterProvider).push(
                                  const ImageEditorRoute().location,
                                  extra: bytes,
                                );
                            if (croppedBytes != null) {
                              await ref.read(profileImageProvider.notifier).changeUserProfileImageByBytes(croppedBytes);
                            }
                          },
                          onTapInfo: () => const ProfileInfoPageRoute().push(context),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: isLTR ? 0 : null,
                      right: isLTR ? null : 0,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          userData.getFirstAndLastName(),
                          style: context.textStyle.heading1.copyWith(color: context.color.textAndIconsBasePrimary),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
}
