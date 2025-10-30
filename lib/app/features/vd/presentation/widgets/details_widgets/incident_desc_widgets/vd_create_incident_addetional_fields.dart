import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/vd_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/picker/hijri_picker/hijri_picker.dart'
    as hijri_picker;
import 'package:hijri/hijri_calendar.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/presentation/picker/Picker.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    hide Picker, DateTimePickerAdapter;
import 'package:balady_plus/app/events_logs/balady_logs.dart';


class TextBoxAddetionalField extends StatefulWidget {
  final String fieldName;
  final int? fieldLength;
  final bool isMandatory;
  final bool isTextArea;
  final String currentVlaue;
  final Function(String?) onChanged;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatter;

  TextBoxAddetionalField(
      {Key? key,
      this.fieldLength,
      required this.fieldName,
      required this.isMandatory,
      required this.currentVlaue,
      required this.onChanged,
      this.isTextArea = false,
      this.keyboardType = TextInputType.text,
      this.inputFormatter})
      : super(key: key);

  @override
  State<TextBoxAddetionalField> createState() => _TextBoxAddetionalFieldState();
}

class _TextBoxAddetionalFieldState extends State<TextBoxAddetionalField> {
  final TextEditingController _controller = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller.text = widget.currentVlaue;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextFieldWidgetWithOptinal(
      label: widget.fieldName,
      hintText: ("write_hint").tr(),
      controller: _controller,
      maxLines: widget.isTextArea ? 4 : 1,
      maxLength: widget.fieldLength,
      readOnly: false,
      textInputAction: TextInputAction.next,
      keyboardType: widget.keyboardType,
      showOptional: !widget.isMandatory,
      onChanged: widget.onChanged,
      inputFormatter: widget.inputFormatter,
      validator: (String? text) {
        return null;
      },
    );
  }
}

class DropDownListAddetionalField extends StatefulWidget {
  final String fieldName;
  final bool isMandatory;
  final ValueItem? currentItem;
  final List<ValueItem> items;
  final Function(ValueItem?) onChanged;

  const DropDownListAddetionalField(
      {Key? key,
      this.currentItem,
      required this.isMandatory,
      required this.fieldName,
      required this.items,
      required this.onChanged})
      : super(key: key);

  @override
  State<DropDownListAddetionalField> createState() =>
      _DropDownListAddetionalFieldState();
}

class _DropDownListAddetionalFieldState
    extends State<DropDownListAddetionalField> {
  DropDownItem? currentItem;
  @override
  void initState() {
    super.initState();
    setCurrentItem();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTapWidgetForLongDialog(
      items: getDropDownItems(),
      value: currentItem,
      showOptional: !widget.isMandatory,
      showHintAsTitle: false,
      onChangeType: (DropDownItem? item) {
        currentItem = item;
        widget.onChanged(ValueItem(id: item?.id, addlFeildValue: item?.name));
        setState(() {});
      },
      label: widget.fieldName,
      hint: ("choose_hint").tr(),
      searchHint: ("searchFor").tr(),
    );
  }

  List<DropDownItem> getDropDownItems() {
    return widget.items
        .mapIndexed((index, e) => DropDownItem(
            id: index.toString(),
            name: e.addlFeildValue ?? "",
            code: "",
            value: e.addlFeildValue ?? ""))
        .toList();
  }

  void setCurrentItem() {
    if (widget.currentItem != null) {
      currentItem = widget.currentItem?.getDropDownItem();
    }
  }
}

class RadioButtonAddetionalField extends StatefulWidget {
  final String fieldName;
  final bool isMandatory;
  final ValueItem? currentItem;
  final List<ValueItem> items;
  final Function(ValueItem?) onChanged;

  const RadioButtonAddetionalField(
      {Key? key,
      this.currentItem,
      required this.isMandatory,
      required this.fieldName,
      required this.items,
      required this.onChanged})
      : super(key: key);

  @override
  State<RadioButtonAddetionalField> createState() =>
      _RadioButtonAddetionalFieldState();
}

class _RadioButtonAddetionalFieldState
    extends State<RadioButtonAddetionalField> {
  ValueItem? currentItem;
  @override
  void initState() {
    super.initState();
    setCurrentItem();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelTextWithOptional(
          label: widget.fieldName,
          labelColor: AppColor.baladyDarkGreen2,
          labelSize: 13,
          labelTextAlign: TextAlign.start,
          showOptional: !widget.isMandatory,
        ),
/*        Row(
          children: [
            CustomTextWidget(
              widget.fieldName,
              fontColor: AppColor.baladyDarkGreen2,
              fontSize: 13.0,
              textAlign: TextAlign.start,
              fontWeight: FONT_WEIGHT.bold,
            ),
            if (!widget.isMandatory) CustomHorizontalSpace(width: 8),
            if (!widget.isMandatory)
              CustomTextWidget(
                Helpers.translatingWord('optional'),
                fontColor: const Color(0xffbabbbb),
                fontSize: 13,
              ),
          ],
        ),*/
        CustomVerticalSpace(height: GeneralKey.smallPadding),
        // types
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.items.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              return CustomRadioButtonEnd<ValueItem>(
                title: widget.items[index].addlFeildValue ?? "",
                value: widget.items[index],
                currentSelected: currentItem,
                onChange: (ValueItem? item) {
                  currentItem = item;
                  widget.onChanged(item);
                  setState(() {});
                },
                endRadio: false,
                unSelectedBackgroundColor: Colors.transparent,
                textSize: 16,
              );
            }),

        const CustomVerticalSpace(height: 30.0),
      ],
    );
  }

  void setCurrentItem() {
    if (widget.currentItem != null) {
      currentItem = widget.currentItem;
    }
  }
}

class HijriCalendarAddetionalField extends StatefulWidget {
  final String fieldName;
  final int? fieldLength;
  final bool isMandatory;
  final String? currentVlaue;
  final Function(String?) onChanged;
  final HijriCalendar? minValue;

  HijriCalendarAddetionalField(
      {Key? key,
      this.fieldLength,
      required this.fieldName,
      required this.isMandatory,
      this.currentVlaue,
      required this.onChanged,
      this.minValue})
      : super(key: key);

  @override
  State<HijriCalendarAddetionalField> createState() =>
      _HijriCalendarAddetionalFieldState();
}

class _HijriCalendarAddetionalFieldState
    extends State<HijriCalendarAddetionalField> {
  String? currentValue;
  HijriCalendar? selectedDate = HijriCalendar.now();

  @override
  void initState() {
    super.initState();
    currentValue = widget.currentVlaue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeaderAndDescOnTapWidget(
          label: widget.fieldName,
          hintText: ("choose_hint").tr(),
          textValue: currentValue,
          showOptional: !widget.isMandatory,
          onTap: () async {
            showHijriDate(context, minValue: widget.minValue);
          },
        ),
      ],
    );
  }

  void showHijriDate(BuildContext context, {HijriCalendar? minValue}) {
    setSelectedDate();
    hijri_picker.Picker(
        isAr: CommonFunctions.isAppAR,
        confirmTextStyle: const TextStyle(
          fontFamily: GeneralKey.appFontType,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: AppColor.baladyDarkGreen2,
        ),
        headercolor: const Color(0xfffafaf8),
        cancel: Container(),
        height: 270,
        confirmText: ('done').tr(),
        title: Text(
          ('choose_date').tr(),
          style: const TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.w700,
            fontStyle: FontStyle.normal,
            fontSize: 15.0,
          ),
          textAlign: TextAlign.right,
        ),
        hideHeader: false,
        adapter: hijri_picker.DateTimePickerAdapter(
            minValue: minValue,
            customColumnType: CommonFunctions.isAppAR ? [2, 1, 0] : [0, 1, 2],
            value: selectedDate),
        selectedTextStyle: const TextStyle(color: AppColor.baladyDarkGreen2),
        onConfirm: (hijri_picker.Picker picker, List value) {
          var date =
              (picker.adapter as hijri_picker.DateTimePickerAdapter).value;
          setState(() {
            currentValue = date!.toFormat("yyyy/mm/dd");
          });
          widget.onChanged(currentValue);
        }).showModal(context);
  }

  setSelectedDate() {
    try {
      var hijriCalender = HijriCalendar();
      if (currentValue != null && currentValue!.isNotEmpty) {
        List<String> dates = currentValue!.split("/");
        if (dates.length == 3) {
          hijriCalender.hYear = int.parse(dates[0]);
          hijriCalender.hMonth = int.parse(dates[1]);
          hijriCalender.hDay = int.parse(dates[2]);
        }

        this.selectedDate = hijriCalender;
      }
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      this.selectedDate = HijriCalendar.now();
    }
  }
}

class GorgianCalendarAddetionalField extends StatefulWidget {
  final String fieldName;
  final int? fieldLength;
  final bool isMandatory;
  final String? currentVlaue;
  final Function(String?) onChanged;

  GorgianCalendarAddetionalField({
    Key? key,
    this.fieldLength,
    required this.fieldName,
    required this.isMandatory,
    this.currentVlaue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<GorgianCalendarAddetionalField> createState() =>
      _GorgianCalendarAddetionalFieldState();
}

class _GorgianCalendarAddetionalFieldState
    extends State<GorgianCalendarAddetionalField> {
  String? currentValue;
  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    currentValue = widget.currentVlaue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomHeaderAndDescOnTapWidget(
          label: widget.fieldName,
          hintText: ("choose_hint").tr(),
          showOptional: !widget.isMandatory,
          textValue: currentValue,
          onTap: () async {
            showPickerDate();
          },
        ),
      ],
    );
  }

  showPickerDate() {
    setSelectedDate();
    Picker(
        confirmTextStyle: const TextStyle(
          fontFamily: GeneralKey.appFontType,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: AppColor.baladyDarkGreen2,
        ),
        //MM headerColor: const Color(0xfffafaf8),
        height: 270,
        confirmText: ('done').tr(),
        hideHeader: false,
        adapter: DateTimePickerAdapter(
            months: DateTimePickerAdapter.MonthsList_EN_L.map(
                (e) => (e).toString().tr()).toList(),
            customColumnType: CommonFunctions.isAppAR ? [2, 1, 0] : [0, 1, 2],
            value: selectedDate),
        selectedTextStyle: const TextStyle(color: AppColor.baladyDarkGreen2),
        onCancel: () {},
        cancelText: ('choose_date').tr(),
        cancelTextStyle: const TextStyle(
          color: AppColor.black,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15.0,
        ),
        onConfirm: (Picker picker, List value) {
          var date = (picker.adapter as DateTimePickerAdapter).value;
          final DateFormat formatter = DateFormat('yyyy/MM/dd');
          if (date != null) currentValue = formatter.format(date);

          setState(() {});
          widget.onChanged(currentValue);
        }).showModal(context);
  }

  setSelectedDate() {
    try {
      if (currentValue != null) {
        DateTime? selectedDate = DateFormat('yyyy/MM/dd').parse(currentValue!);
        this.selectedDate = selectedDate;
      } else
        this.selectedDate = DateTime.now();
    } catch (error, stackTrace) {
      LogsViewModel().sendEventFromModel(
        event: ErrorExceptionModel(
          nameEvent: EventsName.handledException,
          message: error.toString(),
          stackTrace: stackTrace.toString(),
        ),
      );
      this.selectedDate = DateTime.now();
    }
  }
}

class MultiSelectionAddetionalField extends StatefulWidget {
  final String fieldName;
  final bool isMandatory;
  final List<ValueItem>? currentItems;
  final List<ValueItem> items;
  final Function(List<ValueItem>?) onChanged;

  const MultiSelectionAddetionalField(
      {Key? key,
      this.currentItems,
      required this.isMandatory,
      required this.fieldName,
      required this.items,
      required this.onChanged})
      : super(key: key);

  @override
  State<MultiSelectionAddetionalField> createState() =>
      _MultiSelectionAddetionalFieldState();
}

class _MultiSelectionAddetionalFieldState
    extends State<MultiSelectionAddetionalField> {
  List<DropDownItem>? currentItems;
  @override
  void initState() {
    super.initState();
    setCurrentItem();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTapWidgetForMultiLongDialog(
      items: getDropDownItems(),
      values: currentItems,
      showOptional: !widget.isMandatory,
      showHintAsTitle: false,
      onChangeType: (List<DropDownItem>? items) {
        currentItems = items;
        List<ValueItem>? valueItem = currentItems
                ?.map((e) => ValueItem(id: e.id, addlFeildValue: e.name))
                .toList() ??
            null;
        widget.onChanged(valueItem);
        setState(() {});
      },
      label: widget.fieldName,
      hint: ("choose_hint").tr(),
      searchHint: ("searchFor").tr(),
    );
  }

  List<DropDownItem> getDropDownItems() {
    return widget.items
        .mapIndexed((index, e) => DropDownItem(
            id: index.toString(),
            name: e.addlFeildValue ?? "",
            code: "",
            value: e.addlFeildValue ?? ""))
        .toList();
  }

  void setCurrentItem() {
    if (widget.currentItems != null) {
      currentItems?.clear();
      widget.currentItems?.forEach((element) {
        if (element.getDropDownItem() != null)
          currentItems?.add(element.getDropDownItem()!);
      });
    }
  }
}
