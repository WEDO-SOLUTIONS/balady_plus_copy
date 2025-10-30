import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show AppColor, AppStyle;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextWidget, ElevatedButtonWidget;

class ChatBubbleRadioSelector extends StatefulWidget {
  final List<String> items;
  final String? initialSelectedValue;
  final void Function(String)? onChoose;
  final void Function(String)? onSelect;

  const ChatBubbleRadioSelector({
    super.key,
    required this.items,
    this.initialSelectedValue,
    this.onChoose,
    this.onSelect,
  });

  @override
  State<ChatBubbleRadioSelector> createState() =>
      _ChatBubbleRadioSelectorState();
}

class _ChatBubbleRadioSelectorState extends State<ChatBubbleRadioSelector> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialSelectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        CustomTextWidget(
          'municipalAdvisorChooseHint'.tr(),
          textStyle: AppStyle.subMessageTextStle,
        ),
        Column(
          children: [
            for (var item in widget.items)
              InkWell(
                onTap: () => _onSelect(item),
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
                      Expanded(
                        flex: 3,
                        child: CustomTextWidget(
                          item,
                          textStyle: AppStyle.listTitleTextStyle,
                          maxLines: 5,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Radio(
                          value: item,
                          groupValue: selectedValue,
                          activeColor: AppColor.primary700Light,
                          onChanged: (_) => _onSelect(item),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            if (widget.onChoose != null)
              ElevatedButtonWidget.choose(
                onPressed: selectedValue == null
                    ? null
                    : () => widget.onChoose!(selectedValue!),
              ),
          ],
        ),
      ],
    );
  }

  void _onSelect(String item) {
    setState(() => selectedValue = item);
    widget.onSelect?.call(item);
  }
}
