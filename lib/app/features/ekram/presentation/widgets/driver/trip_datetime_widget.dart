import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';

class TripDateTimeWidget extends StatelessWidget {
  final String? date;
  final String? time;
  final String title;
  final bool? isEditable;
  final Function(String?)? onDateCallback;
  final Function(String?)? onTimeCallback;
  final bool? showDate;

  TripDateTimeWidget({Key? key,required this.title,  this.date, required this.time,this.isEditable,this.onDateCallback,this.onTimeCallback,this.showDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextWidget(
          title,
          fontColor: AppColor.blackModern700Light,
          fontSize: 16,
          fontWeight: AppFontWeight.bold,
        ),
        const CustomVerticalSpace(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           showDate==false?
             Container() :
           Expanded(
              child: InkWell(
                onTap: () {
                  if(isEditable == true) {
                    showPickerDate(date,context);
                  }
                },
                child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration:isEditable == true?  BoxDecoration(
                        color: Colors.transparent,
                        border:
                        Border.all(color: AppColor.blackModern300Light, width: 2),
                        borderRadius: BorderRadius.circular(6)):BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                    child: CustomTextWidget(
                      date ?? "select_date".tr(),
                      fontColor: isEditable == true ? AppColor.blackModern700Light:AppColor.grey1000.withOpacity(0.5),
                      fontSize: 14,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      fontWeight: AppFontWeight.semiBold,
                    )),
              ),
            ),
            CustomHorizontalSpace(width: 15),
            Expanded(
              child: InkWell(
                onTap: () {
                  if(isEditable == true) {
                    showPickerTime(time,context);
                  }
                },
                child: Container(
                    padding: const EdgeInsets.all(16),
                    width: double.infinity,
                    decoration:isEditable == true?  BoxDecoration(
                        color: Colors.transparent,
                        border:
                        Border.all(color: AppColor.blackModern300Light, width: 2),
                        borderRadius: BorderRadius.circular(6)):BoxDecoration(color: AppColor.blackModern300Light.withOpacity(0.4), borderRadius: BorderRadius.circular(8)),
                    child: CustomTextWidget(
                      time ?? "choose_time".tr(),
                      fontColor: isEditable == true ? AppColor.blackModern700Light:AppColor.grey1000.withOpacity(0.5),
                      fontSize: 14,
                      maxLines: 1,
                      textAlign: TextAlign.center,
                      fontWeight: AppFontWeight.semiBold,
                    )),
              ),
            ),

          ],
        ),
      ],
    );
  }


  showPickerDate(String? currentDate, BuildContext context) {
    Picker(
        confirmTextStyle: const TextStyle(
          fontFamily: Constants.appFontType,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: AppColor.baladyDarkGreen2,
        ),
        headerColor: const Color(0xfffafaf8),
        height: 270,
        confirmText: 'done'.tr(),
        hideHeader: false,
        adapter: DateTimePickerAdapter(

            minValue: DateTime.now(),
            maxValue: DateTime.now().add(Duration(days: 365)),
            months: DateTimePickerAdapter.monthsListENL
                .map((e) => Helpers.translatingWord(e))
                .toList(),
            customColumnType: Helpers.getCurrentLanguageCode() == "ar"
                ? [2, 1, 0]
                : [0, 1, 2],
            value: selectedDate(currentDate)),
        selectedTextStyle: const TextStyle(color: AppColor.baladyDarkGreen2),
        onCancel: () {
          //print("Cancell");
        },
        cancelText: Helpers.translatingWord('choose_date'),
        cancelTextStyle: const TextStyle(
          color: AppColor.black,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15.0,
        ),
        onConfirm: (Picker picker, List value) {
          //print((picker.adapter as GorgianPicker.DateTimePickerAdapter).value);
          var date = (picker.adapter as DateTimePickerAdapter).value;

          final DateFormat formatter = DateFormat('yyyy/MM/dd');
          if (date != null) currentDate = formatter.format(date);
          if(onDateCallback!= null) {
            onDateCallback!(currentDate);
          }
        }).showModal(context);
  }
  showPickerTime(String? currentDate, BuildContext context) {


   Picker(
        confirmTextStyle: const TextStyle(
          fontFamily: Constants.appFontType,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          color: AppColor.baladyDarkGreen2,
        ),
        headerColor: const Color(0xfffafaf8),
        height: 270,
        confirmText: 'done'.tr(),
        hideHeader: false,

        adapter: DateTimePickerAdapter(

            customColumnType:  [3, 4 ]

        ),
        selectedTextStyle: const TextStyle(color: AppColor.baladyDarkGreen2),
        onCancel: () {
          //print("Cancell");
        },
        cancelText: Helpers.translatingWord('choose_time_desc'),
        cancelTextStyle: const TextStyle(
          color: AppColor.black,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.normal,
          fontSize: 15.0,
        ),
        onConfirm: (Picker picker, List value) {
          //print((picker.adapter as GorgianPicker.DateTimePickerAdapter).value);
          var date = (picker.adapter as DateTimePickerAdapter).value;

          final DateFormat formatter = DateFormat('HH:mm');
          if (date != null && onTimeCallback!= null)
            currentDate = formatter.format(date);
            onTimeCallback!(currentDate);


        }).showModal(context);
  }






  DateTime selectedDate(String? currentDate) {
    if (currentDate != null) {
      DateTime? selectedDate = DateFormat('yyyy/MM/dd').parse(currentDate!);
      return selectedDate;
    }
    return DateTime.now();
  }


}

class TripDetailsCreatedDateWidget extends StatelessWidget {
  final String date;

  const TripDetailsCreatedDateWidget({Key? key, required this.date})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomTextWidget(
          Helpers.translatingWord('ekram_created_at'),
          maxLines: 1,
          fontSize: 13,
          fontColor: AppColor.black400,
          textAlign: TextAlign.start,
          fontWeight: AppFontWeight.medium,
          textOverflow: TextOverflow.ellipsis,
        ),
        CustomHorizontalSpace(width: 8),
        CustomTextWidget(
          date,
          maxLines: 1,
          fontSize: 11,
          fontColor: AppColor.black400,
          textAlign: TextAlign.start,
          textOverflow: TextOverflow.ellipsis,
          fontFamily: Constants.lucidaGrandFontType,
        ),
      ],
    );
  }


}
