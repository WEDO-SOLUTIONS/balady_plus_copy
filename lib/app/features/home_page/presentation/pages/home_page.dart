import 'package:flutter/material.dart';

import '../../home_exports.dart' show HomeBottomSheet, HomeContainer, HomeMap;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: HomeContainer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  HomeMap(),
                  HomeBottomSheet(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
