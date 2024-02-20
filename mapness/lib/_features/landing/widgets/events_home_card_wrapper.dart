import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/balady_features/balady_exports.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_bloc.dart';
import 'package:balady_plus/app/features/events/presentation/bloc/events_event.dart';
import 'package:balady_uikit/colors/app_color_scheme.dart';
import 'package:flutter/material.dart';

class EventsHomeCardWrapper extends StatefulWidget {
  final AppColorScheme colorScheme;

  const EventsHomeCardWrapper({
    required this.colorScheme,
    super.key,
  });

  @override
  State<EventsHomeCardWrapper> createState() => _EventsHomeCardWrapperState();
}

class _EventsHomeCardWrapperState extends State<EventsHomeCardWrapper> {
  @override
  void initState() {
    super.initState();
    sl<EventsBloc>().add(const GetSearchEvent());
  }

  @override
  Widget build(BuildContext context) => EventsHomeCard(
        colorScheme: widget.colorScheme,
      );
}
