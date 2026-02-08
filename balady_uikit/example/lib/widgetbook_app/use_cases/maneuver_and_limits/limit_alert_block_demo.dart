import 'package:balady_uikit/balady_uikit.dart';
import 'package:example/widgetbook_app/use_cases/maneuver_and_limits/demo_container.dart';
import 'package:flutter/material.dart';

class LimitAlertBlockDemo extends StatelessWidget {
  const LimitAlertBlockDemo({super.key});

  @override
  Widget build(BuildContext context) => DemoContainer(
        title: 'Limit-allert_block',
        child: Table(
          children: const [
            TableRow(
              children: [
                SizedBox(),
                Text('LTR'),
                Text(
                  'RTL',
                  textAlign: TextAlign.right,
                ),
              ],
            ),
            TableRow(
              children: [
                Text('Normal'),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: SpeedLimit(
                    info: LimitsModel(
                      speed: 100,
                      speedLimit: 110,
                      speedExceed: false,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: SpeedLimit(
                      info: LimitsModel(
                        speed: 100,
                        speedLimit: 110,
                        speedExceed: false,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                Text('Exceed'),
                SpeedLimit(
                  info: LimitsModel(
                    speed: 120,
                    speedLimit: 110,
                    speedExceed: true,
                  ),
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SpeedLimit(
                    info: LimitsModel(
                      speed: 120,
                      speedLimit: 110,
                      speedExceed: true,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}
