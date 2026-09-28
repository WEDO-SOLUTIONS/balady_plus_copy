import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/friends_on_map/models/share_watch_state.dart';
import 'package:mapness/features/friends_on_map/providers/share_watcher.dart';
import 'package:mapness/features/share_eta/ui/eta_share_expired.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

/// R-85's recipient-side arrival card — mirrors
/// `features/share_eta/ui/eta_arrival_card/eta_arrival_card.dart`'s visual
/// shape (progress bar + "arriving in Xh Ym"), bound to [ShareWatcher]'s
/// simpler state instead: no route polyline, since S-19's eta payload is
/// just arrivalAt/distanceMeters, not a navigable route.
class ShareArrivalCard extends HookConsumerWidget {
  const ShareArrivalCard({super.key});

  static const minSheetHeight = 176.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final watchState = ref.watch(shareWatcherProvider);
    final startDistance = useState<double?>(null);

    // BR-04: the server never sends a position after expiry — render the
    // shared expired-state widget (confirmed free of share_eta coupling: its
    // constructor takes plain title/subtitle strings) instead of the arrival
    // content the instant `ShareWatcher` flips to this terminal state.
    if (watchState.status == ShareWatchStatus.expired) {
      return EtaShareExpired(title: context.l10n.shareExpiredTitle, subtitle: context.l10n.shareExpiredBody);
    }

    return Container(
      constraints: const BoxConstraints(minHeight: minSheetHeight),
      padding: const EdgeInsets.all(Spacing.$4x),
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          matchTextDirection: true,
          image: AssetImage(Assets.images.etaSheetBackground.keyName),
          fit: BoxFit.fill,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: Spacing.$4x).copyWith(bottom: Spacing.$8x),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _arrivalLabel(context, watchState),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: context.textStyles.h3Medium.copyWith(color: context.colors.staticWhite),
          ),
          const SizedBox(height: Spacing.$1_5x),
          Opacity(
            opacity: 0.5,
            child: Text(
              '${context.l10n.kmAway(_distanceKm(watchState))} • ${context.l10n.lastUpdatedAtTime(_updatedAtLabel(watchState))}',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.textStyles.captionLargeRegular.copyWith(color: context.colors.staticWhite),
            ),
          ),
          const SizedBox(height: Spacing.$3x),
          Directionality(
            textDirection: TextDirection.ltr,
            child: LinearProgressIndicator(
              value: _progress(watchState, startDistance),
              backgroundColor: context.colors.staticWhite.withOpacity(.1),
              valueColor: AlwaysStoppedAnimation(context.colors.staticWhite),
            ),
          ),
          const SizedBox(height: Spacing.$4x),
          SizedBox(
            width: double.infinity,
            child: AppButton(
              buttonColorScheme: ButtonColorScheme.accent,
              primaryLabel: context.l10n.back,
              textColor: context.colors.accentOnAccent,
              onTap: () => _stop(context, ref),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _stop(BuildContext context, WidgetRef ref) async {
    await ref.read(shareWatcherProvider.notifier).stopWatching();
    if (context.mounted) {
      context.router.pop();
    }
  }

  double _progress(ShareWatchState watchState, ValueNotifier<double?> startDistance) {
    final distanceLeft = watchState.etaDistanceMeters;
    if (distanceLeft == null) {
      return 0.0;
    }
    startDistance.value ??= distanceLeft;
    final initialDistance = startDistance.value;
    if (initialDistance == null || initialDistance == 0) {
      return 0.5;
    }
    return ((initialDistance - distanceLeft) / initialDistance).clamp(0.0, 1.0);
  }

  String _arrivalLabel(BuildContext context, ShareWatchState watchState) {
    final arrivalAt = watchState.etaArrivalAt;
    if (arrivalAt == null) {
      return context.l10n.arrivingInTime(context.l10n.timerMin('--'));
    }
    final remaining = arrivalAt.difference(DateTime.now().toUtc());
    if (remaining.isNegative || remaining.inSeconds < 60) {
      return context.l10n.arrivingInTime(context.l10n.timerMin('0'));
    }
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes.remainder(60);
    return hours > 0
        ? context.l10n.arrivingInTime(context.l10n.timerHrMin(hours.toString(), minutes.toString()))
        : context.l10n.arrivingInTime(context.l10n.timerMin(minutes.toString()));
  }

  String _distanceKm(ShareWatchState watchState) {
    final distance = watchState.etaDistanceMeters;
    if (distance == null) {
      return '--';
    }
    return (distance / 1000.0).toStringAsFixed(1);
  }

  String _updatedAtLabel(ShareWatchState watchState) {
    final at = watchState.at;
    if (at == null) {
      return '--';
    }
    return intl.DateFormat('HH:mm').format(at.toLocal());
  }
}
