import 'package:collection/collection.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/poi_card/enums/contacts_info_type.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/shared/lib/deeplink_functionds.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class PoiCardViewModel {
  PoiCardViewModel({
    required this.ref,
  });
  final WidgetRef ref;

  void onError() => Future(() =>
      ref.read(mapControlsProvider.notifier).update(MapControlsStateIdle()));

  Future<void> onEntranceTap(DirectoryObjectMessage? objectMessage) async {
    final controller = await ref.read(dgisControllerProvider.future);
    if (objectMessage != null) {
      final list =
          objectMessage.entrances.map((e) => e?.id).whereNotNull().toList();
      await controller.setHighlighted(list);
    }
  }

  void share({required int? objectId, LatLng? markerCoords}) {
    final baseUri = BaldayDeeplink.basePoiUri;
    final query = <String, String>{};
    if (objectId != null) {
      query[BaldayDeeplink.dgisObjectIdKey] = objectId.toString();

      if (markerCoords != null) {
        query[BaldayDeeplink.latitudeKey] = markerCoords.latitude.toString();
        query[BaldayDeeplink.longitudeKey] = markerCoords.longitude.toString();
      }

      Share.share(BaldayDeeplink.urlWithQuery(baseUri, query));
    } else {
      onError();
    }
  }

  String _myLocationDeeplink(LatLng location) => BaldayDeeplink.urlWithQuery(
        BaldayDeeplink.basePoiUri,
        {
          BaldayDeeplink.latitudeKey: location.latitude.toString(),
          BaldayDeeplink.longitudeKey: location.longitude.toString(),
          BaldayDeeplink.typeKey: BaldayDeeplink.typeValueMyLocation,
        },
      );

  void shareMyLocation(LatLng? location) {
    if (location != null) {
      Share.share(_myLocationDeeplink(location));
    } else {
      onError();
    }
  }

  Future<void> copyToClipboard(LatLng? location) async {
    if (location != null) {
      await Clipboard.setData(
        ClipboardData(text: _myLocationDeeplink(location)),
      );
    }
  }

  RoutingRoutesRoute goRoute({
    required String finishLabel,
    required String startLabel,
    required LatLng finishLocation,
    LatLng? startLocation,
  }) =>
      RoutingRoutesRoute(
        finishLabel: finishLabel,
        finishLatitude: finishLocation.latitude,
        finishLongitude: finishLocation.longitude,
        startLabel: startLabel,
        startLatitude: startLocation?.latitude,
        startLongitude: startLocation?.longitude,
        startObjectId: null,
        startEntranceId: null,
        startLevelId: null,
        finishEntranceId: null,
        finishLevelId: null,
        finishObjectId: null,
      );

  Future<void> sendEmail(String value) async {
    await launchUrl(
      Uri(
        scheme: 'mailto',
        path: value,
        queryParameters: {'subject': ''},
      ),
    );
  }

  Future<void> launch(String value) async {
    final url = Uri.parse(value);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    }
  }

  Future<void> callPhone({
    DirectoryObjectMessage? data,
  }) async {
    final phoneNumber = data?.getContactsInfoModels().firstWhereOrNull(
          (element) => element.type == ContactsInfoType.phone,
        );
    final value = phoneNumber?.value;
    if (value != null) {
      await launchUrl(Uri(scheme: 'tel', path: value));
    }
  }

  void resetMapControlsState() {
    ref.read(mapControlsProvider.notifier).update(
          MapControlsStateIdle(),
        );
  }
}
