import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/data/repositories/notification_repository_implementation.dart';
import 'package:balady_plus/app/features/notifications/presentation/bloc/cubit_notification_item/notifications_item_cubit.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_items_widget/expandable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:jiffy/jiffy.dart';

class NotificationsItemWidget extends StatelessWidget {
  final NotificationsMessageItem message;

  const NotificationsItemWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) {
      NotificationRepositoryImplementation listRepository = sl();
      return NotificationsItemCubit(
        itemRepository: listRepository,
        message: message,
      );
    }, child: BlocBuilder<NotificationsItemCubit, SucceedMessageState>(
      builder: (BuildContext contextBloc, state) {
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: state.message.status.id == "2" ? 3 : 0,
          color: state.message.status.id == "2"
              ? null
              : Colors.white.withOpacity(0.77),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  IconPath.bookIcon,
                  color: state.message.status.id == "2" ? null : Colors.grey,
                ),
                const SizedBox(width: 2),
                Expanded(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            message.subject,
                            style: AppStyle.signInFullTextStyle.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Card(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6)),
                            ),
                            color: Colors.red.shade800.withAlpha(60),
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Text(
                                message.eventType.text,
                                style: AppStyle.nearbyItemSubTitleTextStyle
                                    .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red.shade800,
                                ),
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            "${Jiffy.parseFromDateTime(message.eventTime).Hm} ,${Jiffy.parseFromDateTime(message.eventTime).fromNow()}",
                            //DateFormat("hh",).format(message.eventTime)
                            style:
                                AppStyle.nearbyItemSubTitleTextStyle.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              color: AppColor.warmGrey2,
                            ),
                          ),
                        ],
                      ),
                      ExpandableTextWidget(
                        text: message.body,
                        onTap: () {
                          contextBloc.watch<NotificationsItemCubit>().markReadNotificationsMessages();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ));
  }
}
