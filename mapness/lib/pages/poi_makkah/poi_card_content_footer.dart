part of 'poi_makkah_widget_page.dart';

void _onMakkahDirectionsTap(
  BuildContext context,
  WidgetRef ref,
  DirectoryObjectMessage data,
  LatLng? closestPoint,
) {
  final markerPosition = data.markerPosition;
  final lat = markerPosition?.latitude ?? closestPoint?.latitude;
  final lon = markerPosition?.longitude ?? closestPoint?.longitude;

  if (lat == null || lon == null) return;

  final objectId = data.id?.objectId ?? 0;

  final mapSetting = MapObjectManagerSettings.search();
  ref
      .read(
        mapObjectManagerProvider(
          named: mapSetting.name,
          layerId: mapSetting.layerId,
        ).notifier,
      )
      .setMapObjectManagerIsVisible(isVisible: false);

  context.router.push(
    RoutingRoutesRoute(
      points: [
        RouteParamsPointWithLabel(value: null, label: context.l10n.myLocation),
        RouteParamsPointWithLabel(
          value: RouteParamsPoint(
            latitude: lat,
            longitude: lon,
            objectId: objectId,
          ),
          label: data.title,
        ),
      ],
    ),
  );
}

class _MakkahPoiFooterPlaceholder extends ConsumerWidget {
  final MultiStateSheetController<PoiCardBottomSheetState> bottomSheetController;
  final DirectoryObjectMessage data;
  final LatLng? closestPoint;
  final MakkahPlace? makkahPlace;
  final _MakkahPoiColors colors;

  const _MakkahPoiFooterPlaceholder({
    required this.bottomSheetController,
    required this.data,
    required this.colors,
    this.closestPoint,
    this.makkahPlace,
  });

  Future<void> _onPhoneTap(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  void _onWebsiteTap(String website) {
    final uri = Uri.parse(website);
    launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _onInstagramTap(String? website) async {
    if (website == null || website.isEmpty) return;

    try {
      final uri = Uri.parse(website);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      // Handle invalid URL silently
    }
  }

  void _onBookmarkTap(BuildContext context, WidgetRef ref) {
    final objectId = data.id?.objectId;
    if (objectId == null || data.markerPosition == null) return;

    final favState = ref.read(favouriteCacheProvider).value;
    final favNotifier = ref.read(favouriteCacheProvider.notifier);
    final favouriteItem = favNotifier.getFavouriteOrNull(objectId);

    if (favouriteItem != null) {
      favNotifier.deleteItem(favouriteItem);
      return;
    }

    final favItem = FavouriteItem(
      coordinates: Coordinates(
        latitude: data.markerPosition!.latitude,
        longitude: data.markerPosition!.longitude,
      ),
      id: 'overriden',
      subtitle: data.subtitle,
      title: data.title,
      entity: FavouriteItemEntity(
        sourceType: EntitySourceType.urbi,
        id: objectId.toString(),
      ),
    );

    if (favState?.home != null && favState?.work != null) {
      favNotifier.addItem(favItem);
    } else {
      // Build the rich POI here, where [data] (addr/type/marker) is available,
      // so `favorite_add` reports poi_addr/poi_type/poi_distance.
      final loc = ref.read(locationProvider);
      final favoritePoi = data.toDataFinderPoi(myLat: loc?.latitude, myLon: loc?.longitude);
      context.router.push(PoiFavoriteDialogRoute(favItem: favItem, favoritePoi: favoritePoi));
    }
  }

  void _onParkingTap(BuildContext context, WidgetRef ref) {
    final hasParking =
        ref.read(parkingManageProvider(theme: context.read<ThemeController>().currentTheme)).value != null;
    if (hasParking) {
      context.router.push(
        ParkingDialogRoute(
          title: context.l10n.createNewParkingSpot,
          desc: context.l10n.currentParkingSpaceRemoved,
          onAcceptTab: () async {
            context.router.pop();
            await Future.delayed(Duration.zero);
            await context.router.push(
              ParkingSpotRoute(
                address: data.title,
                markerPosition: closestPoint != null
                    ? GeoPointWithElevationMessage(
                        latitude: closestPoint!.latitude,
                        longitude: closestPoint!.longitude,
                        elevation: 0,
                      )
                    : data.markerPosition,
              ),
            );
          },
          onCancelTab: () => context.router.pop(),
        ),
      );
    } else {
      context.router.push(
        ParkingSpotRoute(
          address: data.title,
          markerPosition: closestPoint != null
              ? GeoPointWithElevationMessage(
                  latitude: closestPoint!.latitude,
                  longitude: closestPoint!.longitude,
                  elevation: 0,
                )
              : data.markerPosition,
        ),
      );
    }
  }

  void _onShareTap(BuildContext context) {
    // Prefer makkahPlace.dgisId for sharing, fall back to data.id.objectId

    final shareId = makkahPlace?.dgisId ?? data.id?.objectId.toString();
    final lat = makkahPlace?.lat ?? data.markerPosition?.latitude;
    final lon = makkahPlace?.lon ?? data.markerPosition?.longitude;
    final coordinates = lat != null && lon != null ? Coordinates(latitude: lat, longitude: lon) : null;
    if (shareId == null || shareId == '0') {
      return;
    }

    ShareUtil.sharePOI(context: context, objectId: shareId, markerCoords: coordinates);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phone = makkahPlace?.phone;
    final website = makkahPlace?.website;
    final hasPhone = phone != null && phone.isNotEmpty;
    final hasWebsite = website != null && website.isNotEmpty;
    final hasInstagram = hasWebsite && website.contains('instagram.com');

    final objectId = data.id?.objectId;
    final dgisId = makkahPlace?.dgisId;
    final canShare = (dgisId != null && dgisId.isNotEmpty) || (objectId != null && objectId != 0);
    ref.watch(favouriteCacheProvider).value;
    final provider = ref.watch(favouriteCacheProvider.notifier);
    final isFavourite = objectId != null && provider.isFavourite(objectId);

    final hasParking =
        ref.watch(parkingManageProvider(theme: context.read<ThemeController>().currentTheme)).value != null;

    final actionButtons = <Widget>[
      _MakkahFooterSquareButton(
        svgAsset: MakkahPoiConstants.bookmarkIconPath,
        isFilled: isFavourite,
        onPressed: () => _onBookmarkTap(context, ref),
        colors: colors,
      ),
      if (canShare)
        _MakkahFooterSquareButton(
          svgAsset: MakkahPoiConstants.shareIconPath,
          onPressed: () => _onShareTap(context),
          colors: colors,
        ),
      _MakkahFooterSquareButton(
        onPressed: () => _onParkingTap(context, ref),
        svgAsset: MakkahPoiConstants.parkingAddIconPath,
        isFilled: hasParking,
        matchTextDirection: false,
        colors: colors,
      ),
      if (hasInstagram)
        _MakkahFooterSquareButton(
          svgAsset: MakkahPoiConstants.instagramIconPath,
          onPressed: () => _onInstagramTap(website),
          colors: colors,
        ),
      if (hasPhone)
        _MakkahFooterSquareButton(
          svgAsset: MakkahPoiConstants.phoneIconPath,
          onPressed: () => _onPhoneTap(phone),
          colors: colors,
        ),
      if (hasWebsite && !hasInstagram)
        _MakkahFooterSquareButton(
          svgAsset: MakkahPoiConstants.webIconPath,
          onPressed: () => _onWebsiteTap(website),
          colors: colors,
        ),
    ];

    final spacedButtons = <Widget>[];
    for (var i = 0; i < actionButtons.length; i++) {
      if (i != 0) spacedButtons.add(const SizedBox(width: Spacing.$2x));
      spacedButtons.add(actionButtons[i]);
    }
    // Add end padding so last button doesn't touch screen edge
    spacedButtons.add(const SizedBox(width: Spacing.$4x));

    final barColor = colors.headerBackground;
    final directionsBg = colors.directionsButtonBackground;
    final directionsFg = colors.directionsButtonForeground;
    return ColoredBox(
      color: barColor,
      child: Container(
        padding: const EdgeInsetsDirectional.only(
          start: Spacing.$4x,
          top: Spacing.$3x,
          bottom: Spacing.$3x,
        ),
        decoration: BoxDecoration(
          color: barColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              offset: const Offset(0, -4),
              color: context.colors.foregroundSoft.withOpacity(0.08),
            ),
          ],
        ),
        child: Row(
          children: [
            Directionality(
              textDirection: TextDirection.rtl,
              child: AppButton(
                buttonColorScheme: ButtonColorScheme.accentSecondary,
                buttonType: ButtonType.primary,
                size: ButtonSize.medium,
                onTap: () => _onMakkahDirectionsTap(
                  context,
                  ref,
                  data,
                  closestPoint,
                ),
                trailing: SvgPicture.asset(
                  'assets/icons/makkah/directions.svg',
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    directionsFg,
                    BlendMode.srcIn,
                  ),
                  matchTextDirection: true,
                ),
                primaryLabel: context.l10n.poiCardDirections,
                color: directionsBg,
                textColor: directionsFg,
                iconColor: directionsFg,
                innerPadding: const EdgeInsets.symmetric(
                  vertical: Spacing.$2x,
                  horizontal: Spacing.$3x,
                ),
              ),
            ),
            const SizedBox(width: Spacing.$2x),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                primary: false,
                physics: const ClampingScrollPhysics(),
                child: Row(children: spacedButtons),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MakkahFooterSquareButton extends StatelessWidget {
  final String? svgAsset;
  final VoidCallback? onPressed;
  final bool isFilled;
  final bool matchTextDirection;
  final _MakkahPoiColors colors;

  const _MakkahFooterSquareButton({
    required this.onPressed,
    required this.colors,
    this.svgAsset,
    this.isFilled = false,
    this.matchTextDirection = true,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = isFilled
        ? (colors.actionButtonIconColor == MakkahPoiConstants.normalActionIconColor
              ? MakkahPoiConstants.filledActionIconColor
              : colors.actionButtonIconColor)
        : colors.actionButtonIconColor;
    return AppButton(
      buttonColorScheme: ButtonColorScheme.neutral,
      buttonType: ButtonType.secondary,
      onTap: onPressed,
      trailing: svgAsset == null
          ? null
          : _makkahFooterSvgIcon(
              context,
              svgAsset!,
              color: iconColor,
              matchTextDirection: matchTextDirection,
            ),
      color: colors.actionButtonBackground,
      iconColor: iconColor,
      padding: EdgeInsets.zero,
      innerPadding: const EdgeInsets.symmetric(horizontal: Spacing.$2x),
    );
  }
}
