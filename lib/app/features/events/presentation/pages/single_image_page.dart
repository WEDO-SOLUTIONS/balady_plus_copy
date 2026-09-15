import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_state.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_map_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_category_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_description_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_details_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_title_location_widget.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/constants/analytics_events.dart';
import '../../../_shared_feature_/presentation/widgets/retry_widget.dart';

class SingleEventDescriptionPage extends StatefulWidget {
  const SingleEventDescriptionPage({super.key});

  @override
  State<SingleEventDescriptionPage> createState() => _SingleEventDescriptionPageState();
}

class _SingleEventDescriptionPageState extends State<SingleEventDescriptionPage> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.eventsOpenItemEvent);
  }

  String img = "";
  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider(
      create: (context) => EventsBloc()..add(GetEventsDetails(id: id)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FA),
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (img.isEmpty) img = state.eventDetails.logoUrl ?? "";
            if (state.status == BlocStatus.loading) {
              return const Center(child: CustomCircularLoadingWidget());
            }

            if (state.status == BlocStatus.failure) {
              return Center(
                child: RetryWidget(
                  onRetry: () {
                    context.read<EventsBloc>().add(GetEventsDetails(id: id));
                  },
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<EventsBloc>().add(GetEventsDetails(id: id));
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 0.0, maxHeight: 350.0),
                          child: Image.network(img, width: double.infinity, fit: BoxFit.contain),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, right: 16),
                          /*  decoration: BoxDecoration(
                            image: (img.endsWith(".svg"))
                                ? DecorationImage(
                                    image: svgProvider.Svg(
                                      img,
                                      source: svgProvider.SvgSource.network,
                                    ),
                                    fit: BoxFit.contain,
                                  )
                                : DecorationImage(
                                    image: NetworkImage(img),
                                    alignment: Alignment.topCenter,
                                    fit: BoxFit.contain,
                                  ),
                          ),*/
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      child: CircleIcon(
                                        iconSize: 24,
                                        circleSize: 36,
                                        icon: Icons.close,
                                        backgroundColor: Colors.white.withValues(alpha: 0.7),
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    /*  EventsDayMonthEvent(
                                      color: const Color(0xFF145E75),
                                      monthStyle: AppStyle.eventsMonthStyle1,
                                      dayStyle: AppStyle.eventsDayStyle1,
                                      startDay: state.eventDetails.getStartDay(),
                                      startMonth: state.eventDetails.getStartMonth(),
                                    ),*/
                                    if (state.eventDetails.getEndDateFull() != null &&
                                        state.eventDetails.getStartDateFull() != null)
                                      GestureDetector(
                                        onTap: () {
                                          if (state.eventDetails.ticketUrl != null) {
                                            safeShareText(state.eventDetails.ticketUrl ?? "", context: context);
                                          }

                                          CommonFunctions.sendAnalyticsEvent(
                                            AnalyticsEvents.eventsListClickItemShareEvent,
                                          );
                                        },
                                        child: Container(
                                          width: 36,
                                          height: 36,
                                          padding: const EdgeInsets.all(5),
                                          decoration: ShapeDecoration(
                                            color: AppColor.primary100Light,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                          child: SvgPicture.asset(IconPath.export),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                              /* const Expanded(
                                child: SizedBox(),
                              ),
                              SizedBox(
                                height: 120,
                                child: EventImageSwiper(
                                  onChange: (String img) {
                                    setState(() {
                                      this.img = img;
                                    });
                                  },
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          EventsTitleLocationWidget(
                            title: state.eventDetails.name ?? '',
                            city: state.eventDetails.city ?? '',
                          ),
                          const SizedBox(height: 16),
                          EventCategoryWidget(
                            category: [state.eventDetails.season ?? '', state.eventDetails.category ?? ''],
                          ),
                          const SizedBox(height: 16),
                          EventsDetailsWidget(
                            feesType: state.eventDetails.getFess(),
                            date: state.eventDetails.getDate(),
                            time: state.eventDetails.getTime(),
                            genre: state.eventDetails.audience ?? "",
                            website: "",
                            city: state.eventDetails.city ?? "",
                            category: state.eventDetails.category ?? "",
                            season: state.eventDetails.season ?? "",
                          ),
                          const SizedBox(height: 16),
                          EventsDescriptionWidget(description: state.eventDetails.description ?? ''),
                          const SizedBox(height: 16),
                          EventMapWidget(location: state.eventDetails.getLocation(), name: state.eventDetails.name),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedIconButtonWidget.export(
                              onPressed: () {
                                CommonFunctions.externalLaunch(state.eventDetails.ticketUrl);

                                CommonFunctions.sendAnalyticsEvent(
                                  AnalyticsEvents.eventsListClickItemMoveToDetailsEvent,
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
