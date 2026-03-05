import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/poi_card/enums/poi_card_bottom_sheet_state.dart';
import 'package:mapness/features/poi_card/provider/poi_photo_provider.dart';
import 'package:mapness/features/poi_card/widgets/photos_header/header_component.dart';
import 'package:sheetify/multi_state_sheet/multi_state_sheet.dart';

class PoiPhotosHeader extends ConsumerWidget {
  final int objectId;
  final MultiStateSheetController<PoiCardBottomSheetState>? bottomSheetController;
  const PoiPhotosHeader({
    required this.objectId,
    this.bottomSheetController,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photos = ref.watch(poiPhotoProvider(objectId));
    final isPhotosEmpty = !photos.hasValue || photos.requireValue.items.isEmpty;
    final isPhotosLoading = photos.isLoading;

    return HeaderComponent(
      photosCount: isPhotosEmpty ? 0 : photos.requireValue.items.length,
      photosAreLoading: isPhotosLoading,
      objectId: objectId,
      bottomSheetController: bottomSheetController,
    );
  }
}
