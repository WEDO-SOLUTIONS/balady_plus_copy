import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../vd/presentation/widgets/details_widgets/details_app_bar.dart';
import '../../../renew_commercial_license_exports.dart';

class CommercialLicenseBody extends StatelessWidget {
  const CommercialLicenseBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RenewCommercialLicenseBloc, RenewCommercialLicenseState>(
      builder: (context, state) {
        return WillPopScope(
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
              appBar: DetailsAppBar(
                pageLength: state.pagesList.length,
                currentStep: state.currentPageValue + 1,
                backOnPress: () => context
                    .read<RenewCommercialLicenseBloc>()
                    .add(const GoToPreviousPageEvent()),
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
        );
      },
    );
  }
}
