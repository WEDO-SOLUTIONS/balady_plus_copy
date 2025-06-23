import 'package:balady_plus/app/features/new_appointment/presentation/blocs/new_appointment_bloc/new_appointment_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../core/services/view_models/new_appointment_first_step_view_model.dart';
import '../../widgets/book_new_appointment_details_widgets/new_appointment_body_widget.dart';
import '../../widgets/previous_next_buttons.dart';

class NewAppointmentFirstStepScreen extends StatefulWidget {
  bool fromHomePage;

  NewAppointmentFirstStepScreen({Key? key, this.fromHomePage = false})
      : super(key: key);

  @override
  _BaladyIncidentDetailsScreenState createState() =>
      _BaladyIncidentDetailsScreenState();
}

class _BaladyIncidentDetailsScreenState
    extends State<NewAppointmentFirstStepScreen> {
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //MM   Helpers.sendEventToAnalytics(AppEvents.Appointments_Apply_Details);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewAppointmentBloc, NewAppointmentState>(
      builder: (context, state) {
        return ChangeNotifierProvider<NewAppointmentFirstStepViewModel>(
            create: (context) => NewAppointmentFirstStepViewModel(
                isDraft: state.editedItemInfo != null,
                withPreviousTransaction:
                    state.withPreviousTransaction ?? false),
            builder: (context, child) {
              NewAppointmentFirstStepViewModel model =
                  Provider.of<NewAppointmentFirstStepViewModel>(context,
                      listen: true);
              model.fromHomePage = widget.fromHomePage;
              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Scaffold(
                  body: Column(
                    children: [
                      // appointment body
                      const Expanded(child: NewAppointmentBody()),
                      // submit button
                      PreviousNextButtons(
                        isFormValid: model.isFormValid,
                        onConfirm: () {},
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
}
