import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/splash/splash_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocBuilder, BlocProvider, MultiBlocProvider;

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/utils/utils_exports.dart' show BottomNavBar;
import '../../../profile_features/delegators/delegators_exports.dart'
    show DelegatorsCubit;
import '../../../public_services_features/prayer_times/prayer_times_exports.dart'
    show PrayerTimesCubit;
import '../../../services/services_exports.dart' show ServicesCubit;
import '../../../weather/presentation/bloc/weather_bloc.dart';
import '../../bottom_navigation_exports.dart' show BottomNavBarCubit;
import 'mapness_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        MultiBlocProvider(
          providers: [
            BlocProvider<BottomNavBarCubit>(
              create: (_) =>
                  BottomNavBarCubit(initialNavBar: BottomNavBar.home),
            ),
            BlocProvider<PrayerTimesCubit>(
              create: (_) => sl<PrayerTimesCubit>(),
            ),
            BlocProvider<ServicesCubit>(
              create: (_) => ServicesCubit(
                islamicServices: sl(),
                businessLicenseServices: sl(),
                municipalServices: sl(),
                ekramServices: sl(),
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
          child: const MapnessPage(),
        ),
        BlocBuilder<EntryPointCubit, EntryPointState>(
          builder: (BuildContext context, EntryPointState state) {
            if (!state.showSplash) return SizedBox.shrink();

            return SplashPage();
          },
        ),
      ],
    );
  }
}
