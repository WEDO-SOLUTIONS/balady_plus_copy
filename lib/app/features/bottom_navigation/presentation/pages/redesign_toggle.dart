import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/enums/bottom_nav_bar.dart';
import 'package:balady_plus/app/features/bottom_navigation/presentation/widgets/nav_bar_widget.dart';
import 'package:balady_plus/app/features/home_page/presentation/pages/home_page.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/pages/services_page.dart';
import 'package:flutter/material.dart';
import 'package:mapness/mapness.dart';
import 'package:provider/provider.dart';

import '../../../profile/presentation/pages/profile_page.dart';

class RedesignToggle extends StatelessWidget {
  const RedesignToggle({required this.redesignEnabled, super.key});

  final bool redesignEnabled;

  @override
  Widget build(BuildContext context) {
    return redesignEnabled ? const MapnessOn() : const MapnessOff();
  }
}

class MapnessOff extends StatefulWidget {
  const MapnessOff({
    super.key,
  });

  @override
  State<MapnessOff> createState() => _MapnessOffState();
}

class _MapnessOffState extends State<MapnessOff> {
  late PageController _pageViewController;
  bool resizeToAvoidBottomInset = false;

  @override
  void initState() {
    super.initState();
    _pageViewController = PageController(initialPage: BottomNavBar.home.index);
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: NavigationService.bottomNavKey,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: PageView(
        controller: _pageViewController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          // Home-Page
          const HomePage(
            hideControls: false,
          ),
          const ServicesPage(),
          //   const NearbyPage(),
          // Services-Page
          ProfilePage(),
          // Activities-Page
        ],
      ),
      bottomNavigationBar: BottomNavBarWidget(
        onSelectedBottomNavBar: (prev, next) {
          _pageViewController.jumpToPage(
            next,
          );
          resizeToAvoidBottomInset = next == 0 ? false : true;
          setState(() {});
        },
      ),
    );
  }
}

class MapnessOn extends StatelessWidget {
  const MapnessOn({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: NavigationService.bottomNavKey,
      body: MapnessEntryPoint(
        mapCreated: (controller) {
          context.read<MapViewModel>().controller = controller;
        },
      ),
    );
  }
}
