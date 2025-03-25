import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/services/presentation/cubit/home_services_cubit/home_services_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/utils/utils_exports.dart' show BottomNavBar;
import '../../../profile_features/delegators/delegators_exports.dart'
    show DelegatorsCubit;
import '../../../public_services_features/prayer_times/prayer_times_exports.dart'
    show PrayerTimesCubit;
import '../../../weather/presentation/bloc/weather_bloc.dart';
import '../../bottom_navigation_exports.dart' show BottomNavBarCubit;
import 'mapness_page.dart';

import 'package:balady_authorization/auth_package.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_authorization/src/utils/injection/injection_container.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  @override
  void initState() {
    super.initState();
    slAuthentication<AuthenticationBloc>().add(CheckLoginAuthentication());
    // WidgetsBinding.instance.addPostFrameCallback(
    //   (_) {
    //     Navigator.of(context).pushNamed(
    //       RouteName.splashScreen,
    //     );
    //   },
    // );
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
        BlocProvider<HomeServicesCubit>(
          create: (_) => sl<HomeServicesCubit>(),
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
      child: BaladyAuthorizationWidget(
        authenticated: (LoginDataModel data) {
          // sl<EntryPointCubit>().onLoadingApp();
          sl<EntryPointCubit>().onLoginV2(data: data);
          Navigator.of(context).popUntil(
            ModalRoute.withName(
              RouteName.bottomNavigation,
            ),
          );
        },
        unAuthenticatedState: (data) {
          sl<EntryPointCubit>().clearAuth(loginData: data);
        },
        linkWithNafaz: () {
          sl<EntryPointCubit>().onLoginNfaaz();
        },
        child: const MapnessPage(),
      ),
    );
  }
}
