import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_types_widget/notification_type_widget.dart';
import 'package:flutter/material.dart';

List<String> types = [
  "الكل",
  "الفواتير",
  "الرخص",
  "المخالفات"
];

class NotificationsFiltersTypesWidget extends StatelessWidget {
  const NotificationsFiltersTypesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return NotificationTypeWidget(
            isSelected: index == 0,
            title: types[index],
            count: types.length - index,
          );
        },
        scrollDirection: Axis.horizontal,
        itemCount: types.length,
      ),
    );
  }
}
