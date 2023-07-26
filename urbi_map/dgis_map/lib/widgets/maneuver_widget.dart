import 'package:dgis_map/extensions/maneuver_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../library.dart';

/// Text and icon for next maneuver and additional maneuver
class ManeuverWidget extends StatelessWidget {
  /// @nodoc
  const ManeuverWidget({
    required this.controller,
    super.key,
  });

  final NaviManeuverController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 130,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: _AdditionalManeuver(controller: controller),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: _Maneuver(controller: controller),
          ),
        ],
      ),
    );
  }
}

class _Maneuver extends StatelessWidget {
  const _Maneuver({
    required this.controller,
  });

  final NaviManeuverController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ManeuverEvent>(
        stream: controller.maneuverEvents,
        builder: (_, snapshot) {
          final event = snapshot.data;

          if (event == null) return const SizedBox.shrink();
          if (event is ManeuverEventHidden) return const SizedBox.shrink();

          final iconPath = event.instruction.iconPath;

          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              color: Colors.white,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (iconPath != null)
                      SvgPicture.asset(
                        iconPath,
                        width: 36,
                        height: 36,
                        color: const Color(0xff3588fd),
                      ),
                    const SizedBox(width: 8.0),
                    Text(
                      event.distance,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 26,
                      ),
                    ),
                    const SizedBox(width: 2.0),
                    Text(
                      event.unit,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 26,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Text(
                  event.roadName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _AdditionalManeuver extends StatelessWidget {
  const _AdditionalManeuver({
    required this.controller,
  });

  final NaviManeuverController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ManeuverAdditionalEvent>(
        stream: controller.additionalEvents,
        builder: (_, snapshot) {
          final data = snapshot.data;

          if (data == null) return const SizedBox.shrink();
          if (data is ManeuverAdditionalEventHidden) {
            return const SizedBox.shrink();
          }

          String? instruction;
          String? iconPath;
          if (data is ManeuverAdditionalEventExit) {
            instruction = "Exit";
          }

          if (data is ManeuverAdditionalEventWithIcon) {
            instruction = "Next";
            iconPath = data.instruction.iconPath;
          }

          return Container(
            padding: const EdgeInsets.all(8.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              color: Color(0xffEFEFEF),
            ),
            child: Column(
              children: [
                const SizedBox(height: 25.0),
                Row(
                  children: [
                    Text(
                      instruction ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                      ),
                    ),
                    if (iconPath != null)
                      SvgPicture.asset(
                        iconPath,
                        width: 28,
                        height: 28,
                        color: const Color(0xff3588fd),
                      ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
