import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_state.dart';
import 'package:balady_plus/app/features/events/presentation/pages/single_image_page.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_activities.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_end_date.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_start_day_month.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_start_date.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_title_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class EventsSectionWidget extends StatelessWidget {
  const EventsSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        return RefreshIndicator(
          onRefresh: () async {
            context.read<EventsBloc>().add(const GetSearchEvent());
          },
          child: ListView.builder(
            itemCount: state.searchItems.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.eventsDetailsPage,
                      arguments: state.searchItems[index].id);
                },
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.fill,
                          image: AssetImage(ImagePath.eventsImage1),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                EventsActivitiesWidget(
                                  category:
                                      state.searchItems[index].category ?? '',
                                ),
                                state.searchItems[index].getStartMonth() ==
                                        state.searchItems[index].getEndMonth()
                                    ? EventsStartDateEvent(
                                        month: state.searchItems[index]
                                            .getStartMonth(),
                                        day1: state.searchItems[index]
                                            .getStartDay(),
                                        day2: state.searchItems[index]
                                            .getEndDay(),
                                      )
                                    : EventsEndDate(
                                        month1: state.searchItems[index]
                                            .getStartMonth(),
                                        month2: state.searchItems[index]
                                            .getEndMonth(),
                                        day1: state.searchItems[index]
                                            .getStartDay(),
                                        day2: state.searchItems[index]
                                            .getEndDay(),
                                      ),
                              ]),
                          EventsTitlePriceWidget(
                            address: state.searchItems[index].city ?? "",
                            title: state.searchItems[index].eventName ?? "",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
