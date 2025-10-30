import 'dart:io';
import 'dart:typed_data';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_bloc.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/previous_next_buttons.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';
import 'package:balady_plus/app/features/profile_features/dashboard/presentation/widgets/no_data_widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';

import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../home_page/presentation/widgets/home_tag.dart';
import '../../../../objectable_transactions/presentation/widgets/objection_feedback_details_dialog.dart';
import '../../../../transaction_inquiry/customer_voice_exports.dart';
import '../../../domain/entities/comliance_request_details.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SeventhSubmitComplianceSubmitStep extends StatefulWidget {
  const SeventhSubmitComplianceSubmitStep({super.key});

  @override
  State<SeventhSubmitComplianceSubmitStep> createState() =>
      _SeventhSubmitComplianceSubmitStepState();
}

class _SeventhSubmitComplianceSubmitStepState
    extends State<SeventhSubmitComplianceSubmitStep> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<ComplianceBloc>().add(const GetAppointments());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 32,
                ),
                if (state.appointmentsStatus == BlocStatus.failure &&
                    state.responseCode != "CIS-401")
                  ReloadWidget(onTab: () {
                    context.read<ComplianceBloc>().add(const GetAppointments());
                  }),
                if (state.appointmentsStatus == BlocStatus.failure &&
                    state.responseCode == "CIS-401")
                  Center(
                    child: NoDataWidget(
                      // state.errorMessage ?? "",
                      // textAlign: TextAlign.center,
                    ),
                  ),
                SizedBox(
                    height: 120,
                    child: ListView.builder(
                      itemCount:
                          state.complainceAppointmentResponse?.result.length ??
                              0,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (ctx, index) {
                        return Row(
                          children: [
                            if (index == 0)
                              const CustomHorizontalSpace(width: 16),
                            DateBoxWidget(
                              currentDate: state.visitDate?.slotDate ?? "",
                              date: state.complainceAppointmentResponse
                                      ?.result[index].slotDate ??
                                  "",
                              dayName: state.complainceAppointmentResponse
                                      ?.result[index].day ??
                                  "",
                              onSelect: () {
                                context.read<ComplianceBloc>().add(
                                    ChangeSelectedAppointmentDay(
                                        item: state
                                            .complainceAppointmentResponse!
                                            .result[index]!));
                              },
                            ),
                          ],
                        );
                      },
                    )),
                const Divider(
                  height: 1,
                  color: AppColor.kGray115,
                ),
                const SizedBox(
                  height: 16,
                ),
                if (state.visitDate != null)
                  GridView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: Constants.semiMediumPadding,
                    ),
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                      mainAxisExtent: 60,
                    ),
                    itemCount: state.visitDate?.slots.length,
                    itemBuilder: (context, index) => TimeBoxWidget(
                      visitFrom: state.visitDate?.slots[index].startTime ?? "",
                      visitTo: state.visitDate?.slots[index].endTime ?? "",
                      selectedVisitTime:
                          "${state.visitTimeFrom} - ${state.visitTimeTo}",
                      onSelect: () {
                        context.read<ComplianceBloc>().add(
                            ChangeSelectedAppointmentSlot(
                                visitFrom:
                                    state.visitDate?.slots[index].startTime,
                                visitTo:
                                    state.visitDate?.slots[index].endTime));
                      },
                    ),
                  ),
                const SizedBox(
                  height: 32,
                ),
                const PreviousNextButtons()
              ],
            ),
          ),
        );
      },
    );
  }
}

class DateBoxWidget extends StatefulWidget {
  String date;
  String currentDate;
  String dayName;
  Function onSelect;

  DateBoxWidget(
      {Key? key,
      required this.date,
      required this.currentDate,
      required this.dayName,
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
                widget.dayName.toLowerCase().tr(),
                fontWeight: AppFontWeight.medium,
                fontColor: widget.currentDate == widget.date
                    ? AppColor.primary900Light
                    : AppColor.blackModern500Light,
              ),
              const CustomVerticalSpace(height: 18),
              CustomTextWidget(
                CommonFunctions.getDateNoDash(widget.date),
                fontColor: widget.currentDate == widget.date
                    ? AppColor.primary900Light
                    : AppColor.blackModern500Light,
                fontSize: 13,
                fontFamily: Constants.lucidaGrandFontType,
              ),
            ],
          )),
    );
  }
}

class TimeBoxWidget extends StatefulWidget {
  String visitFrom;
  String visitTo;
  String? selectedVisitTime;
  Function onSelect;

  TimeBoxWidget(
      {Key? key,
      required this.visitFrom,
      required this.visitTo,
      this.selectedVisitTime,
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
          padding: const EdgeInsets.all(0),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            color: "${widget.visitFrom} - ${widget.visitTo}" ==
                    widget.selectedVisitTime
                ? Color(0xFFCDE0E0)
                : Colors.white,
          ),
          alignment: Alignment.center,
          child: CustomTextWidget(
            "${widget.visitFrom} - ${widget.visitTo}",
            fontColor: AppColor.black,
            fontFamily: Constants.lucidaGrandFontType,
            maxLines: 1,
          )),
    );
  }
}
