import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/colorsV2/themes.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:balady_uikit/core/widgets/smooth_radius.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/city_event/active_city_event.dart';
import 'package:mapness/features/poi_card/domain/model/organization_item.dart';
import 'package:mapness/features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/features/poi_card/domain/model/poi_content/src/poi_content_feedback.dart';
import 'package:mapness/features/poi_card/extensions/organizations_ext.dart';
import 'package:mapness/features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/features/poi_card/widgets/poi_content/src/poi_content_feedback_banner.dart';
import 'package:provider/provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

class PoiOrganizationsSliver extends ConsumerStatefulWidget {
  final PoiCardState? state;
  final DgisObjectIdMessage objectId;
  final PoiCameraConfig? cameraConfig;
  final LatLng? closestPoint;
  final double? bottomTabsHeight;

  const PoiOrganizationsSliver({
    required this.state,
    required this.objectId,
    super.key,
    this.cameraConfig,
    this.closestPoint,
    this.bottomTabsHeight,
  });

  @override
  ConsumerState<PoiOrganizationsSliver> createState() => _PoiInBuildingSliverState();
}

class _PoiInBuildingSliverState extends ConsumerState<PoiOrganizationsSliver> {
  late final PagingController<int, OrganizationItem> pagingController;
  late final ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController();
    pagingController = PagingController(
      getNextPageKey: (state) => state.lastPageIsEmpty ? null : state.nextIntPageKey,
      fetchPage: _fetchPage,
    );

    super.initState();
  }

  bool isDisposed = false;

  @override
  void dispose() {
    isDisposed = true;
    pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModelProvider = poiCardProviderProvider(
      widget.objectId.objectId,
      context.read<ThemeController>().currentTheme,
      cameraConfig: widget.cameraConfig,
      closestPoint: widget.closestPoint,
    );
    final viewModel = ref.listen(
      viewModelProvider,
      (prev, next) {
        next.whenOrNull(
          error: (error, stack) {
            if (error is TimeoutException) {
              ref.read(appRouterProvider).pop();
            }
          },
        );
      },
    );
    return MultiSliver(
      children: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.only(top: Spacing.$4x, bottom: Spacing.$2x + Spacing.$0_5x),
            child: PoiContentFeedbackCard(
              data: PoiContentFeedbackType.addPlace,
              onTap: () => context.router.push(QuickFeedbackRoute()),
              activeCityEvent: ref.watch(activeCityEventProvider),
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.only(
            left: Spacing.$4x,
            right: Spacing.$4x,
            bottom: Spacing.$4x,
            top: Spacing.$0_5x,
          ),
          sliver: PagingListener(
            controller: pagingController,
            builder: (context, state, fetchNextPage) => PagedSliverList<int, OrganizationItem>.separated(
              fetchNextPage: fetchNextPage,
              state: state,
              shrinkWrapFirstPageIndicators: true,
              builderDelegate: PagedChildBuilderDelegate<OrganizationItem>(
                newPageProgressIndicatorBuilder: (context) => Center(child: Loading.medium()),
                itemBuilder: (context, item, index) => OrganizationWidget(
                  item: item,
                  onTap: (id) {
                    final id = item.id;
                    if (id == null) {
                      return;
                    }
                    context.router.replace(
                      PoiCardWidgetRoute(
                        objectId: DgisObjectIdMessage(objectId: int.parse(id), entranceId: 0),
                        closestPoint: widget.closestPoint,
                        cameraConfig: PoiCameraConfig(
                          zoom: widget.cameraConfig?.zoom,
                          bearing: widget.cameraConfig?.bearing,
                          tilt: widget.cameraConfig?.tilt,
                        ),
                      ),
                    );
                  },
                ),
              ),
              separatorBuilder: (context, index) => (Spacing.$3x - Spacing.$0_5x).heightBox,
            ),
          ),
        ),
      ],
    );
  }

  Future<List<OrganizationItem>> _fetchPage(int pageKey) async {
    final viewModelProvider = poiCardProviderProvider(
      widget.objectId.objectId,
      context.read<ThemeController>().currentTheme,
      cameraConfig: widget.cameraConfig,
      closestPoint: widget.closestPoint,
    );
    final organizationsData = await ref
        .read(viewModelProvider.notifier)
        .fetchOrganizationsData(objectId: widget.objectId.objectId, page: pageKey);

    final items = organizationsData?.itemsFiltered ?? [];

    final licenseIds = items.map((e) => e.tradeLicense?.license).nonNulls.toSet();

    return items;
  }
}

class OrganizationWidget extends StatelessWidget {
  final OrganizationItem item;
  final bool hasOffers;
  final void Function(int id)? onTap;

  const OrganizationWidget({required this.item, this.hasOffers = false, this.onTap, super.key});

  @override
  Widget build(BuildContext context) => Material(
    clipBehavior: Clip.antiAlias,
    shape: smoothBorder(RadiusBorder.xl),
    color: context.colors.backgroundSurface1,
    child: Stack(
      children: [
        ContentRow(
          onTap: () {
            final itemId = item.id;

            if (itemId == null) {
              return;
            }

            final id = int.tryParse(itemId);
            if (id == null) {
              return;
            }
            onTap?.call(id);
          },
          options: ContentRowOptions(
            title: item.title,
            subtitle: item.rubricsNames,
            subtitleExtra: item.addressComment,
            titleStyle: context.textStyles.bodyLargeSemiBold,
          ),
        ),
      ],
    ),
  );
}
