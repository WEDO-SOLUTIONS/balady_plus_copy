import 'package:balady_plus/app/features/notifications/presentation/widgets/notifications_items_widget/notifications_item_widget.dart';
import 'package:flutter/material.dart';

class ListItemsEventsWidget extends StatelessWidget {
  // final List<CalendarEventItem> listEvents;

  const ListItemsEventsWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemBuilder: (BuildContext context, int index) {
        return const NotificationsItemWidget();
      },
      itemCount: 3,
    );
  }
}
