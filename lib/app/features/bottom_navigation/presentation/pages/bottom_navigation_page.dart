import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/bottom_nav_bar.dart';
import 'package:balady_plus/app/features/bottom_navigation/presentation/cubits/bottom_nav_bar_cubit.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocRequestStatus;
import 'package:balady_plus/app/features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/force_update/presentation/core/force_update_cubit.dart';
import 'package:balady_plus/app/features/splash/presentation/pages/splash_wrapper.dart';
import 'package:balady_authorization/auth_package.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider;
import 'package:flutter/material.dart';
import 'mapness_page.dart';

class BottomNavigationPage extends StatelessWidget {
  const BottomNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<BottomNavBarCubit>(
          create: (_) => BottomNavBarCubit(initialNavBar: BottomNavBar.home),
        ),
        BlocProvider<ForceUpdateCubit>(
          create: (_) => ForceUpdateCubit(),
        ),
        BlocProvider<DelegatorsCubit>(
          create: (_) {
            final cubit = sl<DelegatorsCubit>();
            // Initialize: Fetch delegators/agents and restore selection on app startup
            WidgetsBinding.instance.addPostFrameCallback((_) {
              // Only fetch if not already loaded
              if (cubit.state.delegators.isEmpty && 
                  cubit.state.status != BlocRequestStatus.submissionGetLoading) {
                cubit.getDelegators();
              }
              if (cubit.state.agents.isEmpty && 
                  cubit.state.agentStatus != BlocRequestStatus.submissionGetLoading) {
                cubit.getAgents();
              }
            });
            return cubit;
          },
        ),
      ],
      child: SplashWrapper(
        child: BaladyAuthorizationWidget(
          authenticated: (LoginDataModel data) {
            sl<EntryPointCubit>().onLoginV2(data: data);

            Navigator.of(context).popUntil(
              ModalRoute.withName(
                sl<EntryPointCubit>().mainPage ?? RouteName.bottomNavigation,
              ),
            );
            sl<EntryPointCubit>().mainPage = null;
          },
          unAuthenticatedState: (data) =>
              sl<EntryPointCubit>().clearAuth(loginData: data),
          linkWithNafaz: () => sl<EntryPointCubit>().onLoginNfaaz(),
          child: const MapnessPage(),
        ),
      ),
    );
  }
}
