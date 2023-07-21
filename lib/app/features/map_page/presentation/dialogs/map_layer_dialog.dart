import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/layers_gis_view_model.dart';
import 'package:balady_plus/app/features/map_page/presentation/mvvm/map_view_model.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/model/layers.dart';
import 'package:provider/provider.dart';

class MapLayersDialog extends StatelessWidget {
  final LayersGisViewModel layersModel ;
  const MapLayersDialog({super.key,required this.layersModel});

  @override
  Widget build(BuildContext context) {
    MapViewModel mapViewModel = context.watch<MapViewModel>();
    return Padding(
      padding: MediaQuery.of(context).viewPadding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ValueListenableBuilder<List<Layers>?>(
            valueListenable: layersModel.layers,
            builder: (_, layers, __) {
              return layers?.isNotEmpty ?? false
                  ? ListView.builder(
                      itemCount: layers!.length,
                      shrinkWrap: true,
                      itemBuilder: (ctx, index) {
                        return ValueListenableBuilder<Layers?>(
                            valueListenable: layersModel.layerSelected,
                            builder: (_, layerSelected, __) {
                              return InkWell(
                                onTap: () => layersModel.selectLayers(layers[index]),
                                child: Container(
                                  height: 56,
                                  padding: const EdgeInsetsDirectional.only(start: 12),
                                  margin: const EdgeInsets.only(top: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: AppColor.primary50Light50,
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: MediaQuery.of(context).size.width - 125,
                                        child: CustomTextWidget(
                                          layers[index].name,
                                          textStyle: AppStyle.listTitleTextStyle,
                                          maxLines: 2,
                                        ),
                                      ),
                                      const Spacer(),
                                      Radio(
                                        value: layers[index],
                                        groupValue: layerSelected,
                                        activeColor: AppColor.primary700Light,
                                        onChanged: (_) => layersModel.selectLayers(layers[index]),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                      })
                  : const SizedBox();
            },
          ),
          const CustomVerticalSpace(height: 32),
          ElevatedButtonWidget.apply(
            onPressed: () {
              if(mapViewModel.layerSelected.value != layersModel.layerSelected.value) {
                mapViewModel.selectLayers(layersModel.layerSelected.value!);
              }
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }
}
