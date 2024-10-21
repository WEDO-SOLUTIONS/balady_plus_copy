import 'package:flutter/widgets.dart';
import 'package:mapness/app/routes/favourites.dart';
import 'package:mapness/app/routes/feedback.dart';
import 'package:mapness/app/routes/language_picker.dart';
import 'package:mapness/shared/ui/sheets/location_required_sheet.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final $appRoutes = [
  ...$favouritesRoutes,
  ...$locationErrorBoundaryRoute,
  ...$feedbackRoutes,
  ...$languagePickerRoutes,
];
