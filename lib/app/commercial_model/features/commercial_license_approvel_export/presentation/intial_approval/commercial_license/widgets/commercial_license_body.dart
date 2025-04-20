import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/commercial_license_initial_Approval_bloc.dart';

class InitialApprovalLicenseBody extends StatefulWidget {
  final int? requestId;

  const InitialApprovalLicenseBody({super.key, this.requestId});

  @override
  State<InitialApprovalLicenseBody> createState() => _InitialApprovalLicenseBodyState();
}

class _InitialApprovalLicenseBodyState extends State<InitialApprovalLicenseBody> {
  @override
  void initState() {
    super.initState();
    context.read<CommercialLicenseInitialAprrovalBloc>().initState(
          requestId: widget.requestId,
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommercialLicenseInitialAprrovalBloc, CommercialLicenseInitialApprovalState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            context
                .read<CommercialLicenseInitialAprrovalBloc>()
                .add(const PreviousPageEvent());
            return Future<bool>.value(false);
          },
          child: GestureDetector(
            onTap: () => context.read<CommercialLicenseInitialAprrovalBloc>().hideKeyboard(),
            child: Scaffold(
              appBar: DetailsAppBarTwo(
                pageLength: state.pagesList.length,
                currentStep: state.currentPageValue + 1,
                backOnPress: () =>
                    context
                        .read<CommercialLicenseInitialAprrovalBloc>()
                        .add(const PreviousPageEvent()),
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
                controller: context
                    .read<CommercialLicenseInitialAprrovalBloc>()
                    .controller,
                itemBuilder: (context, position) {
                  return AnimatedContainer(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 300),
                    child: state.pagesList[position],
                  );





                    CommercialDebtsScreen(
                    transactionType: TransactionType.REQUEST,
                    transactionId: context.read<CommercialLicenseInitialAprrovalBloc>().state.requestId,
                    steps:[listIssueSteps[position]],
                    serviceId: CommercialLicenseServiceId.issueCommercialLicense,
                    child: AnimatedContainer(
                      curve: Curves.easeIn,
                      duration: const Duration(milliseconds: 300),
                      child: state.pagesList[position],
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}