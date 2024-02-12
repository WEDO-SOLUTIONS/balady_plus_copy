import 'package:balady_plus/app/core/utils/routes_type.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/calendar_event_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

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
              typeId: event.entityType == ScreenTage.license.name
                  ? int.parse(event.metadata?.mainType?.id ?? '0')
                  : int.parse(event.metadata?.type?.id ?? '0'),
            );

            if (screenName == RouteName.inappWebview) {
              CommonFunctions.openBaldyWithRefreshCookie(
                event.redirectUrl,
              );
            } else {
              Navigator.of(context).pushNamed(
                screenName,
                arguments: {
                  "licenseNumber": int.parse(event.entityId ?? '0'),
                  "requestNumber": int.parse(event.entityId ?? '0'),
                  // for appointment
                  "appointmentId": int.parse(event.entityId ?? '0'),
                  // for invoices
                  "invoiceId": event.hashingEntityId,
                  // for Violation
                  "hashingViolationNumber": event.hashingEntityId,
                  "applicationId": event.metadata?.mainType?.id,
                  // for objection
                  "objectionRequestNumber": event.entityId,
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
              color: AppColor.black200,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      child: Text(
                        event.metadata?.mainType?.name ?? '',
                        style: AppStyle.signInFullTextStyle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      DateFormat(
                        'EEEE dd',
                      ).format(event.eventDate!),
                      style: AppStyle.signInFullTextStyle
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SingleChildScrollView(
                  child: SizedBox(
                    height: 20,
                    child: Text(
                      event.eventDisplayMessage ?? 'Display Message Empty',
                      overflow: TextOverflow.visible,
                      style: AppStyle.serviceTitleStyle
                          .copyWith(fontWeight: FontWeight.w500),
                    ),
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
