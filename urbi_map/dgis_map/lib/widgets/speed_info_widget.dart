import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SpeedInfoWidget extends StatelessWidget {
  const SpeedInfoWidget({
    required this.controller,
    super.key,
  });

  final NaviSpeedController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 80,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: _Speed(controller),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: _SpeedLimit(controller),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _Camera(controller),
          ),
        ],
      ),
    );
  }
}

class _Camera extends StatelessWidget {
  const _Camera(
    this.controller);

  final NaviSpeedController controller;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<NaviCameraEvent>(
        stream: controller.cameraEvents,
        builder: (context, snapshot) {
          final direction = snapshot.data?.direction;
          if (direction == null) return const SizedBox.shrink();

          return SvgPicture.asset(
            direction.iconPath,
            width: 24,
            height: 24,
          );
        });
  }
}

extension _Icon on NaviCameraDirection {
  String get iconPath {
    switch (this) {
      case NaviCameraDirection.along:
        return "packages/dgis_map/assets/svg/dgis_navi_ic_camera_along.svg";
      case NaviCameraDirection.against:
        return "packages/dgis_map/assets/svg/dgis_navi_ic_camera_against.svg";
      case NaviCameraDirection.both:
        return "packages/dgis_map/assets/svg/dgis_navi_ic_camera_both.svg";
    }
  }
}

class _Speed extends StatelessWidget {
  const _Speed(
    this.controller);

  final NaviSpeedController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 64,
      height: 64,
      child: Card(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32)),
        ),
        elevation: 2.0,
        child: Center(
          child: StreamBuilder<int?>(
              stream: controller.currentSpeedEvents,
              builder: (context, snapshot) {
                return Text(
                  "${snapshot.data ?? 0}",
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.black,
                  ),
                );
              }),
        ),
      ),
    );
  }
}

class _SpeedLimit extends StatelessWidget {
  const _SpeedLimit(
    this.controller);

  final NaviSpeedController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: OverflowBox(
        maxWidth: 90,
        maxHeight: 90,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: SizedBox(
                width: 48,
                height: 48,
                child: StreamBuilder<bool?>(
                    stream: controller.exceedSpeedLimitEvents,
                    builder: (_, snapshot) {
                      final speedExceed = snapshot.data ?? false;
                      return DecoratedBox(
                        decoration: BoxDecoration(
                          border: const Border.fromBorderSide(BorderSide(
                            color: Colors.red,
                            width: 4,
                          )),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24)),
                          color: speedExceed ? Colors.red : Colors.white,
                        ),
                        child: Center(
                          child: StreamBuilder<int?>(
                              stream: controller.speedLimitEvents,
                              builder: (context, snapshot) {
                                return Text(
                                  "${snapshot.data ?? 0}",
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: speedExceed
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                );
                              }),
                        ),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
