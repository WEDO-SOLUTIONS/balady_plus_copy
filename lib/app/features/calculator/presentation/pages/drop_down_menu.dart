import 'package:auto_size_text/auto_size_text.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/calculator/presentation/pages/components_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/constants.dart';

class PickerItem<T> {
  final String text;
  final T value;
  PickerItem({required this.text, required this.value});
}

/// Picker confirm callback.
typedef PickerConfirmCallback = void Function(PickerItem item, int selected);

class DropDownMenu {
  String title;
  String? confirmText;
  List<PickerItem> items;
  int selected;
  PickerConfirmCallback onConfirm;
  bool looping;
  bool isSearchable;

  final double height;
  final double itemExtent;
  final TextStyle? textStyle,
      cancelTextStyle,
      confirmTextStyle,
      titleTextStyle,
      selectedTextStyle;

  DropDownMenu(
      {required this.title,
      required this.items,
      this.isSearchable = false,
      this.confirmText,
      this.selected = 0,
      required this.onConfirm,
      this.textStyle,
      this.cancelTextStyle,
      this.height = 300,
      this.confirmTextStyle,
      this.selectedTextStyle,
      this.titleTextStyle,
      this.itemExtent = 55,
      this.looping = false});

  Future<T?> showModal<T>(
      BuildContext context /*, [ThemeData themeData]*/) async {
    return await showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: DropDownBottomList(picker: this),
        );
      },
    );
  }
}

class DropDownBottomList extends StatefulWidget {
  final DropDownMenu picker;

  DropDownBottomList({required this.picker});

  @override
  _DropDownBottomListState createState() => _DropDownBottomListState(picker);
}

class _DropDownBottomListState extends State<DropDownBottomList> {
  double _squeeze = 1.45;
  final DropDownMenu picker;
  List<PickerItem> items = [];

  int selected = 0;
  int length = 0;
  FixedExtentScrollController ctrl = FixedExtentScrollController();
  _DropDownBottomListState(this.picker) {
    selected = picker.selected;
    items.addAll(picker.items);
    length = items.length;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ctrl = FixedExtentScrollController(
      initialItem: picker.selected,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: picker.height,
      child: Column(
        children: [
          Container(
            height: 44,
            child: DecoratedBox(
              child: Directionality(
                textDirection: (ComponentLocalizations(!CommonFunctions.isAppAR
                            ? const Locale("en")
                            : null)
                        .isRTL()
                    ? TextDirection.rtl
                    : TextDirection.ltr),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(picker.title,
                          style: picker.titleTextStyle ??
                              const TextStyle(
                                  color: Color(0xff000000),
                                  fontWeight: FontWeight.w700,
                                  fontFamily: Constants.appFontType,
                                  fontStyle: FontStyle.normal,
                                  fontSize: 15.0),
                          textScaleFactor: 1,
                          textAlign: ComponentLocalizations(
                                      !CommonFunctions.isAppAR
                                          ? const Locale("en")
                                          : null)
                                  .isRTL()
                              ? TextAlign.right
                              : TextAlign.left),
                      GestureDetector(
                          child: Text(
                              picker.confirmText ??
                                  ComponentLocalizations(
                                          !CommonFunctions.isAppAR
                                              ? const Locale("en")
                                              : null)
                                      .confirmText!,
                              textScaleFactor: 1,
                              style: picker.confirmTextStyle ??
                                  const TextStyle(
                                      fontFamily: Constants.appFontType,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                      fontStyle: FontStyle.normal,
                                      color: Color(0xff389492))),
                          onTap: () {
                            if (items != null && items.length != 0) {
                              picker.onConfirm(items[selected], selected);
                              Navigator.of(context).pop();
                            }
                          })
                    ],
                  ),
                ),
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                      color: Theme.of(context).dividerColor, width: 0.5),
                  bottom: BorderSide(
                      color: Theme.of(context).dividerColor, width: 0.5),
                ),
                color: const Color(0xfffafaf8),
              ),
            ),
          ),
          Container(
            // padding: EdgeInsets.only(right: 16),
            child: Directionality(
              textDirection: (ComponentLocalizations(
                          !CommonFunctions.isAppAR ? const Locale("en") : null)
                      .isRTL()
                  ? TextDirection.rtl
                  : TextDirection.ltr),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      search(value);
                    });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  decoration: InputDecoration(
                    contentPadding: ComponentLocalizations(
                                !CommonFunctions.isAppAR
                                    ? const Locale("en")
                                    : null)
                            .isRTL()
                        ? const EdgeInsets.only(right: 5)
                        : const EdgeInsets.only(left: 5),
                    hintText: ComponentLocalizations(!CommonFunctions.isAppAR
                            ? const Locale("en")
                            : null)
                        .seacrhFor,
                    hintStyle:
                        const TextStyle(fontSize: 15, color: Color(0xffbfbfbf)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffbfbfbf))),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: CupertinoPicker.builder(
              squeeze: _squeeze,
              backgroundColor: Colors.white,
              scrollController: ctrl,
              onSelectedItemChanged: (value) {
                setState(() {
                  selected = value;
                });
              },
              itemExtent: picker.itemExtent,
              itemBuilder: (context, index) {
                bool isSel = index % length == selected;
                return makeText(items[index].text, isSel);
              },
              childCount: picker.looping ? null : length,
            ),
          ),
        ],
      ),
    );
  }

  void search(String str) {
    List<PickerItem> data1 = [];

    for (int i = 0; i < picker.items.length; i++) {
      var textWidget = picker.items[i].text;
      if (textWidget.contains(str)) {
        data1.add(picker.items[i]);
      }
    }

    if (data1.length > 1) {
      items.clear();
      items.addAll(data1);
    } else {
      items.clear();
      items.addAll(data1);
      // this.items.add(PickerItem(text: ""));
    }

    length = items.length;

    _forceLayout();
  }

  Widget makeText(String text, bool isSel) {
    return Center(
        //alignment: Alignment.center,
        child: DefaultTextStyle(
            overflow: TextOverflow.visible,
            textAlign: TextAlign.center,
            style: picker.textStyle ??
                const TextStyle(
                  //
                  fontWeight: FontWeight.w500,
                  fontFamily: Constants.appFontType,
                  fontStyle: FontStyle.normal,
                  fontSize: 16.0,
                  //
                  //fontSize: Picker.DefaultTextSize
                  color: Colors.black87,
                ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: AutoSizeText(text,
                  minFontSize: 11.0,
                  textScaleFactor: 1,
                  style: (isSel ? picker.selectedTextStyle : null)),
            )));
  }

  void _forceLayout() {
    ctrl.jumpTo(0.0);
    setState(() {
      if (_squeeze == 1.45) {
        _squeeze = 1.4500000000000001;
      } else {
        _squeeze = 1.45;
      }
    });
  }
}
