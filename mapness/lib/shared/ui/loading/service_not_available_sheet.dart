import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class ServiceNotAvailableSheet extends StatelessWidget {
  const ServiceNotAvailableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Service Not Available'),
      ),
    );
  }
}
