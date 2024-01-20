import 'package:balady_uikit/typography/text_theme_styles.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mapness/_features/landing/providers/map_controls.dart'
    as map_control_provider;
import 'package:mapness/_features/poi_card/constants/info_mock.dart';
import 'package:mapness/_features/poi_card/extensions/directory_message_ext.dart';
import 'package:mapness/_features/poi_card/poi_card_view_model.dart';
import 'package:mapness/_features/poi_card/provider/poi_card_provider.dart';
import 'package:mapness/_features/poi_card/widgets/about.dart';
import 'package:mapness/_features/poi_card/widgets/card_content.dart';
import 'package:mapness/_features/poi_card/widgets/contacts_info.dart';
import 'package:mapness/_features/poi_card/widgets/description.dart';
import 'package:mapness/_features/poi_card/widgets/favourites.dart';
import 'package:mapness/_features/poi_card/widgets/header.dart';
import 'package:mapness/_features/poi_card/widgets/opening_hours.dart';
import 'package:mapness/_features/poi_card/widgets/poi_photos_row.dart';
import 'package:mapness/_features/poi_card/widgets/style.dart';
import 'package:mapness/_features/poi_card/widgets/trade_license.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/app_language.dart';
import 'package:mapness/shared/providers/map/camera_position.dart';
import 'package:mapness/shared/providers/map/highlight.dart';
import 'package:mapness/shared/ui/bottom_sheet/dgis_bottom_sheet_scrollable_content.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared/ui/bottom_sheet/dgis_bottom_sheet.dart';
import 'provider/poi_photo_provider.dart';
import 'widgets/footer.dart';

class GeneralMapCardWidget extends StatelessWidget {
  final DgisObjectIdMessage objectId;

  const GeneralMapCardWidget(
    this.objectId, {
    super.key,
  });

  @override
  // ignore: prefer_expression_function_bodies
  Widget build(BuildContext context) {
    // ref.read(poiCardProviderProvider.notifier).getDgisObject(objectId);

    return LayoutBuilder(
      builder: (context, constraints) => _Content(
        objectId: objectId,
        biggestHeight: constraints.biggest.height,
        biggestWidth: constraints.biggest.width,
        // directoryObject: result,
      ),
    );
  }
}

class _Content extends ConsumerStatefulWidget {
  final DgisObjectIdMessage objectId;

  final double biggestHeight;
  final double biggestWidth;

  const _Content({
    required this.biggestHeight,
    required this.biggestWidth,
    required this.objectId,
  });

  @override
  ConsumerState<_Content> createState() => _ContentState();
}

class _ContentState extends ConsumerState<_Content> {
  bool showEntrances = false;

  final _expansion = ValueNotifier(Expansion.middle);

  @override
  Widget build(BuildContext context) {
    final viewModel = PoiCardViewModel(ref: ref);
    final viewModelProvider = poiCardProviderProvider(widget.objectId);
    final state = ref.watch(viewModelProvider);

    final poiCardState = state.valueOrNull;
    final data = poiCardState?.gisObjectIdMessage;
    final objectId = data?.id?.objectId;

    /// loading shimmer
    if (state.isLoading) {
      return Column(
        children: [
          const Spacer(flex: 3),
          Expanded(
            child: Shimmer.fromColors(
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
            ),
          ),
        ],
      );
    }

    /// error handling or invalid data
    if (state.hasError || objectId == null || data == null) {
      // TODO(ForesThule): fix this
      // чет очень не очень, что у нас логика внутри юай. И если будет стейт в ошибке и перерисовка, то
      // то спамим обновление провайдера. Риверпод, не должен плодить обновление тк стейт идентичен,
      // но класс не реализует сравнение и хеш, так что не гарантирую что все ок и это не приведет к проблемам.
      // чем обусловлен этот вызов я не совсем понял, так что оставил.
      // ps: коммент удалить после фикса
      Future(
        () => ref
            .read(map_control_provider.mapControlsProvider.notifier)
            .update(map_control_provider.MapControlsStateIdle()),
      );
      return Column(
        children: [
          const Spacer(flex: 3),
          ErrorSheet(
            onRetry: () => ref.invalidate(viewModelProvider),
          ),
        ],
      );
    }

    /// has value
    // final qrTradeLicense = poiCardState?.qrTradeLicense;
    final tradeLicense = poiCardState?.tradeLicense;

    final about = aboutMock(
      objectId,
      ref.read(appLanguageProvider),
    );
    final name = data.buildingInfo.buildingName;
    if (name != null) {
      data.title = name;
    }

    return Directionality(
      textDirection: switch (ref.watch(appLanguageProvider)) {
        Language.arabic => TextDirection.rtl,
        Language.english => TextDirection.ltr,
      },

      /// TODO(Demezy): add support for map controls in bottom sheet
      child: DgisBottomSheet(
        showBarrier: false,
        availableExpansions: Expansion.values.toSet(),
        initialExpansion: Expansion.middle,
        collapsedHeight: 300,
        middleHeight: 600,
        onExpansionChanged: (expansion, {byUser = false}) =>
            _expansion.value = expansion,
        scrollHeader: Consumer(
          builder: (context, ref, child) {
            final photos = ref.watch(poiPhotoProvider(objectId));

            /// each item has not null image url, have at least one - show photos
            if (photos.hasValue && photos.requireValue.items.isEmpty) {
              /// if no photos - hide
              return const SizedBox.shrink();
            }

            return child!;
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: ValueListenableBuilder(
              valueListenable: _expansion,
              builder: (context, value, child) => AnimatedSize(
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child: SizedBox(
                  height: switch (value) {
                    Expansion.expanded => 0,
                    Expansion.middle => 150,
                    Expansion.collapsed => 100,
                    Expansion.hidden => 0,
                  },
                  child: child,
                ),
              ),
              child: PoiPhotosRow(objectId: objectId),
            ),
          ),
        ),
        actions: PoiCardFooter(
          data: data,
          viewModel: viewModel,
          onEntranceTap: () {
            showEntrance(data);
          },
        ),
        scrollableBody: (context, controller) =>
            DgisBottomSheetScrollableContent(
          controller: controller,
          header: PoiHeader(
            data: data,
            onTapClose: () {
              // const LandingRoute().go(context);
              context.pop();
            },
          ),
          body: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Favourites(data),
                  About(
                    data,
                    onEntranceTap: () => showEntrance(data),
                  ),
                  if (about != null)
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
                  // if (qrTradeLicense != null)
                  //   QrLicenseInfo(qrTradeLicense),
                  if (tradeLicense != null) TradeLicense(tradeLicense),
                  const SafeArea(
                    top: false,
                    child: SizedBox(height: footerHeight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showEntrance(DirectoryObjectMessage data) {
    // _draggableScrollableController.animateTo(
    //   .3,
    //   duration: const Duration(milliseconds: 300),
    //   curve: Curves.easeIn,
    // );
    setState(() {
      showEntrances = !showEntrances;
    });

    final highlightController = ref.read(highlightProvider.notifier);
    final cameraController = ref.read(cameraPositionProvider.notifier);
    final cameraPosition = ref.read(cameraPositionProvider);

    if (showEntrances) {
      for (final entrance in data.entrances) {
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
      for (final entrance in data.entrances) {
        highlightController.removeHighlight(entrance!.id);
      }
    }
  }
}

class _Parking extends StatelessWidget {
  final ParkingInfoMessage? parkingInfo;

  const _Parking(this.parkingInfo);

  @override
  // ignore: prefer_expression_function_bodies
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
  // ignore: prefer_expression_function_bodies
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
