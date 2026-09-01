import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/helper/app_launch_service.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/widgets/network_icon_based_type_widget.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';


class MiniAppsItemWidget extends StatelessWidget {
  final MiniAppModel miniApp;
  final bool isEvent;

  const MiniAppsItemWidget({super.key, required this.miniApp, required this.isEvent});

  @override
  Widget build(BuildContext context) {
    return miniApp.serviceKey == "smartadvisor"
        ? const SizedBox()
        : InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleTap(context),
            child: Card(
              color: context.colors.backgroundSurface1,
              elevation: 0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: ImageIconBasedTypeWidget(
                        icon: miniApp.logoKey!,
                        type: miniApp.cdnLogoRef?.split(".").last,
                        cdnLogoRef: miniApp.cdnLogoRef,
                        iconSize: 40,
                        iconColor: isEvent ? AppColor.primary900LightEvent : AppColor.primary900Light,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      miniApp.serviceName ?? '',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 17,
                        fontFamily: 'packages/balady_design_system/IBMPlexSansArabic',
                        color: context.colors.foregroundDefault,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      miniApp.description?.isNotEmpty == true ? miniApp.description! : '',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                        fontSize: 13,
                        fontFamily: 'packages/balady_design_system/IBMPlexSansArabic',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
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
              NavigationService.pushNamed(routeName: RouteName.miniAppsMainScreen, args: miniApp);
            }
          },
        ),
      );
    } else if (miniApp.latestVersion?.otpLogin == true && miniApp.latestVersion?.deepLinkModel == null) {
      CommonFunctions.onLogin();
    } else {
      if (miniApp.serviceKey == "volunteerapp") {
        context.read<NewMiniAppLogicCubit>().openMiniAppByServiceKey(
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
          NavigationService.pushNamed(routeName: RouteName.miniAppsMainScreen, args: miniApp);
        }
      }
    }
  }
}
