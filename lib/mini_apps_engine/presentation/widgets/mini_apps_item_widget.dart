import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_config.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/presentation/widgets/network_icon_based_type_widget.dart';
import 'package:flutter/material.dart';

import '../../../app/core/utils/constants/remote_config.dart';
import '../../../super_app_js_bridge/camera/camera_page.dart';

class MiniAppsItemWidget extends StatelessWidget {
  final MiniAppModel miniApp;

  const MiniAppsItemWidget({
    super.key,
    required this.miniApp,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if(miniApp.latestVersion?.nafathLogin == true && !CommonProperties.isLoggedInMunicipality){
          showDialog(
            context: context,
            builder: (ctx) =>
                NeedLoginDialog(
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
        } else if(miniApp.latestVersion?.otpLogin == true){
          CommonFunctions.onLogin();
        } else{
          NavigationService.pushNamed(
            routeName: RouteName.miniAppsMainScreen,
            args: miniApp,
          );
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            crossAxisAlignment:
            CrossAxisAlignment.center,
            children: [
              ImageIconBasedTypeWidget(
                icon: miniApp.logoKey!,
                iconSize: 48,
              ),
              const SizedBox(height: 2),
              Text(
                miniApp.serviceName!,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily:
                  AppConfig.appFontType,
                ),
                textScaler: TextScaler.noScaling,
                textAlign: TextAlign.center,
                maxLines: 2,
                softWrap: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
