import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mapness/_features/common/providers/ui_direction.dart';
import 'package:mapness/features/friends_on_map/models/friends_on_map_activation_status.dart';
import 'package:mapness/features/friends_on_map/providers/friend_requests.dart';
import 'package:mapness/features/friends_on_map/providers/friends_list.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_activation.dart';
import 'package:mapness/features/friends_on_map/providers/friends_on_map_events_socket.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friends_on_map_background_prompt_view.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friends_on_map_disclosure_view.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friends_on_map_permission_denied_view.dart';
import 'package:mapness/features/friends_on_map/ui/widgets/friends_on_map_status_view.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:permission_handler/permission_handler.dart' as perm;

/// The disclosure step (S-01) leads into an optional background-permission
/// step (S-02/R-04) before activation completes. Both are steps within one
/// user action, not states other parts of the app observe — so they're kept
/// as local widget state rather than in [friendsOnMapActivationProvider].
enum _PreActivationStep { disclosure, backgroundPrompt }

@RoutePage()
class FriendsOnMapPage extends ConsumerStatefulWidget {
  const FriendsOnMapPage({super.key});

  @override
  ConsumerState<FriendsOnMapPage> createState() => _FriendsOnMapPageState();
}

class _FriendsOnMapPageState extends ConsumerState<FriendsOnMapPage> with WidgetsBindingObserver {
  _PreActivationStep _step = _PreActivationStep.disclosure;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Lets the denied view recover on its own once the user grants
      // location from OS Settings and comes back, without needing to retap
      // Activate.
      ref.read(friendsOnMapActivationProvider.notifier).refreshPermissionStatus();

      // The events socket can die silently while backgrounded (OS network
      // suspension, or the personal test server's Fly machine scaling to
      // zero while idle) — reconnect it and force an immediate refresh of
      // the friend/request lists rather than waiting for a live event that
      // might never arrive if the remote change happened while this device
      // had no working connection at all. See
      // `providers/friends_on_map_events_socket.dart`.
      ref.read(friendsOnMapEventsSocketProvider.notifier).reconnectNow();
      ref
        ..invalidate(friendsListProvider)
        ..invalidate(incomingFriendRequestsProvider)
        ..invalidate(outgoingFriendRequestsProvider);
    }
  }

  Future<void> _onActivate() async {
    final granted = await ref.read(friendsOnMapActivationProvider.notifier).requestForegroundPermission();
    if (!mounted || !granted) {
      return;
    }
    setState(() => _step = _PreActivationStep.backgroundPrompt);
  }

  Future<void> _onOpenSettings() async {
    final serviceStatus = await perm.Permission.location.serviceStatus;
    if (serviceStatus == perm.ServiceStatus.disabled) {
      await Geolocator.openLocationSettings();
    } else {
      await perm.openAppSettings();
    }
  }

  Future<void> _completeActivation({required bool backgroundGranted}) async {
    await ref.read(friendsOnMapActivationProvider.notifier).completeActivation(backgroundGranted: backgroundGranted);
  }

  Future<void> _onEnableBackground() async {
    final granted = await ref.read(friendsOnMapActivationProvider.notifier).requestBackgroundPermission();
    if (!mounted) {
      return;
    }
    await _completeActivation(backgroundGranted: granted);
  }

  Future<void> _onSkipBackground() => _completeActivation(backgroundGranted: false);

  @override
  Widget build(BuildContext context) {
    final status = ref.watch(friendsOnMapActivationProvider);
    // Keeps the events socket connected for as long as this page (or the
    // friend list/requests routes pushed on top of it) stays mounted — same
    // watch-from-an-always-mounted-place cascade as `friendMarkersProvider`
    // elsewhere in this feature.
    ref.watch(friendsOnMapEventsSocketProvider);

    return Directionality(
      textDirection: ref.watch(uiDirectionProvider),
      child: Material(
        color: context.colors.backgroundSurface4,
        child: Scaffold(
          appBar: BaladyTopBar.iconAndText(
            title: context.l10n.friendsOnMapTitle,
            colorEnabled: context.colors.accentDefault,
            leading: ActionModel(onPressed: () => context.router.pop(), icon: SystemIcons.arrowCornerLeftLarge),
          ),
          body: SafeArea(
            child: status.when(
              data: _buildBody,
              loading: () => const Center(child: CircularProgressIndicator()),
              // A live-permission read failed transiently — fall back to
              // whatever the pre-activation flow would show rather than a
              // dead error screen; the next resume/tap re-checks.
              error: (_, _) => _buildBody(FriendsOnMapActivationStatus.notActivated),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(FriendsOnMapActivationStatus status) => switch (status) {
    FriendsOnMapActivationStatus.notActivated =>
      _step == _PreActivationStep.backgroundPrompt
          ? FriendsOnMapBackgroundPromptView(onEnable: _onEnableBackground, onSkip: _onSkipBackground)
          : FriendsOnMapDisclosureView(onActivate: _onActivate, onNotNow: () => context.router.pop()),
    FriendsOnMapActivationStatus.foregroundDenied => FriendsOnMapPermissionDeniedView(
      onOpenSettings: _onOpenSettings,
    ),
    FriendsOnMapActivationStatus.activeForegroundOnly => const FriendsOnMapStatusView(),
    FriendsOnMapActivationStatus.activeWithBackground => const FriendsOnMapStatusView(backgroundActive: true),
    FriendsOnMapActivationStatus.revoked => const FriendsOnMapStatusView(revoked: true),
  };
}
