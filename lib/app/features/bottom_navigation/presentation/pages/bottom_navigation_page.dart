import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/bottom_nav_bar.dart';
import 'package:balady_plus/app/features/bottom_navigation/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/force_update/presentation/core/force_update_cubit.dart';
import 'package:balady_plus/app/features/splash/presentation/pages/splash_wrapper.dart';
import 'package:balady_authorization/auth_package.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider, MultiBlocProvider;
import 'package:flutter/material.dart';
import 'mapness_page.dart';

class BottomNavigationPage extends StatelessWidget {
  const BottomNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBarCubit>(create: (_) => BottomNavBarCubit(initialNavBar: BottomNavBar.home)),
        BlocProvider<ForceUpdateCubit>(create: (_) => ForceUpdateCubit()),
      ],
      child: SplashWrapper(
        child: BaladyAuthorizationWidget(
          authenticated: (LoginDataModel data) async {
            sl<EntryPointCubit>().onLoginV2(data: data);
            Navigator.of(
              context,
            ).popUntil(ModalRoute.withName(sl<EntryPointCubit>().mainPage ?? RouteName.bottomNavigation));
            sl<EntryPointCubit>().mainPage = null;
            // Reset delegators so loadMiniApps fetches fresh data for the new user
            await sl<DelegatorsCubit>().loadData();
            sl<NewMiniAppLogicCubit>().loadMiniApps(forceRefresh: true);
            debugPrint("authenticated : sl<NewMiniAppLogicCubit>().loadMiniApps(forceRefresh: true);");
          },
          unAuthenticatedState: (data) {
            sl<DelegatorsCubit>().clearData();
            sl<EntryPointCubit>().clearAuth(loginData: data);
            sl<NewMiniAppLogicCubit>().loadMiniApps(forceRefresh: true);
            debugPrint("unAuthenticatedState : sl<NewMiniAppLogicCubit>().loadMiniApps(forceRefresh: true);");
          },
          linkWithNafaz: () => sl<EntryPointCubit>().onLoginNfaaz(),
          child: const MapnessPage(),
        ),
      ),
    );
  }
}
