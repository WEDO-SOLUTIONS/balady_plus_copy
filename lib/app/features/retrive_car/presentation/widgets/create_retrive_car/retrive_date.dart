import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/events_logs/balady_logs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_picker_plus/flutter_picker_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../blocs/create_retrive_bloc/create_retrive_bloc.dart';

class RetriveDate extends StatefulWidget {
  RetriveDate({
    Key? key,
  }) : super(key: key);

  @override
  State<RetriveDate> createState() => _RetriveDateState();
}

class _RetriveDateState extends State<RetriveDate> {
  DateTime? selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateRetriveCarBloc, CreateRetriveCarState>(
      builder: (context, state) {
        return Column(
          children: [
            CustomHeaderAndDescOnTapWidget(
              label: ("dc_exepect_data").tr(),
              hintText: ("choose_hint").tr(),
              showOptional: false,
              textValue: state.date,
              onTap: () async {
                showPickerDate(state.date);
              },
            ),
          ],
        );
      },
    );
  }

  showPickerDate(String? currentDate) {
    setSelectedDate(currentDate);
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
        confirmText: ('done').tr(),
        hideHeader: false,
        adapter: DateTimePickerAdapter(
            months: DateTimePickerAdapter.monthsListENL
                .map((e) => (e).tr())
                .toList(),
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
          if (date != null) {
            String currentValue = formatter.format(date);

            context
                .read<CreateRetriveCarBloc>()
                .add(ChangeDateEvent(date: currentValue));
            setState(() {});
          }
        }).showModal(context);
  }

  setSelectedDate(String? currentDate) {
    try {
      if (currentDate != null) {
        DateTime? selectedDate = DateFormat('yyyy/MM/dd').parse(currentDate!);
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
