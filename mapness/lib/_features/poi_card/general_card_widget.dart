import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/widgets/about.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/contacts_info.dart';
import 'package:mapness/_features/poi_card/widgets/favourites.dart';
import 'package:mapness/_features/poi_card/widgets/footer.dart';
import 'package:mapness/_features/poi_card/widgets/header.dart';
import 'package:mapness/_features/poi_card/widgets/opening_hours.dart';
import 'package:mapness/_features/poi_card/widgets/qr_license_info.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/poi_card/widgets/trade_license.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:shimmer/shimmer.dart';

class GeneralMapCardWidget extends ConsumerWidget {
  final DgisObjectIdMessage objectId;

  const GeneralMapCardWidget(
    this.objectId, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(poiCardProviderProvider(objectId));
    // ref.read(poiCardProviderProvider.notifier).getDgisObject(objectId);

    return LayoutBuilder(builder: (context, constraints) {
      return _Content(
        objectId: objectId,
        biggestHeight: constraints.biggest.height,
        biggestWidth: constraints.biggest.width,
        state: state,
        // directoryObject: result,
      );
    });
  }
}

class _Content extends ConsumerStatefulWidget {
  final DgisObjectIdMessage objectId;

  final double biggestHeight;
  final double biggestWidth;

  final AsyncValue<PoiCardState?> state;

  const _Content({
    required this.biggestHeight,
    required this.biggestWidth,
    required this.objectId,
    required this.state,
  });

  @override
  ConsumerState<_Content> createState() => _ContentState();
}

class _ContentState extends ConsumerState<_Content> {
  late final DraggableScrollableController _draggableScrollableController;

  bool showEntrances = false;

  double _headerExtent() {
    // TODO: calculate based on bottom (safearea + footerHeight + headerHeight) / biggestHeight
    return (footerHeight + headerHeight) / widget.biggestHeight;
  }

  @override
  void dispose() {
    _draggableScrollableController.removeListener(scrollListener);
    _draggableScrollableController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController();
    _draggableScrollableController.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {}

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        controller: _draggableScrollableController,
        initialChildSize: _headerExtent(),
        minChildSize: .1,
        maxChildSize: .9,
        snap: true,
        snapSizes: [.1, _headerExtent(), .7, .9],
        builder: (
          BuildContext context,
          ScrollController scrollController,
        ) {
          final viewModel = PoiCardViewModel(ref: ref);

          return widget.state.map(data: (value) {
            ///do not remove, using for data mocking
            final poiCardState = value.value;
            final data = poiCardState?.gisObjectIdMessage?.id?.objectId ==
                    70030076560519845
                ? getMockPoiCardData()
                : poiCardState?.gisObjectIdMessage;

            final qrTradeLicense = poiCardState?.qrTradeLicense;
            final tradeLicense = poiCardState?.tradeLicense;

            return Material(
              color: Colors.transparent,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: DecoratedBox(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16.0),
                      topLeft: Radius.circular(16.0),
                    ),
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorPrimary.withOpacity(0.05),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(16.0),
                        topLeft: Radius.circular(16.0),
                      ),
                    ),
                    child: Stack(
                      children: [
                        CustomScrollView(
                          controller: scrollController,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          physics: const ClampingScrollPhysics(),
                          slivers: [
                            SliverPersistentHeader(
                              delegate: PoiCardHeaderDelegate(
                                data: data!,
                                ontapClose: () {
                                  // const LandingRoute().go(context);
                                  context.pop();
                                },
                              ),
                              pinned: true,
                            ),
                            SliverList.list(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Favourites(data),
                                      About(
                                        data,
                                        onEntranceTap: () => showEntrance(data),
                                      ),
                                      if (data.openingHours != null)
                                        OpeningHours(
                                            data.getOpeningHoursModel()),
                                      ContactsInfo(
                                        viewModel: viewModel,
                                        data: data,
                                      ),
                                      if (qrTradeLicense != null)
                                        QrLicenseInfo(qrTradeLicense),
                                      if (tradeLicense != null)
                                        TradeLicense(tradeLicense),
                                      const SafeArea(
                                        top: false,
                                        child: SizedBox(height: footerHeight),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: PoiCardFooter(
                            scrollController: _draggableScrollableController,
                            data: data,
                            viewModel: viewModel,
                            onEntranceTap: () {
                              showEntrance(data);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }, error: (_) {
            Future(
              () => ref
                  .read(mapControlsProvider.notifier)
                  .update(MapControlsStateIdle()),
            );
            return Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                ),
              ),
            );
          }, loading: (_) {
            return Shimmer.fromColors(
              baseColor: Colors.grey[200]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                  ),
                ),
              ),
            );
          });
        });
  }

  void showEntrance(DirectoryObjectMessage data) {
    _draggableScrollableController.animateTo(
      .3,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
    setState(() {
      showEntrances = !showEntrances;
    });

    final highlightController = ref.read(highlightProvider.notifier);
    final cameraController = ref.read(cameraPositionProvider.notifier);
    final cameraPosition = ref.read(cameraPositionProvider);

    if (showEntrances) {
      for (var entrance in data.entrances) {
        highlightController.addHighlight(entrance!.id);
      }
      final firstEntrancePoint =
          data.entrances.first?.geometry?.entrancePoints.first;
      if (firstEntrancePoint != null) {
        cameraController.animateTo(
          CameraPositionMessage(
            point: firstEntrancePoint,
            zoom: 18,
            tilt: cameraPosition?.tilt ?? 0,
            bearing: cameraPosition?.tilt ?? 0,
          ),
        );
      }
    } else {
      for (var entrance in data.entrances) {
        highlightController.removeHighlight(entrance!.id);
      }
    }
  }
}

class _Parking extends StatelessWidget {
  final ParkingInfoMessage? parkingInfo;

  const _Parking(this.parkingInfo);

  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'موقف سيارات',
            style: Theme.of(context)
                .extension<ThemeTextStyles>()!
                .accentM
                .copyWith(color: colorPrimary),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              parkingIcon,
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkStatus extends StatelessWidget {
  final WorkStatusMessage? workStatus;

  const _WorkStatus(this.workStatus);

  @override
  Widget build(BuildContext context) {
    return CardContent(
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset(
                'assets/icons/svg/ic_time.svg',
                package: PackageConfig.packageName,
                height: 24,
                width: 24,
                color: colorIconError,
              ),
              const SizedBox(
                width: 8,
              ),
              const Text(
                'لا يعمل مؤقتًا',
                style: TextStyle(
                  color: colorPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 8,
          ),
          const Text(
            'هذا الفرع حاليًا مغلق مؤقتًا، ولكن سيعود للعمل بعد فترة التحقق من المعلومات من الشركة.',
            style: TextStyle(
              color: colorPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
