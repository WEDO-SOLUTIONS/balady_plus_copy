import 'dart:async';

import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';

class MessageControlWidget extends StatefulWidget {
  const MessageControlWidget({
    required this.controller,
    super.key,
  });

  final NaviMessageController controller;

  @override
  State<MessageControlWidget> createState() => _MessageState();
}

class _MessageState extends State<MessageControlWidget> {
  late StreamSubscription<NaviMessageEvent> _subscription;

  Color messageBackgroundColor = Colors.black;
  Color messageTextColor = Colors.white;
  String messageText = "";
  double messageOpacity = 0;

  @override
  void initState() {
    super.initState();
    _subscription = widget.controller.events.listen((event) {
      if (event.state == NaviMessageEventState.gpsLost) {
        setState(() {
          messageBackgroundColor = const Color(0xFFc51116);
          messageTextColor = Colors.white;
          messageText = 'GPS Signal lost';
          messageOpacity = 1;
        });
      } else if (event.state == NaviMessageEventState.routeResearch) {
        setState(() {
          messageBackgroundColor = const Color(0xFF18862E);
          messageTextColor = const Color(0xFFF2F2F2);
          messageText = 'Re-routing';
          messageOpacity = 1;
        });
      } else {
        setState(() {
          messageOpacity = 0;
        });
      }
    });
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: messageOpacity,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: messageBackgroundColor,
          borderRadius: const BorderRadius.all(
            Radius.circular(
              12.0,
            ),
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Text(
          messageText,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: messageTextColor),
        ),
      ),
    );
  }
}
