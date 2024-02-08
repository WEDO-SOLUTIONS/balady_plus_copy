import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/routes_type.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/calendar_event_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListItemsEventsWidget extends StatelessWidget {
  final List<CalendarEventItem> listEvents;

  const ListItemsEventsWidget({super.key, required this.listEvents});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        CalendarEventItem event = listEvents[index];
        return InkWell(
          onTap: () {
            String screenName = getScreenName(
              event.entityType ?? '',
              typeId: int.parse(event.metadata?.mainType?.id ?? '0'),
            );
            if (screenName == RouteName.inappWebview) {
              CommonFunctions.openBaldyWithRefreshCookie(
                event.redirectUrl,
              );
            } else {
              Navigator.of(context).pushNamed(
                screenName,
                arguments: {
                  "licenseNumber": event.entityId,
                  "requestNumber": event.entityId,
                  "invoiceId": event.hashingEntityId,
                },
              );
            }
          },
          child: Container(
            height: 120,
            width: double.infinity,
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColor.black100,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(event.metadata?.mainType?.name ?? ''),
                    ),
                    Text(
                      DateFormat('EEEE dd',).format(event.eventDate!),
                    ),
                  ],
                ),
                const SizedBox(width: 6),
                Container(
                  child: Text(
                    event.eventDisplayMessage ?? 'Display Message Empty',
                    overflow: TextOverflow.visible,
                  ),
                )
              ],
            ),
          ),
        );
      },
      itemCount: listEvents.length,
    );
  }
}
