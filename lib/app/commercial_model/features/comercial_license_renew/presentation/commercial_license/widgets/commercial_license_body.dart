import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../renew_commercial_license_exports.dart';
import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';

class CommercialLicenseBody extends StatelessWidget {
  const CommercialLicenseBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    int requestId = ModalRoute.of(context)!.settings.arguments as int;
    return BlocConsumer<RenewCommercialLicenseBloc,
        RenewCommercialLicenseState>(
      listener: (context, state) {
        if (state.status == BlocStatus.failure ||
            state.contractsListStatus == BlocStatus.failure ||
            state.requestDetailsStatus == BlocStatus.failure) {
          CommonFunctions.showError(state.errorMessage ?? "");
        }
      },
      builder: (context, state) {
        return Stack(
          children: [
            WillPopScope(
              onWillPop: () {
                context
                    .read<RenewCommercialLicenseBloc>()
                    .add(const GoToPreviousPageEvent());
                return Future<bool>.value(false);
              },
              child: GestureDetector(
                onTap: () =>
                    context.read<RenewCommercialLicenseBloc>().hideKeyboard(),
                child: Scaffold(
                  appBar: DetailsAppBarTwo(
                      pageLength: state.pagesList.length,
                      currentStep: state.currentPageValue + 1,
                      backOnPress: () => context
                          .read<RenewCommercialLicenseBloc>()
                          .add(const GoToPreviousPageEvent()),
                      onTapCloseAction: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        bool Function(Route<dynamic>) predicate =
                            ModalRoute.withName(
                                CommercialRouteName.bottomNavigation);
                        Navigator.of(context).popUntil(
                          (predicate),
                        );
                      },
                      requestNum: state.requestId),
                  body: PageView.builder(
                    itemCount: state.pagesList.length,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    controller:
                        context.read<RenewCommercialLicenseBloc>().controller,
                    itemBuilder: (context, position) {
                      return AnimatedContainer(
                        curve: Curves.easeIn,
                        duration: const Duration(milliseconds: 300),
                        child: CommercialDebtsScreen(
                          transactionType: TransactionType.REQUEST,
                          transactionId: requestId,
                          steps: [listReneWEvents[position]],
                          serviceId:
                              CommercialLicenseServiceId.renewCommercialLicense,
                          child: state.pagesList[position],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            if (state.status == BlocStatus.loading ||
                state.calculateInfoRequestStatus == BlocStatus.loading)
              CustomCircularLoadingWidget()
          ],
        );
      },
    );
  }
}
