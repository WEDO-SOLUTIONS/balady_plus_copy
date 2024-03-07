import 'package:balady_plus/app/features/notifications/data/model/notifications_list/notifications_message_item.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_items_widget/expandable_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:intl/intl.dart';

class NotificationsItemWidget extends StatelessWidget {
  final NotificationsMessageItem message;

  const NotificationsItemWidget({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(RouteName.notificationsDetailsScreen);
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 3,
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
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          message.subject ,
                          style: AppStyle.signInFullTextStyle
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(width: 4),
                        Card(
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                          ),
                          color: Colors.red.shade800.withAlpha(60),
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Text(
                              message.eventType.name,
                              style:
                                  AppStyle.nearbyItemSubTitleTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade800,
                              ),
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          "${DateFormat("hh",).format(message.eventTime)} , ${DateFormat("hh",).format(message.eventTime)}",
                          style: AppStyle.nearbyItemSubTitleTextStyle.copyWith(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: AppColor.warmGrey2,
                          ),
                        ),
                      ],
                    ),
                    ExpandableTextWidget(
                      text: message.body,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
