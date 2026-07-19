// import 'package:add_2_calendar/add_2_calendar.dart';
// import 'package:balady_plus/app/core/services/local/navigation_services.dart';
// import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
// import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
// import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
// import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
// import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../../core/dependency_injection/injection_container.dart';
// import '../../../../../core/utils/constants/app_style.dart';
// import '../../../../../core/utils/constants/route_names.dart';
// import '../../../../calendar/domain/entities/search_calendar/search_calendar_item.dart';
// import '../../../../calendar/presentation/bloc/calendar_bloc.dart';
// import '../../../../calendar/presentation/bloc/calendar_state.dart';
// import '../../../../calendar/presentation/widgets/calendar_image_widget.dart';
//
// class CalendarHomeItemWidget extends StatelessWidget {
//   const CalendarHomeItemWidget({
//     super.key,
//     this.padding,
//   });
//
//   final EdgeInsets? padding;
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//         value: sl<CalendarBloc>(),
//         child:
//             BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
//           var item = state.searchItems.firstOrNull;
//           if (item == null) return Container();
//           return Column(
//             children: [
//               const SizedBox(
//                 height: 16,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     CustomTextWidget(
//                       'saudi_calendar'.tr(),
//                       textStyle: AppStyle.sectionTitleStyle,
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         NavigationService.navigatorKey.currentState!
//                             .pushNamed(RouteName.calendarMainPage);
//                       },
//                       child: CustomTextWidget(
//                         "show_all".tr(),
//                         fontColor: AppColor.kGray115,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//               SizedBox(
//                 height: 200,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   padding: padding,
//                   separatorBuilder: (_, __) => const SizedBox(width: 16),
//                   itemCount: state.searchItems.length ?? 0,
//                   itemBuilder: (context, index) => GestureDetector(
//                     onTap: () {
//                       Navigator.of(context).pushNamed(
//                           RouteName.calendarDetailsPage,
//                           arguments: state.searchItems[index]);
//                     },
//                     child: Container(
//                       height: 180,
//                       width: MediaQuery.of(context).size.width - 60,
//                       margin: const EdgeInsets.symmetric(
//                         // horizontal: 16,
//                         vertical: 8,
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(14),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Color(0x4CE9EAF1),
//                             blurRadius: 40,
//                             offset: Offset(0, 10),
//                             spreadRadius: 0,
//                           ),
//                         ],
//                         image: calendarImage(
//                             item.logoURL, "assets/images/calendar_bg_home.webp"),
//                       ),
//                       child: Stack(
//                         children: [
//                           SizedBox(
//                             width: MediaQuery.of(context).size.width * 0.75,
//                             child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   CalendarTag(
//                                     text: state.searchItems[index].type ?? "",
//                                   ),
//                                   const SizedBox(
//                                     height: 8,
//                                   ),
//                                   CustomTextWidget(
//                                     state.searchItems[index].name ?? "",
//                                     fontColor: const Color(0xFF3F3F46),
//                                     fontSize: 14,
//                                     fontWeight: AppFontWeight.bold,
//                                     height: 1.4,
//                                     maxLines: 2,
//                                   ),
//                                   const SizedBox(
//                                     height: 8,
//                                   ),
//                                   CustomTextWidget(
//                                     state.searchItems[index].getDate(),
//                                     fontColor: const Color(0xFF71717A),
//                                     fontSize: 12,
//                                     fontWeight: AppFontWeight.bold,
//                                     height: 1.4,
//                                     maxLines: 2,
//                                   ),
//                                   const SizedBox(
//                                     height: 10,
//                                   ),
//                                   SizedBox(
//                                     width: 130,
//                                     child: ElevatedButtonWidget.primaryCustom(
//                                         height: 40,
//                                         onPressed: () {
//                                           Add2Calendar.addEvent2Cal(
//                                             buildEvent(
//                                               title: state.searchItems[index]
//                                                       .name ??
//                                                   "",
//                                               startDate: state
//                                                   .searchItems[index]
//                                                   .startDate!,
//                                               endDate: (state.searchItems[index]
//                                                       .endDate) ??
//                                                   (state.searchItems[index]
//                                                       .startDate!),
//                                             ),
//                                           );
//                                         },
//                                         fontSize: 12,
//                                         text: "saudi_calendar_add".tr()),
//                                   )
//                                 ]),
//                           ),
//                           if (item.timeToStartInDays != null)
//                             RemainingDaysWidget(
//                               dayNo: item.timeToStartInDays!,
//                             )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }));
//   }
//
//   Event buildEvent({
//     required String title,
//     required DateTime startDate,
//     required DateTime endDate,
//   }) {
//     return Event(
//       title: title,
//       startDate: startDate,
//       endDate: endDate,
//       allDay: false,
//     );
//   }
// }
//
// class CalendarTag extends StatelessWidget {
//   final String text;
//   const CalendarTag({super.key, required this.text});
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 24,
//       padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
//       decoration: ShapeDecoration(
//         color: const Color(0x11145E75),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
//       ),
//       child: CustomTextWidget(
//         text,
//         fontColor: AppColor.primary900Light,
//         fontSize: 12,
//         fontWeight: AppFontWeight.semiBold,
//         textAlign: TextAlign.center,
//       ),
//     );
//   }
// }
//
// class RemainingDaysWidget extends StatelessWidget {
//   final int dayNo;
//   const RemainingDaysWidget({super.key, required this.dayNo});
//
//   @override
//   Widget build(BuildContext context) {
//     return Align(
//       alignment: Alignment.topLeft,
//       child: Container(
//         width: 65,
//         height: 76,
//         padding: const EdgeInsets.all(9),
//         decoration: ShapeDecoration(
//             color: AppColor.secondary900Light,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12))),
//         child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               CustomTextWidget(
//                 "remaining".tr(),
//                 fontColor: AppColor.white,
//                 fontSize: 12,
//                 fontWeight: AppFontWeight.medium,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 4,
//               ),
//               CustomTextWidget(
//                 dayNo.toString(),
//                 fontColor: AppColor.white,
//                 fontSize: 26,
//                 fontWeight: AppFontWeight.bold,
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 2,
//               ),
//               CustomTextWidget(
//                 "saudi_calendar_day_text".tr(),
//                 fontColor: AppColor.white,
//                 fontSize: 12,
//                 fontWeight: AppFontWeight.medium,
//                 textAlign: TextAlign.center,
//               ),
//             ]),
//       ),
//     );
//   }
// }
