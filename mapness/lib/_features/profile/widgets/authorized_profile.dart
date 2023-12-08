import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:mapness/features/sso_auth/domain/entity/sso_user_info_model.dart';

import 'profile_image_widget.dart';

class AuthorizedProfile extends StatelessWidget {
  const AuthorizedProfile({
    super.key,
    required this.userData,
  });

  final SsoUserInfoModel userData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const ProfileImageWidget(
            editable: true,
            dimension: 96,
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            userData.getFirstAndLastName(),
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .headingS
                .copyWith(color: const Color(0xFF1E2A36)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
