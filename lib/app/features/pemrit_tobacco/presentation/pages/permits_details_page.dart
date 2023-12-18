import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants/route_names.dart';
import '../../../vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import '../blocs/permit_tobacco_bloc.dart';

class PermitsTobaccoDetailsPage extends StatefulWidget {
  const PermitsTobaccoDetailsPage({super.key});

  @override
  State<PermitsTobaccoDetailsPage> createState() =>
      _PermitsTobaccoDetailsPageState();
}

class _PermitsTobaccoDetailsPageState extends State<PermitsTobaccoDetailsPage> {
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
                          ModalRoute.withName(RouteName.bottomNavigation);
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
