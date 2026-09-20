import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/path_nav/providers/path_nav_message.dart';
import 'package:mapness/features/routing/providers/current_route.dart';
import 'package:mapness/features/share_eta/providers/eta_geo_subscriber.dart';
import 'package:mapness/features/share_eta/providers/eta_stream_storage.dart';
import 'package:mapness/features/share_eta/providers/share_eta_provider.dart';
import 'package:mapness/features/share_eta/ui/eta_share_expired.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:mapness/shared/utils/logger/logger.dart';

class EtaUtils {
  static const _expiredSheetRouteName = 'eta_share_expired';

  static ModalRoute<void>? _expiredSheetRoute;

  static Future<img.Image> processImage(String imgUrl, int imgSize, {bool isUnavailable = false}) async {
    // Load the mask image from assets
    final maskData = await rootBundle.load(Assets.images.markerEtaMask.keyName);
    final maskBytes = maskData.buffer.asUint8List();

    final mask = img.decodeImage(maskBytes)!;

    var mask48x48 = img.copyResize(mask, width: imgSize, height: imgSize, interpolation: img.Interpolation.average);

    if (mask48x48.hasAlpha == false) {
      mask48x48 = mask48x48.convert(format: mask48x48.format, numChannels: 4);
    }

    // Load the image from the network
    final response = await http.get(Uri.parse(imgUrl));
    var networkImage = img.decodeImage(response.bodyBytes)!;
    if (networkImage.hasAlpha == false) {
      networkImage = networkImage.convert(format: networkImage.format, numChannels: 4);
    }

    if (isUnavailable) {
      networkImage = img.grayscale(networkImage);
    }

    networkImage = img.copyCropCircle(
      networkImage,
      centerX: networkImage.width ~/ 2,
      centerY: networkImage.height ~/ 2,
      radius: networkImage.width ~/ 2,
    );

    final img24x24 = img.copyResize(
      networkImage,
      width: imgSize ~/ 2,
      height: imgSize ~/ 2,
      interpolation: img.Interpolation.average,
    );

    final img48x48 = img.Image(width: imgSize, height: imgSize, numChannels: 4);

    img.compositeImage(img48x48, img24x24, center: true, maskChannel: img.Channel.alpha);
    img.compositeImage(mask48x48, img48x48, dstX: 0, dstY: 0, maskChannel: img.Channel.alpha);

    return mask48x48;
  }

  static Future<bool> processShareLink(
    WidgetRef ref, {
    required String tokenId,
    required String streamId,
    String? type,
    double? latitude,
    double? longitude,
  }) async {
    if (type == 'eta' || type == 'live') {
      dismissExpiredSheet();
    }

    final Completer<Position?> completer = Completer();
    ProviderSubscription? _locationListener;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final location = ref.read(locationProvider);
      if (location != null) {
        completer.complete(location);
      } else {
        _locationListener = ref.listenManual<Position?>(locationProvider, (_, next) {
          if (next != null) {
            _locationListener?.close();
            completer.complete(next);
          }
        });
      }
    });

    try {
      Future.delayed(const Duration(seconds: 10), () {
        if (!completer.isCompleted) {
          completer.complete();
        }
      });
      // Wait for location to be available
      await completer.future;
    } catch (e) {
      logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
    } finally {
      _locationListener?.close();
    }

    if (type == 'eta') {
      try {
        if (latitude != null && longitude != null) {
          await ref
              .read(cameraPositionProvider.notifier)
              .animateTo(
                CameraPositionMessage(
                  point: GeoPointMessage(latitude: latitude, longitude: longitude),
                  zoom: 17,
                  tilt: 0,
                  bearing: 0,
                ),
              );
        }
        final storedTokenId = EtaStreamStorage().state.streamToken;
        if (tokenId == storedTokenId) {
          return true;
        }

        await ref.read(shareEtaProvider.notifier).stopSharing();

        await ref.read(etaGeoSubscriberProvider.notifier).startStreaming(streamId, tokenId);
        detach(
          ref.read(appRouterProvider).push(EtaRouteRoute(latitude: latitude, longitude: longitude)),
          tag: 'utils.push',
        );
      } catch (e) {
        logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showEtaExpired(rootNavigatorKey.currentContext!);
        });
      }
      return true;
    } else if (type == 'live') {
      try {
        // Move to landing page
        if (rootNavigatorKey.currentContext != null) {
          final appRouter = ref.read(appRouterProvider);

          /// Fix for BSA-1010 - if start route isn't landing, we need to close all pages and go to landing
          /// Because we need to close navigation, we need to stop navigation and hide routes
          if (appRouter.isRouteActive(PathNavRoute.name)) {
            ref.read(pathNavMessageProvider.notifier).stopNavigation();
            await ref.read(dgisControllerProvider).value?.setMapAttributeBool('navigatorOn', value: false);
            detach(ref.read(dgisControllerProvider).value?.stopNavigation(), tag: 'utils.stopNavigation');
            ref.read(currentRouteProvider.notifier).clearRoute();
            detach(ref.read(dgisControllerProvider).value?.hideRoutes(), tag: 'utils.hideRoutes');
          }

          await appRouter.navigate(const LandingRoute());
        }

        final storedTokenId = EtaStreamStorage().state.streamToken;
        if (tokenId == storedTokenId) {
          return true;
        }

        await ref.read(shareEtaProvider.notifier).stopSharing();

        if (latitude != null && longitude != null) {
          await ref
              .read(cameraPositionProvider.notifier)
              .animateTo(
                CameraPositionMessage(
                  point: GeoPointMessage(latitude: latitude, longitude: longitude),
                  zoom: 17,
                  tilt: 0,
                  bearing: 0,
                ),
              );
        }
        await ref.read(etaGeoSubscriberProvider.notifier).startStreaming(streamId, tokenId);
      } catch (e) {
        logger.log(e.toString(), logLevel: MapnessLogLevel.critical);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showLiveLocationExpired(rootNavigatorKey.currentContext!);
        });
      }
      return true;
    }

    return false;
  }

  static void showLiveLocationExpired(BuildContext context) {
    _showExpiredSheet(context, (_) => EtaShareExpired.liveLocation(context));
  }

  static void showEtaExpired(BuildContext context) {
    _showExpiredSheet(context, (_) => EtaShareExpired.eta(context));
  }

  static void showBroadcastExpired(BuildContext context) {
    _showExpiredSheet(context, (_) => EtaShareExpired.broadcastExpired(context));
  }

  /// Closes the "share expired" sheet if it is still on screen. Safe to call when nothing is shown.
  static void dismissExpiredSheet() {
    final route = _expiredSheetRoute;
    _expiredSheetRoute = null;
    if (route == null || !route.isActive) {
      return;
    }
    route.navigator?.removeRoute(route);
  }

  static void _showExpiredSheet(BuildContext context, WidgetBuilder builder) {
    dismissExpiredSheet();

    showModalBottomSheet<void>(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      routeSettings: const RouteSettings(name: _expiredSheetRouteName),
      builder: (sheetContext) {
        _expiredSheetRoute = ModalRoute.of<void>(sheetContext);
        return builder(sheetContext);
      },
    ).whenComplete(() {
      if (_expiredSheetRoute?.isActive != true) {
        _expiredSheetRoute = null;
      }
    });
  }
}
