import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_shimmer_list_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/enums/enums.dart';
import '../../data/entities/drop_down_item.dart';
import '../dialogs/incident_type_with_search_dialog.dart';
import '../dialogs/multi_selection_with_search_dialog.dart';
import 'buttons/custom_buttons_widgets.dart';
import 'custom_popups_widgets.dart';
import 'custom_spaces_widgets.dart';

class CustomHeaderAndDescOnTapWidget extends StatefulWidget {
  final String label;
  final Color labelColor;
  final double labelSize;
  final TextAlign labelTextAlign;
  final String hintText;
  final bool filled;
  final Color fillColor;
  final double borderWidth;
  final double borderRadius;
  final Color borderColor;
  final BorderType borderType;
  final bool readOnly;
  final VoidCallback onTap;
  final String? errorMsg;
  final String? textValue;
  final MaterialIconDirection materialIconDirection;
  final Widget? icon;
  final bool? showOptional;
  final double? marginBottom;

  const CustomHeaderAndDescOnTapWidget({
    super.key,
    required this.label,
    this.labelColor = AppColor.blackModern700Light,
    this.labelSize = 16.0,
    this.labelTextAlign = TextAlign.start,
    this.hintText = '',
    this.marginBottom,
    this.filled = false,
    this.fillColor = Colors.transparent,
    this.borderRadius = 8.0,
    this.borderColor = AppColor.blackModern300Light,
    this.borderWidth = 1.5,
    this.borderType = BorderType.outline,
    this.readOnly = false,
    required this.onTap,
    this.errorMsg,
    this.textValue,
    this.materialIconDirection = MaterialIconDirection.down,
    this.icon,
    this.showOptional = false,
  });

  @override
  State<CustomHeaderAndDescOnTapWidget> createState() => _CustomHeaderAndDescOnTapWidget();
}

class _CustomHeaderAndDescOnTapWidget extends State<CustomHeaderAndDescOnTapWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // label
              LabelTextWithOptional(
                label: widget.label,
                labelColor: widget.labelColor,
                labelSize: widget.labelSize,
                labelTextAlign: widget.labelTextAlign,
                showOptional: widget.showOptional,
              ),
              const CustomVerticalSpace(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: GeneralKey.smallPadding,
                  horizontal: GeneralKey.smallPadding,
                ),
                decoration: BoxDecoration(
                  color: widget.readOnly ? AppColor.black400 : widget.fillColor,
                  border: _getBorder(),
                  borderRadius: _getBorderRadius(),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.icon ?? Container(),
                    Expanded(
                      child: CustomTextWidget(
                        widget.textValue ?? widget.hintText,
                        fontColor: (widget.textValue == widget.hintText || widget.textValue == null)
                            ? AppColor.black300
                            : AppColor.black,
                        // fontWeight: (widget.textValue == widget.hintText ||
                        //         widget.textValue == null)
                        //     ? AppFontWeight.medium
                        //     : AppFontWeight.bold,
                        fontWeight: AppFontWeight.medium,
                        textAlign: TextAlign.start,
                      ),
                    ),
                    CustomIconButtonWidget(
                      onPressed: widget.onTap,
                      icon: IconPath.arrowDown,
                      iconColor: AppColor.blackModern600Light,
                      // materialIconDirection: widget.materialIconDirection,
                      iconSize: 16.0,
                    ),
                  ],
                ),
              ),

              if (widget.errorMsg != null && widget.errorMsg!.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomVerticalSpace(height: 8.0),
                    CustomTextWidget(
                      widget.errorMsg!,
                      fontSize: 13.0,
                      fontColor: AppColor.error,
                      fontWeight: AppFontWeight.medium,
                    ),
                  ],
                ),
              CustomVerticalSpace(height: widget.marginBottom ?? 30.0),
            ],
          );
        },
      ),
    );
  }

  BoxBorder? _getBorder() {
    switch (widget.borderType) {
      case BorderType.none:
        return null;
      case BorderType.outline:
        return Border.all(width: widget.borderWidth, color: widget.borderColor);
      case BorderType.underline:
        return Border(
          bottom: BorderSide(width: widget.borderWidth, color: widget.borderColor),
        );
    }
  }

  BorderRadiusGeometry? _getBorderRadius() {
    switch (widget.borderType) {
      case BorderType.none:
        return null;
      case BorderType.outline:
        return BorderRadius.circular(widget.borderRadius);
      case BorderType.underline:
        return null;
    }
  }
}

class CustomTapWidgetForLongDialog extends StatefulWidget {
  final DropDownItem? value;
  final Function(DropDownItem? item) onChangeType;
  final List<DropDownItem> items;
  final String label;
  final String? hint;
  final String? searchHint;
  final String? errorText;
  final bool? showOptional;
  final bool showHintAsTitle;
  final double? marginBottom;
  final bool isLoading;
  final bool? isButtonDisabled;
  final bool? readOnly;

  const CustomTapWidgetForLongDialog({
    super.key,
    required this.onChangeType,
    this.value,
    this.marginBottom,
    required this.items,
    this.hint,
    required this.label,
    this.searchHint,
    this.errorText,
    this.isLoading = false,
    this.showOptional = false,
    this.showHintAsTitle = false,
    this.isButtonDisabled,
    this.readOnly,
  });

  @override
  State<CustomTapWidgetForLongDialog> createState() => _CustomTapWidgetForLongDialog();
}

class _CustomTapWidgetForLongDialog extends State<CustomTapWidgetForLongDialog> {
  @override
  Widget build(BuildContext context) {
    return !widget.isLoading
        ? CustomHeaderAndDescOnTapWidget(
            label: widget.label,
            hintText: widget.hint ?? ("choose_hint").tr(),
            textValue: widget.value?.name,
            showOptional: widget.showOptional,
            labelColor: AppColor.blackModern700Light,
            labelSize: 16,
            marginBottom: widget.marginBottom,
            onTap: widget.items.isNotEmpty
                ? () async {
                    if (widget.readOnly != true) {
                      FocusManager.instance.primaryFocus?.unfocus();
                      await CustomPopUpsWidgets.showBottomSheet(
                        NavigationService.navigatorKey.currentContext!,
                        child: IncidentTypeWithSearchDialog(
                          onSelect: (DropDownItem item) => widget.onChangeType(item),
                          items: widget.items,
                          selectedItem: widget.value,
                          isButtonDisabled: widget.isButtonDisabled,
                          title: widget.showHintAsTitle ? widget.hint : widget.label,
                          searchHint: widget.searchHint ?? ("searchFor").tr(),
                        ),
                      );
                    }
                  }
                : () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    CommonFunctions.showError(widget.errorText ?? ('empty_list_error').tr());
                  },
          )
        : const CustomShimmerWidget(childHeight: 48, padding: EdgeInsets.only(bottom: 30));
  }
}

/*
class CustomLookUpLongDialog extends StatefulWidget {
  final LookUpItem? value;
  final Function(LookUpItem? item) onChangeType;
  final Function? onEmptyList;

  final List<LookUpItem> items;
  final String label;
  final String? hint;
  final String? searchHint;
  final String? errorText;
  final bool? showOptional;
  final bool showHintAsTitle;

  CustomLookUpLongDialog(
      {Key? key,
      required this.onChangeType,
      this.value,
      required this.items,
      this.hint,
      required this.label,
      this.searchHint,
      this.errorText,
      this.showOptional = false,
      this.showHintAsTitle = true,
      this.onEmptyList})
      : super(key: key);

  @override
  State<CustomLookUpLongDialog> createState() => _CustomLookUpLongDialog();
}

class _CustomLookUpLongDialog extends State<CustomLookUpLongDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomHeaderAndDescOnTapWidget(
      label: widget.label,
      hintText: widget.hint!,
      textValue: widget.value?.name,
      showOptional: widget.showOptional,
      onTap: widget.items.isNotEmpty
          ? () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await CustomPopUpsWidgets.showBottomSheet(
                NavigationService.navigatorKey.currentContext!,
                child: LookupWithSearchDialog(
                  onSelect: (LookUpItem item) => widget.onChangeType(item),
                  items: widget.items,
                  selectedItem: widget.value,
                  title: widget.showHintAsTitle ? widget.hint : widget.label,
                  searchHint: widget.searchHint,
                ),
              );
            }
          : () async {
              FocusManager.instance.primaryFocus?.unfocus();
              if (widget.onEmptyList != null) {
                final List<LookUpItem>? items = await widget.onEmptyList!();
                if (items != null) {
                  FocusManager.instance.primaryFocus?.unfocus();
                  await CustomPopUpsWidgets.showBottomSheet(
                    NavigationService.navigatorKey.currentContext!,
                    child: LookupWithSearchDialog(
                      onSelect: (LookUpItem item) => widget.onChangeType(item),
                      items: items,
                      selectedItem: widget.value,
                      title:
                          widget.showHintAsTitle ? widget.hint : widget.label,
                      searchHint: widget.searchHint,
                    ),
                  );
                }
              } else
                showError(widget.errorText ??
                    Helpers.translatingWord('empty_list_error'));
            },
    );
  }
}
*/
class CustomTapWidgetForMultiLongDialog extends StatefulWidget {
  final List<DropDownItem>? values;
  final Function(List<DropDownItem>? item) onChangeType;
  final List<DropDownItem> items;
  final String label;
  final String? hint;
  final String? searchHint;
  final String? errorText;
  final bool? showOptional;
  final bool showHintAsTitle;
  const CustomTapWidgetForMultiLongDialog({
    super.key,
    required this.onChangeType,
    this.values,
    required this.items,
    this.hint,
    required this.label,
    this.searchHint,
    this.errorText,
    this.showOptional = false,
    this.showHintAsTitle = true,
  });

  @override
  State<CustomTapWidgetForMultiLongDialog> createState() => _CustomTapWidgetForMultiLongDialog();
}

class _CustomTapWidgetForMultiLongDialog extends State<CustomTapWidgetForMultiLongDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomHeaderAndDescOnTapWidget(
      label: widget.label,
      hintText: widget.hint!,
      textValue: (widget.values != null && widget.values!.isNotEmpty)
          ? widget.values?.map((e) => e.name).join(",")
          : null,
      showOptional: widget.showOptional,
      onTap: widget.items.isNotEmpty
          ? () async {
              FocusManager.instance.primaryFocus?.unfocus();
              await CustomPopUpsWidgets.showBottomSheet(
                NavigationService.navigatorKey.currentContext!,
                child: MultiSelectionWithSearchDialog(
                  onSelect: (List<DropDownItem> items) => widget.onChangeType(items),
                  items: widget.items,
                  selectedItem: widget.values,
                  title: widget.showHintAsTitle ? widget.hint : widget.label,
                  searchHint: widget.searchHint,
                ),
              );
            }
          : () {
              FocusManager.instance.primaryFocus?.unfocus();
              CommonFunctions.showError(widget.errorText ?? ('empty_list_error').tr());
            },
    );
  }
}

// class TapWidgetForLongDialog extends StatefulWidget {
//   DaemItem? value;
//   Function(DaemItem? item) onChangeType;
//   List<DaemItem> items;
//   String label;
//   String? hint;
//   String? searchHint;
//   String? errorText;
//   final bool? showOptional;
//   final bool showHintAsTitle;
//
//   TapWidgetForLongDialog(
//       {Key? key,
//       required this.onChangeType,
//       this.value,
//       required this.items,
//       this.hint,
//       required this.label,
//       this.searchHint,
//       this.errorText,
//       this.showOptional = false,
//       this.showHintAsTitle = true})
//       : super(key: key);
//
//   @override
//   State<TapWidgetForLongDialog> createState() => _TapWidgetForLongDialog();
// }
//
// class _TapWidgetForLongDialog extends State<TapWidgetForLongDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomHeaderAndDescOnTapWidget(
//       label: widget.label,
//       hintText: widget.hint!,
//       textValue: widget.value?.name,
//       showOptional: widget.showOptional,
//       onTap: widget.items.isNotEmpty
//           ? () async {
//               FocusManager.instance.primaryFocus?.unfocus();
//               await CustomPopUpsWidgets.showBottomSheet(
//                 NavigationService.navigatorKey.currentContext!,
//                 child: DaemTypeWithSearchDialog(
//                   onSelect: (DaemItem item) => widget.onChangeType(item),
//                   items: widget.items,
//                   selectedItem: widget.value,
//                   title: widget.showHintAsTitle ? widget.hint : widget.label,
//                   searchHint: widget.searchHint,
//                 ),
//               );
//             }
//           : () {
//               FocusManager.instance.primaryFocus?.unfocus();
//               CommonFunctions.showError(
//                   widget.errorText ?? ('empty_list_error').tr());
//             },
//     );
//   }
// }

// class CustomLookUpLongDialog extends StatefulWidget {
//   LookUpItem? value;
//   Function(LookUpItem? item) onChangeType;
//   List<LookUpItem> items;
//   String label;
//   String? hint;
//   String? searchHint;
//   String? errorText;
//   final bool? showOptional;
//   final bool showHintAsTitle;
//   final Function? onEmptyList;
//   final bool isDisbaled;
//   final bool refreshList;
//
//   CustomLookUpLongDialog(
//       {Key? key,
//       required this.onChangeType,
//       this.value,
//       required this.items,
//       this.hint,
//       required this.label,
//       this.searchHint,
//       this.errorText,
//       this.showOptional = false,
//       this.showHintAsTitle = true,
//       this.isDisbaled = false,
//       this.refreshList = false,
//       this.onEmptyList})
//       : super(key: key);
//
//   @override
//   State<CustomLookUpLongDialog> createState() => _CustomLookUpLongDialog();
// }
//
// class _CustomLookUpLongDialog extends State<CustomLookUpLongDialog> {
//   @override
//   Widget build(BuildContext context) {
//     return CustomHeaderAndDescOnTapWidget(
//         label: widget.label,
//         hintText: widget.hint!,
//         textValue: widget.value?.name,
//         showOptional: widget.showOptional,
//         onTap: widget.isDisbaled == false
//             ? widget.items.isNotEmpty && !widget.refreshList
//                 ? () async {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     await CustomPopUpsWidgets.showBottomSheet(
//                       NavigationService.navigatorKey.currentContext!,
//                       child: LookupTypeWithSearchDialog(
//                         onSelect: (LookUpItem item) =>
//                             widget.onChangeType(item),
//                         items: widget.items,
//                         selectedItem: widget.value,
//                         title:
//                             widget.showHintAsTitle ? widget.hint : widget.label,
//                         searchHint: widget.searchHint,
//                       ),
//                     );
//                   }
//                 : () async {
//                     FocusManager.instance.primaryFocus?.unfocus();
//                     if (widget.onEmptyList != null) {
//                       List<LookUpItem>? items = await widget.onEmptyList!();
//                       if (items != null) {
//                         FocusManager.instance.primaryFocus?.unfocus();
//                         await CustomPopUpsWidgets.showBottomSheet(
//                           NavigationService.navigatorKey.currentContext!,
//                           child: LookupTypeWithSearchDialog(
//                             onSelect: (LookUpItem item) =>
//                                 widget.onChangeType(item),
//                             items: items,
//                             selectedItem: widget.value,
//                             title: widget.showHintAsTitle
//                                 ? widget.hint
//                                 : widget.label,
//                             searchHint: widget.searchHint,
//                           ),
//                         );
//                       }
//                     } else
//                       CommonFunctions.showError(
//                           widget.errorText ?? ('empty_list_error').tr());
//                   }
//             : () {});
//   }
// }
