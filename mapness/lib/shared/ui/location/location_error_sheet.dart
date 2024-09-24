import 'dart:async';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/sheets/error_sheet_v2.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

class LocationErrorSheet extends ConsumerStatefulWidget {
  final String? routeOnClose;

  const LocationErrorSheet({super.key, this.routeOnClose});

  @override
  ConsumerState<LocationErrorSheet> createState() => _LocationErrorSheetState();
}

class _LocationErrorSheetState extends ConsumerState<LocationErrorSheet> with WidgetsBindingObserver {
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
      context.pop(result);
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Positioned.fill(
            child: Container(
              color: Colors.black54,
            ),
          ),
          Positioned.fill(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ErrorSheetV2(
                onClose: widget.routeOnClose != null
                    ? () {
                        ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
                        CommonFunctions.locationDialogShowed = false;
                        context.go(widget.routeOnClose!);
                      }
                    : () => context.pop(),
                errorTitle: context.l10n.locationDialogErrorTitle,
                errorContent: context.l10n.locationDialogErrorContent,
                buttonLabel: context.l10n.locationDialogButtonLabel,
                assetImage: 'assets/images_svg/lost_location.svg',
                package: PackageConfig.packageName,
                onRetry: () async {
                  final permissionStatus = await perm.Permission.location.status;
                  final serviceStatus = await perm.Permission.location.serviceStatus;

                  if (permissionStatus.isPermanentlyDenied) {
                    ///Here we check our app has location permission and if doesn't - go to appSettings
                    await perm.openAppSettings();
                  } else if (!permissionStatus.isGranted) {
                    await perm.Permission.location.request();
                  } else if (serviceStatus == perm.ServiceStatus.disabled) {
                    ///Here we check is location on or off on device and if off - go to locationSettings
                    await Geolocator.openLocationSettings();
                  }
                },
              ),
            ),
          ),
        ],
      );
}
