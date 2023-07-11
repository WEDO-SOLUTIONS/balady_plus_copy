import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle, IconPath;
import '../../../shared_feature_exports.dart'
    show
        BottomSheetWithActions,
        CustomTextFieldWidget,
        CustomTextWidget,
        DrawIconBasedTypeWidget,
        ElevatedButtonWidget;

class BottomSheetList extends StatefulWidget {
  final String title;
  final List<String> items;
  final String? selectedValue;
  final Function(String) onTap;

  const BottomSheetList({
    super.key,
    required this.title,
    required this.items,
    this.selectedValue,
    required this.onTap,
  });

  @override
  State<BottomSheetList> createState() => _BottomSheetListState();
}

class _BottomSheetListState extends State<BottomSheetList> {
  final TextEditingController _textEditingController = TextEditingController();

  late List<String> items;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    items = widget.items;
    selectedValue = widget.selectedValue;
    _textEditingController.addListener(() {
      setState(() {
        items = widget.items
            .where((element) =>
                element.toLowerCase().contains(_textEditingController.text))
            .toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheetWithActions(
      title: widget.title,
      body: Expanded(
        child: Column(
          children: [
            CustomTextFieldWidget(
              controller: _textEditingController,
              hintText: 'search'.tr(),
              prefixIcon: const DrawIconBasedTypeWidget(
                icon: IconPath.search,
                iconColor: AppColor.primary700Light,
              ),
              borderRadius: 16,
              borderColor: AppColor.primary900Light16,
              suffixIcon: _textEditingController.text.isNotEmpty
                  ? InkWell(
                      onTap: () {
                        _textEditingController.text = '';
                        FocusScope.of(context).unfocus();
                      },
                      child: const DrawIconBasedTypeWidget(
                        icon: Icons.close,
                        iconColor: AppColor.primary700Light,
                      ),
                    )
                  : null,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemExtent: 80,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return InkWell(
                    onTap: () => setState(() => selectedValue = item),
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
                              item,
                              textStyle: AppStyle.listTitleTextStyle,
                              maxLines: 2,
                            ),
                          ),
                          const Spacer(),
                          Radio(
                            value: item,
                            groupValue: selectedValue,
                            activeColor: AppColor.primary700Light,
                            onChanged: (_) =>
                                setState(() => selectedValue = item),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      action: ElevatedButtonWidget.choose(
        onPressed: () {
          if (selectedValue != null) {
            widget.onTap(selectedValue!);
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}
