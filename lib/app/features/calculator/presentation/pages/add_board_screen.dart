import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../_shared_feature_/presentation/dialogs/incident_type_with_search_dialog.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../data/model/Item.dart';
import '../../data/model/SearchItem.dart';
import '../../data/model/request/BoardList.dart';
import 'drop_down_menu.dart';

class AddBoardScreen extends StatefulWidget {
  BoardList? board;
  Function? editBoardList;
  Function? deleteBoard;
  List<Item>? boardList;
  int? lastBoardId = 0;
  String? title;

  AddBoardScreen(
      {this.board,
      this.editBoardList,
      this.deleteBoard,
      this.boardList,
      this.lastBoardId,
      this.title,
      Key? key})
      : super(key: key);

  @override
  _AddBoardScreenState createState() => _AddBoardScreenState();
}

class _AddBoardScreenState extends State<AddBoardScreen> {
  Item? _panelTypeController;
  bool isValidPanelType = true;
  final _paintingSpaceController = TextEditingController();
  bool isValidPaintingSpace = true;

  String? _paintingSpaceErrMsg;
  String? _panelTypeErrMsg;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    setEditedBoard();
  }

  @override
  void dispose() {
    super.dispose();
    _paintingSpaceController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: hideKeybaord, child: body());
  }

  Widget body() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              panelTypeWidget(),
              PaintingSpaceWidget(),
              const CustomVerticalSpace(height: 12),
              _sendDataButton(),
              const CustomVerticalSpace(height: 12),
              if (widget.board != null) _delete(),
            ],
          ),
        ],
      ),
    );
  }

  panelTypeWidget() {
    return CustomHeaderAndDescOnTapWidget(
      label: Helpers.translatingWord("lbl_panel_type"),
      hintText: Helpers.translatingWord("lbl_panel_type"),
      textValue:
          (_panelTypeController != null) ? _panelTypeController!.name : null,
      onTap: () {
        showFilterBoardDialogDialog();
      },
    );
  }

  _selectBoard(Item item) {
    if (item != null) {
      _panelTypeController = item;
      isValidPanelType = true;
      _panelTypeErrMsg = null;
      changeBtnColor();
    }
  }

  showFilterBoardDialogDialog() {
    _showBottomPicker([
      for (int i = 0; i < widget.boardList!.length; i++)
        SearchItem(text: widget.boardList?[i].name, value: widget.boardList?[i])
    ], _selectBoard, Helpers.translatingWord("lbl_panel_type"));
  }

  void hideKeybaord() {
    FocusScope.of(context).unfocus();
  }

//Create PaintingSpace Widget
  Widget PaintingSpaceWidget() {
    return CustomTextFieldWidget(
      controller: _paintingSpaceController,
      label: Helpers.translatingWord("lbl_painting_space"),
      keyboardType: TextInputType.number,
      onValidate: (text) {
        return _paintingSpaceErrMsg;
      },
      suffixIcon: labelUnit("lbl_m2"),
      onChanged: (text) {
        changeBtnColor();
      },
    );
  }

  Widget labelUnit(String text) {
    return SizedBox(
      width: 50,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          Helpers.translatingWord(text),
          style: const TextStyle(
              color: AppColor.black,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.normal,
              fontFamily: Constants.appFontType,
              fontSize: 13.0),
          textAlign: TextAlign.center,
          textScaleFactor: 1,
        ),
      ),
    );
  }

  _showBottomPicker(
      List<SearchItem> items, Function select, String title) async {
    int selectedIndex = 0;
    List<DropDownItem> pickerItems = [];

    for (int i = 0; i < items.length; i++) {
      pickerItems.add(DropDownItem(
          id: i.toString(),
          name: items[i].text ?? "",
          calculatorValue: items[i].value));
    }

    await CustomPopUpsWidgets.showBottomSheet(
      isFullHeight: false,
      context,
      child: IncidentTypeWithSearchDialog(
        onSelect: (DropDownItem? e) {
          if (e!.calculatorValue != null && e.calculatorValue != null) {
            select(e.calculatorValue);
          }
        },
        items: pickerItems,
        selectedItem: null,
        title: title,
        searchHint: Helpers.translatingWord("searchFor"),
      ),
    );

    // Picker(
    //     adapter: PickerDataAdapter(data: [
    //       for (int i = 0; i < items.length; i++)
    //         new PickerItem(text: Text(items[i].text), value: items[i].value)
    //     ]),
    //     //   changeToFirst: true,
    //
    //     changeToFirst: true,
    //     confirmTextStyle: TextStyle(
    //         fontFamily: Constants.appFontType,
    //         fontSize: 15,
    //         fontWeight: FontWeight.w700,
    //         fontStyle: FontStyle.normal,
    //         color: kLightGreen),
    //     selectedTextStyle: TextStyle(color: kLightGreen),
    //     headercolor: const Color(0xfffafaf8),
    //     cancel: Container(),
    //     itemExtent: 50.0,
    //     confirmText: Helpers.translatingWord("date_picker_confirm"),
    //     title: new Text(
    //       title,
    //       style: const TextStyle(
    //           color: kBlack,
    //           fontWeight: FontWeight.w700,
    //           fontStyle: FontStyle.normal,
    //           fontSize: 15.0),
    //     ),
    //     hideHeader: false,
    //     isSearchable: false,
    //     onConfirm: (Picker picker, List value) {
    //       if (picker.getSelectedValues() != null &&
    //           picker.getSelectedValues().length > 0) {
    //         if (picker.getSelectedValues()[0] != null)
    //           select(picker.getSelectedValues()[0]);
    //       }
    //     }
    //     // Set the gender value
    //
    //     ).showModal(context);
  }

  changeBtnColor() {
    if (validateIsEmptyPaintingSpaceValue() && _panelTypeController != null) {
      setState(() {
        isValidPaintingSpace = true;
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }
  }

  checkValidation() {
    if (validatePaintingSpaceValue()) return true;
    return false;
  }

  back() {
    var width = double.parse(CommonFunctions.replaceArabicNumberWithEnglish(
        _paintingSpaceController.text.trim()));
    if (widget.board != null && widget.board!.id! > 0) {
      widget.board!.width = width;
      widget.board!.boardTypeId = _panelTypeController!.id;
      widget.board!.length = 1;
    } else {
      widget.board = new BoardList();
      widget.board!.width = width;
      widget.board!.length = 1;
      widget.board!.boardTypeId = _panelTypeController!.id;
      widget.board!.id = DateTime.now().millisecondsSinceEpoch;
    }
    Navigator.pop(context);
    widget.editBoardList!(widget.board);
  }

  _sendDataButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding: const EdgeInsets.only(top: 5, right: 0, left: 0),
          child: EnhancedCustomElevatedButtonWidget(
            btnColor: _isButtonDisabled
                ? AppColor.black200
                : AppColor.primary900Light,
            btnTextColor:
                _isButtonDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: _isButtonDisabled
                ? null
                : () {
                    if (checkValidation()) {
                      back();
                    }
                  },
            btnText: widget.board == null
                ? Helpers.translatingWord("lbl_add")
                : Helpers.translatingWord("lbl_save_changes"),
            btnTextSize: 16.0,
            btnRadius: 8,
            btnTextWeight: AppFontWeight.medium,
            btnHeight: 56.0,
          )),
    );
  }

  _deleteBoard() {
    Navigator.of(context).pop();
    widget.deleteBoard!(widget.board)!;
  }

  _delete() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: EnhancedCustomElevatedButtonWidget(
        btnPressed: () {
          _deleteBoard();
        },
        btnText: Helpers.translatingWord("lbl_delete"),
        btnTextSize: 16,
        btnTextWeight: AppFontWeight.medium,
        btnHeight: 56,
        btnTextColor: AppColor.primary900Light,
        btnBorderColor: AppColor.primary900Light,
        btnColor: AppColor.white,
      ),
    );
  }

  bool validatePaintingSpaceValue() {
    if (_paintingSpaceController.text.isNotEmpty &&
        double.tryParse(CommonFunctions.replaceArabicNumberWithEnglish(
                _paintingSpaceController.text.trim())) !=
            null &&
        double.parse(CommonFunctions.replaceArabicNumberWithEnglish(
                _paintingSpaceController.text.trim())) >
            0) {
      setState(() {
        isValidPaintingSpace = true;
        _paintingSpaceErrMsg = null;
      });
      return true;
    } else {
      setState(() {
        isValidPaintingSpace = false;
        _paintingSpaceErrMsg = Helpers.translatingWord("lbl_test_error");
      });

      return false;
    }
  }

  bool validateIsEmptyPaintingSpaceValue() {
    if (_paintingSpaceController.text.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  setEditedBoard() {
    if (widget.board != null) {
      setState(() {
        _paintingSpaceController.text = widget.board!.width.toString();
        int index = widget.boardList!
            .indexWhere((panel) => panel.id == widget.board?.boardTypeId);
        if (index >= 0) {
          _panelTypeController = widget.boardList?[index];
        }
      });
    }
  }
}
