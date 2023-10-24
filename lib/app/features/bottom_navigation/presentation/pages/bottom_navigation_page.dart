import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;
import 'package:mapness/entry_point.dart';

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../core/utils/utils_exports.dart' show BottomNavBar;
import '../../../public_services_features/prayer_times/presentation/cubit/prayer_times_cubit.dart';
import '../../../services/services_exports.dart' show ServicesCubit;
import '../../bottom_navigation_exports.dart' show BottomNavBarCubit;

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  late PageController _pageViewController;
  bool resizeToAvoidBottomInset = false;

  bool navVisible = false;

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
        BlocProvider<PrayerTimesCubit>(
          create: (_) => sl<PrayerTimesCubit>(),
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
        resizeToAvoidBottomInset: false,
        key: NavigationService.bottomNavKey,
        body: MapnessEntryPoint(
          [
            Container(),
            Container(),
            Container(),
            Container(),
          ],
        ),
      ),
    );
  }
}
