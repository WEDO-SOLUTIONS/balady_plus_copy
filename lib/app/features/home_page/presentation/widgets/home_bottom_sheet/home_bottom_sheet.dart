import 'dart:async';

import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/features/map_page/extensions/directory_object_ext.dart';
import 'package:dgis_map/library.dart';
import 'package:flutter/material.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../map_page/presentation/mvvm/map_view_model.dart';
import '../../../home_exports.dart'
    show
        BaladySmartAdvisorCard,
        ChallengeHomeCard,
        DraggableHeaderComponent,
        NewServices,
        PrayerHomeCard,
        ReadHomeCard,
        ReportHomeCard;

import 'package:provider/provider.dart';

class HomeBottomSheet extends StatelessWidget {
  const HomeBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel?>()!;
    print("initial ${mapViewModel.bottomSheetSizeFraction.value}");
    return ValueListenableBuilder<bool>(
        valueListenable: mapViewModel.viewHomeBottomSheet,
        builder: (_, visible, child) {
          print("initial ${mapViewModel.bottomSheetSizeFraction.value}");
          return visible ? child! : const SizedBox();
        },
        child: DraggableSheetCard(
          minSize: 0.05,
          maxSize: 0.9,
          cornerRadius: 36,
          initialChildSize: mapViewModel.bottomSheetSizeFraction.value,
          children: [
            const DraggableHeaderComponent(),
            ValueListenableBuilder(
              valueListenable: mapViewModel.suggests,
              builder: (_, suggests, child) {
                if (suggests != null) {
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    separatorBuilder: (context, index) {
                      return const Divider(
                        color: Colors.black,
                      );
                    },
                    itemBuilder: (context, index) {
                      final title = suggests[index]
                          .title
                          .text
                          .replaceAll("region", "منطقة")
                          .replaceAll("governorate", "محافظة")
                          .replaceAll("city", "مدينة")
                          .replaceAll("district", "حى")
                          .replaceAll("streets", "شارع")
                          .replaceAll("buildings", "مبنى");
                      final address = suggests[index]
                              .handler
                              .objectHandler
                              ?.item
                              .makeAddress() ??
                          suggests[index].subtitle.text;

                      return InkWell(
                        onTap: () async {
                          final objectHandler =
                              suggests[index].handler.objectHandler;
                          if (objectHandler != null) {
                            mapViewModel.selectedPointId.value =
                                objectHandler.item.id;
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
                            if (objectHandler.item.types[0]?.type ==
                                ObjectTypeMessage.admDiv) {
                              zoom = 14;
                            } else if ([
                              ObjectTypeMessage.road,
                              ObjectTypeMessage.street,
                            ].contains(objectHandler.item.types[0]?.type)) {
                              zoom = 16;
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
                            }
                          }

                          final incompleteTextHandler =
                              suggests[index].handler.incompleteTextHandler;
                          if (incompleteTextHandler != null) {
                            searchController.text =
                                incompleteTextHandler.queryText;
                            mapViewModel.updateSuggest(
                              queryText: incompleteTextHandler.queryText,
                            );
                          }

                          final performSearchHandler =
                              suggests[index].handler.performSearchHandler;
                          if (performSearchHandler != null) {
                            // mapViewModel.viewHomeBottomSheet.value = false;
                            mapViewModel.performSearch(
                              queryText: '',
                              searchQuery: performSearchHandler.searchQuery,
                            );
                            mapViewModel.draggableScrollableController
                                .jumpTo(0.05);
                          }
                        },
                        child: SizedBox(
                          height: 80,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  title,
                                  style: AppStyle.mainTextStyle.copyWith(
                                      color: AppColor.blackModern600Light,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      height: 1),
                                ),
                                Text(
                                  address,
                                  style: AppStyle.mainTextStyle.copyWith(
                                    color: AppColor.blackModern600Light,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    itemCount: suggests.length,
                  );
                }

                return const SizedBox.shrink();
              },
            ),
            const ReportHomeCard(),
            const PrayerHomeCard(),
            const ReadHomeCard(),
            const BaladySmartAdvisorCard(),
            const ChallengeHomeCard(),
            const NewServices(),
            const SizedBox(height: 30),
          ],
        ));
  }
}
