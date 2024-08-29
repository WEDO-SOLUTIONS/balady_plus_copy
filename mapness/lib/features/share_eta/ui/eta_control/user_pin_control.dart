import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/features/share_eta/models/eta_route_info.dart';
import 'package:mapness/features/share_eta/providers/websocker_error_handler_porvider.dart';
import 'package:mapness/shared/config/package_config.dart';

class UserPinControl extends ConsumerWidget {
  final User? user;

  static const String _unauthorizedUser = 'assets/images_svg/eta_unknown_user.svg';
  static const String _authorizedUser = 'assets/images_svg/eta_named_user.svg';
  static const String _userWithPhoto = 'assets/images_svg/eta_photo_user.svg';

  const UserPinControl({super.key, this.user});

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context, WidgetRef ref) {
    final (code, _) = ref.watch(websocketErrorHandlerProvider);

    return ClipOval(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          // Added black and white filter for unactive connection
          code == null ? Colors.transparent : Colors.grey,
          BlendMode.saturation,
        ),
        child: Stack(
          children: [
            SvgPicture.asset(
              _getUserIcon(),
              width: 32,
              height: 32,
              package: PackageConfig.packageName,
            ),
            // draw user photo if user has one
            if (user?.photoUrl != null)
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: Center(
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: ClipOval(
                      child: Image.network(
                        user!.photoUrl!,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              )
            // draw user initials if user has no photo
            else if (user?.firstName != null && user?.lastName != null)
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
                child: Center(
                  child: SizedBox(
                    height: 18.0,
                    child: Text('${user!.firstName!.characters.first}${user!.lastName!.characters.first}',
                        textAlign: TextAlign.center,
                        style: context.textStyleV3.bodySmallSemiBold.copyWith(
                          color: Colors.white,
                          fontSize: 10,
                        )),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getUserIcon() {
    if (user == null) {
      return _unauthorizedUser;
    }

    if (user!.firstName != null && user!.lastName != null) {
      return _authorizedUser;
    }

    if (user!.photoUrl != null) {
      return _userWithPhoto;
    }

    return _unauthorizedUser;
  }
}
