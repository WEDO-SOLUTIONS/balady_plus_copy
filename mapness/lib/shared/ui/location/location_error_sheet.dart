import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/sheets/error_sheet_v2.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:permission_handler/permission_handler.dart' as perm;
import 'package:provider/provider.dart';

@RoutePage()
class LocationErrorSheetPage extends ConsumerStatefulWidget {
  final String? routeOnClose;

  const LocationErrorSheetPage({super.key, this.routeOnClose});

  @override
  ConsumerState<LocationErrorSheetPage> createState() => _LocationErrorSheetState();
}

class _LocationErrorSheetState extends ConsumerState<LocationErrorSheetPage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _checkPermissionGranted();
    }

    super.didChangeAppLifecycleState(state);
  }

  Future<void> _checkPermissionGranted() async {
    final result = await ref.read(locationProvider.notifier).checkOnLocationPermissionGranted();

    if (result && mounted) {
      if (context.router.stack.length != 1) {
        context.router.pop(result);
      } else {
        detach(context.router.navigate(const BottomMenuRoute()), tag: 'locationErrorSheet.navigate');
        CommonFunctions.locationDialogShowed = false;
      }
    }
  }

  String asset(BuildContext context) => switch (context.read<ThemeController>().currentTheme) {
    BaladyAppThemes.darkDGA => Assets.imagesSvg.lostLocationDark.keyName,
    BaladyAppThemes.saudiDay => Assets.imagesSvg.lostLocation.keyName,
    _ => Assets.imagesSvg.lostLocation.keyName,
  };

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(child: Container(color: Colors.black54)),
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ErrorSheetV2(
            onClose: () async {
              switch (widget.routeOnClose) {
                case != null:
                  {
                    await ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
                    CommonFunctions.locationDialogShowed = false;
                    context.router.pop(widget.routeOnClose);
                  }
                default:
                  {
                    if (context.router.stack.length != 1) {
                      context.router.pop();
                    } else {
                      await context.router.navigate(const BottomMenuRoute());
                      CommonFunctions.locationDialogShowed = false;
                    }
                  }
              }
            },
            errorTitle: context.l10n.locationDialogErrorTitle,
            errorContent: context.l10n.locationDialogErrorContent,
            buttonLabel: context.l10n.locationDialogButtonLabel,
            assetImage: asset(context),
            onRetry: () async {
              final permissionStatus = await perm.Permission.location.status;
              final serviceStatus = await perm.Permission.location.serviceStatus;

              ///On android, you can turn off GPS, but on ios, you can only restrict the application's access to GPS
              /// So here we firstly check - Has app permissions? And if it doesn't - we redirect user to app settings
              /// On android, if user turn off a gps service - we redirect him to service settings page

              if (permissionStatus.isPermanentlyDenied || permissionStatus.isDenied) {
                await perm.openAppSettings();
              } else if (!permissionStatus.isGranted) {
                await perm.Permission.location.request();
              } else if (serviceStatus == perm.ServiceStatus.disabled) {
                await Geolocator.openLocationSettings();
              }
            },
          ),
        ),
      ),
    ],
  );
}
