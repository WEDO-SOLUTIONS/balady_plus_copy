// import 'package:add_2_calendar/add_2_calendar.dart';
// import 'package:balady_plus/app/core/utils/common_functions.dart';
// import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
// import 'package:balady_plus/app/features/calendar/domain/entities/search_calendar/search_calendar_item.dart';
// import 'package:balady_uikit/core/colors/app_color_scheme.dart';
// import 'package:balady_uikit/core/extensions/build_context_ext.dart';
// import 'package:flutter/material.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
// import 'package:mapness/_generated/assets/assets.gen.dart';
//
// class CalendarHomeItemCard extends StatelessWidget {
//   final SearchCalendarItem item;
//   final double? width;
//   final EdgeInsets? padding;
//   final AppColorScheme colorScheme;
//
//   const CalendarHomeItemCard({
//     super.key,
//     required this.item,
//     this.width,
//     this.padding,
//     required this.colorScheme,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final dayString = StringBuffer();
//     dayString.write(item.startDate?.month.toString().padLeft(2, "0") ?? "");
//     dayString.write('/');
//     dayString.write(item.startDate?.day.toString().padLeft(2, "0") ?? "");
//
//     final dayStyle = context.textStyle.heading2.copyWith(
//       color: Colors.white,
//       height: 1.5,
//     );
//     final nameStyle = context.textStyle.footNote.copyWith(
//       color: Colors.white,
//       height: 1.5,
//     );
//
//     return Container(
//       margin: padding ?? const EdgeInsets.only(top: 16, left: 16, right: 16),
//       height: 200,
//       width: width ?? MediaQuery.of(context).size.width - 32,
//       padding: const EdgeInsets.only(left: 16, right: 24, top: 12, bottom: 16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         image: DecorationImage(
//           matchTextDirection: true,
//           image: AssetImage(
//             colorScheme == AppColorScheme.brown
//               ? Assets.images.calendarCardBrown.keyName
//               : Assets.images.calendarCard.keyName),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(item.getStartDayName(), maxLines: 2, style: dayStyle),
//               Text(dayString.toString(), maxLines: 2, style: dayStyle),
//               Text((item.name ?? ""), maxLines: 2, style: nameStyle),
//             ],
//           ),
//           SaudiContainer(
//             btnText: "saudi_calendar_add".tr(),
//             remainingText: "remaining".tr(),
//             timer: item.remainingDays(),
//             addToCalendar: addToCalendar,
//           ),
//         ],
//       ),
//     );
//   }
//
//   void addToCalendar() {
//     CommonFunctions.sendUXCamEvent(
//       UXCamEvents.KingdomCalendar_List_AddToCalender_Event,
//     );
//     Add2Calendar.addEvent2Cal(
//       Event(
//         title: item.name ?? "",
//         startDate: item.startDate!,
//         endDate: item.endDate!,
//         allDay: false,
//       ),
//     );
//   }
// }
//
// class SaudiContainer extends StatelessWidget {
//   final String remainingText;
//   final String timer;
//   final String btnText;
//   final Function addToCalendar;
//
//   const SaudiContainer({
//     super.key,
//     required this.remainingText,
//     required this.timer,
//     required this.btnText,
//     required this.addToCalendar,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final remainingStyle = context.textStyle.footNote.copyWith(color: Colors.white);
//     final timerStyle = context.textStyle.callout.copyWith(color: Colors.white);
//     final buttonTextStyle = context.textStyle.callout.copyWith(
//       color: context.color.textAndIconsStatusAccent,
//     );
//     final borderRadius = BorderRadius.circular(8);
//
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Flexible(
//               child: Text(
//                 remainingText,
//                 maxLines: 4,
//                 style: remainingStyle,
//               ),
//             ),
//             Text(timer, style: timerStyle),
//           ],
//         ),
//         Material(
//           color: Colors.white,
//           borderRadius: borderRadius,
//           child: InkWell(
//             borderRadius: borderRadius,
//             onTap: () => addToCalendar(),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//               child: Text(
//                 btnText,
//                 textAlign: TextAlign.center,
//                 style: buttonTextStyle,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
