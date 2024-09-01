import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import 'package:dgis_map/library.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../_shared_feature_/presentation/widgets/draw_icon_based_type_widget.dart';
import '../../../../map_page/constants/constants.dart';
import '../../../../map_page/presentation/mvvm/map_view_model.dart';

class SuggestHomeBottomSheet extends StatefulWidget {
  const SuggestHomeBottomSheet({super.key});

  @override
  State<SuggestHomeBottomSheet> createState() => _SuggestHomeBottomSheetState();
}

class _SuggestHomeBottomSheetState extends State<SuggestHomeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;

    return ValueListenableBuilder(
      valueListenable: mapViewModel.suggests,
      builder: (_, suggests, child) {
        if (suggests != null) {
          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            separatorBuilder: (context, index) {
              return const Divider(
                color: Color(0xffE6ECEE),
                thickness: 1,
              );
            },
            itemBuilder: (context, index) {
              final prefixMapping = {
                ", region": "منطقة",
                ", governorate": "محافظة",
                ", city": "مدينة",
                ", district area": "محافظة",
                ", district": "حى",
                ", street": "شارع",
                ", buildings": "مبنى",
                ", park": "بارك",
              };
              String title = suggests[index].title.text;
              prefixMapping.forEach((key, replacement) {
                if (title.contains(key)) {
                  title = "$replacement ${title.replaceAll(key, "")}";
                }
              });

              final address =
                  suggests[index].handler.objectHandler?.item.makeAddress() ?? suggests[index].subtitle.text;

              return InkWell(
                onTap: () async {
                  final objectHandler = suggests[index].handler.objectHandler;
                  if (objectHandler != null) {
                    mapViewModel.selectedPointId.value = objectHandler.item.id;
                    final objectId = objectHandler.item.id;
                    mapViewModel.searchOnCameraMove = false;
                    if (objectId != null) {
                      await mapViewModel.controller.setHighlighted(
                        [objectId],
                      );
                    }
                    mapViewModel.viewHomeBottomSheet.value = false;

                    final position = objectHandler.item.markerPosition;
                    double zoom = 17;
                    if (objectHandler.item.types[0]?.type == ObjectTypeMessage.admDiv) {
                      zoom = 14;
                    } else if ([
                      ObjectTypeMessage.road,
                      ObjectTypeMessage.street,
                    ].contains(objectHandler.item.types[0]?.type)) {
                      zoom = 16;
                    }
                    if (mapViewModel.currentSearchSelectionId != null) {
                      mapViewModel.controller.removeMarker(mapViewModel.currentSearchSelectionId!.toString());
                      mapViewModel.currentSearchSelectionId = null;
                    }
                    if (position != null) {
                      await mapViewModel.controller.moveCamera(
                        CameraPositionMessage(
                          point: GeoPointMessage(
                            latitude: position.latitude,
                            longitude: position.longitude,
                          ),
                          zoom: zoom,
                          tilt: 0,
                          bearing: 0,
                        ),
                        1,
                        CameraAnimationTypeMessage.linear,
                      );
                      if ([
                            ObjectTypeMessage.branch,
                            ObjectTypeMessage.parking,
                            ObjectTypeMessage.station,
                          ].contains(objectHandler.item.types[0]?.type) &&
                          objectHandler.item.id?.objectId != null) {
                        mapViewModel.currentSearchSelectionId = "${objectHandler.item.id?.objectId}";
                        await mapViewModel.controller.addMarkers([
                          Marker(
                            id: "${objectHandler.item.id?.objectId}",
                            options: MarkerOptionsMessage(
                              position: position,
                              icon: SvgMarkerIcon(
                                svgPath: Constants.icMarker,
                                width: 40,
                              ),
                            ),
                            onTap: () async {
                              mapViewModel.refreshView();
                              mapViewModel.selectedPointId.value = objectHandler.item.id;
                              mapViewModel.selectedPointId.notifyListeners();
                            },
                          )
                        ]);
                        setState(() {});
                      }
                    }
                  }

                  final incompleteTextHandler = suggests[index].handler.incompleteTextHandler;
                  if (incompleteTextHandler != null) {
                    searchController.text = incompleteTextHandler.queryText;
                    mapViewModel.updateSuggest(
                      queryText: incompleteTextHandler.queryText,
                    );
                  }

                  final performSearchHandler = suggests[index].handler.performSearchHandler;
                  if (performSearchHandler != null) {
                    // mapViewModel.viewHomeBottomSheet.value = false;
                    mapViewModel.performSearch(
                      queryText: '',
                      searchQuery: performSearchHandler.searchQuery,
                    );
                    mapViewModel.draggableScrollableController.jumpTo(0.05);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const DrawIconBasedTypeWidget(
                        icon: IconPath.searchSuggestIcon,
                        iconSize: 20,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 8),
                            Text(
                              title,
                              style: AppStyle.textFieldTitleTextStyle,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              address,
                              style: AppStyle.requestNumberTextStle,
                              maxLines: 10,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
            itemCount: suggests.length,
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
