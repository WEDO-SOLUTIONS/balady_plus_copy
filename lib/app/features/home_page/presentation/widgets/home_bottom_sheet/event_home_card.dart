// import 'package:balady_plus/app/core/services/local/navigation_services.dart';
// import 'package:balady_plus/app/core/utils/utils_exports.dart';
// import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
// import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_bloc.dart';
// import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_event.dart';
// import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_state.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../../core/dependency_injection/injection_container.dart';
// import '../../../../_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
// import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
// import '../../../../calendar/domain/entities/search_calendar/search_calendar_item.dart';
// import '../../../../calendar/presentation/widgets/old_calendar_card.dart';
//
// class EventHomeCard extends StatelessWidget {
//   const EventHomeCard({
//     super.key,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: sl<CalendarBloc>(),
//       child: BlocBuilder<CalendarBloc, CalendarState>(
//         builder: (context, state) {
//           if (state.status == BlocStatus.loading) {
//             return const CustomShimmerWidget(
//               childHeight: 201,
//             );
//           }
//           if (state.status == BlocStatus.failure) {
//             return RetryWidget(
//               onRetry: () {
//                 context.read<CalendarBloc>().add(const GetSearchEvent());
//               },
//             );
//           }
//
//           SearchCalendarItem? item = state.searchItems.firstOrNull;
//           if (item == null) return Container();
//
//           return Column(
//             //   mainAxisSize: MainAxisSize.min,
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
//               SizedBox(
//                 height: 240,
//                 child: ListView.separated(
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   separatorBuilder: (_, __) => const SizedBox(width: 16),
//                   itemCount: ((state.searchItems.length) > 4)
//                       ? 4
//                       : state.searchItems.length,
//                   padding: const EdgeInsets.symmetric(
//                     // vertical: 8,
//                     horizontal: 16,
//                   ),
//                   itemBuilder: (context, index) {
//                     return Padding(
//                       padding: const EdgeInsets.symmetric(
//                         vertical: 16,
//                       ),
//                       child: OldCalendarCard(
//                         width: MediaQuery.of(context).size.width - 60,
//                         item: state.searchItems[index],
//                         padding: EdgeInsets.zero,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const SizedBox(
//                 height: 8,
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
