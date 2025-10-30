import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/map_page/constants/constants.dart';
import 'package:balady_plus/app/features/map_page/data/enums/map_enums.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/layers_gis_view_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/model/layers.dart';
import 'package:provider/provider.dart';

class MapLayersDialog extends StatefulWidget {
  final MapViewModel mapModel;
  const MapLayersDialog({super.key, required this.mapModel});

  @override
  State<MapLayersDialog> createState() => _MapLayersDialogState();
}

class _MapLayersDialogState extends State<MapLayersDialog> {
  Layers? layerSelected;
  @override
  void initState() {
    super.initState();
    layerSelected = widget.mapModel.layerSelected.value;
  }

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel>();

    return Padding(
      padding: MediaQuery.of(context).viewPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<List<Layers>?>(
            valueListenable: widget.mapModel.layers,
            builder: (_, layers, __) {
              return layers?.isNotEmpty ?? false
                  ? Column(
                      children: [
                        CustomVerticalSpace(height: 16),
                        ListView.builder(
                          itemCount: layers!.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (ctx, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  layerSelected = layers[index];
                                });
                                mapViewModel.selectLayers(layers[index]);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 56,
                                padding:
                                    const EdgeInsetsDirectional.only(start: 12),
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: AppColor.primary50Light50,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      GISMapLayers.values[index].icon,
                                      color: AppColor.primary900Light,
                                    ),
                                    CustomHorizontalSpace(width: 8),
                                    CustomTextWidget(
                                      layers[index].name,
                                      textStyle: AppStyle.listTitleTextStyle,
                                      maxLines: 2,
                                    ),
                                    const Spacer(),
                                    Radio(
                                      value: layers[index],
                                      groupValue: layerSelected,
                                      activeColor: AppColor.primary700Light,
                                      onChanged: (_) {
                                        setState(() {
                                          layerSelected = layers[index];
                                        });

                                        mapViewModel
                                            .selectLayers(layers[index]);

                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        CustomVerticalSpace(height: 16),
                      ],
                    )
                  : const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
