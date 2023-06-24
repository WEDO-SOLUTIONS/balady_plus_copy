import 'package:balady_plus/app/features/new_appointment/presentation/blocs/new_appointment_bloc/new_appointment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/book_new_appointment_date_time_widgets/book_new_appointment_date_time_widget.dart';
import '../../widgets/previous_next_buttons.dart';

class BookNewAppointmentDateTimeScreen extends StatelessWidget {
  const BookNewAppointmentDateTimeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewAppointmentBloc, NewAppointmentState>(
      builder: (context, state) {
        return Column(
          children: [
            Expanded(child: BookNewAppointmentDateTimeWidget()),
            PreviousNextButtons()
          ],
        );
      },
    );
  }
}
