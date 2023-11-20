import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/constants/route_names.dart';
import '../../../vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import '../blocs/posters_license_bloc.dart';

class PostersDetailsPage extends StatefulWidget {
  const PostersDetailsPage({super.key});

  @override
  State<PostersDetailsPage> createState() => _PostersDetailsPageState();
}

class _PostersDetailsPageState extends State<PostersDetailsPage> {
  @override
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostersLicenseBloc, PostersLicenseState>(
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () {
            context
                .read<PostersLicenseBloc>()
                .add(const GoToPreviousPageEvent());
            return Future<bool>.value(false);
          },
          child: GestureDetector(
            onTap: () => context.read<PostersLicenseBloc>().hideKeyboard(),
            child: Scaffold(
              appBar: DetailsAppBarTwo(
                pageLength: state.pagesList.length,
                currentStep: state.currentPageValue + 1,
                backOnPress: () => context
                    .read<PostersLicenseBloc>()
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
                controller: context.read<PostersLicenseBloc>().controller,
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
