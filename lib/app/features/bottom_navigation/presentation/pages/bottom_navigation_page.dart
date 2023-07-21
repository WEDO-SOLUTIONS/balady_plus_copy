import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../core/utils/utils_exports.dart'
    show BottomNavBar, CommonFunctions;
import '../../../home_page/presentation/pages/home_page.dart';
import '../../../services/services_exports.dart'
    show ServicesCubit, ServicesPage;
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
        BlocProvider<ServicesCubit>(
          create: (_) => ServicesCubit(
            importantServices: sl(),
            newServices: sl(),
            municipalServices: sl(),
            publicServices: sl(),
          ),
        ),
      ],
      child: Scaffold(
        key: NavigationService.bottomNavKey,
        body: PageView(
          controller: _pageViewController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Home-Page
            const HomePage(),
            // Services-Page
            Container(),
            // Activities-Page
            const ServicesPage(),
            // Profile-Page
            Container(),
          ],
        ),
        bottomNavigationBar: BottomNavBarWidget(
          onSelectedBottomNavBar: (index) {
            _pageViewController.jumpToPage(
              index,
            );
          },
        ),
      ),
    );
  }
}
