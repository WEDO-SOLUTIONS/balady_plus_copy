import 'dart:async';
import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/friends_on_map/models/friends_on_map_activation_status.dart';
import 'package:mapness/features/friends_on_map/models/meetup.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_activated.dart';
import 'package:mapness/features/friends_on_map/providers/friend_markers.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_activation.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_position_reporter.dart';
import 'package:mapness/features/friends_on_map/providers/meetups_list.dart';
import 'package:mapness/features/friends_on_map/ui/open_meetup_on_map.dart';
import 'package:mapness/features/lifestyle_layers/providers/layers_controls.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/first_start.dart';
import 'package:mapness/shared/providers/map/dgis_controller.dart';
import 'package:mapness/shared/providers/map/navigation_controls_visibility.dart';
import 'package:mapness/shared/providers/map/object_manager.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/toast/toast_overlay.dart';

@RoutePage()
class MapPage extends ConsumerStatefulWidget {
  const MapPage({super.key});

  @override
  ConsumerState<MapPage> createState() => _MapPageState();
}

class _MapPageState extends ConsumerState<MapPage>
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver, AutoRouteAwareStateMixin<MapPage> {
  final int _keyIndex = 0;
  bool _needRefresh = false;

  @override
  void initState() {
    super.initState();
    _trace('initState');
    WidgetsBinding.instance.addObserver(this);
    // We show toast on the map (not in MapnessEntryPoint) because it must be shown only when the map is visible
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initToastMessage();
    });
  }

  @override
  void dispose() {
    _trace('dispose');
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didPushNext() {
    _trace('didPushNext');
  }

  @override
  void didPopNext() {
    _trace('didPopNext');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _trace('appLifecycle=$state');
    if (_needRefresh && state == AppLifecycleState.resumed) {
      setState(() {
        _needRefresh = false;
      });
    }
    // R-07: re-check the OS location permission on resume so a revoked grant
    // is reflected without the user reopening Friends on Map. Gated on the
    // persisted flag so this is a no-op before the feature is ever
    // activated.
    if (state == AppLifecycleState.resumed && ref.read(friendsOnMapActivatedProvider)) {
      unawaited(ref.read(friendsOnMapActivationProvider.notifier).refreshPermissionStatus());
    }
  }

  @override
  void didHaveMemoryPressure() {
    _trace('memoryPressure-before');
    setState(() {
      _needRefresh = true;
    });
    super.didHaveMemoryPressure();
    _trace('memoryPressure-after');
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    // R-07: inform the user the moment their friends can no longer see them,
    // even while they're not on the Friends on Map screen itself.
    ref
      ..listen<AsyncValue<FriendsOnMapActivationStatus>>(friendsOnMapActivationProvider, (previous, next) {
        final wasRevoked = previous?.value == FriendsOnMapActivationStatus.revoked;
        final isRevoked = next.value == FriendsOnMapActivationStatus.revoked;
        if (isRevoked && !wasRevoked) {
          ToastOverlay.of(context).show(
            title: context.l10n.friendsOnMapRevokedToast,
            isDismissible: true,
          );
        }
      })
      // S-17: a toast the moment a new place is shared with the user, with a
      // "View" action that opens it — no unread badge/count exists (no
      // read-state is modeled server-side), so this only fires once a first
      // successful list is already in hand (previous?.value != null), never
      // for meetups that were already there on cold start. Diffs by id
      // (not just list length) so the toast/View action can name and target
      // the actual new meetup; if more than one arrives at once, only the
      // newest is referenced.
      ..listen<AsyncValue<List<Meetup>>>(receivedMeetupsProvider, (previous, next) {
        final previousMeetups = previous?.value;
        final nextMeetups = next.value;
        if (previousMeetups == null || nextMeetups == null) {
          return;
        }
        final previousIds = previousMeetups.map((m) => m.id).toSet();
        final newMeetups = nextMeetups.where((m) => !previousIds.contains(m.id)).toList();
        if (newMeetups.isEmpty) {
          return;
        }
        final newest = newMeetups.first;
        ToastOverlay.of(context).show(
          title: newest.label != null
              ? context.l10n.meetupReceivedToastWithPlace(newest.senderDisplayName, newest.label!)
              : context.l10n.meetupReceivedToast(newest.senderDisplayName),
          isDismissible: true,
          actions: [
            ToastAction(
              title: context.l10n.meetupReceivedToastView,
              onTap: () => openMeetupOnMap(ref, newest),
            ),
          ],
        );
      })
      // R-13: keeps the position-reporting Timer alive for as long as
      // activation status says it should, independent of whether the
      // Friends on Map screen itself is open — MapPage is the
      // always-mounted root route, same rationale as the resume/revocation
      // wiring above.
      ..watch(friendsOnMapPositionReporterProvider)
      // R-48/R-97: draws/clears friend markers whenever the friend list or
      // the layer-visibility toggle changes — same "always-mounted root
      // route" rationale as the position reporter above.
      ..watch(friendMarkersProvider);

    final dgisController = ref.watch(dgisControllerProvider.notifier);

    ref.watch(selectedMarkerProvider);
    final settings = MapObjectManagerSettings.selectedMarker();
    ref.watch(
      mapObjectManagerProvider(
        named: settings.name,
        layerId: settings.layerId,
      ).notifier,
    );

    if (Platform.isAndroid) {
      return Stack(
        fit: StackFit.expand,
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              _trace('pointerDown android');
              ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction();
            },
            onPointerSignal: (_) => ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction(),
            child: DgisMap(
              key: ValueKey(_keyIndex),
              androidUseExpensive: true,
              onMapCreated: (controller) async {
                _trace('onMapCreated android start controller=${identityHashCode(controller)}');
                await dgisController.onMapCreated(controller);
                _trace('onMapCreated android done controller=${identityHashCode(controller)}');
                Future.delayed(const Duration(seconds: 3), () {
                  if (!mounted) {
                    return;
                  }
                  _trace('showActiveLayerOnMap android');
                  ref.read(layersControlsProvider.notifier).showActiveLayerOnMap();
                });
              },
            ),
          ),
          Positioned.fill(
            top: null,
            child: Container(
              color: context.colors.backgroundSurface2,
              height: MediaQuery.of(context).viewPadding.bottom,
            ),
          ),

          const SafeArea(
            top: false,
            child: AutoRouter(),
          ),
        ],
      );
    } else {
      return Stack(
        fit: StackFit.expand,
        children: [
          Listener(
            behavior: HitTestBehavior.translucent,
            onPointerDown: (_) {
              _trace('pointerDown ios');
              ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction();
            },
            onPointerSignal: (_) => ref.read(navigationControlsVisibilityProvider.notifier).registerInteraction(),
            child: DgisMap(
              key: ValueKey(_keyIndex),
              androidUseExpensive: true,
              onMapCreated: (controller) async {
                _trace('onMapCreated ios start controller=${identityHashCode(controller)}');
                await dgisController.onMapCreated(controller);
                _trace('onMapCreated ios done controller=${identityHashCode(controller)}');
                Future.delayed(const Duration(seconds: 3), () {
                  if (!mounted) {
                    return;
                  }
                  _trace('showActiveLayerOnMap ios');
                  ref.read(layersControlsProvider.notifier).showActiveLayerOnMap();
                });
              },
            ),
          ),
          const AutoRouter(),
        ],
      );
    }
  }

  @override
  bool get wantKeepAlive => true;

  void _trace(String event) {}

  Future<void> _initToastMessage() async {
    final isFirstStart = ref.read(firstStartProvider);
    if (!isFirstStart) {
      return;
    }

    ToastOverlay.of(context).show(
      title: context.l10n.darkModeToastMessage,
      isDismissible: true,
      actions: [
        ToastAction(
          title: context.l10n.darkModeToastAction,
          onTap: () {
            ref
                .read(appRouterProvider)
                .push(
                  const DarkMapRoute(),
                );
          },
        ),
      ],
      icon: ToastIconData(GeneralIcons.darkMode, color: context.themeRead.colors.foregroundSoft),
    );
  }
}
