import 'dart:async';
import 'dart:math';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/advert_metrics/advert_metrics.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/search/models/search_state.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/features/special_themes/core/special_theme_mode.dart';
import 'package:mapness/shared/constants/metrics_constants.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/urbi_metrics.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:mapness/shared/providers/analytic/models/bss_request.dart';
import 'package:mapness/shared/providers/dark_mode.dart';
import 'package:mapness/shared/providers/location.dart';
import 'package:mapness/shared/providers/urbi_analytics.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/widgets/landing/dashboard_contents/dashboard_theme_config.dart';
import 'package:mapness/widgets/landing/map_quick_filters.dart';
import 'package:mapness/widgets/quick_filters/models/filter_item.dart';
import 'package:mapness/widgets/quick_filters/ui/quick_filters.dart';

class DashboardHeaderDelegate extends SliverPersistentHeaderDelegate {
  final TickerProvider _vsync;

  static const headerHeight = 24.0;

  DashboardHeaderDelegate({required TickerProvider vsync}) : _vsync = vsync;

  @override
  TickerProvider? get vsync => _vsync;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    const heightOfQuickFilters = QuickFilters.defaultHeight + Spacing.$4x;
    final currentHeaderExtent = minExtent + max(0.0, heightOfQuickFilters - shrinkOffset);

    return FlexibleSpaceBar.createSettings(
      minExtent: minExtent,
      maxExtent: maxExtent,
      currentExtent: currentHeaderExtent,
      child: _DashboardMenu(shrinkOffset: shrinkOffset),
    );
  }

  @override
  double get maxExtent => headerHeight + QuickFilters.defaultHeight;

  @override
  double get minExtent => headerHeight - Spacing.$4x - Spacing.$2x;

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration => FloatingHeaderSnapConfiguration();

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;
}

class _DashboardMenu extends ConsumerWidget {
  final double shrinkOffset;

  const _DashboardMenu({required this.shrinkOffset});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const heightOfQuickFilters = QuickFilters.defaultHeight + Spacing.$2x * 2;
    final remainingSpaceForQuickFilters = max(
      0.0,
      heightOfQuickFilters - shrinkOffset,
    );
    final quickFilterSizeProportion = remainingSpaceForQuickFilters / heightOfQuickFilters;

    final specialThemeMode = ref.watch(specialThemeModeProvider);
    final activeEvent = ref.watch(activeCityEventProvider);
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;

    final themeConfig = dashboardThemeConfigFor(specialThemeMode, activeEvent, isDark: isDark);
    final backgroundColor = themeConfig.backgroundColor ?? context.colors.backgroundSurface2;

    return ColoredBox(
      color: backgroundColor,
      child: ClipRect(
        clipBehavior: Clip.antiAlias,
        child: Opacity(
          opacity: quickFilterSizeProportion,
          child: SizedOverflowBox(
            size: Size(double.infinity, remainingSpaceForQuickFilters),
            child: const MapQuickFiltersDefault(),
          ),
        ),
      ),
    );
  }
}

class MapQuickFiltersDefault extends ConsumerWidget {
  final bool forMap;
  const MapQuickFiltersDefault({this.forMap = false, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SizedBox(
    height: QuickFilters.defaultHeight,
    child: MapQuickFilters(
      forMap: forMap,
      customFilters: [
        FilterItemConfig(
          filterType: FilterType.custom,
          icon: TransportIcons.newlocationDirectionNavigator,
          semanticsLabel: context.l10n.goToNavigator,
          onTap: () async {
            final isAllowed = await ref.read(locationProvider.notifier).checkLocationPermission();
            if (isAllowed) {
              ref
                  .read(advertMetricsProvider.notifier)
                  .sendEvent(
                    AdvertMetricsKeys.exploreLandingEngagement,
                  );
              await context.router.push(const FreeRoamRoute());
            }
          },
        ),
        FilterItemConfig(
          filterType: FilterType.custom,
          icon: GeneralIcons.block,
          semanticsLabel: context.l10n.goToNavigator,
          onTap: () async {
            final isAllowed = await ref.read(locationProvider.notifier).checkLocationPermission();
            if (isAllowed) {
              ref
                  .read(advertMetricsProvider.notifier)
                  .sendEvent(
                    AdvertMetricsKeys.exploreLandingEngagement,
                  );
              await context.router.push(const FavoriteListsRoute());
            }
          },
        ),
      ],
    ),
  );
}

class DashboardHeader extends ConsumerStatefulWidget {
  const DashboardHeader({super.key});

  @override
  DashboardHeaderState createState() => DashboardHeaderState();
}

class DashboardHeaderState extends ConsumerState<DashboardHeader> {
  final _scope = SearchScopeEnum.map.value;
  final TextEditingController ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    ctrl.text = ref.read(searchProvider(_scope)).searchText;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<SearchState>(
      searchProvider(_scope),
      (previous, next) {
        ctrl.value = ctrl.value.copyWith(
          text: next.searchText,
          selection: TextSelection.fromPosition(
            TextPosition(offset: next.searchText.length),
          ),
        );
      },
    );
    final specialThemeMode = ref.watch(specialThemeModeProvider);
    final activeEvent = ref.watch(activeCityEventProvider);
    final isDark = ref.watch(darkModeProvider).value?.isDark ?? false;
    final themeConfig = dashboardThemeConfigFor(specialThemeMode, activeEvent, isDark: isDark);
    final headerBackgroundColor = themeConfig.backgroundColor ?? context.colors.backgroundSurface2;
    final headerHintColor = themeConfig.searchHintColor ?? context.colors.foregroundSoft;

    return GestureDetector(
      onTap: (){
        // Here we clean the search query on tap on the search field
        // So the user can see the search history, not previous search results
        final text = ref.read(searchProvider(_scope)).searchText;
        ref.read(searchProvider(_scope).notifier).clear();

        // Push the route first so the transition starts on the next frame.
        // Analytics/method-channel work happens after, in a microtask, so it
        // doesn't extend the frame that handles the tap.
        unawaited(context.router.push(SearchRoute(expansion: Expansion.expanded, initialState: text)));

        scheduleMicrotask(() {
          Metrics.logEventAdvanced(
            MetricsConstants.exploreKeys.searchField,
            action: MetricAction.tap.name,
            group: MetricsConstants.exploreTag,
          );
          BssService.instance.sendEvent(
            const BssRequest(
              eventType: BSSEventType.action,
              actionType: BSSActionType.tap,
              uiElement: BssUIElement(name: BssUIElementNames.searchField),
            ),
          );
          ref.read(advertMetricsProvider.notifier).sendEvent(AdvertMetricsKeys.exploreSearch);
          ref
              .read(urbiAnalyticsProvider.notifier)
              .trackWithPrint(
            '${MetricsConstants.searchTag}::${MetricsConstants.searchKeys.uniqueSearchInitialized}',
          );
        });
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusBorder.m),
          color: isDark?context.colors.staticBlack: context.colors.staticWhite,

          border: Border.all(
            color: context.colors.borderDefault,
            width: 0,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(RadiusBorder.m),
          child: AbsorbPointer(
            child: BaladyTextInput.search(
              controller: ctrl,
              inputState: BaladyInputState.readOnly,
              config: BaladyInputConfig(
                hintText: context.l10n.searchPlaceOrAddress,
                fillColor: context.colors.backgroundSurface2,
                hintColor: headerHintColor,
                textStyle: context.textStyles.bodySmallRegular,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
