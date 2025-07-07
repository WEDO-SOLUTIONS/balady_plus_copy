import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_plus/app/features/force_update/presentation/core/force_update_cubit.dart';
import 'package:balady_plus/app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashWrapper extends StatefulWidget {
  final Widget child;

  const SplashWrapper({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  bool _isInitialized = false;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _checkInitialForceUpdate();
  }

  void _checkInitialForceUpdate() {
    final forceUpdateState = sl<ForceUpdateCubit>().state;
    if (forceUpdateState is HaveForceUpdateState) {
      _navigateToForceUpdate();
    } else if (forceUpdateState is NotHaveForceUpdateState) {
      _checkAuthentication();
    }
    // Otherwise, wait for BlocListener to handle state changes
  }

  void _navigateToForceUpdate() {
    if (!_navigated) {
      _navigated = true;
      Future.microtask(() {
        if (mounted) NavigationService.pushAndReplaceForceUpdate();
      });
    }
  }

  void _checkAuthentication() {
    if (!_isInitialized) {
      _isInitialized = true;
      sl<EntryPointCubit>().hideSplash();
      sl<AuthenticationBloc>().add(CheckLoginAuthentication());
    }
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
      child: BlocListener<SplashCubit, SplashState>(
        listener: (context, state) {
          if (state is CompletedSplashState) _checkAuthentication();
        },
        child: widget.child,
      ),
    );
  }
}
