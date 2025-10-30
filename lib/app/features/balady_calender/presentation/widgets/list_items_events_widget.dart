import 'package:balady_plus/app/core/utils/routes_type.dart';
import 'package:balady_plus/app/features/balady_calender/data/models/events_details/calendar_event_item.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/bloc/events_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ListItemsEventsWidget extends StatelessWidget {
  final List<CalendarEventItem> listEvents;

  const ListItemsEventsWidget({super.key, required this.listEvents});

  @override
  Widget build(BuildContext context) {
    EventsListCubit bloc = context.watch<EventsListCubit>();
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
                event.redirectUrl ?? event.appRedirectUrl,
              );
            } else {
              Navigator.of(context).pushNamed(
                screenName,
                arguments: {
                  "licenseNumber": event.entityId,
                  "requestNumber": event.entityId,
                  // for appointment
                  "appointmentId": int.tryParse(event.entityId ?? '0'),
                  // for invoices
                  "invoiceId": event.hashingEntityId,
                  // for Violation
                  "hashingViolationNumber": event.hashingEntityId,
                  "applicationId": event.metadata?.mainType?.id,
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
                        event.metadata?.mainType?.name ??
                            "calendar_type_${event.entityType ?? ''}".tr(),
                        style: AppStyle.signInFullTextStyle
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      (bloc.params.commonParams.commonParams.hijri
                              ? " ${HijriCalendar.fromDate(event.eventDate!).dayWeName} ${HijriCalendar.fromDate(event.eventDate!).hDay}"
                              : DateFormat(
                                  ' EEEE dd ',
                                  Localizations.localeOf(context).languageCode,
                                ).format(event.eventDate!)) +
                          ((event.entityType ?? '') == ScreenTage.appmt.name
                              ? "\n${event.metadata?.time}" ?? ''
                              : ''),
                      style: AppStyle.signInFullTextStyle
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  event.eventDisplayMessage ?? '',
                  overflow: TextOverflow.visible,
                  maxLines: 3,
                  style: AppStyle.serviceTitleStyle
                      .copyWith(fontWeight: FontWeight.w500),
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
