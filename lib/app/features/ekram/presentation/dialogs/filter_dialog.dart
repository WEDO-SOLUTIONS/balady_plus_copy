import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/section_title_widget.dart';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';

class FilterDialog extends StatefulWidget {
  final Function onFilter;
  final Function onClear;
  final LookUpItem? requestCurrentSelection;
  final LookUpItem? deathCurrentSelection;
  final LookUpItem? cityCurrentSelection;

  final List<LookUpItem>? requestStatusItems;
  final List<LookUpItem>? deathTransferItems;
  final List<LookUpItem>? citiesItems;

  const FilterDialog(
      {Key? key,
      required this.onFilter,
      required this.onClear,
      this.requestCurrentSelection,
      this.deathCurrentSelection,
      this.cityCurrentSelection,
      this.requestStatusItems,
      this.deathTransferItems,
      this.citiesItems})
      : super(key: key);

  @override
  _FilterDialogState createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  bool isBtnDisabled = false;

  LookUpItem? requestCurrentSelection;
  LookUpItem? deathCurrentSelection;
  LookUpItem? cityCurrentSelection;

  @override
  void initState() {
    super.initState();
    requestCurrentSelection = widget.requestCurrentSelection;
    deathCurrentSelection = widget.deathCurrentSelection;
    cityCurrentSelection = widget.cityCurrentSelection;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 5),
      child: Column(
        children: [
          // header
          DialogHeader(
            title: Helpers.translatingWord('lbl_orders_filter'),
          ),
          const CustomVerticalSpace(height: 20),
          // filter type list
          if (widget.requestStatusItems?.isNotEmpty ?? false) ...[
            SectionTitleWidget(title: trans("ekram_request_status")),
            ListView.builder(
                itemCount: widget.requestStatusItems?.length ?? 0,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (ctx, index) {
                  return Column(
                    children: [
                      FilterItemWidget(
                        currentItem: requestCurrentSelection,
                        item: widget.requestStatusItems![index],
                        onChecked: onRequestFilterSelected,
                      ),
                      // DrawLineWidget(
                      //   lineColor: AppColors.warmGrey2
                      //       .withOpacity(0.09530785112257859),
                      // )
                    ],
                  );
                }),
          ],
          const CustomVerticalSpace(height: 24),
          // buttons
          SafeArea(
            top: false,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: EnhancedCustomElevatedButtonWidget(
                    btnColor: isBtnDisabled
                        ? AppColor.black200
                        : AppColor.primary900Light,
                    btnPressed: isBtnDisabled
                        ? null
                        : () {
                            Navigator.of(context).pop();
                            widget.onFilter([
                              requestCurrentSelection,
                              deathCurrentSelection,
                              cityCurrentSelection
                            ]);
                          },
                    btnTextColor:
                        isBtnDisabled ? AppColor.black400 : AppColor.white,
                    btnText: Helpers.translatingWord("view_orders"),
                    btnTextSize: 16,
                    btnTextWeight: AppFontWeight.medium,
                    btnHeight: 56,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomTextButtonWidget(
                      onPressed: () {
                        Navigator.of(context).pop();

                        widget.onClear();
                      },
                      text: Helpers.translatingWord(
                        "erase_all",
                      ),
                      btnTextColor: AppColor.primary900Light,
                      btnTextSize: 17.0,
                      btnTextWeight: AppFontWeight.medium,
                      btnAlignment: AlignmentDirectional.center,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  void onRequestFilterSelected(LookUpItem? type) {
    setState(() {
      requestCurrentSelection = type;
    });
  }

  void onLocationFilterSelected(LookUpItem? type) {
    setState(() {
      deathCurrentSelection = type;
    });
  }

  void onCityFilterSelected(LookUpItem? type) {
    setState(() {
      cityCurrentSelection = type;
    });
  }
}

class FilterItemWidget extends StatelessWidget {
  final LookUpItem item;
  final LookUpItem? currentItem;
  final Function onChecked;

  const FilterItemWidget(
      {Key? key,
      required this.item,
      required this.currentItem,
      required this.onChecked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onChecked(item);
      },
      child: Container(
        height: 60,
        padding: const EdgeInsets.only(right: 10, left: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: CustomTextWidget(
                item.name ?? "",
                fontColor: AppColor.black,
                fontSize: 17.0,
                fontWeight: AppFontWeight.medium,
                textAlign: TextAlign.start,
                textScaleFactor: 1,
              ),
            ),
            Visibility(
              visible: item == currentItem,
              child: SvgPicture.asset(
                IconPath.checked,
                height: 12,
                width: 17,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
