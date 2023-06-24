import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../core/models/available_times_response.dart';
import '../../core/services/view_models/new_appointment_second_step_view_model.dart';
import '../../widgets/previous_next_buttons.dart';
import 'package:provider/provider.dart';

class BookNewAppointmentDateTimeWidget extends StatefulWidget {
  @override
  State<BookNewAppointmentDateTimeWidget> createState() =>
      _BookNewAppointmentDateTimeWidgetState();
}

class _BookNewAppointmentDateTimeWidgetState
    extends State<BookNewAppointmentDateTimeWidget> {
  @override
  void initState() {
    super.initState();

//MM    Helpers.sendEventToAnalytics(AppEvents.Appointments_Apply_Times);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    NewAppointmentSecondStepViewModel model =
        Provider.of<NewAppointmentSecondStepViewModel>(context, listen: false);
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.only(bottom: 90),
        child: Column(
          children: [
            /*Padding(
                    padding: const EdgeInsetsDirectional.only(start: 24),
                    child: CustomSectionHeaderWithImg(
                      title: Helpers.translatingWord('date_picker_header'),
                      img: "titleItemsIconAppointment@3x.png",
                    ),
                  ),*/
            SizedBox(
                height: 120,
                child: ListView.builder(
                  itemCount: model.getDatesTable.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (ctx, index) {
                    return Row(
                      children: [
                        if (index == 0) const CustomHorizontalSpace(width: 16),
                        DateBoxWidget(
                          currentDate: model.selectedDate?.date ?? "",
                          date: model.getDatesTable[index].date ?? "",
                          onSelect: () {
                            model.selectedTime = null;
                            // model.setAvailableTimesResponse = null;
                            model.selectedDate = model.getDatesTable[index];
                            // model.getAvailableTimes(model.serviceId!,
                            //     model.getDatesTable[index].date!);

                            setState(() {});
                            if (model.selectedDate?.times?.isEmpty ?? false) {
                              CommonFunctions.showError(
                                  ("bookNewAppointmentNoTimesButtonWord").tr());
                            }
                          },
                        ),
                      ],
                    );
                  },
                )),
            if (model.selectedDate != null)
              const CustomVerticalSpace(height: 20),
            //MM
            // if (model.selectedDate != null)
            /*   Padding(
                      padding: const EdgeInsetsDirectional.only(start: 24),
                      child: CustomSectionHeaderWithImg(
                        title: Helpers.translatingWord('choose_time'),
                        img: "titleItemsIconAppointment@3x.png",
                        desc: Helpers.translatingWord('choose_time_desc'),
                      ),
                    ),*/

            if (model.selectedDate != null)
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: Constants.semiMediumPadding,
                ),
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  mainAxisExtent: 60,
                ),
                itemCount: model.selectedDate?.times?.length,
                itemBuilder: (context, index) => TimeBoxWidget(
                  time: model.selectedDate?.times?[index] ?? TimeItem(),
                  currentTimeKey: model.selectedTime?.timeKey ?? "",
                  onSelect: () {
                    setState(() {
                      model.selectedTime = model.selectedDate?.times?[index];
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
    ;
  }
}

class DateBoxWidget extends StatefulWidget {
  String date;
  String currentDate;
  Function onSelect;

  DateBoxWidget(
      {Key? key,
      required this.date,
      required this.currentDate,
      required this.onSelect})
      : super(key: key);

  @override
  State<DateBoxWidget> createState() => _DateBoxWidgetState();
}

class _DateBoxWidgetState extends State<DateBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect();
      },
      child: Container(
          width: 90,
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: widget.currentDate == widget.date
                ? Color(0xFFCDE0E0)
                : AppColor.white,
          ),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomTextWidget(
                CommonFunctions.getDayName(widget.date),
                fontWeight: AppFontWeight.medium,
                fontColor: widget.currentDate == widget.date
                    ? AppColor.primary900Light
                    : AppColor.blackModern500Light,
              ),
              const CustomVerticalSpace(height: 18),
              CustomTextWidget(
                CommonFunctions.getDate(widget.date),
                fontColor: widget.currentDate == widget.date
                    ? AppColor.primary900Light
                    : AppColor.blackModern500Light,
                fontSize: 13,
                fontFamily: Constants.lucidaGrandFontType,
              ),
              const CustomVerticalSpace(height: 12),
              CustomTextWidget(
                CommonFunctions.getMonthName(widget.date),
                fontColor: widget.currentDate == widget.date
                    ? AppColor.primary900Light
                    : AppColor.blackModern500Light,
                fontSize: 13,
                fontWeight: AppFontWeight.medium,
              ),
            ],
          )),
    );
  }
}

class TimeBoxWidget extends StatefulWidget {
  TimeItem time;
  String currentTimeKey;

  Function onSelect;

  TimeBoxWidget(
      {Key? key,
      required this.time,
      required this.currentTimeKey,
      required this.onSelect})
      : super(key: key);

  @override
  State<TimeBoxWidget> createState() => _TimeBoxWidget();
}

class _TimeBoxWidget extends State<TimeBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelect();
      },
      child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: widget.time.timeKey == widget.currentTimeKey
                ? Color(0xFFCDE0E0)
                : Colors.white,
          ),
          alignment: Alignment.center,
          child: CustomTextWidget(
            widget.time.timeValue ?? "",
            fontColor: AppColor.black,
            fontFamily: Constants.lucidaGrandFontType,
            maxLines: 1,
          )),
    );
  }
}
