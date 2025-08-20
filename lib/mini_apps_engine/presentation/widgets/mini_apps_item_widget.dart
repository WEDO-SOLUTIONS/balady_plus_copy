import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/need_login_dialog.dart';
import 'package:balady_plus/mini_apps_engine/data/models/mini_app_model.dart';
import 'package:balady_plus/mini_apps_engine/helper/app_launch_service.dart';
import 'package:balady_plus/mini_apps_engine/presentation/widgets/network_icon_based_type_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class MiniAppsItemWidget extends StatelessWidget {
  final MiniAppModel miniApp;

  const MiniAppsItemWidget({
    super.key,
    required this.miniApp,
  });

  @override
  Widget build(BuildContext context) {
    return miniApp.serviceKey == "smartadvisor"
        ? const SizedBox()
        : InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _handleTap(context),
            child: Card(
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 24, horizontal: 18),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: ImageIconBasedTypeWidget(
                          icon: miniApp.logoKey!,
                          type: miniApp.cdnLogoRef?.split(".").last,
                          iconSize: 55,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              miniApp.serviceName ?? '',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontFamily:
                                        'packages/balady_uikit/Frutiger',
                                  ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              miniApp.description?.isNotEmpty == true
                                  ? miniApp.description!
                                  : '',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                    color: Colors.grey[600],
                                    fontFamily:
                                        'packages/balady_uikit/Frutiger',
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
            ),
          );
  }

  void _handleTap(BuildContext context) async {
    if (miniApp.latestVersion?.nafathLogin == true &&
        !CommonProperties.isLoggedInMunicipality) {
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
    } else if (miniApp.latestVersion?.otpLogin == true) {
      CommonFunctions.onLogin();
    } else {
      if (miniApp.latestVersion?.deepLinkModel != null) {
        try {
          await AppLaunchService.launchApp(
            deepLinkInfo: miniApp.latestVersion!.deepLinkModel!,
            //deepLink: deeplink,
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('launch_failed'.tr())),
          );
          debugPrint('Error launching app: $e');
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
