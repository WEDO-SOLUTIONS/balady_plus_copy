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
import 'package:localize_and_translate/localize_and_translate.dart';

class NotificationsItemWidget extends StatelessWidget {
  final NotificationsMessageItem message;

  const NotificationsItemWidget({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        NotificationRepositoryImplementation listRepository = sl();
        return NotificationsItemCubit(itemRepository: listRepository, message: message);
      },
      child: BlocBuilder<NotificationsItemCubit, SucceedMessageState>(
        builder: (BuildContext contextBloc, state) {
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            elevation: state.message.status.id != "read" ? 3 : 0,
            color: state.message.status.id != "read" ? null : Colors.white.withValues(alpha: 0.77),
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    IconPath.bookIcon,
                    colorFilter: state.message.status.id != "read"
                        ? null
                        : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 2),
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                message.subject,
                                style: AppStyle.signInFullTextStyle.copyWith(fontWeight: FontWeight.w600),
                                overflow: TextOverflow.clip,
                                maxLines: 3,
                              ),
                            ),
                            const SizedBox(width: 2),
                            Card(
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                              color: state.message.status.id == "read"
                                  ? Colors.green.shade800.withAlpha(60)
                                  : Colors.red.shade800.withAlpha(60),
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: Text(
                                  state.message.status.id == "read"
                                      ? ('notification_read').tr()
                                      : 'notification_unread'.tr(),
                                  style: AppStyle.nearbyItemSubTitleTextStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: state.message.status.id == "read"
                                        ? Colors.green.shade800
                                        : Colors.red.shade800,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Text(
                                "${Jiffy.parseFromDateTime(message.createTime).toLocal().Hm} ,${Jiffy.parseFromDateTime(message.createTime).toLocal().fromNow()}",
                                style: AppStyle.nearbyItemSubTitleTextStyle.copyWith(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                  color: AppColor.warmGrey2,
                                ),
                              ),
                            ),
                          ],
                        ),
                        ExpandableTextWidget(
                          text: message.body,
                          onTap: () {
                            if (message.status.id != "read") {
                              contextBloc.read<NotificationsItemCubit>().markReadNotificationsMessages();
                            }
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
      ),
    );
  }
}
