import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_state.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_image_swiper.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_map_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_category_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_description_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_details_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_title_location_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_start_day_month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SingleEventDescriptionPage extends StatefulWidget {
  const SingleEventDescriptionPage({Key? key}) : super(key: key);

  @override
  State<SingleEventDescriptionPage> createState() =>
      _SingleEventDescriptionPageState();
}

class _SingleEventDescriptionPageState
    extends State<SingleEventDescriptionPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  @override
  Widget build(BuildContext context) {
    String id = ModalRoute.of(context)!.settings.arguments as String;

    return BlocProvider(
      create: (context) => EventsBloc()..add(GetEventsDetails(id: id)),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FA),
        body: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            if (state.status == BlocStatus.loading)
              return Center(child: CustomCircularLoadingWidget());

            return RefreshIndicator(
              onRefresh: () async {
                context.read<EventsBloc>().add(GetEventsDetails(id: id));
              },
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      height: 455,
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top,
                        right: 16,
                      ),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(state.eventDetails.logoUrl ?? ""),
                          fit: BoxFit.fill,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                child: SvgPicture.asset(
                                  IconPath.vdAppBarBack,
                                ),
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              EventsDayMonthEvent(
                                color: const Color(0xFF145E75),
                                monthStyle: AppStyle.eventsMonthStyle1,
                                dayStyle: AppStyle.eventsDayStyle1,
                                startDay: state.eventDetails.getStartDay(),
                                startMonth: state.eventDetails.getStartMonth(),
                              ),
                            ],
                          ),
                          const Expanded(
                            child: SizedBox(),
                          ),
                          SizedBox(
                            height: 120,
                            child: EventImageSwiper(),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        children: [
                          EventsTitleLocationWidget(
                            title: state.eventDetails.name ?? '',
                            city: state.eventDetails.city ?? '',
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          EventCategoryWidget(
                            category: [
                              state.eventDetails.season ?? '',
                              state.eventDetails.category ?? ''
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          EventsDetailsWidget(
                            feesType: state.eventDetails.getFess() ?? '',
                            date: state.eventDetails.getDate(),
                            time: state.eventDetails.getTime(),
                            genre: state.eventDetails.audience ?? "",
                            website: "",
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          EventsDescriptionWidget(
                              description:
                                  state.eventDetails.description ?? ''),
                          const SizedBox(
                            height: 16,
                          ),
                          EventMapWidget(
                            location: state.eventDetails.getLocation(),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          ElevatedIconButtonWidget.export(
                            onPressed: () {
                              CommonFunctions.externalLaunch(
                                  state.eventDetails.ticketUrl);
                            },
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
