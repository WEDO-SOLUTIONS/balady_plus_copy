import 'package:auto_route/annotations.dart';
import 'package:balady_plus/app/features/services/presentation/pages/home_services_screen.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MapnessServicesPage extends StatelessWidget {
  const MapnessServicesPage({super.key});

  @override
  Widget build(BuildContext context) => const Material(
        child: HomeServicesScreen(),
      );
}
