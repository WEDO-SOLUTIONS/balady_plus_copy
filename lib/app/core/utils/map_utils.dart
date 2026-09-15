import 'package:flutter/services.dart';

import 'dart:ui' as ui;

class MapUtils {
  // static BitmapDescriptor? locationMarker;
  // static BitmapDescriptor? userLocationMarker;
  // static BitmapDescriptor? pinMarkerDarkGreen;
  // static BitmapDescriptor? pinMarkerLightGreen;
  // static BitmapDescriptor? mapIconMarker;

  static double slaughterRadius = 40000;

  // static void loadMarkers() async {
  //   try {
  //     BitmapDescriptor.fromAssetImage(
  //             const ImageConfiguration(size: Size(28, 28)),
  //             Constants.mapMarkerLocation)
  //         .then((onValue) {
  //       locationMarker = onValue;
  //     });
  //     BitmapDescriptor.fromAssetImage(
  //             const ImageConfiguration(size: Size(28, 28)),
  //             Constants.userMarkerLocation)
  //         .then((onValue) {
  //       userLocationMarker = onValue;
  //     });
  //
  //     final Uint8List? pinMarkerDarkGreenIcon =
  //         await getBytesFromAsset(Constants.pinDarkGreenMarkerLocation, 70);
  //
  //     pinMarkerDarkGreen = BitmapDescriptor.fromBytes(pinMarkerDarkGreenIcon!);
  //
  //     final Uint8List? pinMarkerLightGreenIcon =
  //         await getBytesFromAsset(Constants.pinLightGreenMarkerLocation, 70);
  //
  //     pinMarkerLightGreen =
  //         BitmapDescriptor.fromBytes(pinMarkerLightGreenIcon!);
  //
  //     mapIconMarker = BitmapDescriptor.fromBytes(pinMarkerDarkGreenIcon!);
  //   } catch (error, stackTrace) {
  //   LogsViewModel().sendEventFromModel(
  //     event: ErrorExceptionModel(
  //       nameEvent: EventsName.handledException,
  //       message: error.toString(),
  //       stackTrace: stackTrace.toString(),
  //     ),
  //   );
  // }
  // }

  static Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }
}
