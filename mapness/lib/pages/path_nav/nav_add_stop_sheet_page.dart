import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/entities/routing/route_params_point.dart';
import 'package:mapness/entities/routing/route_search_point_mapper.dart';
import 'package:mapness/features/balady_analytics/events/navigation_events.dart';
import 'package:mapness/features/path_nav/add_stop_prompt.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/hooks/toggle_sheet_controller_hook.dart';
import 'package:mapness/shared/lib/make_address.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/widgets/timed_fill_button.dart';
import 'package:provider/provider.dart';
import 'package:sheetify/sheetify.dart';
import 'package:shimmer/shimmer.dart';

/// Sheet over active guidance for a tapped POI. Pops the POI as a route point on
/// "Add stop" and null otherwise; Cancel fires by itself after [timeout].
@RoutePage()
class NavAddStopSheetPage extends StatefulHookConsumerWidget {
  const NavAddStopSheetPage({required this.objectId, required this.tapPoint, required this.prompt, super.key});

  static const timeout = Duration(seconds: 5);

  final int objectId;
  final LatLng tapPoint;
  final AddStopPrompt prompt;

  @override
  ConsumerState<NavAddStopSheetPage> createState() => _NavAddStopSheetPageState();
}

class _NavAddStopSheetPageState extends ConsumerState<NavAddStopSheetPage> {
  late final AddStopPromptTracking _tracking;
  bool _closed = false;

  @override
  void initState() {
    super.initState();
    final prompt = widget.prompt;
    _tracking = BaladyNavigationEvents.trackAddStopPromptShown(
      tripSource: prompt.tripSource,
      navType: prompt.navType,
      stopsCount: prompt.stopsCount,
      limitReached: prompt.limitReached,
      poiInRoute: prompt.poiInRoute,
    );
  }

  @override
  void dispose() {
    // Back gesture, swipe or the guidance screen going away.
    _tracking.report(AddStopPromptResult.dismissed);
    super.dispose();
  }

  void _close(AddStopPromptResult result, [RouteParamsPointWithLabel? stop]) {
    if (_closed) {
      return;
    }
    _closed = true;
    _tracking.report(result);
    context.router.pop(stop);
  }

  void _cancel() => _close(AddStopPromptResult.cancel);

  RouteParamsPointWithLabel _stopFor(DirectoryObjectMessage? object) {
    final fallbackLabel = context.l10n.poi;
    if (object == null || object.markerPosition == null) {
      return RouteParamsPointWithLabel(
        value: RouteParamsPoint(
          latitude: widget.tapPoint.latitude,
          longitude: widget.tapPoint.longitude,
          objectId: widget.objectId,
        ),
        label: fallbackLabel,
      );
    }
    final title = object.title.trim();
    return RouteParamsPointWithLabel(value: object.toRouteParamsPoint(), label: title.isEmpty ? fallbackLabel : title);
  }

  @override
  Widget build(BuildContext context) {
    final sheetController = useToggleSheetController(onClose: (_) => _close(AddStopPromptResult.dismissed));
    final colors = context.colors;
    final textStyles = context.textStyles;
    final l10n = context.l10n;
    final prompt = widget.prompt;

    final theme = context.read<ThemeController>().currentTheme;
    final poi = ref.watch(
      pointOfInterestProvider(DgisObjectId(objectId: widget.objectId, entranceId: 0), widget.tapPoint, theme),
    );
    final object = poi.value;
    final title = object?.title.trim() ?? '';
    final address = object?.makeAddress() ?? '';

    return ToggleSheet(
      scrollController: sheetController,
      backgroundColor: colors.backgroundSurface4,
      safeAreaColor: colors.backgroundSurface4,
      dragger: SheetDragger(backgroundColor: colors.backgroundSurface4),
      outside: GestureDetector(onTap: () => _close(AddStopPromptResult.dismissed)),
      content: [
        Padding(
          padding: const EdgeInsets.fromLTRB(Spacing.$3x, Spacing.$2x, Spacing.$3x, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (poi.isLoading)
                const _TitleShimmer()
              else
                Text(
                  title.isEmpty ? l10n.poi : title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.h3SemiBold.copyWith(color: colors.foregroundDefault),
                ),
              if (address.isNotEmpty && address != title) ...[
                const SizedBox(height: Spacing.$1x),
                Text(
                  address,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyles.bodySmallRegular.copyWith(color: colors.foregroundSoft),
                ),
              ],
              if (prompt.showAddStop && prompt.limitReached) ...[
                const SizedBox(height: Spacing.$2x),
                Text(
                  _stopsLimitReachedText(context),
                  style: textStyles.bodySmallRegular.copyWith(color: colors.errorDefault),
                ),
              ],
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: Spacing.$3x, horizontal: Spacing.$3x),
          child: Row(
            children: [
              if (prompt.showAddStop) ...[
                Expanded(
                  child: AppButton(
                    buttonColorScheme: ButtonColorScheme.accentSecondary,
                    buttonType: ButtonType.secondary,
                    size: ButtonSize.large,
                    color: Colors.transparent,
                    buttonState: prompt.canAddStop && !poi.isLoading ? ButtonState.defaultState : ButtonState.disabled,
                    primaryLabel: l10n.addStop,
                    onTap: () => _close(AddStopPromptResult.addStop, _stopFor(object)),
                  ),
                ),
                const SizedBox(width: Spacing.$2x),
              ],
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: TimedFillButton(
                    duration: NavAddStopSheetPage.timeout,
                    onCompleted: () => _close(AddStopPromptResult.timeout),
                    background: _CancelButton(onTap: _cancel),
                    fill: _CancelButton(
                      bgColor: colors.neutralOnContainer,
                      textColor: colors.accentSecondaryOnAccentSecondary,
                      onTap: _cancel,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// TODO(HB-122): switch to the Localazy key `addStopLimitReachedMessage` (EN/AR below) once published.
String _stopsLimitReachedText(BuildContext context) => Localizations.localeOf(context).languageCode == 'ar'
    ? 'لقد وصلت إلى الحد الأقصى لعدد نقاط التوقف.'
    : 'You have reached the maximum number of stops.';

class _CancelButton extends StatelessWidget {
  const _CancelButton({required this.onTap, this.bgColor, this.textColor});

  final VoidCallback onTap;
  final Color? bgColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) => AppButton(
    buttonColorScheme: ButtonColorScheme.accentSecondary,
    buttonType: ButtonType.secondary,
    size: ButtonSize.large,
    color: bgColor,
    textColor: textColor,
    primaryLabel: context.l10n.cancel,
    onTap: onTap,
  );
}

class _TitleShimmer extends StatelessWidget {
  const _TitleShimmer();

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: context.colors.backgroundSurface5,
    highlightColor: context.colors.backgroundSurface1,
    child: FractionallySizedBox(
      widthFactor: 0.6,
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        height: 20,
        decoration: BoxDecoration(color: context.colors.backgroundSurface5, borderRadius: BorderRadius.circular(6)),
      ),
    ),
  );
}
