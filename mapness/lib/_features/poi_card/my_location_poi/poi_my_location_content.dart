part of 'content_deeplink.dart';

class PoiMyLocationContent extends StatelessWidget {
  final Function()? onTapClose;
  final LatLng location;
  final AsyncValue<PoiMyLocationState?> data;
  final double height;

  const PoiMyLocationContent({
    required this.onTapClose,
    required this.location,
    required this.data,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: Spacing.$4x),
        decoration: const ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(Spacing.$4x),
            ),
          ),
        ),
        child: data.maybeWhen(
          data: (value) {
            final isAuthorized = value?.isAuthorized ?? false;
            final title = value?.title ?? context.l10n.myLocation;
            final subTitle = isAuthorized ? context.l10n.myLocationSubtitle : null;
            final text = value?.address ?? '${location.latitude}, ${location.longitude}';

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
                  subTitle: subTitle,
                  profileImage: isAuthorized
                      ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: Spacing.$1x),
                          child: MyLocationImageWidget(),
                        )
                      : null,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: value?.isAuthorized == true ? Spacing.$2x : Spacing.$4x,
                    bottom: Spacing.$4x,
                  ),
                  child: Text(
                    text,
                    style: context.textStyleV3.bodySmallRegular.copyWith(color: context.colorsV2.foregroundSoft),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            );
          },
          orElse: () => Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              const Center(child: SheetDragger()),
              const SizedBox(height: 6),
              Container(
                height: height - 90,
                alignment: Alignment.center,
                color: Colors.white,
                child: Loading.medium(),
              ),
            ],
          ),
        ),
      );
}
