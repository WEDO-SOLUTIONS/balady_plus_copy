import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart' as svgProvider;
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../facility_qr/presentation/pages/facility_photos_screen.dart';
import '../../domain/entities/search_calendar/search_calendar_item.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_state.dart';
import '../widgets/calendar_image_widget.dart';

class CalendarDetailsPage extends StatefulWidget {
  const CalendarDetailsPage({Key? key}) : super(key: key);

  @override
  State<CalendarDetailsPage> createState() => _CalendarDetailsPageState();
}

class _CalendarDetailsPageState extends State<CalendarDetailsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {});
  }

  String img = "";
  @override
  Widget build(BuildContext context) {
    SearchCalendarItem params =
        ModalRoute.of(context)!.settings.arguments as SearchCalendarItem;

    return BlocProvider(
      create: (context) =>
          CalendarBloc()..add(GetCalendarDetailsEvent(id: params.id ?? "")),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F8FA),
        body: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            if (img.isEmpty) img = state.details?.logoUrl ?? "";
            if (state.status == BlocStatus.loading)
              return Center(child: CustomCircularLoadingWidget());

            if (state.status == BlocStatus.failure)
              return Center(child: RetryWidget(
                onRetry: () {
                  context
                      .read<CalendarBloc>()
                      .add(GetCalendarDetailsEvent(id: params.id ?? ""));
                },
              ));

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<CalendarBloc>()
                    .add(GetCalendarDetailsEvent(id: params.id ?? ""));
              },
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Image.asset(
                            "assets/images/calendar_details_bg.png",
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: MediaQuery.of(context).padding.top + 16,
                                right: 16,
                                left: 16),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      child: SvgPicture.asset(
                                        IconPath.vdAppBarBack,
                                        color: Colors.white,
                                      ),
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Add2Calendar.addEvent2Cal(
                                          buildEvent(
                                            title: params.name ?? "",
                                            startDate: params.startDate!,
                                            endDate: (params.endDate) ??
                                                (params.startDate!),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        width: 36,
                                        height: 36,
                                        padding: EdgeInsets.all(5),
                                        decoration: ShapeDecoration(
                                          color: AppColor.primary100Light,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        child: SvgPicture.asset(
                                          IconPath.calendar,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                CustomVerticalSpace(height: 27),
                                CustomTextWidget(state.details?.name ?? "",
                                    fontWeight: AppFontWeight.bold,
                                    height: 1.4,
                                    fontSize: 20,
                                    fontColor: AppColor.white),
                                CustomVerticalSpace(height: 12),
                                CalendarTag(text: params.type ?? "")
                              ],
                            ),
                          ),
                        ],
                      ),
                      const CustomVerticalSpace(height: 21),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                "saudi_calendar_intro".tr(),
                                fontWeight: AppFontWeight.bold,
                                fontSize: 18,
                                fontColor: AppColor.black,
                              ),
                              const CustomVerticalSpace(height: 10),
                              CustomTextWidget(state.details?.description ?? "",
                                  fontWeight: AppFontWeight.medium,
                                  height: 1.4,
                                  fontSize: 14,
                                  fontColor: Color(0xff71717A)),
                              const CustomVerticalSpace(height: 24),
                              CalendarDetailsItem(),
                              const CustomVerticalSpace(height: 24),
                              if ((state.details?.pictures?.length ?? 0) >
                                  0) ...[
                                CustomTextWidget(
                                  "saudi_calendar_type_photos".tr(),
                                  fontWeight: AppFontWeight.bold,
                                  fontSize: 18,
                                  fontColor: AppColor.black,
                                ),
                                const CustomVerticalSpace(height: 24),
                                StaggredCalendarPhotos()
                              ]
                            ],
                          ),
                        ),
                      )
                    ]),
              ),
            );
          },
        ),
      ),
    );
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
}

class CalendarDetailsItem extends StatelessWidget {
  const CalendarDetailsItem({super.key});

  @override
  Widget build(BuildContext context) {
    SearchCalendarItem params =
        ModalRoute.of(context)!.settings.arguments as SearchCalendarItem;

    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return Container(
        height: 93,
        padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextWidget("saudi_calendar_type_date".tr(),
                    fontWeight: AppFontWeight.bold,
                    height: 1.4,
                    fontSize: 14,
                    fontColor: AppColor.black),
                CustomVerticalSpace(height: 12),
                CustomTextWidget(
                  params.getDate(),
                  fontColor: const Color(0xFF71717A),
                  fontSize: 12,
                  fontWeight: AppFontWeight.bold,
                  height: 1.4,
                  maxLines: 2,
                ),
              ],
            ),
            if (params.timeToStartInDays != null)
              RemainingDaysWidget(
                dayNo: params.timeToStartInDays!,
              )
          ],
        ),
      );
    });
  }
}

class RemainingDaysWidget extends StatelessWidget {
  final int dayNo;
  const RemainingDaysWidget({super.key, required this.dayNo});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 60,
        height: 71,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(0.76, 0.64),
            end: Alignment(-0.76, -0.64),
            colors: [Color(0xFF65C1C0), Color(0xFFA6D377)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextWidget(
                "remaining".tr(),
                fontColor: AppColor.white,
                fontSize: 12,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 4,
              ),
              CustomTextWidget(
                dayNo.toString(),
                fontColor: AppColor.white,
                fontSize: 26,
                fontWeight: AppFontWeight.bold,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 4,
              ),
              CustomTextWidget(
                "saudi_calendar_day_text".tr(),
                fontColor: AppColor.white,
                fontSize: 12,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.center,
              ),
            ]),
      ),
    );
  }
}

class StaggredCalendarPhotos extends StatelessWidget {
  const StaggredCalendarPhotos({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
      return Container(
        height: 300,
        child: Container(
          margin: const EdgeInsetsDirectional.only(end: 16),
          child: SingleChildScrollView(
            child: StaggeredGrid.count(
              crossAxisCount: 4,
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              children: List<Widget>.generate(
                  state.details?.pictures?.length ?? 0, (index) {
                return StaggeredGridTile.fit(
                  child: CustomNetworkImageWidget(
                      state.details?.pictures?[index].url ?? ""),
                  crossAxisCellCount: 2,
                );
              }),
            ),
          ),
        ),
      );
    });
  }
}

class CalendarTag extends StatelessWidget {
  final String text;
  const CalendarTag({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: ShapeDecoration(
        color: Color(0xFFC1D6AB),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      ),
      child: CustomTextWidget(
        text,
        fontColor: AppColor.primary900Light,
        fontSize: 12,
        fontWeight: AppFontWeight.semiBold,
        textAlign: TextAlign.center,
      ),
    );
  }
}
