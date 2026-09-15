import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/analytics_events.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../bloc/events_bloc.dart';
import '../../bloc/events_state.dart';

class EventsTitleLocationWidget extends StatelessWidget {
  const EventsTitleLocationWidget({super.key, required this.title, required this.city});
  final String title;
  final String city;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextWidget(title, textStyle: AppStyle.eventMainTitleStyle, maxLines: 10),
                  CustomVerticalSpace(height: 4),
                  Row(
                    children: [
                      SvgPicture.asset(IconPath.locationBlack),
                      SizedBox(width: 1),
                      CustomTextWidget(city, textStyle: AppStyle.eventsMainSubtitleStyle),
                    ],
                  ),
                ],
              ),
            ),
            Row(
              children: [
                InkWell(
                  onTap: () {
                    Add2Calendar.addEvent2Cal(
                      buildEvent(
                        title: state.eventDetails.name ?? "",
                        desc: state.eventDetails.description ?? "",
                        url: state.eventDetails.ticketUrl ?? "",
                        city: state.eventDetails.city ?? "",
                        startDate: state.eventDetails.getStartDateFull()!,
                        endDate: state.eventDetails.getEndDateFull()!,
                      ),
                    );

                    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.eventsListClickItemAddToCalenderEvent);
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    padding: EdgeInsets.all(5),
                    decoration: ShapeDecoration(
                      color: AppColor.primary100Light,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: SvgPicture.asset(IconPath.calendar),
                  ),
                ),
                /*  SizedBox(
                width: 8,
              ),
             if (state.eventDetails.getEndDateFull() != null &&
                  state.eventDetails.getStartDateFull() != null)
                InkWell(
                  onTap: () {
                    Add2Calendar.addEvent2Cal(
                      buildEvent(
                        title: state.eventDetails.name ?? "",
                        desc: state.eventDetails.description ?? "",
                        url: state.eventDetails.ticketUrl ?? "",
                        city: state.eventDetails.city ?? "",
                        startDate: state.eventDetails.getStartDateFull()!,
                        endDate: state.eventDetails.getEndDateFull()!,
                      ),
                    );
                  },
                  child: Container(
                    width: 36,
                    height: 36,
                    padding: EdgeInsets.all(5),
                    decoration: ShapeDecoration(
                      color: const Color(0xFFE8EFF1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: SvgPicture.asset(
                      IconPath.calendar,
                    ),
                  ),
                ),*/
              ],
            ),
          ],
        );
      },
    );
  }

  Event buildEvent({
    required String title,
    required String desc,
    required String city,
    required DateTime startDate,
    required DateTime endDate,
    required String url,
  }) {
    return Event(
      title: title,
      description: desc,
      location: city,
      startDate: startDate,
      endDate: endDate,
      allDay: false,
      iosParams: IOSParams(url: url),
    );
  }
}
