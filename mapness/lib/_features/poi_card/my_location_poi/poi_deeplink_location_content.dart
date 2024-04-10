part of 'content_my_location.dart';

class PoiDeeplinkContent extends ConsumerWidget {
  final Function()? onTapClose;
  final LatLng location;

  const PoiDeeplinkContent({
    required this.onTapClose,
    required this.location,
    super.key,
  });

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
            final title = context.l10n.pointToMap;

            return Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                PoiHeader(
                  onTapClose: onTapClose,
                  text: title,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
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
