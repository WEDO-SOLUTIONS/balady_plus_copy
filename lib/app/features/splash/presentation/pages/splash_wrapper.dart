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

  @override
  void initState() {
    super.initState();
    _initializeApp();

    // this is for testing purposes, you can remove it
    // _testForceUpdate();
  }

  // void _testForceUpdate() {
  //   Future.delayed(const Duration(milliseconds: 1000), () {
  //     sl<ForceUpdateCubit>().emit(HaveForceUpdateState());
  //   });
  // }

  Future<void> _initializeApp() async {
    final forceUpdateState = sl<ForceUpdateCubit>().state;

    if (forceUpdateState is HaveForceUpdateState) {
      NavigationService.pushAndReplaceForceUpdate();
      return;
    }

    if (forceUpdateState is NotHaveForceUpdateState) {
      _checkAuthentication();
      return;
    }

    sl<ForceUpdateCubit>().stream.listen((state) {
      if (!_isInitialized) {
        if (state is HaveForceUpdateState) {
          NavigationService.pushAndReplaceForceUpdate();
        } else if (state is NotHaveForceUpdateState) {
          _checkAuthentication();
        }
      }
    });
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
          Future.delayed(const Duration(milliseconds: 100), () {
            if (mounted) NavigationService.pushAndReplaceForceUpdate();
          });
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
