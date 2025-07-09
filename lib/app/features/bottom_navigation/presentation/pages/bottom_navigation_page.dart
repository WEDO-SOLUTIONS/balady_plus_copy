import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;

import '../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../core/utils/utils_exports.dart' show BottomNavBar;
import '../../bottom_navigation_exports.dart' show BottomNavBarCubit;
import 'mapness_page.dart';

import 'package:balady_authorization/auth_package.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({super.key});

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Navigator.of(context).pushNamed(
          RouteName.splashScreen,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBarCubit>(
          create: (_) => BottomNavBarCubit(initialNavBar: BottomNavBar.home),
        ),
        // BlocProvider<DelegatorsCubit>(
        //   create: (_) => sl<DelegatorsCubit>(),
        // ),
        // BlocProvider<PrayerTimesCubit>(
        //   create: (_) => sl<PrayerTimesCubit>(),
        // ),
        // BlocProvider<WeatherBloc>(
        //   create: (_) => sl<WeatherBloc>(),
        // ),
      ],
      child: BaladyAuthorizationWidget(
        authenticated: (LoginDataModel data) {
          // sl<EntryPointCubit>().onLoadingApp();
          sl<EntryPointCubit>().onLoginV2(data: data);
          Navigator.of(context).popUntil(
            ModalRoute.withName(
              sl<EntryPointCubit>().mainPage ?? RouteName.bottomNavigation,
            ),
          );
          sl<EntryPointCubit>().mainPage = null;
        },
        unAuthenticatedState: (data) {
          sl<EntryPointCubit>().clearAuth(loginData: data);
          sl<EntryPointCubit>().mainPage = null;
        },
        linkWithNafaz: () {
          sl<EntryPointCubit>().onLoginNfaaz();
        },
        child: const MapnessPage(),
      ),
    );
  }
}
