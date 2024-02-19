import 'dart:async';
import 'dart:ui';

import 'package:dgis_map/library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/providers/color_scheme.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';
import 'package:mapness/_features/landing/providers/search_by_rubrics.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/_features/lifestyle_layers/providers/layers_state.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/events.dart';
import 'package:mapness/app/routes/poi_map.dart';
import 'package:mapness/entities/quick_filters/quick_filter.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/constants/constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/hive.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';

import 'controls.dart' as controls;
import 'dashboard.dart';

enum LangingFocusMaker { iwish, mosques }

class LandingPage extends ConsumerStatefulWidget {
  final LangingFocusMaker? focusMaker;

  const LandingPage({this.focusMaker, Key? key}) : super(key: key);

  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> {
  StreamSubscription<TapEvent>? _streamSubscription;
  bool dialogWasShown = false;
  bool needToShow = false;

  @override
  void initState() {
    super.initState();

    setupTapListener();

    switch (widget.focusMaker) {
      case LangingFocusMaker.iwish:
        () async {
          ref.read(layersControlsProvider.notifier).handleTap(LayerType.joy);
          try {
            await ref.read(cameraPositionProvider.notifier).animateTo(
                  CameraPositionMessage(
                    point: GeoPointMessage(
                      latitude: 24.7113,
                      longitude: 46.6744,
                    ),
                    zoom: 11,
                    tilt: 0,
                    bearing: 0,
                  ),
                );
            // dgisController
          } catch (e) {
            // todo: make it better
            if (kDebugMode) {
              print(e);
            }
          }
        }();
        break;
      case LangingFocusMaker.mosques:
        Future.delayed(Duration.zero, () {
          ref.read(searchByRubricsQueryProvider.notifier).update((
            QuickFilter(
              rubrics: [13374],
              title: "المساجد",
              uiIcon: "assets/icons/svg/quick_filters/ic_quick_mosques.svg",
              mapIcon: "assets/icons/svg/quick_filters/mosques_pin.svg",
            ),
            1
          ));
        });
        break;
      default:
        break;
    }
  }

  void setupTapListener() async {
    final dgisController = await ref.read(dgisControllerProvider.future);
    _streamSubscription =
        dgisController.objectTapEvents.listen(_objectTapListener);
  }

  @override
  void deactivate() {
    _streamSubscription?.cancel();
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(layersControlsProvider);
    ref.watch(favouriteMarkersProvider.select((value) => null));

    /// keep iwish markers alive when page is opened  (DO NOT DELETE UNTIL REFACOR OF LAYER CONTROLS!)
    ref.watch(mapObjectManagerProvider(named: mapLayerName).notifier);
    // ref.watch(iwishMarkersProvider.select((value) => null));

    ref.watch(mapObjectManagerProvider(named: MapnessConsts.mapLayerName));

    ref.read(colorSchemeProvider.notifier).needToShowBanner().then((value) {
      setState(() {
        needToShow = value;
        // if(dialogWasShown == false){
        //   dialogWasShown = true;
        // }
      });
    });

    // if (needToShow && !dialogWasShown) {
    //   showDialog(
    //       context: context,
    //       builder: (c) {
    //         return BackdropFilter(
    //           filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
    //           child: Center(
    //             child: Padding(
    //               padding: const EdgeInsets.all(16),
    //               child: Container(
    //                 child: Image(
    //                     fit: BoxFit.fitWidth,
    //                     image: AssetImage(
    //                       'assets/images/foundation_day_banner.png',
    //                       package: PackageConfig.packageName,
    //                     )),
    //               ),
    //             ),
    //           ),
    //         );
    //       });
    //
    //   setState(() {
    //     dialogWasShown = true;
    //   });
    // }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Directionality(
        textDirection: Directionality.of(context),
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              const controls.MapControls(),
              LayoutBuilder(
                  builder: (context, constraints) => Dashboard(
                        biggestHeight: constraints.biggest.height,
                        biggestWidth: constraints.biggest.width,

                        ///TODO: change while Dashboard refactoring
                        initWithMinSize:
                            widget.focusMaker == LangingFocusMaker.iwish,
                      )),
              if (needToShow)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Stack(
                        children: [
                          Container(
                            child: Image(
                                fit: BoxFit.fitWidth,
                                image: AssetImage(
                                  'assets/images/foundation_day_banner.png',
                                  package: PackageConfig.packageName,
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Material(
                              borderRadius: borderRadius,
                              child: InkWell(
                                borderRadius: borderRadius,
                                onTap: () {
                                  setState(() {
                                    needToShow = false;
                                  });
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                    color: context
                                        .color.text_and_icons_base_primary
                                        .withAlpha(10),
                                  ),
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/icons/svg/ic_search_close.svg',
                                    semanticsLabel: 'MinApps Screen',
                                    package: PackageConfig.packageName,
                                    colorFilter: ColorFilter.mode(
                                      context.color.text_and_icons_base_primary
                                          .withOpacity(0.7),
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _objectTapListener(TapEvent event) {
    if (event is ObjectTapEvent) {
      ref.read(urbiMetricsProvider.notifier).logEvent(
        'Landing/objectTap',
        {'objectId': event.dgisObjectId.objectId},
      );
      if (context.mounted) {
        PoiMapRoute.open(
          ref.read(goRouterProvider),
          event.dgisObjectId.objectId,
          latLng: event.latLng,
        );
      }
    } else if (event is RoadEventTapEvent) {
      EventsRoute.open(context, event);
    }
  }
}
