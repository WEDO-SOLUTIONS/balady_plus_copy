import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/domain/model/poi_camera_config.dart';
import 'package:mapness/_features/poi_card/enums/pot_tabs_type.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/widgets/about.dart';
import 'package:mapness/_features/poi_card/widgets/contacts_info.dart';
import 'package:mapness/_features/poi_card/widgets/description.dart';
import 'package:mapness/_features/poi_card/widgets/favourites.dart';
import 'package:mapness/_features/poi_card/widgets/footer/footer.dart';
import 'package:mapness/_features/poi_card/widgets/header.dart';
import 'package:mapness/_features/poi_card/widgets/opening_hours.dart';
import 'package:mapness/_features/poi_card/widgets/poi_card_map_controls.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photo_card.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photos_header.dart';
import 'package:mapness/_features/poi_card/widgets/qr_license_info.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/poi_card/widgets/trade_license.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/lib/common_functions.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';
import 'package:mapness/shared/providers/map/selected_marker.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet_scrollable_content.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:mapness/shared/ui/sheets/error_sheet_v2.dart';
import 'package:mapness/shared/ui/sheets/loading_sheet.dart';

class PoiCardWidget extends StatelessWidget {
  const PoiCardWidget({
    required this.objectId,
    required this.closestPoint,
    super.key,
    this.cameraConfig,
  });
  final DgisObjectIdMessage objectId;
  final PoiCameraConfig? cameraConfig;
  final LatLng? closestPoint;

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    // ref.read(poiCardProviderProvider.notifier).getDgisObject(objectId);
    return LayoutBuilder(
      builder: (context, constraints) => _Content(
        objectId: objectId,
        cameraConfig: cameraConfig,
        biggestHeight: constraints.biggest.height,
        biggestWidth: constraints.biggest.width,
        closestPoint: closestPoint,
        // directoryObject: result,
      ),
    );
  }
}

class _Content extends ConsumerStatefulWidget {
  const _Content({
    required this.biggestHeight,
    required this.biggestWidth,
    required this.objectId,
    required this.closestPoint,
    this.cameraConfig,
  });
  final DgisObjectIdMessage objectId;
  final PoiCameraConfig? cameraConfig;

  final double biggestHeight;
  final double biggestWidth;
  final LatLng? closestPoint;

  @override
  ConsumerState<_Content> createState() => _ContentState();
}

class _ContentState extends ConsumerState<_Content>
    with SingleTickerProviderStateMixin {
  bool showEntrances = false;

  final _expansion = ValueNotifier(Expansion.middle);
  late final TabController _tabController;
  late final ValueNotifier<PoiTabsType> _tabType;

  late final DgisBottomSheetController _bottomSheetController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );

    _tabType = ValueNotifier(PoiTabsType.info);
    _tabController.addListener(
      () {
        if (_tabController.indexIsChanging) {
          switch (_tabController.index) {
            case 0:
              _tabType.value = PoiTabsType.info;
            case 1:
              _tabType.value = PoiTabsType.photos;
          }
        }
      },
    );

    _bottomSheetController = DgisBottomSheetController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _tabType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.l10n;
    final viewModel = PoiCardViewModel(ref: ref);
    final viewModelProvider = poiCardProviderProvider(
      widget.objectId,
      cameraConfig: widget.cameraConfig,
      closestPoint: widget.closestPoint,
    );
    final state = ref.watch(viewModelProvider);

    final poiCardState = state.valueOrNull;
    final data = poiCardState?.gisObjectIdMessage;
    final objectId = data?.id?.objectId;

    /// loading progress indicator
    if (state.isLoading) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: LoadingSheet(text: context.l10n.sending),
      );
    }

    /// error handling or invalid data
    if (state.hasError || objectId == null || data == null) {
      if (state.error is PlatformException &&

          /// sometimes error code is in message and sometimes in code, idk, probably changed in releases
          ((state.error! as PlatformException).code == 'NotFoundException' ||
              (state.error! as PlatformException).message ==
                  'NotFoundException')) {
        return Column(
          children: [
            const Spacer(flex: 3),
            ErrorSheetV2(
              errorTitle: locale.poiObjectNotFoundTitle,
              errorContent: locale.poiObjectNotFoundContent,
              buttonLabel: locale.poiObjectNotFoundButtonLabel,
              assetImage: 'assets/images_svg/happy_face.svg',
              package: PackageConfig.packageName,
              onRetry: () => context.pop(),
            )
          ],
        );
      }
      return Column(
        children: [
          const Spacer(flex: 3),
          ErrorSheet(
            onRetry: () => ref.invalidate(
              pointOfInterestProvider(widget.objectId),
            ),
          ),
        ],
      );
    }

    /// has value
    final qrTradeLicense = poiCardState?.qrTradeLicense;
    final tradeLicense = poiCardState?.tradeLicense;

    final about = data.about;
    final name = data.buildingInfo.buildingName;
    if (name != null) {
      data.title = name;
    }

    // TODO(scroollocker): move it to widget
    final infoBody = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Favourites(data),
          About(
            title: data.address?.buildingName ?? data.title,
            exits: data.entrances.length,
            onEntranceTap: () => showEntrance(data),
          ),
          if (about.isNotEmpty)
            Description(
              text: about,
            ),
          if (data.openingHours != null)
            OpeningHours(
              data.getOpeningHoursModel(
                context.l10n,
              ),
            ),
          ContactsInfo(
            viewModel: viewModel,
            data: data,
          ),
          if (qrTradeLicense != null) QrLicenseInfo(qrTradeLicense),
          if (tradeLicense != null) TradeLicense(tradeLicense),
          const SafeArea(
            top: false,
            child: SizedBox(height: footerHeight),
          ),
        ],
      ),
    );
    final language = ref.watch(appLanguageProvider);

    return Directionality(
      textDirection: switch (language) {
        Language.arabic => TextDirection.rtl,
        Language.english => TextDirection.ltr,
      },
      child: DgisBottomSheet(
        showBarrier: false,
        availableExpansions: Expansion.values.toSet(),
        initialExpansion: Expansion.middle,
        collapsedHeight: 300,
        middleHeight: 600,
        hiddenHeight: 100,
        controller: _bottomSheetController,
        mapControlsBuilder:
            (context, scrollController, biggestHeight, smallestHeight) =>
                PoiCardMapControls(
          scrollController: scrollController,
          biggestHeight: biggestHeight,
        ),
        onExpansionChanged: (expansion, {byUser = false}) =>
            _expansion.value = expansion,
        scrollHeader: PoiPhotosHeader(
          objectId: objectId,
          expansion: _expansion,
        ),
        actions: PoiCardFooter2(
          data: data,
          share: () => viewModel.share(objectId: objectId),
          callPhone: () => viewModel.callPhone(data: data),
          onEntranceTap: () => showEntrance(data),
        ),
        scrollableBody: (context, controller) =>
            DgisBottomSheetScrollableContent(
          controller: controller,
          header: PoiHeader(
            tabController: _tabController,
            data: data,
            onTapClose: () {
              ref.read(selectedMarkerProvider.notifier).removeMarker(poiPinId);
              ref
                  .read(highlightProvider.notifier)
                  .removeHighlight(widget.objectId);
              context.pop();
            },
          ),
          body: [
            ValueListenableBuilder(
              valueListenable: _tabType,
              builder: (context, tabType, _) => switch (tabType) {
                PoiTabsType.info => infoBody,
                PoiTabsType.photos => PoiPhotoCard(
                    model: PoiModel(
                      directoryObjectMessage: data,
                    ),
                  ),
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showEntrance(DirectoryObjectMessage data) async {
    setState(() {
      showEntrances = !showEntrances;
    });

    final highlightController = ref.read(highlightProvider.notifier);

    if (showEntrances) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _bottomSheetController.animateTo(Expansion.collapsed);
      });
      for (final entrance in data.entrances) {
        await highlightController.addHighlight(entrance!.id);
      }

      await _animateToEntrance([
        ...data.entrances
            .map((e) => e?.geometry?.entrancePoints ?? [])
            .toList()
            .expand((element) => element)
            .toList()
      ]);
    } else {
      for (final entrance in data.entrances) {
        await highlightController.removeHighlight(entrance!.id);
      }
    }
  }

  Future<void> _animateToEntrance(List<GeoPointMessage?> data) async {
    if (data.isEmpty) {
      return;
    }

    // Remove all null values
    final points = data.where((element) => element != null);

    if (points.isEmpty) {
      return;
    }

    double minDistance = double.infinity;
    GeoPointMessage? minCoords;
    // Find the minimum distance to entrance
    for (final point in points) {
      final distance = CommonFunctions.distance(
        point!.latitude,
        point.longitude,
        widget.closestPoint?.latitude ?? 0,
        widget.closestPoint?.longitude ?? 0,
      );
      if (distance <= minDistance) {
        minDistance = distance;
        minCoords = point;
      }
    }

    if (minCoords == null) {
      return;
    }

    final cameraController = ref.read(cameraPositionProvider.notifier);
    final cameraPosition = ref.read(cameraPositionProvider);

    // Animate to the entrance
    await cameraController.animateTo(
      CameraPositionMessage(
        point: GeoPointMessage(
          latitude: minCoords.latitude,
          longitude: minCoords.longitude,
        ),
        zoom: 18,
        tilt: cameraPosition?.tilt ?? 0,
        bearing: cameraPosition?.tilt ?? 0,
      ),
    );
  }
}
