import 'package:flutter/widgets.dart';
import 'package:mapness/app/routes/app_feedback.dart';
import 'package:mapness/app/routes/dark_map.dart';
import 'package:mapness/app/routes/esri_layers.dart';
import 'package:mapness/app/routes/eta.dart';
import 'package:mapness/app/routes/events.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/app/routes/free_roam.dart';
import 'package:mapness/app/routes/free_roam_autostart_settings.dart';
import 'package:mapness/app/routes/happines_map.dart';
import 'package:mapness/app/routes/iwish.dart';
import 'package:mapness/app/routes/jobs_map.dart';
import 'package:mapness/app/routes/kiblah.dart';
import 'package:mapness/app/routes/language_picker.dart';
import 'package:mapness/app/routes/layer_details.dart';
import 'package:mapness/app/routes/mini_apps.dart';
import 'package:mapness/app/routes/navigator_settings.dart';
import 'package:mapness/app/routes/path_nav.dart';
import 'package:mapness/app/routes/photo_viewer.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/app/routes/profile.dart';
import 'package:mapness/app/routes/road_panel.dart';
import 'package:mapness/app/routes/routing.dart';
import 'package:mapness/app/routes/search.dart';
import 'package:mapness/app/routes/signin.dart';
import 'package:mapness/app/routes/sound_settings.dart';
import 'package:mapness/app/routes/stories.dart';
import 'package:mapness/app/routes/voice_settings.dart';
import 'package:mapness/app/routes/weather.dart';
import 'package:mapness/shared/ui/sheets/location_required_sheet.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final $appRoutes = [
  ...$searchRoutes,
  ...$kiblahRoutes,
  ...$favouritesRoutes,
  ...$poiMapRoutes,
  ...$iwishRoutes,
  ...$happinesMapRoutes,
  ...$pathNavRoutes,
  ...$freeRoamRoutes,
  ...$freeRoamAutostartSettingsRoutes,
  ...$roadPanelRoutes,
  ...$routingRoutes,
  ...$weatherRoutes,
  ...$jobsMapRoutes,
  ...$profileRoutes,
  ...$layerDetailsRoutes,
  ...$SignInRoutes,
  ...$locationErrorBoundaryRoute,
  ...$layersRoutes,
  ...$eventRoutes,
  ...$miniAppsRoutes,
  ...$storiesRoutes,
  ...$photoViewerRoutes,
  ...$navigatorSettingsRoutes,
  ...$etaRoutes,
  ...$feedbackRoutes,
  ...$soundSettingsRoutes,
  ...$darkMapRoutes,
  ...$languagePickerRoutes,
  ...$voiceSettingsRoutes,
  ...$appFeedbackRoutes
];
