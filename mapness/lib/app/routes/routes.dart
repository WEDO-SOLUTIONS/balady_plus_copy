import 'package:flutter/widgets.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/app/routes/feedback.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final $appRoutes = [
  ...$favouritesRoutes,
  ...$feedbackRoutes,
];
