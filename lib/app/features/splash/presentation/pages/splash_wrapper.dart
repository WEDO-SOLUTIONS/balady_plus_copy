import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/force_update/presentation/core/force_update_cubit.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashWrapper extends StatelessWidget {
  final Widget child;

  const SplashWrapper({super.key, required this.child});

  void _navigateToForceUpdate() {
    NavigationService.pushAndReplaceForceUpdate();
  }

  void _checkAuthentication() {
    sl<EntryPointCubit>().hideSplash();
    sl<AuthenticationBloc>().add(CheckLoginAuthentication());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ForceUpdateCubit, ForceUpdateState>(
      listener: (context, state) {
        if (state is HaveForceUpdateState) {
          _navigateToForceUpdate();
        } else if (state is NotHaveForceUpdateState) {
          _checkAuthentication();
        }
      },
      child: child,
    );
  }
}
