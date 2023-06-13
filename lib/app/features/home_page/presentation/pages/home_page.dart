import 'package:flutter/material.dart';

import '../../../_shared_feature_/shared_feature_exports.dart' show TabPageContainer;
import '../../home_exports.dart' show HomeBottomSheet, HomeMap;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: TabPageContainer(
        child: Stack(
          children: [
            HomeMap(),
            HomeBottomSheet(),
          ],
        ),
      ),
    );
  }
}
