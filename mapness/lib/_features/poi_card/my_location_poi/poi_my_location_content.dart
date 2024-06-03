part of 'content_my_location.dart';

class PoiMyLocationContent extends ConsumerWidget {
  final Function()? onTapClose;
  final LatLng location;

  const PoiMyLocationContent({
    required this.onTapClose,
    required this.location,
    super.key,
  });

  /// Profile size with image padding included
  static const _profileImgSize = 52.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Container(
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
        child: Builder(
          builder: (context) {
            final userData = ref.watch(authProvider).requireValue;
            final language = ref.read(appLanguageProvider);
            final title = userData?.getLocalizedFirstAndLastName(language) ??
                context.l10n.guestName;
            final subTitle = context.l10n.myLocationSubtitle;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                PoiHeader(
                  onTapClose: onTapClose,
                  text: title,
                  subTitle: subTitle,
                  profileImage: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: NumericBase.$1x),
                    child: ProfileImageWidget(
                      dimension: _profileImgSize,
                      color: context.color.strokeAccent,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: Spacing.verticalPaddingInsideCell),
                  child: Text(
                    '${location.latitude}, ${location.longitude}',
                    style: context.textStyle.text,
                  ),
                ),
              ],
            );
          },
        ),
      );
}
