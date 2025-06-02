// import 'package:balady_plus/app/core/services/local/navigation_services.dart';
// import 'package:balady_plus/app/core/utils/utils_exports.dart';
// import 'package:balady_plus/app/features/_shared_feature_/balady_features/balady_exports.dart';
// import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
// import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
// import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
// import 'package:balady_plus/app/features/events/presentation/bloc/events_state.dart';
// import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart';
// import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_shimmer_widget.dart';
// import 'package:balady_uikit/core/typography/text_theme_styles.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// class EventsHomeCard extends StatelessWidget {
//   final VoidCallback? onShowAll;
//   final ValueChanged<SearchEventsItem>? onItemTap;
//
//   const EventsHomeCard({
//     super.key,
//     this.onShowAll,
//     this.onItemTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider.value(
//       value: sl<EventsBloc>(),
//       child: BlocBuilder<EventsBloc, EventsState>(
//         builder: (context, state) {
//           if (state.status == BlocStatus.loading) {
//             return const CustomShimmerWidget(
//               childHeight: 201,
//             );
//           }
//           if (state.status == BlocStatus.failure) {
//             return RetryWidget(
//               onRetry: () {
//                 context.read<EventsBloc>().add(const GetSearchEvent());
//               },
//             );
//           }
//
//           SearchEventsItem? item = state.searchItems.firstOrNull;
//           if (item == null) return Container();
//
//           return Column(
//             //   mainAxisSize: MainAxisSize.min,
//             children: [
//               const SizedBox(height: 20),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       'events'.tr(),
//                       style: Theme.of(context)
//                           .extension<ThemeTextStyles>()
//                           ?.heading2
//                           .copyWith(color: const Color(0xFF1E2A36)),
//                     ),
//                     GestureDetector(
//                       onTap: () {
//                         onShowAll?.call();
//                         NavigationService.navigatorKey.currentState!.pushNamed(RouteName.eventsMainPage);
//                       },
//                       child: Text(
//                         "show_all".tr(),
//                         style: Theme.of(context).extension<ThemeTextStyles>()?.footNoteBold.copyWith(
//                               color: const Color(0xFF1E2A36).withOpacity(0.5),
//                             ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(
//                 height: 12,
//               ),
//               SizedBox(
//                 height: 200,
//                 child: ListView.builder(
//                   scrollDirection: Axis.horizontal,
//                   shrinkWrap: true,
//                   itemCount: ((state.searchItems.length) > 4) ? 4 : state.searchItems.length,
//                   padding: const EdgeInsets.only(
//                     left: 16,
//                   ),
//                   itemBuilder: (context, index) {
//                     return EventItemCard(
//                       onItemTap: onItemTap,
//                       width: MediaQuery.of(context).size.width - 60,
//                       padding: const EdgeInsets.only(right: 16),
//                       item: state.searchItems[index],
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );
//         },
//       ),
//     );
//   }
// }
