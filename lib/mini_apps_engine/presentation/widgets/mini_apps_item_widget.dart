import 'package:balady_plus/app/core/base/base_view.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/helper/app_launch_service.dart';
import 'package:balady_plus/mini_apps_engine/presentation/bloc/home_mini_apps_list_bloc/home_mini_apps_list_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/widgets/network_icon_based_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MiniAppsItemWidget extends StatelessWidget {

  final MiniAppModel miniApp;

  const MiniAppsItemWidget({
    super.key,
    required this.miniApp,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => _handleTap(context),
      child: Card(
        elevation: 0.5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: ImageIconBasedTypeWidget(
                    icon: miniApp.logoKey!,
                    type: miniApp.cdnLogoRef?.split(".").last,
                    iconSize: 40,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  miniApp.serviceName ?? '',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'packages/balady_uikit/Frutiger',
                    color: Color(0xFF003449)
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  miniApp.description?.isNotEmpty == true
                      ? miniApp.description!
                      : '',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                        fontFamily: 'packages/balady_uikit/Frutiger',

                      ),
                  textAlign:
                  TextAlign.center,
                ),
              ],
            )),
      ),
    );
  }

  void _handleTap(BuildContext context) async {
    if (miniApp.latestVersion?.nafathLogin == true &&
        !CommonProperties.isLoggedInMunicipality &&
        miniApp.latestVersion?.deepLinkModel == null) {
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
        miniApp.latestVersion?.deepLinkModel == null) {
      CommonFunctions.onLogin();
    } else {
      if (miniApp.serviceKey == "volunteerapp") {
        context.read<HomeMiniAppsListCubit>().openMiniApp(
              serviceKey: "municipalservice",
              path: "#Volunteer_Home_Screen",
            );
      } else {
        if (miniApp.latestVersion?.deepLinkModel != null) {
          try {
            await AppLaunchService.launchApp(
              deepLinkInfo: miniApp.latestVersion!.deepLinkModel!,
              //deepLink: deeplink,
            );
          } catch (e) {
            CommonFunctions.showError('launch_failed'.tr());
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
