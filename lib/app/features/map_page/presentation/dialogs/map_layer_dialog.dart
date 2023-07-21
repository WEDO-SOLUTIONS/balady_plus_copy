import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/model/layers.dart';

class MapLayersDialog extends StatefulWidget {
  final Function onSelect;
  final List<Layers> mainLayers;
  final Layers? selectd;

  const MapLayersDialog(
      {super.key,
      required this.onSelect,
      required this.mainLayers,
      this.selectd});

  @override
  State<MapLayersDialog> createState() => _MapLayersDialogState();
}

class _MapLayersDialogState extends State<MapLayersDialog> {
  Layers? selectedLayer;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListView.builder(
            itemCount: widget.mainLayers.length,
            shrinkWrap: true,
            itemBuilder: (ctx, index) {
              return InkWell(
                onTap: () =>
                    setState(() => selectedLayer = widget.mainLayers[index]),
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
                          widget.mainLayers[index].name,
                          textStyle: AppStyle.listTitleTextStyle,
                          maxLines: 2,
                        ),
                      ),
                      const Spacer(),
                      Radio(
                        value: widget.mainLayers[index],
                        groupValue: selectedLayer,
                        activeColor: AppColor.primary700Light,
                        onChanged: (_) => setState(
                            () => selectedLayer = widget.mainLayers[index]),
                      )
                    ],
                  ),
                ),
              );
            }),
        const CustomVerticalSpace(height: 32),
        ElevatedButtonWidget.apply(
          onPressed: () {
            widget.onSelect(selectedLayer);
          },
        )
      ],
    );
  }
}
