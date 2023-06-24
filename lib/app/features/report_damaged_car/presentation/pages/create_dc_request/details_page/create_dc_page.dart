import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../blocs/create_dc_request/create_dc_details_bloc/create_dc_bloc.dart';
import '../../../widgets/create_dc_request/details_widgets/details_app_bar.dart';

class CreateDCDetailsPage extends StatefulWidget {
  //final CreateVDParamsPage params;
  const CreateDCDetailsPage({
    super.key, //required this.params
  });

  @override
  State<CreateDCDetailsPage> createState() => _CreateDCDetailsPageState();
}

class _CreateDCDetailsPageState extends State<CreateDCDetailsPage> {
  @override
  void initState() {
    super.initState();
    //Helpers.sendEventToAnalytics(AppEvents.VD_Open_Details);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<CreateDCBloc>(),
      child: BlocConsumer<CreateDCBloc, CreateDCState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context.read<CreateDCBloc>().add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<CreateDCBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: DetailsAppBar(
                  currentStep: state.currentPageValue + 2,
                  backOnPress: () =>
                      context.read<CreateDCBloc>().add(GoToPreviousPageEvent()),
                ),
                body: Stack(
                  children: [
                    PageView.builder(
                        itemCount:
                            context.read<CreateDCBloc>().pagesList.length,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        controller: context.read<CreateDCBloc>().controller,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 300),
                            child: context
                                .read<CreateDCBloc>()
                                .pagesList[position],
                          );
                        }),
                    if (state.status == BlocStatus.loading &&
                        state.currentPageValue != 1)
                      CustomCircularLoadingWidget(),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
