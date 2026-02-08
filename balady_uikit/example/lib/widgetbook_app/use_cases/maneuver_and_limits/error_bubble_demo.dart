// ignore_for_file: prefer_expression_function_bodies

import 'package:balady_uikit/balady_uikit.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/demo_container.dart';
import 'package:flutter/material.dart';

class ErrorBubbleDemo extends StatelessWidget {
  final String customText;
  const ErrorBubbleDemo({required this.customText, super.key});

  @override
  Widget build(BuildContext context) {
    final bool isRTL = Directionality.of(context) == TextDirection.rtl;
    return DemoContainer(
      title: 'Error Bubble',
      wrapInLRT: false,
      height: 300,
      child: ListView(
        children: [
          Row(
            children: [
              BaladyManeuverMessage(
                message: ManeuverMessageModel(
                  state: ManeuverMessageState.error,
                  comment: customText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              BaladyManeuverMessage(
                message: ManeuverMessageModel(
                  state: ManeuverMessageState.error,
                  comment: isRTL ? 'فقدت إشارة GPS' : 'Lost GPS signal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              BaladyManeuverMessage(
                message: ManeuverMessageModel(
                  state: ManeuverMessageState.reroute,
                  comment: isRTL ? 'إعادة التوجيه' : 'Re-route',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
