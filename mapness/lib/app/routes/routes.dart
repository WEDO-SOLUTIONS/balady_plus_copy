import 'package:flutter/widgets.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/app/routes/happines_map.dart';
import 'package:mapness/app/routes/home_shell.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/app/routes/kiblah.dart';
import 'package:mapness/app/routes/path_nav.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/app/routes/weather.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final $appRoutes = [
  ...$homeRoutes,
  ...$searchRoutes,
  ...$kiblahRoutes,
  ...$favouritesRoutes,
  ...$poiMapRoutes,
  ...$iwishRoutes,
  ...$happinesMapRoutes,
  ...$pathNavRoutes,
  ...$routingRoutes,
  ...$weatherRoutes,
];
