import 'package:balady_plus/app/features/map_page/presentation/mvvm/search_bottom_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;
import 'package:provider/provider.dart';

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/services/services_exports.dart' show NavigationService;
import '../../../../core/utils/utils_exports.dart'
    show BottomNavBar, CommonFunctions;
import '../../../home_page/presentation/pages/home_page.dart';
import '../../../map_page/presentation/mvvm/map_view_model.dart';
import '../../../nearby/nearby_exports.dart' show NearbyPage;
import '../../../profile/profile_exports.dart' show ProfilePage;
import '../../../profile_features/delegators/delegators_exports.dart'
    show DelegatorsCubit;
import '../../../public_services_features/prayer_times/prayer_times_exports.dart'
    show PrayerTimesCubit;
import '../../../services/services_exports.dart'
    show ServicesCubit, ServicesPage;
import '../../../weather/presentation/bloc/weather_bloc.dart';
import '../../bottom_navigation_exports.dart'
    show BottomNavBarCubit, BottomNavBarWidget;

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
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
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;
    return ChangeNotifierProvider(
      create: (_) {
        return SearchBottomViewModel(mapViewModel);
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<BottomNavBarCubit>.value(
            value: sl<BottomNavBarCubit>(),
          ),
          BlocProvider<ServicesCubit>(
            create: (_) => ServicesCubit(
              importantServices: sl(),
              newServices: sl(),
              islamicServices: sl(),
              customerVoiceServices: sl(),
              businessLicenseServices: sl(),
              honoringTheDeadServices: sl(),
              municipalServices: sl(),
              //healthCertificatesServices: sl(),
              helpServices: sl(),
            ),
          ),
          BlocProvider<DelegatorsCubit>(
            create: (_) => sl<DelegatorsCubit>(),
          ),
          BlocProvider<PrayerTimesCubit>(
            create: (_) => sl<PrayerTimesCubit>(),
          ),
          BlocProvider<WeatherBloc>(
            create: (_) => sl<WeatherBloc>(),
          ),
        ],
        child: Scaffold(
          key: NavigationService.bottomNavKey,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: PageView(
            controller: _pageViewController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              // Home-Page
              HomePage(),
              // Services-Page
              //  NearbyPage(),
              // Activities-Page
              ServicesPage(),
              // Profile-Page
              ProfilePage(),
            ],
          ),
          bottomNavigationBar: BottomNavBarWidget(
            onSelectedBottomNavBar: (index) {
              _pageViewController.jumpToPage(
                index,
              );
              resizeToAvoidBottomInset = index == 0 ? false : true;
              setState(() {});
            },
          ),
        ),
      ),
    );
  }
}
