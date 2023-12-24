import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/landing/widgets/compass_control.dart';
import 'package:mapness/_features/landing/widgets/follow_control.dart';
import 'package:mapness/_features/landing/widgets/happines_control.dart';
import 'package:mapness/_features/landing/widgets/indoor_control.dart';
import 'package:mapness/_features/landing/widgets/layers_control.dart';
import 'package:mapness/_features/landing/widgets/zoom_control.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/weather/widgets/weather_control.dart';
import 'package:mapness/app/routes/kiblah.dart';
import 'package:mapness/app/routes/weather.dart';
import 'package:mapness/shared/providers/app_features.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';
import 'package:mapness/widgets/landing/ui/traffic_control.dart';

class PoiCardMapControls extends ConsumerStatefulWidget {
  final double biggestHeight;
  final DraggableScrollableController scrollController;

  const PoiCardMapControls({
    required this.biggestHeight,
    Key? key,
    required this.scrollController,
  }) : super(key: key);

  @override
  ConsumerState<PoiCardMapControls> createState() => _PoiCardMapControlsState();
}

class _PoiCardMapControlsState extends ConsumerState<PoiCardMapControls> {
  late double bottomExtent;

  @override
  void initState() {
    super.initState();
    bottomExtent = footerHeight + headerHeight;
    widget.scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    Future.delayed(Duration.zero, () {
      var size = widget.scrollController.size;
      var sizeFixed = double.parse(size.toStringAsFixed(2));

      if (sizeFixed == .1) {
        var extent = widget.biggestHeight * sizeFixed;
        setState(() {
          bottomExtent = extent;
        });
      } else {
        setState(() {
          bottomExtent = footerHeight + headerHeight;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 12,
                  right: 12,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        WeatherControl(
                            onTap: () => const WeatherRoute().push(context)),
                        const SizedBox(height: 8),
                        const HappinesControl(),
                        const Spacer(),
                        const IndoorControl(),
                        const Spacer(),
                        // MapButton(
                        //   child: Image.asset(
                        //     "assets/images/beta_icon.png",
                        //     height: 44,
                        //   ),
                        //   onTap: () {
                        //     Stories.showOnboarding(
                        //         context, StoryTypes.route, 'route');
                        //   },
                        // ),
                        // const SizedBox(height: 8),
                        MapButton(
                          child: SvgPicture.asset(
                            "assets/icons/svg/ic_controls_qibla.svg",
                            semanticsLabel: 'MinApps Screen',
                            package: "mapness",
                          ),
                          onTap: () {
                            const KiblahRoute().pushReplacement(context);
                          },
                        ),
                      ],
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LayersControl(),
                        const SizedBox(
                          height: 8,
                        ),
                        Consumer(
                          builder: (context, ref, _) {
                            final navi = ref.watch(appFeaturesProvider);
                            return Visibility(
                              visible: navi.naviEnabled,
                              replacement: const SizedBox.square(
                                dimension: 28,
                              ),
                              child: const TrafficControl(),
                            );
                          },
                        ),
                        const Spacer(),
                        const ZoomControl(),
                        const Spacer(),
                        const CompassControl(),
                        const SizedBox(
                          height: 8,
                        ),
                        const FollowControl(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: bottomExtent,
            ),
          ],
        ),
      ),
    );
  }
}
