import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/map/providers/point_of_interest.dart';
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
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';

class GeneralMapCardWidget extends ConsumerWidget {
  final DgisObjectIdMessage objectId;

  const GeneralMapCardWidget(
    this.objectId, {
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(pointOfInterestProvider(objectId));

    final poiCardViewModel = PoiCardViewModel(ref: ref);

    return state.map(
      data: (value) {
        final result = value.value;

        return LayoutBuilder(builder: (context, constraints) {
          return _Content(
            viewModel: poiCardViewModel,
            biggestHeight: constraints.biggest.height,
            biggestWidth: constraints.biggest.width,
            data: result,
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

class _Content extends StatefulWidget {
  final PoiCardViewModel viewModel;
  final PoiModel data;

  final double biggestHeight;
  final double biggestWidth;

  const _Content({
    required this.biggestHeight,
    required this.biggestWidth,
    required this.viewModel,
    required this.data,
  });

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  late final DraggableScrollableController _draggableScrollableController;

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
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _draggableScrollableController,
      initialChildSize:
          .2, // TODO: calculate based on bottom (safearea + footerHeight + headerHeight) / biggestHeight
      minChildSize: .0,
      maxChildSize: .9,
      snap: true,
      snapSizes: const [
        .2,
        .5,
        .9,
      ],
      builder: (
        BuildContext context,
        ScrollController scrollController,
      ) {
        final data = widget.data.directoryObjectMessage;
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Material(
            color: const Color(0xFFF1F4F8),
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(16.0),
              topLeft: Radius.circular(16.0),
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
                        data: widget.data,
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
                              if (data?.openingHours != null)
                                OpeningHours(widget.data.directoryObjectMessage
                                    ?.getOpeningHoursModel()),
                              if (data?.contactInfos != null)
                                ContactsInfo(
                                  viewModel: widget.viewModel,
                                  data: data!,
                                ),
                              if (data?.tradeLicense != null)
                                TradeLicense(data?.tradeLicense),
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
                    data: widget.data,
                    viewModel: widget.viewModel,
                  ),
                ),
              ],
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
            style: PackageFonts.frutigerArabic(
              color: colorPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
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
                color: const Color(0xffD14733),
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
