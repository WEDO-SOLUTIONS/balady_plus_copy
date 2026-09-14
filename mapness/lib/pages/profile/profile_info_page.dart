import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/features/entry_point/domain/entities/sso_user_info.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/entities/profile/user_profile_data.dart';
import 'package:mapness/features/sso_auth/data/auth_provider.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/utils/logger/logger.dart';
import 'package:mapness/widgets/profile/personal_data.dart';
import 'package:mapness/widgets/profile/profile_account_service.dart';
import 'package:provider/provider.dart';

@RoutePage()
class ProfileInfoPage extends ConsumerStatefulWidget {
  const ProfileInfoPage({super.key});

  @override
  ConsumerState<ProfileInfoPage> createState() => _ProfileInfoPageState();
}

class _ProfileInfoPageState extends ConsumerState<ProfileInfoPage> {
  SsoUserInfo? _userInfo;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfoFromApi();
  }

  Future<void> _loadUserInfoFromApi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final service = ProfileAccountService();
      final userInfoJson = await service.getUserInfo();
      // `/api/user/userinfo` does NOT carry `complete_profile` — preserve the
      // value already captured at login (from `MobileLoginVerifyOtp`) so we
      // don't accidentally re-enable editing for SSO-backed OTP users.
      final existing = ref.read(authProvider).value;
      final freshParsed = SsoUserInfo.fromJson(userInfoJson);
      // `/api/user/userinfo` may omit a previously-saved but still-unverified
      // email. Fall back to the address captured at login (kept in the auth
      // provider) so it shows immediately without the user having to edit it.
      final freshHasEmail = freshParsed.mail?.trim().isNotEmpty ?? false;
      final freshUserInfo = freshParsed.copyWith(
        completeProfile: existing?.completeProfile,
        loginType: existing?.loginType,
        isEmailEditable: existing?.isEmailEditable,
        isSSOLocked: existing?.isSSOLocked,
        mail: freshHasEmail ? freshParsed.mail : existing?.mail,
        isEmailVerified: freshHasEmail ? freshParsed.isEmailVerified : (existing?.isEmailVerified ?? false),
      );

      setState(() {
        _userInfo = freshUserInfo;
        _isLoading = false;
      });

      // تحديث الـ provider أيضاً
      await ref.read(authProvider.notifier).forceUpdate();
    } catch (e) {
      logger.log('Error loading user info from API: $e', logLevel: MapnessLogLevel.error);
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = _userInfo ?? ref.watch(authProvider).value;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: context.read<ThemeController>().systemOverlayStyle,
      child: SafeArea(
        top: false,
        bottom: false,
        child: Material(
          color: context.colors.backgroundSurface4,
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x),
            child: Scaffold(
              appBar: BaladyTopBar.iconAndText(
                systemUiOverlayStyle: context.read<ThemeController>().systemOverlayStyle,
                title: context.l10n.profileInfo,
                colorEnabled: context.colors.accentDefault,
                leading: ActionModel(
                  onPressed: () => context.router.pop(),
                  icon: SystemIcons.arrowCornerLeftLarge,
                ),
              ),
              body: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              if (userData != null) PersonalData(userInfo: userData),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
