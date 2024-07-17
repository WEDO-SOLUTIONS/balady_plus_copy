import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_features/notifications_count/cubit_notification_count/notifications_item_cubit.dart';
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jiffy/jiffy.dart';

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
                    NotificationsCountCubit cubit = contextCubit.watch<NotificationsCountCubit>();
                    return InkWell(
                      onTap: () {
                        NavigationService.navigatorKey.currentState!
                            .pushNamed(
                          RouteName.notificationsListScreen,
                        )
                            .then((value) {
                          cubit.getUnreadMessages();
                          Jiffy.setLocale("en");
                        });
                      },
                      child: Stack(
                        alignment: AlignmentDirectional.topStart,
                        children: [
                          Card(
                            elevation: 2,
                            color: Colors.grey.shade200,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 7,
                              ),
                              child: SvgPicture.asset(
                                IconPath.notificationIc2,
                                colorFilter: const ColorFilter.mode(
                                  Colors.black,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                          state.count != null && state.count! > 0
                              ? Card(
                                  margin: EdgeInsets.zero,
                                  color: Colors.red.shade600,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Text(
                                      state.count!.toString(),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    );
                  },
                ),
              )
            : const SizedBox();
      },
    );
  }
}
