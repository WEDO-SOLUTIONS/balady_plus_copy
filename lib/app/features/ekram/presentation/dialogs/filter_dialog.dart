import 'package:balady_new_app/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_new_app/etmam_app/features/_shared_feature_/shared/presentation/widgets/section_title_widget.dart';
import 'package:balady_new_app/shared/core/data/entities/lookup_item.dart';
import 'package:collection/collection.dart';

import 'package:balady_new_app/app/core/core_exports.dart'
    show
        AppColors,
        Constants,
        CustomElevatedButtonWidget,
        CustomTextButtonWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        DialogHeader,
        FONT_WEIGHT,
        Helpers;
import 'package:balady_new_app/app/features/license_management/license_management_exports.dart'
    show HealthLicenseFilterTypeModel;
import 'package:flutter/material.dart';

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
                  child: CustomElevatedButtonWidget(
                    btnColor: isBtnDisabled
                        ? AppColors.black200
                        : AppColors.darkTurquoise,
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
                        isBtnDisabled ? AppColors.black400 : AppColors.white,
                    btnText: Helpers.translatingWord("view_orders"),
                    btnTextSize: 16,
                    btnTextWeight: FONT_WEIGHT.medium,
                    btnHeight: 56,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    alignment: AlignmentDirectional.centerEnd,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: CustomTextButtonWidget(
                      btnPressed: () {
                        Navigator.of(context).pop();

                        widget.onClear();
                      },
                      btnText: Helpers.translatingWord(
                        "erase_all",
                      ),
                      btnTextColor: AppColors.darkTurquoise,
                      btnTextSize: 17.0,
                      btnTextWeight: FONT_WEIGHT.medium,
                      alignment: AlignmentDirectional.center,
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 5),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: DialogHeader(
              title: Helpers.translatingWord('lbl_orders_filter'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // header
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
                  if (widget.deathTransferItems?.isNotEmpty ?? false) ...[
                    CustomVerticalSpace(height: 32),
                    SectionTitleWidget(title: trans("ekram_transfer_status")),
                    Expanded(
                      flex: 0,
                      child: ListView.builder(
                          itemCount: widget.deathTransferItems?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: [
                                FilterItemWidget(
                                  currentItem: deathCurrentSelection,
                                  item: widget.deathTransferItems![index],
                                  onChecked: onLocationFilterSelected,
                                ),
                                // DrawLineWidget(
                                //   lineColor: AppColors.warmGrey2
                                //       .withOpacity(0.09530785112257859),
                                // )
                              ],
                            );
                          }),
                    ),
                  ],
                  if (widget.citiesItems?.isNotEmpty ?? false) ...[
                    CustomVerticalSpace(height: 32),
                    SectionTitleWidget(title: trans("ekram_city_status")),
                    Expanded(
                      flex: 0,
                      child: ListView.builder(
                          itemCount: widget.citiesItems?.length ?? 0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (ctx, index) {
                            return Column(
                              children: [
                                FilterItemWidget(
                                  currentItem: cityCurrentSelection,
                                  item: widget.citiesItems![index],
                                  onChecked: onCityFilterSelected,
                                ),
                                // DrawLineWidget(
                                //   lineColor: AppColors.warmGrey2
                                //       .withOpacity(0.09530785112257859),
                                // )
                              ],
                            );
                          }),
                    ),
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
                          child: CustomElevatedButtonWidget(
                            btnColor: isBtnDisabled
                                ? AppColors.black200
                                : AppColors.darkTurquoise,
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
                            btnTextColor: isBtnDisabled
                                ? AppColors.black400
                                : AppColors.white,
                            btnText: Helpers.translatingWord("view_orders"),
                            btnTextSize: 16,
                            btnTextWeight: FONT_WEIGHT.medium,
                            btnHeight: 56,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: CustomTextButtonWidget(
                              btnPressed: () {
                                Navigator.of(context).pop();

                                widget.onClear();
                              },
                              btnText: Helpers.translatingWord(
                                "erase_all",
                              ),
                              btnTextColor: AppColors.darkTurquoise,
                              btnTextSize: 17.0,
                              btnTextWeight: FONT_WEIGHT.medium,
                              alignment: AlignmentDirectional.center,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
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
                fontColor: AppColors.black,
                fontSize: 17.0,
                fontWeight: FONT_WEIGHT.medium,
                textAlign: TextAlign.start,
                textScaleFactor: 1,
              ),
            ),
            Visibility(
              visible: item == currentItem,
              child: Image.asset(
                Constants.imgPath + "checkMark@3x.png",
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
