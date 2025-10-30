import 'package:balady_plus/app/core/base/base_view_model.dart';
import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/app/features/new_appointment/presentation/blocs/new_appointment_bloc/new_appointment_bloc.dart';
import 'package:balady_plus/app/features/new_appointment/presentation/core/services/view_models/new_appointment_view_model.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../core/models/appointment_details_model.dart';
import '../../widgets/details_app_bar.dart';

class NewAppointmentPage extends StatefulWidget {
  const NewAppointmentPage({super.key});

  @override
  State<NewAppointmentPage> createState() => _NewAppointmentPageState();
}

class _NewAppointmentPageState extends State<NewAppointmentPage> {
  bool isSuccess = false;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    CommonFunctions.sendEventToAnalytics(AppEvents.makeAppointment);
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceAppointmentBooking);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Appointment_Booking_Open_Create_Details_Event);

    loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    var argument = ModalRoute.of(context)!.settings.arguments;
    AppointmentItemInfo? editedItem =
        argument is AppointmentItemInfo? ? argument : null;
    return BlocProvider<NewAppointmentBloc>(
      create: (context) => NewAppointmentBloc(
        withPreviousTransaction: false,
        editedItem: editedItem,
      ),
      child: BlocConsumer<NewAppointmentBloc, NewAppointmentState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context.read<NewAppointmentBloc>().add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<NewAppointmentBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: DetailsAppBar(
                  currentStep: state.currentPageValue + 1,
                  backOnPress: () => context.read<NewAppointmentBloc>().add(
                        GoToPreviousPageEvent(),
                      ),
                ),
                body: isSuccess
                    ? isSuccess
                        ? Stack(
                            children: [
                              PageView.builder(
                                itemCount: context
                                    .read<NewAppointmentBloc>()
                                    .pagesList
                                    .length,
                                scrollDirection: Axis.vertical,
                                physics: const NeverScrollableScrollPhysics(),
                                controller: context
                                    .read<NewAppointmentBloc>()
                                    .controller,
                                itemBuilder: (context, position) {
                                  return AnimatedContainer(
                                    curve: Curves.easeIn,
                                    duration: const Duration(milliseconds: 300),
                                    child: context
                                        .read<NewAppointmentBloc>()
                                        .pagesList[position],
                                  );
                                },
                              ),
                              if (state.status == BlocStatus.loading &&
                                  state.currentPageValue != 1)
                                const CustomCircularLoadingWidget(),
                            ],
                          )
                        : ReloadWidget(
                            onTab: loadInitialData,
                          )
                    : const CustomCircularLoadingWidget(),
              ),
            ),
          );
        },
      ),
    );
  }

  void loadInitialData() async {
    setState(() {
      isLoading = true;
    });
    bool isSuccessTwo =
        await locator<NewAppointmentViewModel>().loadInitialData();
    setState(() {
      isSuccess = isSuccessTwo;
      isLoading = false;
    });
  }
}
