// import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
// import 'package:balady_plus/app/features/_shared_feature_/balady_features/balady_exports.dart';
// import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
// import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:mapness/shared/constants/metrics_constants.dart';
// import 'package:mapness/features/balady_analytics/metrics.dart';
//
// class EventsHomeCardWrapper extends ConsumerStatefulWidget {
//   const EventsHomeCardWrapper({
//     super.key,
//   });
//
//   @override
//   ConsumerState<EventsHomeCardWrapper> createState() => _EventsHomeCardWrapperState();
// }
//
// class _EventsHomeCardWrapperState extends ConsumerState<EventsHomeCardWrapper> {
//   @override
//   void initState() {
//     super.initState();
//     sl<EventsBloc>().add(const GetSearchEvent());
//   }
//
//   @override
//   Widget build(BuildContext context) => EventsHomeCard(
//         onItemTap: (value) => Metrics.logEventAdvanced(MetricsConstants.exploreKeys.eventsCalendarBanner,
//             action: MetricAction.tap.name, group: MetricsConstants.exploreTag, props: {'event_id': value.id}),
//         onShowAll: () => Metrics.logEventAdvanced(
//           MetricsConstants.exploreKeys.eventsCalendarViewAll,
//           action: MetricAction.tap.name,
//           group: MetricsConstants.exploreTag,
//         ),
//       );
// }
