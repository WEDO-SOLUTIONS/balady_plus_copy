import 'package:balady_plus/app/features/events/presentation/pages/events_main_page.dart';
import 'package:balady_plus/app/features/events/presentation/pages/events_not_found_page.dart';
import 'package:balady_plus/app/features/events/presentation/pages/events_section_page.dart';
import 'package:balady_plus/app/features/events/presentation/pages/single_image_page.dart';
import 'package:flutter/material.dart';

class EventsPageViewer extends StatelessWidget {
  const EventsPageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: PageController(initialPage: 0),
      children: const [
        EventsMainPage(),
        SingleEventDescriptionPage(),
        DariyahEventPage(),
        EventsNotFoundPage(),
      ],
    );
  }
}
