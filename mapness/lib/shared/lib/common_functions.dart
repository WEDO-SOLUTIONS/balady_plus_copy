import 'dart:async';
import 'dart:math';

import 'package:dgis_map/library.dart' show VisibleRect;
import 'package:geobase/geobase.dart' as gb;
import 'package:url_launcher/url_launcher.dart';

class CommonFunctions {
  static Future<void> externalLaunch(String url) async {
    final convertUrl = Uri.parse(url);
    if (!await launchUrl(convertUrl, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $convertUrl');
    }
  }

  static Future<void> launch(String url) async {
    final convertUrl = Uri.parse(url);
    if (!await launchUrl(convertUrl)) {
      throw Exception('Could not launch $convertUrl');
    }
  }

  static Future<void> call(String? number) async {
    if (number != null && number.isNotEmpty) {
      await CommonFunctions.launch('tel:$number');
    }
  }

  static Future<void> email(String? mail) async {
    if (mail != null && mail.isNotEmpty) {
      await CommonFunctions.launch('mailto:$mail');
    }
  }

  static double distance(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371; // km
    const p = pi / 180;

    final a = 0.5 - cos((lat2 - lat1) * p) / 2 + cos(lat1 * p) * cos(lat2 * p) * (1 - cos((lon2 - lon1) * p)) / 2;

    return 2 * r * asin(sqrt(a));
  }

  static double convertDegreesToRadiansAndShift(double degree) => pi * degree / 180 - 0.5 * pi;

  static gb.Polygon getPolygonFromRect(VisibleRect rect) {
    final box = gb.Box.create(
      minX: rect.southWestLon,
      minY: rect.southWestLat,
      maxX: rect.northEastLon,
      maxY: rect.northEastLat,
    );

    final corners = box.corners2D.toList();
    final positions = [...corners, corners[0]].map((e) => gb.Position.create(x: e.x, y: e.y)).toList();

    final polygon = gb.Polygon.from(
      [positions],
      bounds: box,
    );

    return polygon;
  }
}

bool setsEqual<T>(Set<T> set1, Set<T> set2) => set1.length == set2.length && set1.containsAll(set2);
