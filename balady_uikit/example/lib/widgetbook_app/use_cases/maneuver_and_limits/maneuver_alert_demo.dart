// ignore_for_file: prefer_expression_function_bodies
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';

import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/demo_container.dart';
import 'package:flutter/material.dart';

class ManeuverAlertDemo extends StatelessWidget {
  const ManeuverAlertDemo({
    super.key,
  });

  static const BaladyManeuverModel maneuverLTR = BaladyManeuverModel(
    instruction: BaladyManeuverInstruction.crossroadKeepLeft,
    roadName: 'Road name',
    distance: '999',
    unit: 'm',
  );

  static const BaladyManeuverModel maneuverRTL = BaladyManeuverModel(
    instruction: BaladyManeuverInstruction.crossroadKeepLeft,
    roadName: 'اسم الطريق',
    distance: '999',
    unit: 'm',
  );

  @override
  Widget build(BuildContext context) {
    return DemoContainer(
      title: 'Maneuver-allert',
      child: SizedBox(
        width: 300,
        child: Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              children: [
                Text(
                  'LTR',
                  style: context.textStyles.bodyLargeRegular,
                ),
                Text(
                  'RTL',
                  textAlign: TextAlign.right,
                  style: context.textStyles.bodyLargeRegular,
                ),
              ],
            ),
            const TableRow(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Directionality(
                    textDirection: TextDirection.ltr,
                    child: BaladyManeuver(
                      maneuver: maneuverLTR,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: BaladyManeuver(
                      maneuver: maneuverRTL,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
