import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/features/force_update/presentation/core/force_update_cubit.dart';
import 'package:balady_plus/app/features/splash/presentation/cubit/splash_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../entry_point/presentation/cubit/auth_cubit.dart';

import 'package:balady_authorization/src/authentication/bloc/authentication_bloc.dart';
import 'package:balady_authorization/src/utils/injection/injection_container.dart';

class SplashScreenAnimator extends StatefulWidget {
  const SplashScreenAnimator({Key? key}) : super(key: key);

  @override
  State<SplashScreenAnimator> createState() => _SplashScreenAnimatorState();
}

class _SplashScreenAnimatorState extends State<SplashScreenAnimator>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForceUpdateCubit, ForceUpdateState>(
      listener: (context, state) {
        if (state is HaveForceUpdateState) {
          if (context.read<SplashCubit>().state is CompletedSplashState) {
            NavigationService.pushAndReplaceForceUpdate();
          }
        }

        if (state is NotHaveForceUpdateState) {
          if (context.read<SplashCubit>().state is CompletedSplashState) {
            takeActionChickLogin();
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColor.primary900Light,
        body: SizedBox(
          width: double.maxFinite,
          height: double.maxFinite,
          child: BlocBuilder<SplashCubit, SplashState>(
            buildWhen: (previous, current) {
              // if the current state is completed splash state we will not rebuild the widget
              if (current is CompletedSplashState) {
                return false;
              }
              return true;
            },
            builder: (context, state) {
              if (state is InitialSplashState) {
                return const SizedBox.shrink();
              }
              if (state is OnlineSplashState) {
                return Gif(
                  image: FileImage(state.splashFile),
                  fit: BoxFit.cover,
                  autostart: Autostart.once,
                  onFetchCompleted: () async {
                    // wating for 1.3 seconds to hide the splash screen to make shower is splash screen is completed
                    Future.delayed(Duration(seconds: state.splashDuration))
                        .then(
                      (e) {
                        if (context.read<ForceUpdateCubit>().state
                            is NotHaveForceUpdateState) {
                          takeActionChickLogin();
                        } else if (context.read<ForceUpdateCubit>().state
                            is HaveForceUpdateState) {
                          NavigationService.pushAndReplaceForceUpdate();
                        } else {
                          context
                              .read<SplashCubit>()
                              .emitCompletedSplashState();
                        }
                      },
                    );
                  },
                );
              }
              if (state is OfflineSplashState) {
                return Gif(
                  image: const AssetImage('assets/images/splash-screen.gif'),
                  fps: 10,
                  fit: BoxFit.cover,
                  autostart: Autostart.once,
                  onFetchCompleted: () async {
                    // wating for 1.3 seconds to hide the splash screen to make shower is splash screen is completed
                    Future.delayed(const Duration(milliseconds: 3000))
                        .then((e) {
                      if (context.read<ForceUpdateCubit>().state
                          is NotHaveForceUpdateState) {
                        takeActionChickLogin();
                      } else if (context.read<ForceUpdateCubit>().state
                          is HaveForceUpdateState) {
                        NavigationService.pushAndReplaceForceUpdate();
                      } else {
                        context.read<SplashCubit>().emitCompletedSplashState();
                      }
                    });
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void takeActionChickLogin() {
    sl<EntryPointCubit>().hideSplash();
    Navigator.of(context).pop();
    slAuthentication<AuthenticationBloc>().add(CheckLoginAuthentication());
  }
}
