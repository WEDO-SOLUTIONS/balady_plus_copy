import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_image_swiper.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_map_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_category_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_description_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_details_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_title_location_widget.dart';
import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_day_month.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class SingleEventDescriptionPage extends StatelessWidget {
  const SingleEventDescriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> category = [
      "ola_moment".tr(),
      "nature".tr(),
    ];
  
    return Scaffold(
      backgroundColor: const Color(0xFFF5F8FA),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 455,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(ImagePath.elephantStone),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SvgPicture.asset(
                          IconPath.vdAppBarBack,
                        ),
                        EventsDayMonthEvent(
                          color: const Color(0xFF145E75),
                          monthStyle: AppStyle.eventsMonthStyle1,
                          dayStyle: AppStyle.eventsDayStyle1,
                        ),
                      ],
                    ),
                    const Expanded(
                      child: SizedBox(),
                    ),
                    SizedBox(
                      height: 120,
                      child: EventImageSwiper(
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    EventsTitleLocationWidget(
                      title: 'elephant_stone'.tr(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    EventCategoryWidget(
                      category: category,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const EventsDetailsWidget(),
                    const SizedBox(
                      height: 16,
                    ),
                    EventsDescriptionWidget(
                      description: 'events_description_subtitle'.tr(),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    const EventMapWidget(),
                    const SizedBox(
                      height: 16,
                    ),
                    ElevatedIconButtonWidget.export(
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
