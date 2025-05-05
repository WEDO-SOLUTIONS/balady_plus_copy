import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';

@RoutePage()
class MapnessServicesPage extends StatelessWidget {
  const MapnessServicesPage({super.key});

  @override
  Widget build(BuildContext context) => Material(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Mapness Services'),
          ),
          body: const Column(
            children: [
              Text('Test App'),
            ],
          ),
        ),
      );
}
