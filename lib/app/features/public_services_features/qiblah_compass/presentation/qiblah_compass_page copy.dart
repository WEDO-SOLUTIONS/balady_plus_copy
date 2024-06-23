/*import 'dart:async';
import 'dart:math';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/app_style.dart';

class QiblahCompassPage extends StatefulWidget {
  const QiblahCompassPage({super.key});

  @override
  QiblahCompassPageState createState() => QiblahCompassPageState();
}

class QiblahCompassPageState extends State<QiblahCompassPage> {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  Stream<LocationStatus> get stream => _locationStreamController.stream;

  @override
  void initState() {
    super.initState();
    _checkLocationStatus();
  }

  @override
  void dispose() {
    _locationStreamController.close();
    FlutterQiblah().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(-1.00, 0.10),
                end: Alignment(1, -0.1),
                colors: [Color(0xFF1C7372), Color(0xFF127F4C)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x663B69DE),
                  blurRadius: 68.19,
                  offset: Offset(0, 6.82),
                  spreadRadius: 0,
                )
              ],
            ),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: 60,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(start: 8),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.close,
                            color: AppColor.white,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: CustomTextWidget(
                        "qiblahCompass".tr(),
                        textAlign: TextAlign.center,
                        textStyle: AppStyle.appBarTitleTextStyle.copyWith(
                          color: AppColor.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: stream,
                builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColor.primary900Light,
                      ),
                    );
                  }
                  if (snapshot.data!.enabled == true) {
                    switch (snapshot.data!.status) {
                      case LocationPermission.always:
                      case LocationPermission.whileInUse:
                        return QiblahCompassPageWidget();

                      case LocationPermission.denied:
                        return LocationErrorWidget(
                          error: "Location service permission denied",
                          callback: _checkLocationStatus,
                        );
                      case LocationPermission.deniedForever:
                        return LocationErrorWidget(
                          error: "Location service Denied Forever !",
                          callback: _checkLocationStatus,
                        );
                      default:
                        return const SizedBox();
                    }
                  } else {
                    return LocationErrorWidget(
                      error: "Please enable Location service",
                      callback: _checkLocationStatus,
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _checkLocationStatus() async {
    final locationStatus = await FlutterQiblah.checkLocationStatus();
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await FlutterQiblah.requestPermissions();
      final s = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(s);
    } else {
      _locationStreamController.sink.add(locationStatus);
    }
  }
}

class QiblahCompassPageWidget extends StatelessWidget {
  final _compassSvg = SvgPicture.asset(ImagePath.compass);
  final _needleSvg = SvgPicture.asset(ImagePath.needle);

  QiblahCompassPageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.primary900Light,
            ),
          );
        }

        final QiblahDirection qiblahDirection = snapshot.data!;

        return Column(
          children: [
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedRotation(
                    turns: (qiblahDirection.direction * (pi / 180) * -1),
                    duration: const Duration(seconds: 1),
                    child: _compassSvg,
                  ),
                  AnimatedRotation(
                    turns: (qiblahDirection.qiblah * (pi / 180) * -1),
                    duration: const Duration(seconds: 1),
                    child: _needleSvg,
                  ),
                  // Transform.rotate(
                  //   angle: (qiblahDirection.direction * (pi / 180) * -1),
                  //   child: _compassSvg,
                  // ),
                  // Transform.rotate(
                  //   angle: (qiblahDirection.qiblah * (pi / 180) * -1),
                  //   child: _needleSvg,
                  // ),
                ],
              ),
            ),
            CustomTextWidget(
              "${qiblahDirection.offset.toStringAsFixed(3)}°",
              textStyle: AppStyle.compassOffsetTextStyle,
            ),
            const SizedBox(height: 16),
            CustomTextWidget(
              _getDirection(qiblahDirection.offset),
              textStyle: AppStyle.compassDirectionTextStyle,
            ),
            const SizedBox(height: 80),
            const SafeArea(child: SizedBox())
          ],
        );
      },
    );
  }

  String _getDirection(double degrees) {
    if (degrees >= 0 && degrees < 22.5) {
      return "N";
    } else if (degrees >= 22.5 && degrees < 67.5) {
      return "NE";
    } else if (degrees >= 67.5 && degrees < 112.5) {
      return "E";
    } else if (degrees >= 112.5 && degrees < 157.5) {
      return "SE";
    } else if (degrees >= 157.5 && degrees < 202.5) {
      return "S";
    } else if (degrees >= 202.5 && degrees < 247.5) {
      return "SW";
    } else if (degrees >= 247.5 && degrees < 292.5) {
      return "W";
    } else if (degrees >= 292.5 && degrees < 337.5) {
      return "NW";
    } else if (degrees >= 337.5 && degrees < 360.0) {
      return "N";
    } else {
      return "";
    }
  }
}

class LocationErrorWidget extends StatelessWidget {
  final String error;
  final VoidCallback callback;

  const LocationErrorWidget({
    super.key,
    required this.error,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(error),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: callback,
          child: const Text("Retry"),
        ),
      ],
    );
  }
}
*/
