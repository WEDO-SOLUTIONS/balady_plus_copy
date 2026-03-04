import 'package:auto_route/annotations.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/mini_apps_list_pages.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MapnessServicesPage extends StatelessWidget {
  const MapnessServicesPage({super.key});

  @override
  Widget build(BuildContext context) => const Material(
        child: HomeMiniAppsListPages(),
      );
}
