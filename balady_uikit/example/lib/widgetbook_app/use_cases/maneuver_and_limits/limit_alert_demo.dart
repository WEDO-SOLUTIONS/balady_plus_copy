import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/demo_container.dart';
import 'package:flutter/material.dart';

class LimitAlertDemo extends StatelessWidget {
  static const limitAlert = LimitsModel(
    speed: 100,
    speedLimit: 110,
    speedExceed: false,
  );
  const LimitAlertDemo({super.key});

  @override
  Widget build(BuildContext context) => DemoContainer(
        title: 'Limit-allert',
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
                      child: Row(
                        children: [
                          LimitAlert(info: limitAlert, hideSpeedLimit: false),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          LimitAlert(info: limitAlert, hideSpeedLimit: false),
                        ],
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
