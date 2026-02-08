// ignore_for_file: prefer_expression_function_bodies

import 'package:balady_uikit/balady_uikit.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/demo_container.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/error_bubble_demo.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/limit_alert_block_demo.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/limit_alert_demo.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/maneuver_alert_demo.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/maneuver_alert_icons_demo.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

enum ManeuverDemoViews {
  maneuverAllert,
  maneuverAllertIcons,
  limitAllert,
  limitAllertBlock,
  errorBubble,
  general,
}

@widgetbook.UseCase(
  name: '18. Maneuver and limits',
  type: Widget,
)
Widget maneuverAndLimitsDemo(BuildContext context) {
  final view = context.knobs.list(
    label: 'View',
    options: ManeuverDemoViews.values,
    initialOption: ManeuverDemoViews.general,
  );

  switch (view) {
    case ManeuverDemoViews.maneuverAllert:
      return const ManeuverAlertDemo();
    case ManeuverDemoViews.maneuverAllertIcons:
      return const ManeuverAlertIcons();
    case ManeuverDemoViews.limitAllert:
      return const LimitAlertDemo();
    case ManeuverDemoViews.limitAllertBlock:
      return const LimitAlertBlockDemo();
    case ManeuverDemoViews.errorBubble:
      final String customText = context.knobs.string(
        label: 'Custom text',
        initialValue: 'Custom text with a very long text',
      );
      return ErrorBubbleDemo(customText: customText);
    case ManeuverDemoViews.general:
      final maneuver = BaladyManeuverModel(
        instruction: context.knobs.list(
          label: 'Maneuver instruction',
          options: [
            BaladyManeuverInstruction.crossroadSharplyLeft,
            BaladyManeuverInstruction.finish,
            BaladyManeuverInstruction.start,
            BaladyManeuverInstruction.ringroadLeft45,
          ],
          initialOption: BaladyManeuverInstruction.crossroadSharplyLeft,
        ),
        roadName: context.knobs.string(label: 'Road name', initialValue: 'Road mane'),
        distance: context.knobs.string(label: 'Distance', initialValue: '999'),
        unit: context.knobs.string(label: 'Unit', initialValue: 'm'),
      );
      final loaderText = context.knobs.string(label: 'Loader text', initialValue: 'Loading...');
      final typeOfLoader = context.knobs.list(label: 'Type of loader', options: [
        'Error',
        'Re-route',
      ]);
      final showLoader = context.knobs.boolean(label: 'Show loader');
      final speedInfo = LimitsModel(
        speed: context.knobs.double
            .slider(
              label: 'Current vehicle speed',
              min: 10,
              initialValue: 100,
              max: 320,
              divisions: 20,
            )
            .toInt(),
        speedLimit: context.knobs.double
            .slider(
              label: 'Speed limit',
              min: 20,
              initialValue: 60,
              max: 140,
              divisions: 20,
            )
            .toInt(),
        speedExceed: context.knobs.boolean(label: 'Speed exceed'),
      );
      return DemoContainer(
        wrapInLRT: false,
        title: 'Navi-top-information',
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: BaladyManeuverAndLimit(
            isPedestrian: false,
            speedInfo: speedInfo,
            maneuver: showLoader ? null : maneuver,
            message: showLoader
                ? ManeuverMessageModel(
                    comment: loaderText,
                    state: typeOfLoader == 'Error' ? ManeuverMessageState.error : ManeuverMessageState.reroute,
                  )
                : null,
          ),
        ),
      );
  }
}
