import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/mini_apps_engine/helper/app_launch_service.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/data/models/new_mini_app_logic_response_model.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MiniAppsNavigationHelper {
  void handleTap(BuildContext context, MiniApp miniApp) async {
    if (miniApp.latestVersion?.nafathLogin == true &&
        !CommonProperties.isLoggedInMunicipality &&
        miniApp.latestVersion?.deepLinkDto == null) {
      showDialog(
        context: context,
        builder: (ctx) => NeedLoginDialog(
          onSuccessLogin: (bool? isSuccess) async {
            if (isSuccess ?? false) {
              NavigationService.pushNamed(
                routeName: RouteName.miniAppsMainScreen,
                args: miniApp,
              );
            }
          },
        ),
      );
    } else if (miniApp.latestVersion?.otpLogin == true &&
        miniApp.latestVersion?.deepLinkDto == null) {
      CommonFunctions.onLogin();
    } else {
      if (miniApp.latestVersion?.deepLinkDto != null) {
        try {
          await AppLaunchService.launchApp(
            deepLinkInfo: miniApp.latestVersion!.deepLinkDto!,
            //deepLink: deeplink,
          );
        } catch (e) {
          CommonFunctions.showError('launch_failed'.tr());
        }
      } else {
        if (miniApp.childDeepLinkUrl != null) {
          NewMiniAppLogicState state =
              context.read<NewMiniAppLogicCubit>().state;
          MiniApp? parentMAiniApp =
              state.parentMiniApp[miniApp.parentServiceKey];

          if (parentMAiniApp != null) {
            NavigationService.pushNamed(
              routeName: RouteName.miniAppsMainScreen,
              args: miniApp.copyWith(
                // get this from parent
                latestVersion: parentMAiniApp.latestVersion,
                serviceKey: miniApp.parentServiceKey,
                path: miniApp.childDeepLinkUrl,
              ),
            );
          } else {
            /// TODO : Show errors Not Fund The Parent Maini App
            CommonFunctions.showError(
                'Show errors Not Fund The Parent Maini App'.tr());
          }
        } else {
          NavigationService.pushNamed(
            routeName: RouteName.miniAppsMainScreen,
            args: miniApp,
          );
        }
      }
    }
  }
}
