// import 'package:balady_plus/app/core/utils/constants/app_style.dart';
// import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
// import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
// import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_icon_button_widgets.dart';
// import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
// import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
// import 'package:balady_plus/app/features/events/presentation/bloc/events_state.dart';
// import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_image_swiper.dart';
// import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/event_map_widget.dart';
// import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_category_widget.dart';
// import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_description_widget.dart';
// import 'package:balady_plus/app/features/events/presentation/widgets/event_description_widgets.dart/events_title_location_widget.dart';
// import 'package:balady_plus/app/features/events/presentation/widgets/events_main_page_widgets/events_start_day_month.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class EventsDetailsSection extends StatelessWidget {
//   const EventsDetailsSection({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<EventsBloc, EventsState>(
//       builder: (context, state) {
//         return RefreshIndicator(
//           onRefresh: () async {
//             context.read<EventsBloc>().add(const GetEventsDetails());
//           },
//           child: SizedBox(
//             height: 100,
//             child: ListView.builder(
//               itemCount: 1,
//               itemBuilder: (context, index) {
//                 return Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   children: [
//                     Container(
//                       height: 455,
//                       decoration: const BoxDecoration(
//                         image: DecorationImage(
//                           image: AssetImage(ImagePath.elephantStone),
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                       child: Column(
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SvgPicture.asset(
//                                 IconPath.vdAppBarBack,
//                               ),
//                               EventsDayMonthEvent(
//                                 color: const Color(0xFF145E75),
//                                 monthStyle: AppStyle.eventsMonthStyle1,
//                                 dayStyle: AppStyle.eventsDayStyle1,
//                               ),
//                             ],
//                           ),
//                           const Expanded(
//                             child: SizedBox(),
//                           ),
//                           SizedBox(
//                             height: 120,
//                             child: EventImageSwiper(),
//                           ),
//                         ],
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(15.0),
//                       child: Column(
//                         children: [
//                           EventsTitleLocationWidget(
//                             title: 'title',
//                           ),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           EventCategoryWidget(
//                             category: state.eventDetails!.category ?? '',
//                           ),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           //const EventsDetailsWidget(),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           EventsDescriptionWidget(
//                               description:
//                                   state.eventDetails!.description ?? ''),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           const EventMapWidget(),
//                           const SizedBox(
//                             height: 16,
//                           ),
//                           ElevatedIconButtonWidget.export(
//                             onPressed: () {},
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 );
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

//  // return Column(
//                 //   mainAxisAlignment: MainAxisAlignment.start,
//                 //   children: [
//                 //     Container(
//                 //       height: 455,
//                 //       decoration: const BoxDecoration(
//                 //         image: DecorationImage(
//                 //           image: AssetImage(ImagePath.elephantStone),
//                 //           fit: BoxFit.fill,
//                 //         ),
//                 //       ),
//                 //       child: Column(
//                 //         children: [
//                 //           Row(
//                 //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 //             children: [
//                 //               SvgPicture.asset(
//                 //                 IconPath.vdAppBarBack,
//                 //               ),
//                 //               EventsDayMonthEvent(
//                 //                 color: const Color(0xFF145E75),
//                 //                 monthStyle: AppStyle.eventsMonthStyle1,
//                 //                 dayStyle: AppStyle.eventsDayStyle1,
//                 //               ),
//                 //             ],
//                 //           ),
//                 //           const Expanded(
//                 //             child: SizedBox(),
//                 //           ),
//                 //           SizedBox(
//                 //             height: 120,
//                 //             child: EventImageSwiper(),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     ),
//                 //     // Padding(
//                 //     //   padding: const EdgeInsets.all(15.0),
//                 //     //   child: Column(
//                 //     //     children: [
//                 //     //       EventsTitleLocationWidget(
//                 //     //         title: state.eventDetails[index].eventName ?? '',
//                 //     //       ),
//                 //     //       const SizedBox(
//                 //     //         height: 16,
//                 //     //       ),
//                 //     //       EventCategoryWidget(
//                 //     //         category: state.eventDetails[index].category ?? '',
//                 //     //       ),
//                 //     //       const SizedBox(
//                 //     //         height: 16,
//                 //     //       ),
//                 //     //       //const EventsDetailsWidget(),
//                 //     //       const SizedBox(
//                 //     //         height: 16,
//                 //     //       ),
//                 //     //       EventsDescriptionWidget(
//                 //     //           description:
//                 //     //               state.eventDetails[index].description ?? ""),
//                 //     //       const SizedBox(
//                 //     //         height: 16,
//                 //     //       ),
//                 //     //       const EventMapWidget(),
//                 //     //       const SizedBox(
//                 //     //         height: 16,
//                 //     //       ),
//                 //     //       ElevatedIconButtonWidget.export(
//                 //     //         onPressed: () {},
//                 //     //       ),
//                 //     //     ],
//                 //     //   ),
//                 //     // ),
//                 //   ],
//                 // );
