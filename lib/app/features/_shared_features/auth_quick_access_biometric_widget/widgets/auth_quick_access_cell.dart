import 'package:balady_authorization/auth_package.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_authorization/src/shared/authentication_routes/authentication_route_names.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/app_config.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AuthQuickAccessCell extends StatelessWidget {
  final bool isQuickAccess;

  const AuthQuickAccessCell({super.key, required this.isQuickAccess});

  @override
  Widget build(BuildContext context) {
    AuthenticatedState state =
        context.read<AuthenticationBloc>().state as AuthenticatedState;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: InkWell(
            onTap: () {
              NavigationService.pushNamed(
                routeName: AuthenticationRouteName.registerPassCodeStep1Screen,
                args: LoginDataModel.fromJson(state.loginData.toJson()),
              );
            },
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 48,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "packages/balady_authorization/assets/svg/passcode.svg",
                      height: 24,
                      width: 24,
                      colorFilter: ColorFilter.mode(
                       context.colors.accentActive,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Text(
                        'quick_access'.tr(),
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              color: context.colors.foregroundDefault,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              fontFamily: AppConfig.appFontType,
                              // height: 24,
                            ),
                      ),
                    ),
                    const Spacer(),
                    IgnorePointer(
                      child: CupertinoSwitch(
                        onChanged: (bool value) {},
                        value: isQuickAccess,
                        activeTrackColor: context.colors.accentActive,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
