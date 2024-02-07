import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
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

          },
          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: AppColor.black100,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 10,
                  decoration: const BoxDecoration(
                    color: AppColor.primary700Light,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
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
                            DateFormat('EEEE dd').format(event.eventDate!),
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
                const SizedBox(width: 10)
              ],
            ),
          ),
        );
      },
      itemCount: listEvents.length,
    );
  }
}
