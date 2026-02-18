import 'package:balady_plus/app/core/services/local/navigation_services.dart';
// import 'package:balady_plus/app/features/bottom_navigation/presentation/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:mapness/mapness.dart';

class MapnessPage extends StatelessWidget {
  const MapnessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: NavigationService.bottomNavKey,
      body: MapnessEntryPoint(
        mapCreated: (controller) {
          // context.read<MapViewModel>().controller = controller;
        },
      ),
    );
  }
}
