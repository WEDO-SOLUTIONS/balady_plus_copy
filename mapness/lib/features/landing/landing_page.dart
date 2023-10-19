import 'package:flutter/material.dart';

import '../map/map_page_new.dart';
import 'controls.dart';
import 'dashboard.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: [
          MapPage(),
          Dashboard(),
          MapControls(),
        ],
      ),
    );
  }
}
