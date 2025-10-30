import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/blocs/new_appointment_bloc/new_appointment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../core/services/view_models/new_appointment_second_step_view_model.dart';
import '../../core/services/view_models/new_appointment_view_model.dart';
import '../../widgets/book_new_appointment_date_time_widgets/book_new_appointment_date_time_widget.dart';
import '../../widgets/previous_next_buttons.dart';

class BookNewAppointmentDateTimeScreen extends StatelessWidget {
  const BookNewAppointmentDateTimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewAppointmentBloc, NewAppointmentState>(
      builder: (context, state) {
        return ChangeNotifierProvider<NewAppointmentSecondStepViewModel>(
            create: (context) => NewAppointmentSecondStepViewModel(),
            builder: (context, child) {
              NewAppointmentSecondStepViewModel model =
                  Provider.of<NewAppointmentSecondStepViewModel>(context);
              return Column(
                children: [
                  Expanded(child: BookNewAppointmentDateTimeWidget()),
                  PreviousNextButtons(
                    isFormValid: model.selectedDate != null &&
                        model.selectedTime != null,
                    onConfirm: () {
                      final dataModel = locator<NewAppointmentViewModel>();
                      if (dataModel.editedItem != null) {
                        model.updateAppointment();
                      } else {
                        model.saveAppointment();
                      }
                    },
                  )
                ],
              );
            });
      },
    );
  }
}
