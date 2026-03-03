part of 'poi_makkah_widget_page.dart';

class _MakkahPoiFooterPlaceholder extends StatelessWidget {
  final DirectoryObjectMessage data;
  final MultiStateSheetController<PoiCardBottomSheetState> bottomSheetController;
  final LatLng? closestPoint;
  final MakkahPlace? makkahPlace;

  const _MakkahPoiFooterPlaceholder({
    required this.data,
    required this.bottomSheetController,
    this.closestPoint,
    this.makkahPlace,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(height: 16);
  }
}
