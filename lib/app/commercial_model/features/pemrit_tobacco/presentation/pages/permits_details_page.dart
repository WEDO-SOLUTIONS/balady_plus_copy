import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import '../blocs/permit_tobacco_bloc.dart';

class PermitsTobaccoDetailsPage extends StatefulWidget {
  const PermitsTobaccoDetailsPage({super.key});

  @override
  State<PermitsTobaccoDetailsPage> createState() =>
      _PermitsTobaccoDetailsPageState();
}

class _PermitsTobaccoDetailsPageState extends State<PermitsTobaccoDetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceTobaccoPermit);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Permit_Tobaco_Open_Create_Details_Event);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Permit_Tobaco_Open_Hotel_Step_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: ModalRoute.of(context)!.settings.arguments
            as PermitTobaccoLicenseBloc,
        child:
            BlocConsumer<PermitTobaccoLicenseBloc, PermitTobaccoLicenseState>(
          listener: (context, state) {
            if (state.status.isSubmissionFailure ||
                state.detailsStatus.isSubmissionFailure) {
              CommonFunctions.showError(state.error ?? "");
            }
          },
          builder: (context, state) {
            return WillPopScope(
              onWillPop: () {
                context
                    .read<PermitTobaccoLicenseBloc>()
                    .add(const GoToPreviousPageEvent());
                return Future<bool>.value(false);
              },
              child: GestureDetector(
                onTap: () =>
                    context.read<PermitTobaccoLicenseBloc>().hideKeyboard(),
                child: Scaffold(
                  appBar: DetailsAppBarTwo(
                    pageLength: state.pagesList.length,
                    currentStep: state.currentPageValue + 1,
                    backOnPress: () => context
                        .read<PermitTobaccoLicenseBloc>()
                        .add(const GoToPreviousPageEvent()),
                    onTapCloseAction: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                      bool Function(Route<dynamic>) predicate =
                          ModalRoute.withName(CommercialRouteName.bottomNavigation);
                      Navigator.of(context).popUntil((predicate));
                    },
                    requestNum: state.requestId,
                  ),
                  body: PageView.builder(
                    itemCount: state.pagesList.length,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    controller:
                        context.read<PermitTobaccoLicenseBloc>().controller,
                    itemBuilder: (context, position) {
                      return AnimatedContainer(
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 300),
                        child: state.pagesList[position],
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ));
  }
}
