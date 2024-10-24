import 'package:flutter/widgets.dart';
import 'package:mapness/app/routes/language_picker.dart';

final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();

final $appRoutes = [
  ...$languagePickerRoutes,
];
