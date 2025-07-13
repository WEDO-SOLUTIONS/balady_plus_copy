part of 'poi_photo_row_builder.dart';

class _PoiPhotoOne extends StatelessWidget {
  final double padding;
  final BorderRadius borderRadius;
  final Widget Function(BuildContext context) itemBuilder;

  const _PoiPhotoOne({
    required this.itemBuilder,
    required this.borderRadius,
    required this.padding,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Padding(
        key: key,
        padding: EdgeInsets.symmetric(horizontal: padding),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: itemBuilder(context),
        ),
      );
}
