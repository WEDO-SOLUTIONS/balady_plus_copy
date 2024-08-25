import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:balady_plus/app/core/utils/constants/ux_cam_events.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import '../blocs/permit_24_bloc.dart';

class Permits24DetailsPage extends StatefulWidget {
  const Permits24DetailsPage({super.key});

  @override
  State<Permits24DetailsPage> createState() => _Permits24DetailsPageState();
}

class _Permits24DetailsPageState extends State<Permits24DetailsPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Permit_24_Open_Create_Details_Event);
    CommonFunctions.sendUXCamEvent(
        UXCamEvents.Permit_24_Open_Review_Step_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value:
            ModalRoute.of(context)!.settings.arguments as Permit24LicenseBloc,
        child: BlocConsumer<Permit24LicenseBloc, Permit24LicenseState>(
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
                    .read<Permit24LicenseBloc>()
                    .add(const GoToPreviousPageEvent());
                return Future<bool>.value(false);
              },
              child: GestureDetector(
                onTap: () => context.read<Permit24LicenseBloc>().hideKeyboard(),
                child: Scaffold(
                  appBar: DetailsAppBarTwo(
                    pageLength: state.pagesList.length,
                    currentStep: state.currentPageValue + 1,
                    backOnPress: () => context
                        .read<Permit24LicenseBloc>()
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
                    controller: context.read<Permit24LicenseBloc>().controller,
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
