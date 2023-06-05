import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;

import '../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../core/utils/utils_exports.dart' show BottomNavBar;
import '../../../activities/activities_exports.dart' show ActivitiesPage;
import '../../../component_test/component_test_exports.dart' show HomePage;
import '../../../home_page/presentation/pages/home_page.dart';
import '../../../more/more_exports.dart' show MorePage;
import '../../../services/services_exports.dart' show ServicesPage;
import '../../bottom_navigation_exports.dart'
    show BottomNavBarCubit, BottomNavBarWidget;

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late PageController _pageViewController;

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
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBarCubit>(
          create: (_) => BottomNavBarCubit(initialNavBar: BottomNavBar.home),
        ),
      ],
      child: Scaffold(
        key: NavigationService.bottomNavKey,
        body: PageView(
          controller: _pageViewController,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            // Home-Page
            HomePage(),
            // Services-Page
            ServicesPage(),
            // Activities-Page
            ActivitiesPage(),
            // Profile-Page
            MorePage(),
          ],
        ),
        bottomNavigationBar: BottomNavBarWidget(
          onSelectedBottomNavBar: (index) {
            _pageViewController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.decelerate,
            );
          },
        ),
      ),
    );
  }
}
