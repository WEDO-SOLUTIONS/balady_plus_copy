import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_state.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_activities.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_end_date.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_title_price.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;

import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../pages/events_not_found_page.dart';
import '../old_event_card.dart';

class EventsSectionWidget extends StatefulWidget {
  const EventsSectionWidget({super.key});

  @override
  State<EventsSectionWidget> createState() => _EventsSectionWidgetState();
}

class _EventsSectionWidgetState extends State<EventsSectionWidget> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      context.read<EventsBloc>().add(GetMoreSearchEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        if (state.status == BlocStatus.loading) {
          return CustomShimmerListWidget(height: 189, itemCount: 10);
        }
        if (state.status == BlocStatus.success && state.searchItems.isEmpty) {
          return EventsNotFoundPage();
        }

        if (state.status == BlocStatus.retry) {
          return ReloadWidget(
            onTab: () {
              context.read<EventsBloc>().add(const GetSearchEvent());
            },
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            context.read<EventsBloc>().add(const GetSearchEvent());
          },
          child: ListView.builder(
            controller: _scrollController,
            itemCount: state.searchItems.length + 1,
            itemBuilder: (context, index) {
              if (index >= (state.searchItems.length)) {
                if (state.status == BlocStatus.loadMore) {
                  return const SizedBox(height: 50, child: Center(child: CustomCircularLoadingWidget()));
                } else {
                  return Container(height: 50);
                }
              }

              return GestureDetector(
                onTap: () {
                  NavigationService.navigatorKey.currentState!.pushNamed(
                    RouteName.eventsDetailsPage,
                    arguments: state.searchItems[index].id,
                  );
                },
                child: OldEventHomeCard(item: state.searchItems[index]),
              );
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, RouteName.eventsDetailsPage, arguments: state.searchItems[index].id);
                },
                child: Column(
                  children: [
                    Container(
                      height: 180,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: (state.searchItems[index].logoImage?.endsWith(".svg") ?? false)
                            ? DecorationImage(
                                image: svgProvider.Svg(
                                  state.searchItems[index].logoImage ?? "",
                                  source: svgProvider.SvgSource.network,
                                ),
                                fit: BoxFit.fill,
                              )
                            : DecorationImage(
                                image: NetworkImage(state.searchItems[index].logoImage ?? ""),
                                fit: BoxFit.fill,
                              ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              EventsActivitiesWidget(category: state.searchItems[index].category ?? ''),
                              //  state.searchItems[index].getStartMonth() ==
                              //       state.searchItems[index].getEndMonth()
                              /*   ? 
                                    EventsStartDateEvent(
                                        month: state.searchItems[index]
                                            .getStartMonth(),
                                        day1: state.searchItems[index]
                                            .getStartDay(),
                                        day2: state.searchItems[index]
                                            .getEndDay(),
                                      )*/
                              //:
                              EventsEndDate(
                                month1: state.searchItems[index].getStartMonth(),
                                month2: state.searchItems[index].getEndMonth(),
                                year1: state.searchItems[index].startDate?.year.toString() ?? "",
                                year2: state.searchItems[index].endDate?.year.toString() ?? "",
                                day1: state.searchItems[index].getStartDay(),
                                day2: state.searchItems[index].getEndDay(),
                              ),
                            ],
                          ),
                          EventsTitlePriceWidget(
                            address: state.searchItems[index].city ?? "",
                            title: state.searchItems[index].eventName ?? "",
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
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
