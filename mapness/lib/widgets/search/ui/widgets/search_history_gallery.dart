part of '../search_item.dart';

class _PhotosGallery extends StatelessWidget {
  static const sizeOfGallery = 96;
  final List<String> photosUrls;
  final List<Item> photoItems;

  const _PhotosGallery({
    required this.photosUrls,
    required this.photoItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: Spacing.$4x, right: Spacing.$4x, top: Spacing.$3x),
        child: SizedBox(
          height: sizeOfGallery.toDouble(),
          child: ScrollConfiguration(
            behavior: NoGlowingScrollBehavior(),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photosUrls.length,
              itemBuilder: (context, i) {
                final photo = photoItems[i].previewUrls?.smallByWidth ?? photosUrls[i];
                return ClipRRect(
                  borderRadius: BorderRadius.circular(
                    RadiusBorder.l,
                  ),
                  child: Image.network(
                    photo,
                    fit: BoxFit.cover,
                    height: sizeOfGallery.toDouble(),
                    width: sizeOfGallery.toDouble(),
                    cacheHeight: sizeOfGallery,
                    cacheWidth: sizeOfGallery,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      final valueOfLoading =
                          (loadingProgress.cumulativeBytesLoaded) / (loadingProgress.expectedTotalBytes ?? 1);
                      return Container(
                        color: context.colorsV2.backgroundSurface3,
                        width: sizeOfGallery.toDouble(),
                        height: sizeOfGallery.toDouble(),
                        child: Center(
                          child: Loading.small(value: valueOfLoading),
                        ),
                      );
                    },
                  ),
                );
              },
              separatorBuilder: (context, index) => Spacing.$1x.widthBox,
            ),
          ),
        ),
      );
}
