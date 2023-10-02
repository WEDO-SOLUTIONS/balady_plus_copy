import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../../calendar/domain/entities/search_calendar/search_calendar_item.dart';

class EventHomeCard extends StatelessWidget {
  const EventHomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<CalendarBloc>(),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        builder: (context, state) {
          if (state.status == BlocStatus.loading)
            return CustomShimmerWidget(
              childHeight: 201,
            );
          if (state.status == BlocStatus.failure)
            return RetryWidget(
              onRetry: () {
                context.read<CalendarBloc>().add(GetSearchEvent());
              },
            );

          SearchCalendarItem? item = state.searchItems.firstOrNull;
          if (item == null) return Container();
          return Container(
            padding: EdgeInsets.all(16),
            height: 201,
            child: Stack(
              children: [
                CustomNetworkImageWidget(
                  item.logoURL ?? "",
                  imageHeight: 201,
                  placeHolderWidget: Container(color: Colors.white),
                ),
                /* Positioned(
                  top: 15,
                  left: 18,
                  child: CircleAvatar(
                    backgroundColor: const Color(0xA5F7FFFD),
                    radius: 24,
                    child: SvgPicture.asset(IconPath.notification),
                  ),
                ),*/
                Positioned(
                  bottom: 10,
                  left: 15,
                  child: SaudiContainer(
                    btnText: "saudi_calendar_add".tr(),
                    remainingText: item.remainingText() ?? "",
                    timer: item.remainingDays(),
                    addToCalendar: () {
                      Add2Calendar.addEvent2Cal(
                        buildEvent(
                          title: item.name ?? "",
                          startDate: item.startDate!,
                          endDate: item.endDate!,
                        ),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 15,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SaudiDay(
                        name: item.getStartDayName(),
                        size: 14,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          SaudiDay(
                            name: item.startDate?.month.toString() ?? "",
                            size: 20,
                          ),
                          SaudiDay(
                            name: '  / ',
                            size: 20,
                          ),
                          SaudiDay(
                            name: item.startDate?.day
                                    .toString()
                                    .padLeft(2, "0") ??
                                "",
                            size: 28,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 4,
                      ),
                      SaudiDay(
                        name: item.name ?? "",
                        size: 20,
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

class SaudiDay extends StatelessWidget {
  final String name;
  final double size;
  const SaudiDay({super.key, required this.name, required this.size});

  @override
  Widget build(BuildContext context) {
    return CustomTextWidget(
      name,
      fontColor: const Color(0xFF145E75),
      fontSize: size,
      fontWeight: AppFontWeight.bold,
    );
  }
}

class SaudiContainer extends StatelessWidget {
  final String remainingText;
  final String timer;
  final String btnText;
  final Function addToCalendar;
  const SaudiContainer(
      {super.key,
      required this.remainingText,
      required this.timer,
      required this.btnText,
      required this.addToCalendar});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 315,
      height: 66,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: CustomTextWidget(
                    "remaining".tr(),
                    fontColor: Color(0xFF145E75),
                    fontSize: 11.28,
                    maxLines: 3,
                    fontWeight: AppFontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                CustomTextWidget(
                  timer,
                  fontColor: Color(0xFF145E75),
                  fontSize: 26.33,
                  fontWeight: AppFontWeight.bold,
                ),
              ],
            ),
          ),
          SizedBox(
            width: 32,
          ),
          ElevatedButton(
            onPressed: () => addToCalendar(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColor.primary900Light,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: CustomTextWidget(
              btnText,
              textAlign: TextAlign.center,
              fontColor: Colors.white,
              fontSize: 11.80,
              fontWeight: AppFontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

Event buildEvent({
  required String title,
  required DateTime startDate,
  required DateTime endDate,
}) {
  return Event(
    title: title,
    startDate: startDate,
    endDate: endDate,
    allDay: false,
  );
}
