import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as dialog;
import 'package:hijri/hijri_calendar.dart';
import 'dart:async';
import 'picker_localizations.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

const bool __printDebug = false;

/// Picker selected callback.
typedef PickerSelectedCallback = void Function(Picker picker, int index, List<int> selecteds);

/// Picker confirm callback.
typedef PickerConfirmCallback = void Function(Picker picker, List<int> selecteds);

/// Picker value format callback.
typedef PickerValueFormat<T> = String Function(T value);

/// Picker
class Picker {
  static const double defaultTextSize = 20.0;

  /// Index of currently selected items
  List<int>? selecteds;

  /// Picker adapter, Used to provide data and generate widgets
  final PickerAdapter? adapter;

  /// insert separator before picker columns
  final List<PickerDelimiter>? delimiter;

  final VoidCallback? onCancel;
  final PickerSelectedCallback? onSelect;
  final PickerConfirmCallback? onConfirm;

  /// When the previous level selection changes, scroll the child to the first item.
  final bool? changeToFirst;

  /// Specify flex for each column
  final List<int>? columnFlex;

  final Widget? title;
  final Widget? cancel;
  final Widget? confirm;
  final String? cancelText;
  final String? confirmText;

  final double? height;

  /// Height of list item
  final double? itemExtent;

  final TextStyle? textStyle, cancelTextStyle, confirmTextStyle, selectedTextStyle;
  final TextAlign? textAlign;

  /// Text scaling factor
  final double? textScaleFactor;

  final EdgeInsetsGeometry? columnPadding;
  final Color? backgroundColor, headercolor, containerColor;

  /// Hide head
  final bool? hideHeader;

  /// Show pickers in reversed order
  final bool? reversedOrder;

  /// Generate a custom header， [hideHeader] = true
  final WidgetBuilder? builderHeader;

  /// List item loop
  final bool? looping;

  /// Delay generation for smoother animation, This is the number of milliseconds to wait. It is recommended to > = 200
  final int? smooth;
  bool? isAr;
  final Widget? footer;

  final Decoration? headerDecoration;

  final double? magnification;
  final double? diameterRatio;
  final double? squeeze;

  Widget? _widget;
  PickerWidgetState? _state;

  Picker({
    this.adapter,
    this.delimiter,
    this.selecteds,
    this.height = 217.0,
    this.itemExtent = 35.0,
    this.columnPadding,
    this.textStyle,
    this.cancelTextStyle,
    this.confirmTextStyle,
    this.selectedTextStyle,
    this.textAlign = TextAlign.center,
    this.isAr = true,
    this.textScaleFactor,
    this.title,
    this.cancel,
    this.confirm,
    this.cancelText,
    this.confirmText,
    this.backgroundColor = Colors.white,
    this.containerColor,
    this.headercolor,
    this.builderHeader,
    this.changeToFirst = false,
    this.hideHeader = false,
    this.looping = false,
    this.reversedOrder = false,
    this.headerDecoration,
    this.columnFlex,
    this.footer,
    this.smooth,
    this.magnification = 1.0,
    this.diameterRatio = 1.1,
    this.squeeze = 1.45,
    this.onCancel,
    this.onSelect,
    this.onConfirm,
  }) : assert(adapter != null);

  Widget get widget => _widget!;
  PickerWidgetState get state => _state!;
  int _maxLevel = 1;

  /// 生成picker控件
  /// Build picker control
  Widget makePicker([ThemeData? themeData, bool isModal = false]) {
    _maxLevel = adapter!.maxLevel;
    adapter!.picker = this;
    adapter!.initSelects();
    _widget = _PickerWidget(picker: this, themeData: themeData, isModal: isModal);
    return _widget!;
  }

  /// show picker
  void show(ScaffoldState state, [ThemeData? themeData]) {
    state.showBottomSheet((BuildContext context) {
      return makePicker(themeData);
    });
  }

  /// Display modal picker
  Future<T?> showModal<T>(BuildContext context, [ThemeData? themeData]) async {
    return await showModalBottomSheet<T>(
      context: context, //state.context,
      builder: (BuildContext context) {
        return makePicker(themeData, true);
      },
    );
  }

  /// show dialog picker
  Future<List<int>?> showdialog(BuildContext context, {bool barrierDismissible = true, Key? key}) {
    return dialog.showDialog<List<int>>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) {
        List<Widget> actions = [];

        if (cancel == null) {
          String resolvedCancelText = cancelText ?? PickerLocalizations.of(context).cancelText;
          if (resolvedCancelText != "") {
            actions.add(
              TextButton(
                onPressed: () {
                  Navigator.pop<List<int>>(context, null);
                  if (onCancel != null) onCancel!();
                },
                child: cancelTextStyle == null
                    ? Text(resolvedCancelText, textScaler: TextScaler.noScaling)
                    : DefaultTextStyle(
                        style: cancelTextStyle!,
                        child: Text(resolvedCancelText, textScaler: TextScaler.noScaling),
                      ),
              ),
            );
          }
        } else {
          actions.add(cancel!);
        }

        if (confirm == null) {
          String resolvedConfirmText = confirmText ?? PickerLocalizations.of(context).confirmText;
          if (resolvedConfirmText != "") {
            actions.add(
              TextButton(
                onPressed: () {
                  Navigator.pop<List<int>>(context, selecteds);
                  if (onConfirm != null) onConfirm!(this, selecteds!);
                },
                child: confirmTextStyle == null
                    ? Text(resolvedConfirmText, textScaler: TextScaler.noScaling)
                    : DefaultTextStyle(
                        style: confirmTextStyle!,
                        child: Text(resolvedConfirmText, textScaler: TextScaler.noScaling),
                      ),
              ),
            );
          }
        } else {
          actions.add(confirm!);
        }

        return AlertDialog(
          key: key ?? const Key('picker-dialog'),
          title: title,
          actions: actions,
          content: makePicker(),
        );
      },
    );
  }

  /// 获取当前选择的值
  /// Get the value of the current selection
  List getSelectedValues() {
    return adapter!.getSelectedValues();
  }

  /// 取消
  void doCancel(BuildContext context) {
    if (onCancel != null) onCancel!();
    Navigator.of(context).pop<List<int>>(null);
    _widget = null;
  }

  /// 确定
  void doConfirm(BuildContext context) {
    if (onConfirm != null) onConfirm!(this, selecteds!);
    Navigator.of(context).pop();
    _widget = null;
  }

  /// 弹制更新指定列的内容
  /// 当 onSelect 事件中，修改了当前列前面的列的内容时，可以调用此方法来更新显示
  void updateColumn(int index, [bool all = false]) {
    if (all) {
      _state!.update();
      return;
    }
    adapter!.setColumn(index - 1);
    _state!._keys[index].currentState!.update();
  }
}

/// 分隔符
class PickerDelimiter {
  final Widget? child;
  final int? column;
  PickerDelimiter({this.child, this.column = 1}) : assert(child != null);
}

/// picker data list item
class PickerItem<T> {
  /// 显示内容
  final Widget? text;

  /// 数据值
  final T? value;

  /// 子项
  final List<PickerItem<T>>? children;

  PickerItem({this.text, this.value, this.children});
}

class _PickerWidget<T> extends StatefulWidget {
  final Picker? picker;
  final ThemeData? themeData;
  final bool? isModal;
  const _PickerWidget({super.key, required this.picker, required this.themeData, this.isModal});

  @override
  PickerWidgetState createState() => PickerWidgetState<T>();
}

class PickerWidgetState<T> extends State<_PickerWidget> {
  // Read straight from the widget instead of being handed copies in
  // createState, which must not contain logic.
  Picker? get picker => widget.picker;
  ThemeData? get themeData => widget.themeData;

  ThemeData? theme;
  final List<FixedExtentScrollController> scrollController = [];
  final List<GlobalKey<_StateViewState>> _keys = [];

  @override
  void initState() {
    super.initState();
    theme = themeData;
    picker!._state = this;
    picker!.adapter!.doShow();

    if (scrollController.isEmpty) {
      for (int i = 0; i < picker!._maxLevel; i++) {
        scrollController.add(FixedExtentScrollController(initialItem: picker!.selecteds![i]));
        _keys.add(GlobalKey(debugLabel: i.toString()));
      }
    }
  }

  void update() {
    setState(() {});
  }

  // var ref = 0;
  @override
  Widget build(BuildContext context) {
    if (_wait && picker!.smooth != null && picker!.smooth! > 0) {
      Future.delayed(Duration(milliseconds: picker!.smooth!), () {
        if (!_wait) return;
        setState(() {
          _wait = false;
        });
      });
    } else {
      _wait = false;
    }

    var body = <Widget>[];
    if (!picker!.hideHeader!) {
      if (picker!.builderHeader != null) {
        body.add(
          picker!.headerDecoration == null
              ? picker!.builderHeader!(context)
              : DecoratedBox(decoration: picker!.headerDecoration!, child: picker!.builderHeader!(context)),
        );
      } else {
        body.add(
          DecoratedBox(
            decoration:
                picker!.headerDecoration ??
                BoxDecoration(
                  border: Border(
                    top: BorderSide(color: theme!.dividerColor, width: 0.5),
                    bottom: BorderSide(color: theme!.dividerColor, width: 0.5),
                  ),
                  color: picker!.headercolor ?? theme!.bottomAppBarTheme.color,
                ),
            child: Directionality(
              textDirection: (picker!.isAr! ? TextDirection.rtl : TextDirection.ltr),
              child: Row(children: _buildHeaderViews()!),
            ),
          ),
        );
      }
    }
    body.add(
      _wait
          ? Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: _buildViews())
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: _buildViews()),
            ),
    );

    if (picker!.footer != null) body.add(picker!.footer!);
    Widget v = Column(mainAxisSize: MainAxisSize.min, children: body);
    if (widget.isModal != null && widget.isModal!) {
      return GestureDetector(onTap: () {}, child: v);
    }
    return v;
  }

  List<Widget>? _headerItems;

  List<Widget>? _buildHeaderViews() {
    if (_headerItems != null) return _headerItems;
    theme ??= Theme.of(context);
    List<Widget> items = [];

    if (picker!.cancel != null) {
      items.add(
        DefaultTextStyle(
          style:
              picker!.cancelTextStyle ??
              TextStyle(color: theme!.colorScheme.secondary, fontSize: Picker.defaultTextSize),
          child: picker!.cancel!,
        ),
      );
    } else {
      String resolvedCancelText = picker!.cancelText ?? PickerLocalizations.of(context).cancelText;
      if (resolvedCancelText != "") {
        items.add(
          TextButton(
            onPressed: () {
              picker!.doCancel(context);
            },
            child: Text(
              resolvedCancelText,
              overflow: TextOverflow.ellipsis,
              textScaler: TextScaler.noScaling,
              style:
                  picker!.cancelTextStyle ??
                  TextStyle(color: theme!.colorScheme.secondary, fontSize: Picker.defaultTextSize),
            ),
          ),
        );
      }
    }

    items.add(
      Expanded(
        child: Container(
          padding: (picker!.isAr! ? const EdgeInsets.only(right: 16) : const EdgeInsets.only(left: 16)),
          alignment: picker!.isAr! ? Alignment.topRight : Alignment.topLeft,
          child: picker!.title == null
              ? picker!.title
              : DefaultTextStyle(
                  style: TextStyle(fontSize: Picker.defaultTextSize, color: theme!.textTheme.displayLarge!.color),
                  child: picker!.title!,
                ),
        ),
      ),
    );

    if (picker!.confirm != null) {
      items.add(
        DefaultTextStyle(
          style:
              picker!.confirmTextStyle ??
              TextStyle(color: theme!.colorScheme.secondary, fontSize: Picker.defaultTextSize),
          child: picker!.confirm!,
        ),
      );
    } else {
      String resolvedConfirmText = picker!.confirmText ?? PickerLocalizations.of(context).confirmText;
      if (resolvedConfirmText != "") {
        items.add(
          TextButton(
            onPressed: () {
              picker!.doConfirm(context);
            },
            child: Text(
              resolvedConfirmText,
              textScaler: TextScaler.noScaling,
              overflow: TextOverflow.ellipsis,
              style:
                  picker!.confirmTextStyle ??
                  TextStyle(color: theme!.colorScheme.secondary, fontSize: Picker.defaultTextSize),
            ),
          ),
        );
      }
    }

    _headerItems = items;
    return items;
  }

  bool _changeing = false;
  bool _wait = true;
  final Map<int, int> lastData = {};

  List<Widget> _buildViews() {
    if (__printDebug) debugPrint("_buildViews");
    theme ??= Theme.of(context);

    List<Widget>? items = [];

    PickerAdapter? adapter = picker!.adapter!;
    adapter.setColumn(-1);

    if (adapter.length > 0) {
      var columnDecoration = BoxDecoration(
        color: picker!.containerColor ?? theme!.dialogTheme.backgroundColor ?? theme!.colorScheme.surface,
      );

      for (int i = 0; i < picker!._maxLevel; i++) {
        Widget view = Expanded(
          flex: adapter.getColumnFlex(i),
          child: Container(
            padding: picker!.columnPadding,
            height: picker!.height,
            decoration: columnDecoration,
            child: _wait
                ? null
                : _StateView(
                    key: _keys[i],
                    builder: (context) {
                      adapter.setColumn(i - 1);
                      var columnLength = adapter.length;
                      var view = CupertinoPicker.builder(
                        backgroundColor: picker!.backgroundColor,
                        scrollController: scrollController[i],
                        itemExtent: picker!.itemExtent!,
                        // looping: picker.looping,
                        magnification: picker!.magnification!,
                        diameterRatio: picker!.diameterRatio!,
                        squeeze: picker!.squeeze!,
                        onSelectedItemChanged: (int rawIndex) {
                          if (__printDebug) debugPrint("onSelectedItemChanged");
                          var index = rawIndex % columnLength;
                          picker!.selecteds![i] = index;
                          updateScrollController(i);
                          adapter.doSelect(i, index);
                          if (picker!.changeToFirst!) {
                            for (int j = i + 1; j < picker!.selecteds!.length; j++) {
                              picker!.selecteds![j] = 0;
                              scrollController[j].jumpTo(0.0);
                            }
                          }
                          if (picker!.onSelect != null) {
                            picker!.onSelect!(picker!, i, picker!.selecteds!);
                          }

                          if (adapter.needUpdatePrev(i)) {
                            setState(() {});
                          } else {
                            _keys[i].currentState!.update();
                            if (adapter.isLinkage) {
                              for (int j = i + 1; j < picker!.selecteds!.length; j++) {
                                if (j == i) continue;
                                adapter.setColumn(j - 1);
                                _keys[j].currentState!.update();
                              }
                            }
                          }
                        },
                        itemBuilder: (context, index) {
                          adapter.setColumn(i - 1);
                          return adapter.buildItem(context, index % columnLength);
                        },
                        childCount: picker!.looping! ? null : columnLength,
                      );

                      if (!picker!.changeToFirst! && picker!.selecteds![i] >= columnLength) {
                        Timer(const Duration(milliseconds: 100), () {
                          if (__printDebug) debugPrint("timer last");
                          adapter.setColumn(i - 1);
                          var len = adapter.length;
                          var rawIndex = (len < columnLength ? len : columnLength) - 1;
                          scrollController[i].jumpToItem(rawIndex);
                        });
                      }

                      return view;
                    },
                  ),
          ),
        );
        items.add(view);
      }
    }

    if (picker!.delimiter != null && !_wait) {
      for (int i = 0; i < picker!.delimiter!.length; i++) {
        var o = picker!.delimiter![i];
        if (o.child == null) continue;
        var item = SizedBox(height: picker!.height, child: o.child);
        if (o.column! < 0) {
          items.insert(0, item);
        } else if (o.column! >= items.length) {
          items.add(item);
        } else {
          items.insert(o.column!, item);
        }
      }
    }

    if (picker!.reversedOrder!) return items.reversed.toList();

    return items;
  }

  void updateScrollController(int i) {
    if (_changeing || !picker!.adapter!.isLinkage) return;
    _changeing = true;
    for (int j = 0; j < picker!.selecteds!.length; j++) {
      if (j != i) {
        scrollController[j].position.notifyListeners();
      }
    }
    _changeing = false;
  }
}

/// 选择器数据适配器
abstract class PickerAdapter<T> {
  Picker? picker;

  int getLength();
  int getMaxLevel();
  void setColumn(int index);
  void initSelects();
  Widget buildItem(BuildContext context, int index);

  /// 是否需要更新前面的列
  /// Need to update previous columns
  bool needUpdatePrev(int curIndex) {
    return false;
  }

  Widget makeText(Widget? child, String? text, bool? isSel) {
    return Center(
      //alignment: Alignment.center,
      child: DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: picker!.textAlign,
        style: picker!.textStyle ?? const TextStyle(color: Colors.black87, fontSize: Picker.defaultTextSize),
        child:
            child ?? Text(text!, textScaler: TextScaler.noScaling, style: (isSel! ? picker!.selectedTextStyle : null)),
      ),
    );
  }

  Widget makeTextEx(Widget? child, String? text, Widget? postfix, Widget? suffix, bool? isSel) {
    List<Widget> items = [];
    if (postfix != null) items.add(postfix);
    items.add(
      child ?? Text(text!, style: (isSel! ? picker!.selectedTextStyle : null), textScaler: TextScaler.noScaling),
    );
    if (suffix != null) items.add(suffix);

    var txtColor = Colors.black87;
    var txtSize = Picker.defaultTextSize;
    if (isSel! && picker!.selectedTextStyle != null) {
      if (picker!.selectedTextStyle!.color != null) {
        txtColor = picker!.selectedTextStyle!.color!;
      }
      if (picker!.selectedTextStyle!.fontSize != null) {
        txtSize = picker!.selectedTextStyle!.fontSize!;
      }
    }

    return Center(
      //alignment: Alignment.center,
      child: DefaultTextStyle(
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: picker!.textAlign,
        style: picker!.textStyle ?? TextStyle(color: txtColor, fontSize: txtSize),
        child: Wrap(children: items),
      ),
    );
  }

  String getText() {
    return getSelectedValues().toString();
  }

  List<T> getSelectedValues() {
    return [];
  }

  void doShow() {}
  void doSelect(int column, int index) {}

  int getColumnFlex(int column) {
    if (picker!.columnFlex != null && column < picker!.columnFlex!.length) {
      return picker!.columnFlex![column];
    }

    return 1;
  }

  int get maxLevel => getMaxLevel();

  /// Content length of current column
  int get length => getLength();

  String get text => getText();

  // 是否联动，即后面的列受前面列数据影响
  bool get isLinkage => getIsLinkage();

  @override
  String toString() {
    return getText();
  }

  bool getIsLinkage() {
    return true;
  }

  /// 通知适配器数据改变
  void notifyDataChanged() {
    if (picker != null) {
      picker!.adapter!.doShow();
      picker!.adapter!.initSelects();
      for (int j = 0; j < picker!.selecteds!.length; j++) {
        picker!.state.scrollController[j].jumpToItem(picker!.selecteds![j]);
      }
    }
  }
}

/// 数据适配器
class PickerDataAdapter<T> extends PickerAdapter<T> {
  List<PickerItem<T>>? data;
  List<PickerItem<dynamic>>? _datas;
  int _maxLevel = -1;
  int _col = 0;
  final bool isArray;

  PickerDataAdapter({List? pickerdata, this.data, this.isArray = false}) {
    _parseData(pickerdata!);
  }

  @override
  bool getIsLinkage() {
    return !isArray;
  }

  void _parseData(final List? pickerData) {
    if (pickerData != null && pickerData.isNotEmpty && (data == null || data!.isEmpty)) {
      data ??= [];
      if (isArray) {
        _parseArrayPickerDataItem(pickerData, data!);
      } else {
        _parsePickerDataItem(pickerData, data!);
      }
    }
  }

  void _parseArrayPickerDataItem(List? pickerData, List<PickerItem>? data) {
    if (pickerData == null) return;
    var len = pickerData.length;
    for (int i = 0; i < len; i++) {
      var v = pickerData[i];
      if (!(v is! List)) continue;
      List lv = v;
      if (lv.isEmpty) continue;

      PickerItem item = PickerItem<T>(children: []);
      data!.add(item);

      for (int j = 0; j < lv.length; j++) {
        var o = lv[j];
        if (o is T) {
          item.children!.add(PickerItem<T>(value: o));
        } else if (T == String) {
          String v = o.toString();
          item.children!.add(PickerItem<T>(value: v as T));
        }
      }
    }
    if (__printDebug) debugPrint("data.length: ${data!.length}");
  }

  void _parsePickerDataItem(List? pickerData, List<PickerItem>? data) {
    if (pickerData == null) return;
    var len = pickerData.length;
    for (int i = 0; i < len; i++) {
      var item = pickerData[i];
      if (item is T) {
        data!.add(PickerItem<T>(value: item));
      } else if (item is Map) {
        final Map map = item;
        if (map.isEmpty) continue;

        List<T> mapList = map.keys.toList() as List<T>;
        for (int j = 0; j < mapList.length; j++) {
          var o = map[mapList[j]];
          if (o is List && o.isNotEmpty) {
            List<PickerItem<T>> childItems = [];

            data!.add(PickerItem<T>(value: mapList[j], children: childItems));
            _parsePickerDataItem(o, childItems);
          }
        }
      } else if (T == String && !(item is! List)) {
        String v = item.toString();

        data!.add(PickerItem<T>(value: v as T));
      }
    }
  }

  @override
  void setColumn(int index) {
    if (_datas != null && _col == index + 1) return;
    _col = index + 1;
    if (isArray) {
      if (__printDebug) debugPrint("index: $index");
      if (_col < data!.length) {
        _datas = data![_col].children;
      } else {
        _datas = null;
      }
      return;
    }
    if (index < 0) {
      _datas = data;
    } else {
      _datas = data;
      // 列数过多会有性能问题
      for (int i = 0; i <= index; i++) {
        var j = picker!.selecteds![i];
        if (_datas != null && _datas!.length > j) {
          _datas = _datas![j].children;
        } else {
          _datas = null;
          break;
        }
      }
    }
  }

  @override
  int getLength() {
    return _datas == null ? 0 : _datas!.length;
  }

  @override
  getMaxLevel() {
    if (_maxLevel == -1) _checkPickerDataLevel(data!, 1);
    return _maxLevel;
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    final PickerItem item = _datas![index];
    if (item.text != null) {
      return item.text!;
    }
    return makeText(item.text, item.text != null ? null : item.value.toString(), index == picker!.selecteds![_col]);
  }

  @override
  void initSelects() {
    if (picker!.selecteds == null || picker!.selecteds!.isEmpty) {
      if (picker!.selecteds == null) picker!.selecteds = [];
      {
        for (int i = 0; i < _maxLevel; i++) {
          picker!.selecteds!.add(0);
        }
      }
    }
  }

  @override
  List<T> getSelectedValues() {
    List<T> items = [];
    if (picker!.selecteds != null) {
      var sLen = picker!.selecteds!.length;
      if (isArray) {
        for (int i = 0; i < sLen; i++) {
          int j = picker!.selecteds![i];
          if (j < 0 || data![i].children == null || j >= data![i].children!.length) {
            break;
          }
          items.add(data![i].children![j].value as T);
        }
      } else {
        List<PickerItem<dynamic>> datas = data!;
        for (int i = 0; i < sLen; i++) {
          int j = picker!.selecteds![i];
          if (j < 0 || j >= datas.length) break;
          items.add(datas[j].value);
          datas = datas[j].children!;
          if (datas.isEmpty) break;
        }
      }
    }
    return items;
  }

  void _checkPickerDataLevel(List<PickerItem>? data, int? level) {
    if (data == null) return;
    if (isArray) {
      _maxLevel = data.length;
      return;
    }
    for (int i = 0; i < data.length; i++) {
      if (data[i].children != null && data[i].children!.isNotEmpty) {
        _checkPickerDataLevel(data[i].children, level! + 1);
      }
    }
    if (_maxLevel < level!) _maxLevel = level;
  }
}

class NumberPickerColumn {
  final List<int>? items;
  final int? begin;
  final int? end;
  final int? initValue;
  final int? columnFlex;
  final int? jump;
  final Widget? postfix, suffix;
  final PickerValueFormat<int>? onFormatValue;

  const NumberPickerColumn({
    this.begin = 0,
    this.end = 9,
    this.items,
    this.initValue,
    this.jump = 1,
    this.columnFlex = 1,
    this.postfix,
    this.suffix,
    this.onFormatValue,
  }) : assert(jump != null);

  int indexOf(int? value) {
    if (value == null) return -1;
    if (items != null) return items!.indexOf(value);
    if (value < begin! || value > end!) return -1;
    return (value - begin!) ~/ (jump == 0 ? 1 : jump!);
  }

  int valueOf(int index) {
    if (items != null) {
      return items![index];
    }
    return begin! + index * (jump == 0 ? 1 : jump!);
  }

  String getValueText(int index) {
    return onFormatValue == null ? "${valueOf(index)}" : onFormatValue!(valueOf(index));
  }

  int count() {
    var v = (end! - begin!) ~/ (jump == 0 ? 1 : jump!) + 1;
    if (v < 1) return 0;
    return v;
  }
}

class NumberPickerAdapter extends PickerAdapter<int> {
  NumberPickerAdapter({this.data}) : assert(data != null);

  final List<NumberPickerColumn>? data;
  NumberPickerColumn? cur;
  int _col = 0;

  @override
  int getLength() {
    if (cur == null) return 0;
    if (cur!.items != null) return cur!.items!.length;
    return cur!.count();
  }

  @override
  int getMaxLevel() {
    return data == null ? 0 : data!.length;
  }

  @override
  bool getIsLinkage() {
    return false;
  }

  @override
  void setColumn(int index) {
    if (index != -1 && _col == index + 1) return;
    _col = index + 1;
    if (_col >= data!.length) {
      cur = null;
    } else {
      cur = data![_col];
    }
  }

  @override
  void initSelects() {
    int maxLevel = getMaxLevel();
    if (picker!.selecteds == null || picker!.selecteds!.isEmpty) {
      if (picker!.selecteds == null) picker!.selecteds = [];
      for (int i = 0; i < maxLevel; i++) {
        int v = data![i].indexOf(data![i].initValue);
        if (v < 0) v = 0;
        picker!.selecteds!.add(v);
      }
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    if (cur!.postfix == null && cur!.suffix == null) {
      return makeText(null, cur!.getValueText(index), index == picker!.selecteds![_col]);
    } else {
      return makeTextEx(null, cur!.getValueText(index), cur!.postfix, cur!.suffix, index == picker!.selecteds![_col]);
    }
  }

  @override
  int getColumnFlex(int column) {
    return data![column].columnFlex!;
  }

  @override
  List<int> getSelectedValues() {
    List<int> items = [];
    if (picker!.selecteds != null) {
      for (int i = 0; i < picker!.selecteds!.length; i++) {
        int j = picker!.selecteds![i];
        int v = data![i].valueOf(j);
        items.add(v);
      }
    }
    return items;
  }
}

/// Picker DateTime Adapter Type
class PickerDateTimeType {
  static const int kMDY = 0; // m, d, y
  static const int kHM = 1; // hh, mm
  static const int kHMS = 2; // hh, mm, ss
  static const int kHMAp = 3; // hh, mm, ap(AM/PM)
  static const int kMDYHM = 4; // m, d, y, hh, mm
  static const int kMDYHMAp = 5; // m, d, y, hh, mm, AM/PM
  static const int kMDYHMS = 6; // m, d, y, hh, mm, ss

  static const int kYMD = 7; // y, m, d
  static const int kYMDHM = 8; // y, m, d, hh, mm
  static const int kYMDHMS = 9; // y, m, d, hh, mm, ss
  static const int kYMDApHm = 10; // y, m, d, ap, hh, mm

  static const int kYM = 11; // y, m
  static const int kDMY = 12; // d, m, y
  static const int kY = 13; // y
}

class DateTimePickerAdapter extends PickerAdapter<DateTime> {
  /// display type, ref: columnType
  final int? type;

  /// Whether to display the month in numerical form.If true, months is not used.
  final bool? isNumberMonth;

  /// custom months strings
  final List<String>? months;

  /// Custom AM, PM strings
  final List<String>? strAMPM;

  /// year begin...end.
  final int? yearBegin, yearEnd;

  /// hour min ... max, min >= 0, max <= 23, max > min
  final int? minHour, maxHour;

  /// minimum datetime
  final HijriCalendar? minValue, maxValue;

  /// jump minutes, user could select time in intervals of 30min, 5mins, etc....
  final int? minuteInterval;

  /// Year, month, day suffix
  final String? yearSuffix, monthSuffix, daySuffix;

  /// use two-digit year, 2019, displayed as 19
  final bool? twoDigitYear;

  /// year 0, month 1, day 2, hour 3, minute 4, sec 5, am/pm 6, hour-ap: 7
  final List<int>? customColumnType;

  static const List<String> monthsListEN = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  static const List<String> monthsListENL = [
    "month_1",
    "month_2",
    "month_3",
    "month_4",
    "month_5",
    "month_6",
    "month_7",
    "month_8",
    "month_9",
    "month_10",
    "month_11",
    "month_12",
  ];

  DateTimePickerAdapter({
    Picker? picker,
    this.type = 0,
    this.isNumberMonth = false,
    this.months = monthsListENL,
    this.strAMPM,
    this.yearBegin = 1320,
    this.yearEnd = 1491,
    this.value,
    this.minValue,
    this.maxValue,
    this.minHour,
    this.maxHour,
    this.yearSuffix,
    this.monthSuffix,
    this.daySuffix,
    this.minuteInterval,
    this.customColumnType,
    this.twoDigitYear = false,
  }) : assert(minuteInterval == null || (minuteInterval >= 1 && minuteInterval <= 30 && (60 % minuteInterval == 0))) {
    super.picker = picker;
    _yearBegin = yearBegin!;
    if (minValue != null && minValue!.hYear > _yearBegin) {
      _yearBegin = minValue!.hYear;
    }
    // Judge whether the day is in front of the month
    // If in the front, set "needUpdatePrev" = true
    List<int> resolvedColumnTypes;
    if (customColumnType != null) {
      resolvedColumnTypes = customColumnType!;
    } else {
      resolvedColumnTypes = columnType[type!];
    }
    var month = resolvedColumnTypes.indexWhere((element) => element == 1);
    var day = resolvedColumnTypes.indexWhere((element) => element == 2);
    _needUpdatePrev = day < month;
  }

  int _col = 0;
  int _colAP = -1;
  int _colHour = -1;
  int _colDay = -1;
  int _yearBegin = 0;
  bool _needUpdatePrev = false;

  /// Currently selected value
  HijriCalendar? value;

  // but it can improve the performance, so keep it.
  static const List<List<int>> lengths = [
    [12, 31, 0],
    [24, 60],
    [24, 60, 60],
    [12, 60, 2],
    [12, 31, 0, 24, 60],
    [12, 31, 0, 12, 60, 2],
    [12, 31, 0, 24, 60, 60],
    [0, 12, 31],
    [0, 12, 31, 24, 60],
    [0, 12, 31, 24, 60, 60],
    [0, 12, 31, 2, 12, 60],
    [0, 12],
    [31, 12, 0],
    [0],
  ];

  static const Map<int, int> columnTypeLength = {0: 0, 1: 12, 2: 31, 3: 24, 4: 60, 5: 60, 6: 2, 7: 12};

  /// year 0, month 1, day 2, hour 3, minute 4, sec 5, am/pm 6, hour-ap: 7
  static const List<List<int>> columnType = [
    [1, 2, 0],
    [3, 4],
    [3, 4, 5],
    [7, 4, 6],
    [1, 2, 0, 3, 4],
    [1, 2, 0, 7, 4, 6],
    [1, 2, 0, 3, 4, 5],
    [0, 1, 2],
    [0, 1, 2, 3, 4],
    [0, 1, 2, 3, 4, 5],
    [0, 1, 2, 6, 7, 4],
    [0, 1],
    [2, 1, 0],
    [0],
  ];

  // static const List<int> leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

  // 获取当前列的类型
  int getColumnType(int index) {
    if (customColumnType != null) return customColumnType![index];
    List<int> items = columnType[type!];
    if (index >= items.length) return -1;
    return items[index];
  }

  @override
  int getLength() {
    int? v = customColumnType == null ? lengths[type!][_col] : columnTypeLength[customColumnType![_col]];
    if (v == 0) {
      int ye = yearEnd!;
      if (maxValue != null) ye = maxValue!.hYear;
      return ye - _yearBegin + 1;
    }
    if (v == 31) return _calcDateCount(value!.hYear, value!.hMonth);
    int colType = getColumnType(_col);
    switch (colType) {
      case 3: // hour
        if ((minHour != null && minHour! >= 0) || (maxHour != null && maxHour! <= 23)) {
          return (maxHour ?? 23) - (minHour ?? 0) + 1;
        }
        break;
      case 4: // minute
        if (minuteInterval != null && minuteInterval! > 1) {
          return v! ~/ minuteInterval!;
        }
        break;
      case 7: // hour am/pm
        if ((minHour != null && minHour! >= 0) || (maxHour != null && maxHour! <= 23)) {
          if (_colAP < 0) {
            // I don't know am or PM
            return 12;
          }
        } else {
          var min = 0;
          var max = 0;
          if (picker!.selecteds![_colAP] == 0) {
            // am
            min = minHour == null
                ? 1
                : minHour! >= 12
                ? 12
                : minHour! + 1;
            max = maxHour == null
                ? 12
                : maxHour! >= 12
                ? 12
                : maxHour! + 1;
          } else {
            // pm
            min = minHour == null
                ? 1
                : minHour! >= 12
                ? 24 - minHour! - 12
                : 1;
            max = maxHour == null
                ? 12
                : maxHour! >= 12
                ? maxHour! - 12
                : 1;
          }
          return max > min ? max - min + 1 : min - max + 1;
        }
        break;
    }
    return v!;
  }

  @override
  int getMaxLevel() {
    return customColumnType == null ? lengths[type!].length : customColumnType!.length;
  }

  @override
  bool needUpdatePrev(int curIndex) {
    if (_needUpdatePrev) {
      var curType = getColumnType(curIndex);
      return curType == 1 || curType == 0;
    }
    return false;
  }

  @override
  void setColumn(int index) {
    _col = index + 1;
    if (_col < 0) _col = 0;
  }

  @override
  void initSelects() {
    value ??= HijriCalendar.now();
    _colAP = _getAPColIndex();
    int maxLevel = getMaxLevel();
    if (picker!.selecteds == null || picker!.selecteds!.isEmpty) {
      if (picker!.selecteds == null) picker!.selecteds = [];
      for (int i = 0; i < maxLevel; i++) {
        picker!.selecteds!.add(0);
      }
    }
  }

  @override
  Widget buildItem(BuildContext context, int index) {
    String text = "";
    int colType = getColumnType(_col);
    switch (colType) {
      case 0:
        if (twoDigitYear != null && twoDigitYear!) {
          text = "${_yearBegin + index}";
          var l = text.length;
          text = "${text.substring(l - (l - 2), l)}${_checkStr(yearSuffix)}";
        } else {
          text = "${_yearBegin + index}${_checkStr(yearSuffix)}";
        }
        break;
      case 1:
        if (isNumberMonth!) {
          text = "${index + 1}${_checkStr(monthSuffix!)}";
        } else {
          if (months != null) {
            text = months![index].tr();
          } else {
            List monthLabels = PickerLocalizations.of(context).months;
            text = "${monthLabels[index]}";
          }
        }
        break;
      case 2:
        text = "${index + 1}${_checkStr(daySuffix)}";
        break;
      case 3:
        text = intToStr(index + (minHour ?? 0));
        break;
      case 5:
        text = intToStr(index);
        break;
      case 4:
        if (minuteInterval == null || minuteInterval! < 2) {
          text = intToStr(index);
        } else {
          text = intToStr(index * minuteInterval!);
        }
        break;
      case 6:
        List ampmLabels = strAMPM ?? PickerLocalizations.of(context).ampm;
        text = "${ampmLabels[index]}";
        break;
      case 7:
        text = intToStr(index + (minHour == null ? 0 : (picker!.selecteds![_colAP] == 0 ? minHour : 0)!) + 1);
        break;
    }

    return makeText(null, text, picker!.selecteds![_col] == index);
  }

  @override
  String getText() {
    return value.toString();
  }

  @override
  int getColumnFlex(int column) {
    if (picker!.columnFlex != null && column < picker!.columnFlex!.length) {
      return picker!.columnFlex![column];
    }
    if (getColumnType(column) == 1) return 2;
    return 1;
  }

  @override
  void doShow() {
    if (_yearBegin == 0) getLength();
    var maxLevel = getMaxLevel();
    for (int i = 0; i < maxLevel; i++) {
      int colType = getColumnType(i);
      switch (colType) {
        case 0:
          picker!.selecteds![i] = yearEnd != null && value!.hYear > yearEnd!
              ? yearEnd! - _yearBegin
              : value!.hYear - _yearBegin;
          break;
        case 1:
          picker!.selecteds![i] = value!.hMonth - 1;
          break;
        case 2:
          picker!.selecteds![i] = value!.hDay - 1;
          break;
      }
    }
  }

  @override
  void doSelect(int column, int index) {
    int? year, month, day, h;
    year = value!.hYear;
    month = value!.hMonth;
    day = value!.hDay;
    // h = value.hour;

    int colType = getColumnType(column);
    switch (colType) {
      case 0:
        year = _yearBegin + index;
        break;
      case 1:
        month = index + 1;
        break;
      case 2:
        day = index + 1;
        break;
      case 3:
        h = index + (minHour ?? 0);
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        if (picker!.selecteds![_colAP] == 0) {
          if (h == 0) h = 12;
          if (h! > 12) h = h - 12;
        } else {
          if (h! < 12) h = h + 12;
          if (h == 12) h = 0;
        }
        if (minHour != null || maxHour != null) {
          if (minHour != null && _colHour >= 0) {
            if (h < minHour!) {
              picker!.selecteds![_colHour] = 0;
              picker!.updateColumn(_colHour);
              return;
            }
          }
          if (maxHour != null && h > maxHour!) h = maxHour;
        }
        break;
      case 7:
        h = index + (minHour == null ? 0 : (picker!.selecteds![_colAP] == 0 ? minHour : 0))! + 1;
        if (_colAP >= 0 && picker!.selecteds![_colAP] == 1) h = h + 12;
        if (h > 23) h = 0;
        break;
    }
    int daysInMonth = _calcDateCount(year, month);

    bool isChangeDay = false;
    if (day > daysInMonth) {
      day = daysInMonth;
      isChangeDay = true;
    }
    value = HijriCalendar()
      ..hYear = year
      ..hMonth = month
      ..hDay = day;

    if (minValue != null && (value!.isBefore(minValue!.hYear, minValue!.hMonth, minValue!.hDay))) {
      value = minValue;
      notifyDataChanged();
    } else if (maxValue != null && value!.isAfter(maxValue!.hYear, maxValue!.hMonth, maxValue!.hDay)) {
      value = maxValue;
      notifyDataChanged();
    } else if (isChangeDay && _colDay >= 0) {
      doShow();
      picker!.updateColumn(_colDay);
    }
  }

  int _getAPColIndex() {
    List<int> items = customColumnType ?? columnType[type!];
    _colHour = items.indexWhere((e) => e == 7);
    _colDay = items.indexWhere((e) => e == 2);
    for (int i = 0; i < items.length; i++) {
      if (items[i] == 6) return i;
    }
    return -1;
  }

  int _calcDateCount(int year, int month) {
    return getHijriDaysInMonth(year, month);
  }

  String intToStr(int v) {
    return (v < 10) ? "0$v" : "$v";
  }

  String _checkStr(String? v) {
    return v ?? "";
  }
}

int getHijriDaysInMonth(int year, int month) {
  // cause the umm Alquara calenar cannot get days in month between 1356 and 1500
  if (year < 1356 || year > 1500) return 30;

  return HijriCalendar().getDaysInMonth(year, month);
}

class _StateView extends StatefulWidget {
  final WidgetBuilder? builder;
  const _StateView({super.key, this.builder});

  @override
  State<StatefulWidget> createState() => _StateViewState();
}

class _StateViewState extends State<_StateView> {
  @override
  Widget build(BuildContext context) {
    return widget.builder!(context);
  }

  void update() {
    setState(() {});
  }
}
