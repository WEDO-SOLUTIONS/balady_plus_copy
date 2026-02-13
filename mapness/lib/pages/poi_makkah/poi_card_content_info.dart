part of 'poi_makkah_widget_page.dart';

class _MakkahNearbySection extends StatelessWidget {
  const _MakkahNearbySection({this.excludeDgisId, this.excludePlaceId});

  final String? excludeDgisId;
  final String? excludePlaceId;

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return DecoratedBox(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/themes/makkah/places_makkah.png'),
          matchTextDirection: true,
          fit: BoxFit.fitWidth,
          alignment: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
            child: Container(
              height: 400,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(RadiusBorder.xl)),
              padding: const EdgeInsets.only(top: Spacing.$4x),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
                    child: Text(
                      context.l10n.placesToVisitNearYou,
                      style: context.textStyles.bodyLargeSemiBold.copyWith(color: const Color(0xFF4A3016)),
                    ),
                  ),
                  const SizedBox(height: Spacing.$4x),
                  Expanded(child: PlacePreviewMakkah(excludeDgisId: excludeDgisId, excludePlaceId: excludePlaceId)),
                ],
              ),
            ),
          ),
          const SizedBox(height: Spacing.$6x),
        ],
      ),
    );
  }
}

class _MakkahPoiInfoSliverPlaceholder extends ConsumerWidget {
  final int objectId;
  final String aboutText;
  final MakkahPlace? makkahPlace;
  final _MakkahPoiColors colors;

  const _MakkahPoiInfoSliverPlaceholder({
    required this.objectId,
    required this.aboutText,
    required this.colors,
    this.makkahPlace,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final workingHours = _workingHoursFromMakkahJson(makkahPlace?.workhoursJson);
    final workhoursHint = isArabic ? makkahPlace?.workhoursAr : makkahPlace?.workhoursEn;
    final address = isArabic ? makkahPlace?.addressAr : makkahPlace?.addressEn;
    final featuresFromList = (makkahPlace?.features ?? const [])
        .map((e) => isArabic ? (e.textAr ?? '') : (e.textEn ?? ''))
        .where((e) => e.trim().isNotEmpty)
        .join('\n');
    final features =
        featuresFromList.trim().isNotEmpty
            ? featuresFromList
            : (isArabic ? makkahPlace?.featuresAr : makkahPlace?.featuresEn);
    final accessibility = isArabic ? makkahPlace?.accessibilityAr : makkahPlace?.accessibilityEn;

    const itemPadding = EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, bottom: Spacing.$3x);

    final featureWidgets = _buildFeatureWidgets(context, features, makkahPlace?.features, accessibility);

    final title =
        makkahPlace != null ? MakkahMultilingualHelper.getTitle(makkahPlace!, Directionality.of(context)) : null;

    return SliverPadding(
      padding: const EdgeInsets.only(top: Spacing.$4x),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          childCount: 1,
          (context, index) => Column(
            children: [
              if (address != null && address.isNotEmpty && title != null)
                Padding(
                  padding: itemPadding,
                  child: _MakkahAddressCard(colors: colors, title: title, address: address),
                ),
              Padding(
                padding: itemPadding,
                child: _MakkahAboutSection(colors: colors, aboutText: aboutText, featureWidgets: featureWidgets),
              ),
              if (workingHours != null)
                Padding(
                  padding: itemPadding,
                  child:
                      workingHours.isOpen24x7
                          ? _MakkahOpenHoursCard(colors: colors, subtitle: workhoursHint)
                          : MakkahPoiWorkingHoursCard(
                            workingHours: workingHours,
                            colors: colors,
                            workhoursHint: workhoursHint,
                          ),
                ),
              // Kaaba virtual journey card - same logic as dashboard
              if (ref.watch(showPilgrimFeatureProvider) != null)
                Padding(
                  padding: itemPadding,
                  child: KaabaVirtualJourneyCard(
                    onTap: () {
                      context.router.push(const GaussianSplattingRoute());
                    },
                  ),
                ),
              Padding(
                padding: EdgeInsets.zero,
                child: _MakkahNearbySection(
                  excludeDgisId: makkahPlace?.dgisId ?? objectId.toString(),
                  excludePlaceId: makkahPlace?.placeId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeatureWidgets(
    BuildContext context,
    String? features,
    List<MakkahPlaceFeature>? featuresList,
    String? accessibility,
  ) {
    final widgets = <Widget>[];

    final normalizedFeaturesList = (featuresList ?? const []).where((e) => e.code != null).toList();

    if (normalizedFeaturesList.isNotEmpty) {
      final isArabic = Directionality.of(context) == TextDirection.rtl;

      for (final feature in normalizedFeaturesList) {
        final title = (isArabic ? feature.textAr : feature.textEn) ?? '';
        if (title.trim().isEmpty) continue;

        widgets.add(
          _MakkahFeatureTile(
            colors: colors,
            svgAsset: MakkahPoiConstants.levelsIconPath,
            iconUrl: feature.imageUrl,
            title: title,
            subtitle: '',
          ),
        );
      }
    } else if (features != null && features.isNotEmpty) {
      widgets.add(
        _MakkahFeatureTile(colors: colors, svgAsset: MakkahPoiConstants.levelsIconPath, title: features, subtitle: ''),
      );
    }

    if (accessibility != null && accessibility.isNotEmpty) {
      widgets.add(
        _MakkahFeatureTile(
          colors: colors,
          svgAsset: MakkahPoiConstants.accessibilityIconPath,
          title: accessibility,
          subtitle: '',
        ),
      );
    }

    return widgets;
  }
}

class _MakkahAboutSection extends StatelessWidget {
  final _MakkahPoiColors colors;
  final String aboutText;
  final List<Widget> featureWidgets;

  const _MakkahAboutSection({required this.colors, required this.aboutText, required this.featureWidgets});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;

    return _MakkahContentCard(
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.aboutTheLandmark,
            style: context.textStyles.bodyLargeSemiBold.copyWith(color: colors.titleColor),
          ),
          const SizedBox(height: Spacing.$2x),
          if (aboutText.isNotEmpty)
            Text(
              aboutText,
              style: context.textStyles.bodyLargeRegular.copyWith(
                color: colors.secondaryTextColor.withOpacity(0.8),
                height: 22 / 16,
              ),
            ),
          if (featureWidgets.isNotEmpty) ...[
            const SizedBox(height: Spacing.$4x),
            ..._withVerticalSpacing(featureWidgets, spacing: Spacing.$2x),
          ],
        ],
      ),
    );
  }
}

List<Widget> _withVerticalSpacing(List<Widget> items, {required double spacing}) {
  if (items.isEmpty) return const [];
  final spaced = <Widget>[];
  for (var i = 0; i < items.length; i++) {
    if (i != 0) spaced.add(SizedBox(height: spacing));
    spaced.add(items[i]);
  }
  return spaced;
}

class _MakkahOpenHoursCard extends StatelessWidget {
  final _MakkahPoiColors colors;
  final String? subtitle;

  const _MakkahOpenHoursCard({required this.colors, this.subtitle});

  @override
  Widget build(BuildContext context) {
    final isArabic = Directionality.of(context) == TextDirection.rtl;
    final displaySubtitle = (subtitle != null && subtitle!.isNotEmpty) ? subtitle : null;

    return _MakkahContentCard(
      colors: colors,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(width: 10),
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: const Color(0xFFD19D3F),
              borderRadius: BorderRadius.circular(RadiusBorder.baseSharp),
            ),
            child: Center(
              child: SvgPicture.asset(
                MakkahPoiConstants.clockIconPath,
                width: MakkahPoiConstants.addressIconSize,
                height: MakkahPoiConstants.addressIconSize,
                colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
                matchTextDirection: true,
              ),
            ),
          ),
          const SizedBox(width: Spacing.$3x),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.available24Hours,
                  style: context.textStyles.bodySmallRegular.copyWith(
                    color: colors.titleColor,
                    fontSize: 16,
                    height: 20 / 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (displaySubtitle != null) ...[
                  const SizedBox(height: Spacing.$0_5x),
                  Text(
                    displaySubtitle,
                    style: context.textStyles.bodySmallRegular.copyWith(color: const Color(0xFF806E5C), fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MakkahContentCard extends StatelessWidget {
  final _MakkahPoiColors colors;
  final Widget child;

  const _MakkahContentCard({required this.colors, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.contentCardBackground,
        borderRadius: BorderRadius.circular(RadiusBorder.xl),
        boxShadow: [
          BoxShadow(blurRadius: 12, offset: const Offset(0, 4), color: context.colors.foregroundSoft.withOpacity(0.06)),
        ],
      ),
      child: Padding(padding: const EdgeInsets.all(Spacing.$4x), child: child),
    );
  }
}

class _MakkahAddressCard extends StatelessWidget {
  final _MakkahPoiColors colors;
  final String title;
  final String address;

  const _MakkahAddressCard({required this.colors, required this.title, required this.address});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.contentCardBackground,
          borderRadius: BorderRadius.circular(RadiusBorder.xl),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x, vertical: Spacing.$1x),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: Spacing.$3x),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: context.textStyles.bodyLargeSemiBold.copyWith(
                    color: const Color(0xFF4A3016),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: Spacing.$1x),
                Text(
                  address,
                  style: context.textStyles.bodySmallRegular.copyWith(
                    color: const Color(0xFF806E5C),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MakkahFeatureTile extends StatelessWidget {
  final _MakkahPoiColors colors;
  final String svgAsset;
  final String? iconUrl;
  final String title;
  final String subtitle;

  const _MakkahFeatureTile({
    required this.colors,
    required this.svgAsset,
    this.iconUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    const iconSize = 28.0;
    final effectiveIconUrl = (iconUrl ?? '').trim();
    final icon = _MakkahFeatureTileIcon(svgAsset: svgAsset, iconUrl: effectiveIconUrl, size: iconSize);
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFFAF5EE), borderRadius: BorderRadius.circular(10)),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          const SizedBox(width: 10),
          Expanded(
            child:
                subtitle.isEmpty
                    ? Text(
                      title,
                      style: context.textStyles.bodySmallRegular.copyWith(
                        color: colors.secondaryTextColor.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    )
                    : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          style: context.textStyles.bodySmallRegular.copyWith(
                            color: colors.secondaryTextColor.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(height: Spacing.$0_5x),
                        Text(
                          subtitle,
                          style: context.textStyles.bodySmallRegular.copyWith(
                            color: colors.secondaryTextColor.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
          ),
        ],
      ),
    );
  }
}

class _MakkahFeatureTileIcon extends StatelessWidget {
  final String svgAsset;
  final String iconUrl;
  final double size;

  const _MakkahFeatureTileIcon({required this.svgAsset, required this.iconUrl, required this.size});

  @override
  Widget build(BuildContext context) {
    const effectiveAssetColor = Color(0xFFD19D3F);
    if (iconUrl.isNotEmpty) {
      final lower = iconUrl.toLowerCase();
      if (lower.endsWith('.svg')) {
        // Don't apply colorFilter to network SVGs - backend provides properly colored icons
        return SvgPicture.network(
          iconUrl,
          width: size,
          height: size,
          fit: BoxFit.contain,
          placeholderBuilder:
              (_) => SvgPicture.asset(
                svgAsset,
                width: size,
                height: size,
                colorFilter: const ColorFilter.mode(effectiveAssetColor, BlendMode.srcIn),
                matchTextDirection: true,
              ),
        );
      }

      return CachedNetworkImage(
        imageUrl: iconUrl,
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholder:
            (_, __) => SvgPicture.asset(
              svgAsset,
              width: size,
              height: size,
              colorFilter: const ColorFilter.mode(effectiveAssetColor, BlendMode.srcIn),
              matchTextDirection: true,
            ),
        errorWidget:
            (_, __, ___) => SvgPicture.asset(
              svgAsset,
              width: size,
              height: size,
              colorFilter: const ColorFilter.mode(effectiveAssetColor, BlendMode.srcIn),
              matchTextDirection: true,
            ),
      );
    }

    return SvgPicture.asset(
      svgAsset,
      width: size,
      height: size,
      colorFilter: const ColorFilter.mode(effectiveAssetColor, BlendMode.srcIn),
      matchTextDirection: true,
    );
  }
}
