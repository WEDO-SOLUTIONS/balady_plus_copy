import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../events/domain/entities/search_events/search_events_item.dart';
import '../../../../../events/presentation/bloc/events_bloc.dart';
import '../../../../../events/presentation/bloc/events_event.dart';
import '../../../../../events/presentation/bloc/events_state.dart';
import '../../../../presentation/widgets/custom_shimmer_list_widget.dart';
import 'events_item_card.dart';

class EventsHomeCard extends StatelessWidget {
  const EventsHomeCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: sl<EventsBloc>(),
      child: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state.status == BlocStatus.loading)
            return CustomShimmerWidget(
              childHeight: 201,
            );
          if (state.status == BlocStatus.failure)
            return RetryWidget(
              onRetry: () {
                context.read<EventsBloc>().add(GetSearchEvent());
              },
            );

          SearchEventsItem? item = state.searchItems.firstOrNull;
          if (item == null) return Container();

          return Column(
            //   mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 16,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomTextWidget(
                      'events'.tr(),
                      textStyle: AppStyle.sectionTitleStyle,
                    ),
                    GestureDetector(
                      onTap: () {
                        NavigationService.navigatorKey.currentState!
                            .pushNamed(RouteName.eventsMainPage);
                      },
                      child: CustomTextWidget(
                        "show_all".tr(),
                        fontColor: AppColor.kGray115,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 240,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemCount: ((state.searchItems.length) > 4)
                      ? 4
                      : state.searchItems.length,
                  padding: EdgeInsets.only(
                    top: 8,
                    bottom: 8,
                    left: 16,
                  ),
                  itemBuilder: (context, index) {
                    return Container(
                        child: EventItemCard(
                            width: MediaQuery.of(context).size.width - 60,
                            padding: EdgeInsets.only(top: 16, right: 16),
                            item: state.searchItems[index]));
                  },
                ),
              ),
              SizedBox(
                height: 8,
              ),
            ],
          );
        },
      ),
    );
  }
}
