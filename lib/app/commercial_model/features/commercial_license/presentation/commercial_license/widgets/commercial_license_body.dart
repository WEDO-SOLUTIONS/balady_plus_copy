import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import '../../../commercial_license_exports.dart';

class CommercialLicenseBody extends StatefulWidget {
  final int? requestId;
  const CommercialLicenseBody({super.key, this.requestId});

  @override
  State<CommercialLicenseBody> createState() => _CommercialLicenseBodyState();
}

class _CommercialLicenseBodyState extends State<CommercialLicenseBody> {
  @override
  void initState() {
    super.initState();

    context
        .read<CommercialLicenseBloc>()
        .initState(requestId: widget.requestId);
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
              appBar: DetailsAppBarTwo(
                pageLength: state.pagesList.length,
                currentStep: state.currentPageValue + 1,
                backOnPress: () => context
                    .read<CommercialLicenseBloc>()
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
