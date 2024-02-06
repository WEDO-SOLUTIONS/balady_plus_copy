import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
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
          child: Column(children: [
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
            const SizedBox(
              height: 20,
            ),
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
            const BaladyCalendarEvents(),
          ]),
        ),
      ),
    );
  }
}

class BaladyCalendarEvents extends StatefulWidget {
  const BaladyCalendarEvents({
    super.key,
  });

  @override
  State<BaladyCalendarEvents> createState() => _BaladyCalendarEventsState();
}

class _BaladyCalendarEventsState extends State<BaladyCalendarEvents> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [Text('سبتمبر'), Text('(1)')],
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 120,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: AppColor.white10,
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 10,
              decoration: const BoxDecoration(
                  color: AppColor.darkRed,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
            ),
            const SizedBox(
              width: 10,
            ),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('رخصة تجارية'),
                Text('انتهاء صلاخية الفاتورة 45891562')
              ],
            ),
            const Spacer(),
            const Text('الثلاثاء 14'),
            const SizedBox(
              width: 10,
            )
          ]),
        ),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Text('اكتوبر'), Text('(2)')],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.white10,
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 10,
                  decoration: const BoxDecoration(
                      color: AppColor.primary700Light,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('رخصة تجارية'),
                    Text('انتهاء صلاخية الفاتورة 45891562')
                  ],
                ),
                const Spacer(),
                const Text('الثلاثاء 14'),
                const SizedBox(
                  width: 10,
                )
              ]),
            ),
            const SizedBox(
              height: 15,
            ),
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.white10,
              ),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 10,
                  decoration: const BoxDecoration(
                      color: AppColor.darkYellow,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15))),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('رخصة تجارية'),
                    Text('انتهاء صلاخية الفاتورة 45891562')
                  ],
                ),
                const Spacer(),
                const Text('الثلاثاء 14'),
                const SizedBox(
                  width: 10,
                )
              ]),
            )
          ],
        ),
      ],
    );
  }
}
