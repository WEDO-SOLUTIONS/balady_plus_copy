// import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
// import 'package:balady_plus/app/features/events/presentation/pages/events_main_page.dart';
// import 'package:balady_plus/app/features/events/presentation/pages/events_not_found_page.dart';
// import 'package:balady_plus/app/features/events/presentation/pages/events_section_page.dart';
// import 'package:balady_plus/app/features/events/presentation/pages/single_image_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class EventsPageViewer extends StatelessWidget {
//   const EventsPageViewer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => EventsBloc(),
//       child: PageView(
//         controller: PageController(initialPage: 0),
//         children: const [
//           EventsMainPage(),
//           SingleEventDescriptionPage(),
//           DariyahEventPage(),
//           EventsNotFoundPage(),
//         ],
//       ),
//     );
//   }
// }
