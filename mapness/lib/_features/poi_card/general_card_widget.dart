import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/_features/poi_card/extensions/geopoint_mapper.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/widgets/about.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/contacts_info.dart';
import 'package:mapness/_features/poi_card/widgets/favourites.dart';
import 'package:mapness/_features/poi_card/widgets/footer.dart';
import 'package:mapness/_features/poi_card/widgets/header.dart';
import 'package:mapness/_features/poi_card/widgets/opening_hours.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/poi_card/widgets/trade_license.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/providers/map/find_brief_route_info.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/providers/map/point_of_interest.dart';

class GeneralMapCardWidget extends ConsumerStatefulWidget {
  final DgisObjectIdMessage objectId;

  const GeneralMapCardWidget(
    this.objectId, {
    super.key,
  });

  @override
  ConsumerState<GeneralMapCardWidget> createState() =>
      _GeneralMapCardWidgetState();
}

class _GeneralMapCardWidgetState extends ConsumerState<GeneralMapCardWidget> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      pointOfInterestProvider(
        widget.objectId,
      ),
    );

    final poiCardViewModel = PoiCardViewModel(ref: ref);

    return state.map(
      data: (value) {
        final result = value.value;
        if (result == null) {
          return const SizedBox.shrink();
        }

        return LayoutBuilder(builder: (context, constraints) {
          return _Content(
            viewModel: poiCardViewModel,
            biggestHeight: constraints.biggest.height,
            biggestWidth: constraints.biggest.width,
            directoryObject: result,
          );
        });
      },
      error: (_) {
        poiCardViewModel.onError();
        return const SizedBox.shrink();
      },
      loading: (_) => const SizedBox.shrink(),
    );
  }
}

class _Content extends ConsumerStatefulWidget {
  final PoiCardViewModel viewModel;
  final DirectoryObjectMessage directoryObject;

  final double biggestHeight;
  final double biggestWidth;

  const _Content({
    required this.biggestHeight,
    required this.biggestWidth,
    required this.viewModel,
    required this.directoryObject,
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
    _draggableScrollableController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _draggableScrollableController = DraggableScrollableController();
    _draggableScrollableController.addListener(() {
      if (_draggableScrollableController.size <= 0.001) {
        context.pop();
        widget.viewModel.resetMapControlsState();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final briefInfo = ref.watch(briefRouteInfoProvider(
      finishPoint: RouteSearchPointMessage(
        coordinates: widget.directoryObject.markerPosition!.toGeoPointMessage(),
        objectId: widget.directoryObject.id!,
      ),
      navType: RouteSearchOptionsMessage.car,
    ));
    final poi = PoiModel(
      directoryObjectMessage: widget.directoryObject,
      briefeRouteInfos: briefInfo,
    );

    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize: _headerExtent(),
      minChildSize: .0,
      maxChildSize: .9,
      snap: true,
      snapSizes: [
        _headerExtent(),
        .5,
        .9,
      ],
      builder: (
        BuildContext context,
        ScrollController scrollController,
      ) {
        final data = widget.directoryObject;

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
                            data: poi,
                            ontapClose: () =>
                                _draggableScrollableController.animateTo(
                              0,
                              duration: const Duration(milliseconds: 250),
                              curve: Curves.easeInOut,
                            ),
                          ),
                          pinned: true,
                        ),
                        SliverList.list(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Favourites(data),
                                  About(data),
                                  if (data.openingHours != null)
                                    OpeningHours(widget.directoryObject
                                        .getOpeningHoursModel()),
                                  ContactsInfo(
                                    viewModel: widget.viewModel,
                                    data: data,
                                  ),
                                  if (data.tradeLicense != null)
                                    TradeLicense(data.tradeLicense),
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
                        data: poi,
                        viewModel: widget.viewModel,
                        onEntranceTap: () {
                          setState(() {
                            showEntrances = !showEntrances;
                          });
                          final highlightController =
                              ref.read(highlightProvider.notifier);

                          if (showEntrances) {
                            for (var entrance
                                in widget.directoryObject.entrances) {
                              highlightController.addHighlight(entrance!.id);
                            }
                          } else {
                            for (var entrance
                                in widget.directoryObject.entrances) {
                              highlightController.removeHighlight(entrance!.id);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
