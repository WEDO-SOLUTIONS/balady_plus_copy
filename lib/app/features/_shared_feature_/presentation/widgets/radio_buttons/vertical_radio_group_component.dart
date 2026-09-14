import 'package:flutter/material.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../shared_feature_exports.dart';
import 'custom_radio_button_widget_copy.dart';

class VerticalRadioGroup<T> extends StatelessWidget {
  final String groupName;
  final bool? isMandatory;
  final T? currentItem;
  final List<RadioItem<T>> items;
  final Function(T?) onChanged;

  const VerticalRadioGroup(
      {super.key,
      this.currentItem,
      this.isMandatory,
      required this.groupName,
      required this.items,
      required this.onChanged});

  @override
  build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextWithOptional(
          label: groupName,
          labelColor: AppColor.blackModern700Light,
          labelSize: 16,
          labelTextAlign: TextAlign.start,
          showOptional: isMandatory,
        ),
        const CustomVerticalSpace(height: GeneralKey.smallPadding),
        // types
        Column(
          children: items
              .map((e) => Padding(
                    padding: EdgeInsetsDirectional.only(
                        end: items.last == e ? 0 : 16),
                    child: CustomRadioButtonEnd<T>(
                      title: e.radioText,
                      value: e.radioValue,
                      height: 48,
                      currentSelected: currentItem,
                      onChange: (T? item) {
                        onChanged(item);
                      },
                      endRadio: false,
                      unSelectedBackgroundColor: Colors.transparent,
                      textSize: 12,
                    ),
                  ))
              .toList(),
        ),
        // ListView.builder(
        //     padding: EdgeInsets.zero,
        //     itemCount: items.length,
        //     shrinkWrap: true,
        //     physics: const NeverScrollableScrollPhysics(),
        //     itemBuilder: (ctx, index) {
        //       return CustomRadioButtonEnd<RadioItem>(
        //         title: items[index].radioValue,
        //         value: items[index],
        //         currentSelected: currentItem,
        //         onChange: (RadioItem? item) {
        //           currentItem = item;
        //           onChanged(item);
        //           setState(() {});
        //         },
        //         endRadio: false,
        //         unSelectedBackgroundColor: Colors.transparent,
        //         textSize: 16,
        //       );
        //     }),

        const CustomVerticalSpace(height: 30.0),
      ],
    );
  }
}
