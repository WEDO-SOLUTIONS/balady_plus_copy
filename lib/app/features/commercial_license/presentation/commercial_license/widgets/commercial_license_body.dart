import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../vd/presentation/widgets/details_widgets/details_app_bar.dart';
import '../../../commercial_license_exports.dart';

class CommercialLicenseBody extends StatefulWidget {
  const CommercialLicenseBody({
    super.key,
  });

  @override
  State<CommercialLicenseBody> createState() => _CommercialLicenseBodyState();
}

class _CommercialLicenseBodyState extends State<CommercialLicenseBody> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<CommercialLicenseBloc>().initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommercialLicenseBloc, CommercialLicenseState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            context
                .read<CommercialLicenseBloc>()
                .add(const GoToPreviousPageEvent());
            return Future<bool>.value(false);
          },
          child: GestureDetector(
            onTap: () => context.read<CommercialLicenseBloc>().hideKeyboard(),
            child: Scaffold(
              appBar: DetailsAppBar(
                pageLength: state.pagesList.length,
                currentStep: state.currentPageValue + 1,
                backOnPress: () => context
                    .read<CommercialLicenseBloc>()
                    .add(const GoToPreviousPageEvent()),
              ),
              body: PageView.builder(
                itemCount: state.pagesList.length,
                scrollDirection: Axis.vertical,
                physics: const NeverScrollableScrollPhysics(),
                controller: context.read<CommercialLicenseBloc>().controller,
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
