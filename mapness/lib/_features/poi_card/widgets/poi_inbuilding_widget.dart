import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/extensions/layout_extension.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mapness/_features/poi_card/domain/model/organization_item.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/extensions/organizations_ext.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/app/router.dart';
import 'package:mapness/app/routes/poi_map.dart';

class InBuildingWidget extends ConsumerStatefulWidget {
  final PoiCardState? state;
  final DgisObjectIdMessage objectId;
  final PoiCameraConfig? cameraConfig;
  final LatLng? closestPoint;
  final double? bottomTabsHeight;

  const InBuildingWidget({
    required this.state,
    required this.objectId,
    super.key,
    this.cameraConfig,
    this.closestPoint,
    this.bottomTabsHeight,
  });

  @override
  ConsumerState<InBuildingWidget> createState() => _InBuildingWidgetState();
}

class _InBuildingWidgetState extends ConsumerState<InBuildingWidget> {
  late final PagingController<int, OrganizationItem> pagingController;
  late final ScrollController scrollController;
  bool init = true;

  @override
  void initState() {
    scrollController = ScrollController();
    pagingController = PagingController(
      firstPageKey: (widget.state?.organizations?.page ?? 1) + 1,
    );
    pagingController
      ..itemList = widget.state?.organizations?.itemsFiltered
      ..addPageRequestListener(_fetchPage);

    init = false;

    super.initState();
  }

  @override
  void dispose() {
    pagingController
      ..removePageRequestListener(_fetchPage)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CustomScrollView(
        controller: scrollController,
        physics: const BouncingScrollPhysics(),
        scrollBehavior: const CupertinoScrollBehavior(),
        shrinkWrap: true,
        slivers: [
          PagedSliverList<int, OrganizationItem>.separated(
            shrinkWrapFirstPageIndicators: true,
            pagingController: pagingController,
            builderDelegate: PagedChildBuilderDelegate<OrganizationItem>(
              itemBuilder: (context, item, index) => ContentWrapper(
                color: context.color.surfaceBasePrimary,
                children: [
                  ContentRow(
                    onTap: () {
                      final id = item.id;
                      if (id == null) {
                        return;
                      }
                      context.pop();
                      PoiMapRoute.open(
                        ref.read(goRouterProvider),
                        int.parse(id),
                        zoom: widget.cameraConfig?.zoom,
                        bearing: widget.cameraConfig?.bearing,
                        tilt: widget.cameraConfig?.tilt,
                        latLng: widget.closestPoint,
                      );
                    },
                    options: ContentRowOptions(
                      title: item.title,
                      subtitle: item.rubricsNames,
                      subtitleExtra: item.addressComment,
                    ),
                  )
                ],
              ),
            ),
            separatorBuilder: (context, index) => Spacing.verticalPaddingInsideWrapper.heightBox,
          ),
          SliverToBoxAdapter(
              child: ((widget.bottomTabsHeight ?? 56.0) + MediaQuery.of(context).padding.bottom).heightBox),
        ],
      );

  Future<void> _fetchPage(int pageKey) async {
    final viewModelProvider = poiCardProviderProvider(
      widget.objectId.objectId,
      cameraConfig: widget.cameraConfig,
      closestPoint: widget.closestPoint,
    );

    try {
      final newItems = await ref.read(viewModelProvider.notifier).fetchOrganizationsData(
            objectId: widget.objectId.objectId,
            page: pageKey,
          );

      final length = pagingController.itemList?.length ?? 0;
      final total = newItems?.count ?? 0;
      if (length >= total) {
        pagingController.appendLastPage(newItems?.itemsFiltered ?? []);
      } else {
        pagingController.appendPage(newItems?.itemsFiltered ?? [], pageKey + 1);
      }
    } catch (error) {
      pagingController.error = error;
    }
  }
}
