// ignore_for_file: dead_code

part of 'content_my_location.dart';

class PoiMyLocationContent extends ConsumerWidget {
  final Function()? onTapClose;
  final LatLng location;

  const PoiMyLocationContent({
    required this.onTapClose,
    required this.location,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(
      poiMyLocationProvider(
        latitude: location.latitude,
        longitude: location.longitude,
      ),
    );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 16, right: 16),
      decoration: const ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
      ),
      child: data.maybeWhen(
        data: (value) {
          final title = value?.title ?? context.l10n.myLocation;
          final subTitle = context.l10n.myLocationSubtitle;
          final text = value?.address ?? '${location.latitude}, ${location.longitude}';
          final isAuthorized = value?.isAuthorized == true;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              const Center(child: SheetDragger()),
              const SizedBox(height: 6),
              PoiHeader(
                onTapClose: onTapClose,
                text: title,
                subTitle: isAuthorized ? subTitle : null,
                profileImage: isAuthorized
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: NumericBase.$1x),
                        child: MyLocationImageWidget(),
                      )
                    : null,
              ),
              Padding(
                padding: EdgeInsets.only(top: isAuthorized ? Spacing.$4x : 0, bottom: Spacing.$4x),
                child: Text(
                  text + text,
                  style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV2.foregroundSoft),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          );
        },
        // TODO: Add loading and error states
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}
