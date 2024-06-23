import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_types_widget/notification_type_widget.dart';
import 'package:flutter/material.dart';

class NotificationsTypesWidget extends StatelessWidget {
  const NotificationsTypesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      color: AppColor.white10,
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: NotificationTypeWidget(
              isSelected: true,
              title: 'الخاصة',
              count: 5,
            ),
          ),
          Expanded(
            flex: 1,
            child: SizedBox(),
          ),
          Expanded(
            flex: 6,
            child: NotificationTypeWidget(
              isSelected: false,
              title: 'العامة',
              count: 10,
            ),
          ),
        ],
      ),
    );
  }
}
