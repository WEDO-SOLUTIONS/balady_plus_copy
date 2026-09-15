part of 'content_deeplink.dart';

class PoiDeeplinkContent extends ConsumerWidget {
  final Function()? onTapClose;
  final LatLng location;
  final AsyncValue<PoiMyLocationState?> data;

  /// Title supplied by whoever opened the link; falls back to the generic
  /// "point on the map" when absent or blank.
  final String? label;

  const PoiDeeplinkContent({
    required this.onTapClose,
    required this.location,
    required this.data,
    this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
    width: double.infinity,
    padding: const EdgeInsets.only(left: 16, right: 16),
    decoration: ShapeDecoration(
      color: context.colors.backgroundSurface2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
    ),
    child: Builder(
      builder: (context) {
        final trimmedLabel = label?.trim() ?? '';
        final title = trimmedLabel.isNotEmpty ? trimmedLabel : context.l10n.pointToMap;

        return Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            CardHeader(
              onTapClose: onTapClose,
              title: CardHeaderText.title(text: title, context: context),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: Spacing.$4x,
                bottom: Spacing.$4x,
              ),
              child: data.maybeWhen(
                data: (value) => Text(
                  value?.address ?? '',
                  style: context.textStyles.bodySmallRegular.copyWith(
                    color: context.colors.foregroundSoft,
                  ),
                ),
                orElse: () => _AddressShimmer(),
              ),
            ),
          ],
        );
      },
    ),
  );
}

class _AddressShimmer extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: context.colors.backgroundSurface4,
    highlightColor: context.colors.backgroundSurface1,
    child: FractionallySizedBox(
      widthFactor: 0.55,
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        height: 12,
        decoration: BoxDecoration(
          color: context.colors.backgroundSurface4,
          borderRadius: BorderRadius.circular(6),
        ),
      ),
    ),
  );
}
