import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/_shared_features/notifications_count/cubit_notification_count/notifications_item_cubit.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsCountIcon extends StatelessWidget {
  const NotificationsCountIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EntryPointCubit, EntryPointState>(
      builder: (contextCubit, state) {
        return state.userInfo != null
            ? BlocProvider(
                create: (context) {
                  return NotificationsCountCubit(webService: sl());
                },
                child: BlocBuilder<NotificationsCountCubit, SucceedCountState>(
                  builder: (contextCubit, state) {
                    return state.count != null && state.count! > 0
                        ? Padding(
                            padding: const EdgeInsetsDirectional.only(
                              end: 6,
                            ),
                            child: Counter(
                              count: state.count!,
                            ),
                          )
                        : const SizedBox();
                  },
                ),
              )
            : const SizedBox();
      },
    );
  }
}
