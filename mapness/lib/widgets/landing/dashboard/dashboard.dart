import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_uikit/balady_uikit.dart' hide Stories, StatefulSheetDelegateFunction, StatefulSheetDelegateValue;
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart' hide ScrollPosition, SearchBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_features/common/scroll/no_glowing_scroll_behavior.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/entities/free_roam/free_roam_start_state.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/app_analytics/app_analytics.dart';
import 'package:mapness/features/free_roam/free_roam_starter.dart';
import 'package:mapness/features/landing/map_controls.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/saudi_national_day/saudi_national_day.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/explore_card.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/ui/dashboard_feedback/feedback_banner_card_v2.dart';
import 'package:mapness/widgets/landing/dashboard/map_dashboard_controls.dart';
import 'package:mapness/widgets/landing/dashboard/map_hidden_state_controls.dart';
import 'package:mapness/widgets/landing/dashboard_header.dart';
import 'package:mapness/widgets/landing/dashboard_offers_row.dart';
import 'package:mapness/widgets/landing/dashboard_title.dart';
import 'package:mapness/widgets/landing/drive_back_home_card.dart';
import 'package:mapness/widgets/landing/place_preview.dart';
import 'package:mapness/widgets/landing/quick_action_button.dart';
import 'package:mapness/widgets/stories/lib/stories_widget.dart';
import 'package:sheetify/sheetify.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({
    required this.bottomSheetController,
    required this.fireworksController,
    super.key,
  });

  final MultiStateSheetController<ThreeStateSheet> bottomSheetController;

  final AnimationController fireworksController;

  @override
  ConsumerState<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final ValueNotifier<double> footerOpacity = ValueNotifier<double>(1.0);

  late FreeRoamStartState freeRoamState;

  late final outsideOpacityDelegate = StatefulSheetDelegateFunction<double, ThreeStateSheet>(
    function: (controller) {
      final fraction = controller.fraction;
      final interpolation = controller.interpolation;
      final state = controller.state;

      final isGoToNavigatorShown = freeRoamState.canStart && !freeRoamState.isAutorun;

      final isSheetCoversHalfOfTheScreen = fraction > 0.4;
      final isSheetStateOpen = state == ThreeStateSheet.open;
      final isSheetScrolledForHalfOfTheState = interpolation > 0.4;

      final isFull = isGoToNavigatorShown ||
          (!controller.isEnabled && isSheetStateOpen && isSheetScrolledForHalfOfTheState) ||
          isSheetCoversHalfOfTheScreen;

      return !isFull ? 1.0 : max(0.0, 1 - (fraction - 0.4) * 9);
    },
  );
  final barrierColorDelegate = StatefulSheetDelegateFunction<Color?, ThreeStateBottomSheet>(function: (controller) {
    final state = controller.state;

    if (state == ThreeStateBottomSheet.expanded) {
      return Colors.black.withOpacity(.4);
    }
    if (state == ThreeStateBottomSheet.open) {
      return Colors.black.withOpacity(.4 * controller.interpolation);
    }
    return null;
  });

  final topHeaderOffset = const StatefulSheetDelegateValue<double>(value: -Spacing.$4x);

  @override
  void initState() {
    super.initState();
    widget.bottomSheetController.addListener(_scrollListenHandler);
  }

  @override
  void dispose() {
    widget.bottomSheetController.removeListener(_scrollListenHandler);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) => _checkLocationPermission(state);

  ///This method is intended for handling location permission requests
  /// if it's triggered by someone before Mapness starts.
  void _checkLocationPermission(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(locationProvider.notifier).checkLocationPermission();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(layersControlsProvider, (previous, next) {
      if (next.layersVisible) {
        widget.bottomSheetController.setState(ThreeStateSheet.hidden);
      }
    });

    freeRoamState = ref.watch(freeRoamStarterProvider);
    final isNationalDay = ref.watch(saudiNationalDayProvider);

    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.viewPaddingOf(context).top),
      child: MultiStateSheet<ThreeStateSheet>(
        animateOpening: false,
        keepContentBehindFooter: true,
        useSafeArea: false,
        scrollController: widget.bottomSheetController,
        topHeader: MapHiddenStateControls(widget.bottomSheetController, widget.fireworksController),
        topHeaderOffset: isNationalDay ? topHeaderOffset : null,
        offsetOutsideWidgetByTopheader: !isNationalDay,
        backgroundColor: context.colors.backgroundSurface2,
        dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface2),
        header: const DashboardHeader(),
        footer: IgnorePointer(
          child: SizedBox(
            height: Spacing.$16x + Spacing.$5x,
            width: double.infinity,
            child: FadeTransition(
              opacity: Animation.fromValueListenable(footerOpacity),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  backgroundBlendMode: BlendMode.srcOver,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white.withOpacity(0),
                      Colors.white.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        barrierColorDelegate: barrierColorDelegate,
        outside: MapDashboardControls(widget.bottomSheetController, key: const ValueKey('MapDashboardControls')),
        outsideOpacityDelegate: outsideOpacityDelegate,
        sliver: SliverPersistentHeader(
          delegate: DashboardHeaderDelegate(vsync: this),
          pinned: true,
          floating: true,
        ),
        content: [
          const SizedBox(height: Spacing.$3x),
          FeedbackBannerCardV2(
            path: isNationalDay
                ? Assets.images.feedbackDashboardSaudiday.keyName
                : Assets.images.feedbackDashboard.keyName,
            onTap: () {
              ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.addPoiBanner);
              context.router.push(const ContributeRoute());
            },
            gradientColors: isNationalDay
                ? [
                    const Color(0xFF014850),
                    const Color(0xFF00343A),
                  ]
                : [
                    const Color(0xFF4EC9C0),
                    const Color(0xFF2AB3A9),
                  ],
            title: context.l10n.contribute,
            subtitle: context.l10n.buildBaladyTogether,
          ),
          const SizedBox(height: Spacing.$6x),
          StoriesWidget(
            titleWidget: Padding(
              padding: const EdgeInsets.only(bottom: Spacing.$3x),
              child: DashboardTitle(context.l10n.whatIsNewInBalady),
            ),
          ),
          const SizedBox(height: Spacing.$6x),
          DashboardTitle(context.l10n.quickActions),
          const SizedBox(height: Spacing.$4x),
          ScrollConfiguration(
            behavior: NoGlowingScrollBehavior(),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$0_5x),
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  QuickActionButton(
                    text: context.l10n.sendLocation,
                    icon: General32Icons.locationAction,
                    onTap: _openMyLocation,
                  ),
                  const SizedBox(width: Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.freeRoam,
                    icon: TransportIcons.locationDirectionNavigator,
                    onTap: _openFreeRoam,
                  ),
                  const SizedBox(width: Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.parkingAction,
                    icon: General32Icons.parkingAction,
                    onTap: _openParking,
                  ),
                  const SizedBox(width: Spacing.$2x),
                  Consumer(
                    builder: (context, ref, child) {
                      final streamAudio = ref.watch(streamAudioProvider);
                      final isLoading = streamAudio.isLoadingChannels;
                      final hasChannels = streamAudio.hasChannels;

                      return QuickActionButton(
                        text: Directionality.of(context) == TextDirection.rtl ? 'البث الصوتي' : 'Stream Audio',
                        icon: Icons.wifi,
                        child: isLoading
                            ? SizedBox(
                                height: Spacing.$6x + Spacing.$1x,
                                width: Spacing.$6x + Spacing.$1x,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    context.colors.accentDefault,
                                  ),
                                ),
                              )
                            : SvgPicture.asset(
                                Assets.icons.svg.audio.audioStream.keyName,
                                height: Spacing.$6x + Spacing.$1x,
                                colorFilter: ColorFilter.mode(
                                  context.colors.accentDefault,
                                  BlendMode.srcIn,
                                ),
                              ),
                        onTap: () async {
                          final provider = ref.read(streamAudioProvider.notifier);

                          try {
                            // Reset if needed before getting live programs
                            if (provider.needsReinitialization) {
                              await provider.reset();
                            }

                            // Always try to get channels (this will show loading state)
                            await provider.getChannels(forceRefresh: !hasChannels);

                            if (provider.filteredChannels.isNotEmpty) {
                              await provider.selectChannel(provider.filteredChannels.first);
                            } else {
                              // Show message if no channels available
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(Directionality.of(context) == TextDirection.rtl
                                        ? 'لا توجد قنوات متاحة حالياً. اضغط مرة أخرى للمحاولة.'
                                        : 'No channels available right now. Tap again to retry.'),
                                    action: SnackBarAction(
                                      label:
                                          Directionality.of(context) == TextDirection.rtl ? 'إعادة المحاولة' : 'Retry',
                                      onPressed: () async {
                                        await provider.getChannels(forceRefresh: true);
                                      },
                                    ),
                                  ),
                                );
                              }
                            }
                          } catch (e) {
                            debugPrint('Dashboard: Error loading channels: $e');
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(Directionality.of(context) == TextDirection.rtl
                                      ? 'خطأ في تحميل القنوات. اضغط مرة أخرى للمحاولة.'
                                      : 'Error loading channels. Tap again to retry.'),
                                ),
                              );
                            }
                          }
                        },
                      );
                    },
                  ),
                  const SizedBox(width: Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.snapAndSendAction,
                    icon: General32Icons.snapAndSendAction,
                    onTap: _openSnapAndSend,
                  ),
                  const SizedBox(width: Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.qibla,
                    icon: General32Icons.qiblaAction,
                    onTap: () => _openQibla(context),
                  ),
                  const SizedBox(width: Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.quaranAction,
                    icon: General32Icons.quaranAction,
                    onTap: () => _openQuran(context),
                  ),
                  const SizedBox(width: Spacing.$2x),
                  QuickActionButton(
                    text: context.l10n.athkarAction,
                    icon: General32Icons.athkarAction,
                    onTap: () => _openAthkar(context),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.$4x),
          const DriveBackHomeCard(),
          const SizedBox(height: Spacing.$6x),
          const DashboardOffersRow(),
          const SizedBox(height: Spacing.$6x),
          if (!isNationalDay) ...[
            DashboardTitle(context.l10n.exploreNearby),
            const SizedBox(height: Spacing.$4x),
            const PlacePreview(),
            const SizedBox(height: Spacing.$4x),
            const ExploreCard(),
            const SizedBox(height: Spacing.$6x),
          ],
          if (isNationalDay)
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Color(0xff00343A),
                  ],
                ),
                image: DecorationImage(
                  image: Assets.images.backgroundOrnamentSaudiday.provider(),
                  matchTextDirection: true,
                  fit: BoxFit.cover,
                  alignment: AlignmentDirectional.centerEnd,
                ),
              ),
              child: Column(
                children: [
                  DashboardTitle(context.l10n.exploreNearby),
                  const SizedBox(height: Spacing.$4x),
                  const PlacePreview(),
                  const SizedBox(height: Spacing.$4x),
                  const ExploreCard(),
                  const SizedBox(height: Spacing.$6x),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _openParking() {
    ref.read(appAnalyticsProvider).quickActionSelected('parking');
    widget.bottomSheetController.position.animateTo(0, duration: Durations.medium1, curve: Curves.easeOutQuart);
    widget.bottomSheetController.setState(ThreeStateSheet.hidden);
    ref.read(layersControlsProvider.notifier).enableParking();
  }

  Future<void> _openQibla(BuildContext context) async {
    ref.read(appAnalyticsProvider).quickActionSelected('qibla');
    Metrics.logEventAdvanced(
      MetricsConstants.exploreKeys.qibla,
      action: MetricAction.tap.name,
      group: MetricsConstants.exploreTag,
    );
    final location = ref.read(locationProvider.notifier);

    await location.checkLocationPermission().then((allowed) {
      if (allowed) {
        context.router.push(const KiblahRoute());
      }
    });
  }

  void _openQuran(BuildContext context) {
    ref.read(appAnalyticsProvider).quickActionSelected('quran');
    CommonFunctions.openMiniApp(serviceKey: 'Quran');
  }

  void _openAthkar(BuildContext context) {
    ref.read(appAnalyticsProvider).quickActionSelected('athkar');
    CommonFunctions.openMiniApp(serviceKey: 'Athkar');
  }

  void _openFreeRoam() {
    ref.read(appAnalyticsProvider).quickActionSelected('free_roam');
    context.router.push(const FreeRoamRoute());
  }

  void _openMyLocation() {
    ref.read(appAnalyticsProvider).quickActionSelected('my_location');
    Metrics.logEventAdvanced(
      MetricsConstants.poiKeys.myLocation,
      group: MetricsConstants.poiTag,
      action: MetricAction.tap.toString(),
    );

    ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreLandingEngagement);

    final userLocation = ref.read(locationProvider);
    if (userLocation != null) {
      context.router.push(
        ShareMyLocationRoute(
          cameraConfig: const PoiCameraConfig(zoom: 17, bearing: 0, tilt: 0),
          closestPoint: LatLng(latitude: userLocation.latitude, longitude: userLocation.longitude),
        ),
      );
    }
  }

  void _openSnapAndSend() {
    ref.read(appAnalyticsProvider).quickActionSelected('snap_and_send');
    Metrics.logEventAdvanced(MetricsConstants.exploreKeys.enhanceUrbanSceneBannerButton,
        action: MetricAction.tap.name, group: MetricsConstants.exploreTag);
    sl<NewMiniAppLogicCubit>().openMiniAppByServiceKey(
      serviceKey: 'snapandsend',
    );
  }

  void _scrollListenHandler() {
    footerOpacity.value = min(1.0, (1 - widget.bottomSheetController.fraction) * 2);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.bottomSheetController.state != ThreeStateSheet.hidden) {
        ref.read(mapControlsProvider.notifier).update(
              MapControlsStateDashboard(),
            );
      } else {
        ref.read(mapControlsProvider.notifier).update(
              MapControlsStateIdle(),
            );
      }
    });
  }
}
