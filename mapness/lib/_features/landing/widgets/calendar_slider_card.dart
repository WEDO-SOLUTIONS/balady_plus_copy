import 'dart:math';

import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/calendar/domain/entities/search_calendar/search_calendar_item.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_state.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_shimmer_widget.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/landing/widgets/slider_list_view.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class CalendarSliderCard extends StatelessWidget {
  final VoidCallback? onShowAll;
  final AppColorScheme colorScheme;

  const CalendarSliderCard({
    required this.colorScheme,
    super.key,
    this.onShowAll,
  });

  @override
  Widget build(BuildContext context) => BlocProvider.value(
        value: sl<CalendarBloc>(),
        child: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            if (state.status == BlocStatus.loading) {
              return const CustomShimmerWidget(
                childHeight: 132,
                padding: EdgeInsets.symmetric(horizontal: Spacing.$4x),
              );
            }

            if (state.status == BlocStatus.failure) {
              return RetryWidget(
                onRetry: () {
                  context.read<CalendarBloc>().add(const GetSearchEvent());
                },
              );
            }

            if (state.searchItems.firstOrNull == null) {
              return const SizedBox.shrink();
            }

            return SliderListView(
              items: state.searchItems,
              contentHeight: 132,
              itemBuilder: (item) => _CalendarCard(item),
            );
          },
        ),
      );
}

class _CalendarCard extends StatelessWidget {
  final SearchCalendarItem item;

  const _CalendarCard(this.item);

  void addToCalendar() {
    CommonFunctions.sendUXCamEvent(UXCamEvents.KingdomCalendar_List_AddToCalender_Event);
    Add2Calendar.addEvent2Cal(Event(
      title: item.name ?? '',
      startDate: item.startDate!,
      endDate: item.endDate!,
    ));
  }

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF9DC96C), Color(0xFF6FA03B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Transform(
                  alignment: Alignment.center,
                  transform: context.isLTR ? Matrix4.identity() : Matrix4.rotationY(pi),
                  child: SvgPicture.asset(
                    'assets/images_svg/palm_outline.svg',
                    package: PackageConfig.packageName,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: Spacing.$5x, start: Spacing.$6x),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name ?? '',
                      maxLines: 2,
                      style: context.textStyleV3.h3SemiBold.copyWith(
                        color: context.colorsV2.staticWhite,
                      ),
                    ),
                    const SizedBox(height: Spacing.$1x + Spacing.$0_5x),
                    Text(
                      item.startDate?.toWrittenDate() ?? '',
                      maxLines: 2,
                      style: context.textStyleV3.bodySmallRegular.copyWith(
                        color: context.colorsV2.staticWhite,
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: Spacing.$6x, right: Spacing.$6x, bottom: Spacing.$6x),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        item.type ?? '',
                        maxLines: 2,
                        style: context.textStyleV3.bodySmallRegular.copyWith(
                          color: context.colorsV2.staticWhite,
                        ),
                      ),
                      SizedBox(
                        width: 40,
                        height: 40,
                        child: GestureDetector(
                          onTap: addToCalendar,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: context.colorsV2.staticWhite.withOpacity(0.25),
                              borderRadius: BorderRadius.circular(RadiusBorder.m),
                            ),
                            child: const Center(
                              child: Icon(SystemIcons.calendarPlus, color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
