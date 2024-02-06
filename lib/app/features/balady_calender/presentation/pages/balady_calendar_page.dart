import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/balady_calendar_events_widget.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/calendar_filter_popup.dart';
import 'package:balady_plus/app/features/balady_calender/presentation/widgets/calendar_type_popup.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class BaladyCalendarPage extends StatefulWidget {
  const BaladyCalendarPage({super.key});

  @override
  State<BaladyCalendarPage> createState() => _BaladyCalendarPageState();
}

class _BaladyCalendarPageState extends State<BaladyCalendarPage> {
  int selectedYearIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              // AppBar
              Row(
                children: [
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: CircleIcon(
                      icon: Icons.close,
                      iconColor: AppColor.primary600Light,
                      backgroundColor: AppColor.geyser.withOpacity(0.5),
                      iconSize: 18,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  CustomTextWidget(
                    "balady_calendar".tr(),
                    textStyle: AppStyle.appBarTitleTextStyle,
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await CustomPopUpsWidgets.showBottomSheet(context,
                          child: const CalendarTypePopup(),
                          height: 300,
                          radius: 30);
                    },
                    child: Container(
                      height: 60,
                      width: 110,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppColor.white10,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Row(children: [
                        SvgPicture.asset(
                          ImagePath.baladyCalendar,
                          width: 25,
                          height: 25,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        CustomTextWidget(
                          "gregorian".tr(),
                          textStyle: AppStyle.mainTextStyle,
                        ),
                      ]),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await CustomPopUpsWidgets.showBottomSheet(context,
                          child: const CalendarFilterPopup(),
                          height: 550,
                          radius: 30);
                    },
                    child: Container(
                      height: 60,
                      width: 60,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColor.white10,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: SvgPicture.asset(
                        ImagePath.filter,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              // Years
              SizedBox(
                height: 85,
                width: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedYearIndex = index;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            color: selectedYearIndex == index
                                ? AppColor.primary700Light
                                : AppColor.white5),
                        width: 80,
                        child: Column(children: [
                          Text(
                            2023.toString(),
                            style: TextStyle(
                                color: selectedYearIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          ),
                          Text(
                            '(2)',
                            style: TextStyle(
                                color: selectedYearIndex == index
                                    ? Colors.white
                                    : Colors.black),
                          )
                        ]),
                      ),
                    );
                  },
                ),
              ),
              const Expanded(child: BaladyCalendarEventsWidget()),
            ],
          ),
        ),
      ),
    );
  }
}
