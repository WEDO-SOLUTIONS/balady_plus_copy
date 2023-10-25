import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../vd/presentation/widgets/details_widgets/details_app_bar.dart';
import '../../../renew_commercial_license_exports.dart';

class CommercialLicenseBody extends StatelessWidget {
  const CommercialLicenseBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RenewCommercialLicenseBloc,
        RenewCommercialLicenseState>(
      listener: (context, state) {
        if (state.status == BlocStatus.failure ||
            state.contractsListStatus == BlocStatus.failure) {
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
                  appBar: FormAppBar(
                    pageLength: state.pagesList.length,
                    currentStep: state.currentPageValue + 1,
                    backOnPress: () => context
                        .read<RenewCommercialLicenseBloc>()
                        .add(const GoToPreviousPageEvent()),
                    onClose: () {
                      int count = 0;
                      Navigator.of(context).popUntil((_) => count++ >= 2);
                    },
                  ),
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
                        child: state.pagesList[position],
                      );
                    },
                  ),
                ),
              ),
            ),
            if (state.status == BlocStatus.loading)
              CustomCircularLoadingWidget()
          ],
        );
      },
    );
  }
}
