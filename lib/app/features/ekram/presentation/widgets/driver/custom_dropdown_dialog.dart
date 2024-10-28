import 'package:flutter/cupertino.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/dialogs/dialog_header.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../_shared_feature_/presentation/widgets/search_text_field_widget.dart';
import '../../../../daem/presentation/dialogs/str_type_with_search_dialog.dart';
import '../../../data/model/driver/trip_stations.dart';

class CustomDropDownDialog extends StatefulWidget {


  Function(TripStations? item) onChangeType;
  List<TripStations> items;
  String label;
  String? hint;
  String? searchHint;
  String? errorText;
  String? selectedValue;
 // String? selectedValue;
  final bool? showOptional;
  final bool showHintAsTitle;
  final Function? onEmptyList;
  final bool isDisbaled;
  final bool refreshList;

  CustomDropDownDialog(
      {Key? key,
        required this.onChangeType,
        this.selectedValue,
        required this.items,
        this.hint,
        required this.label,
        this.searchHint,
        this.errorText,
        this.showOptional = false,
        this.showHintAsTitle = true,
        this.isDisbaled = false,
        this.refreshList = false,
        this.onEmptyList})
      : super(key: key);

  @override
  State<CustomDropDownDialog> createState() => _CustomDropDownDialog();
}

class _CustomDropDownDialog extends State<CustomDropDownDialog> {
  @override
  Widget build(BuildContext context) {
    return CustomHeaderAndDescOnTapWidget(
        label: widget.label,
        hintText: widget.hint!,
        textValue: widget.selectedValue??widget.hint,

        showOptional: widget.showOptional,
        onTap: widget.isDisbaled == false
            ? widget.items.isNotEmpty && !widget.refreshList
            ? () async {
          FocusManager.instance.primaryFocus?.unfocus();
          await CustomPopUpsWidgets.showBottomSheet(
            NavigationService.navigatorKey.currentContext!,
            child: SearchDialog(
              onSelect: (TripStations item) =>
                  widget.onChangeType(item),
              items: widget.items,
              selectedItem: widget.selectedValue,
              title:
              widget.showHintAsTitle ? widget.hint : widget.label,
              searchHint: widget.searchHint,
            ),
          );
        }
            : () async {
          FocusManager.instance.primaryFocus?.unfocus();
          if (widget.onEmptyList != null) {
            List<TripStations>? items = await widget.onEmptyList!();
            if (items != null) {
              FocusManager.instance.primaryFocus?.unfocus();
              await CustomPopUpsWidgets.showBottomSheet(
                NavigationService.navigatorKey.currentContext!,
                child: SearchDialog(
                  onSelect: (TripStations item) =>
                      widget.onChangeType(item),
                  items: items,
                  selectedItem: widget.selectedValue,
                  title: widget.showHintAsTitle
                      ? widget.hint
                      : widget.label,
                  searchHint: widget.searchHint,
                ),
              );
            }
          } else
            CommonFunctions.showError(
                widget.errorText ?? ('empty_list_error').tr());
        }
            : () {});
  }
}


class SearchDialog extends StatefulWidget {
  final Function(TripStations item) onSelect;
  List<TripStations> items;
  String? selectedItem;
  String? title;
  String? searchHint;

  SearchDialog(
      {Key? key,
        required this.onSelect,
        this.selectedItem,
        required this.items,
        this.title,
        this.searchHint})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SearchDialog();
  }
}

class _SearchDialog extends State<SearchDialog> {
  List<TripStations> items = [];
  TripStations? currentSelected;

  //List<SpecializedClassificationItem> items = [];
  final ScrollController _scrollController = ScrollController();
  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();

    items.clear();
    items.addAll(widget.items);

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 10),
      child: Column(
        children: [
          // header
          DialogHeader(
            title: widget.title ?? ('choose_incident_type').tr(),
          ),
          const CustomVerticalSpace(height: 20),
          // search
          SearchTextFieldWidget(
            containerHeight: 52,
            hintText: widget.searchHint ?? ('searchFor').tr(),
            onTextChanged: /* () {},*/
                (value) {
              setState(() {
                items = widget.items
                    .where((element) => element.typeName?.contains(value) ?? false)
                    .toList();
              });
            },
            onSubmitSearch: (String val) {},
          ),
          const CustomVerticalSpace(height: 20),
          // incident type list
          Expanded(
            child: ListView.builder(
              //   itemCount: items != null ? items.length : 0,
                itemCount: items.length,
                shrinkWrap: true,
                controller: _scrollController,
                itemBuilder: (ctx, index) {
                  return CustomRadioButtonEnd<TripStations>(
                    // title: items[index].name,
                    // value: items[index].id,
                    title: items[index].typeName ?? "",
                    value: items[index],
                    isDisabled: false,

                    currentSelected: currentSelected ??items[0],
                    onChange: onItemChanged,
                  );
                }),
          ),
          const CustomVerticalSpace(height: 5),
          // button
          EnhancedCustomElevatedButtonWidget(
            btnColor:
            isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isButtonDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isButtonDisabled
                ? null
                : () {
              Navigator.of(context).pop();
              //     SpecializedClassificationItem item = items.firstWhere(
              //             (element) => element.id == currentSelected,
              //         orElse: () => null);
              if (currentSelected != null) {
                widget.onSelect(currentSelected!);
              }
            },
            btnText: ("bookNewAppointmentSelectWord").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.regular,
            btnHeight: 56,
            btnRadius: 8,
          )
        ],
      ),
    );
  }

  void onItemChanged(TripStations item) {
    FocusScope.of(context).unfocus();
    isButtonDisabled = false;
    setState(() {
      currentSelected = item;
    });
  }


}

