import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/app_analytics_events.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/bloc_status.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../domain/entities/create_retrive_page_params.dart';
import '../blocs/create_retrive_bloc/create_retrive_bloc.dart';
import '../widgets/create_retrive_car/details_app_bar.dart';

class CreateRetriveDetailsPage extends StatefulWidget {
  const CreateRetriveDetailsPage({
    super.key,
  });

  @override
  State<CreateRetriveDetailsPage> createState() =>
      _CreateRetriveDetailsPageState();
}

class _CreateRetriveDetailsPageState extends State<CreateRetriveDetailsPage> {
  @override
  void initState() {
    super.initState();
    //Helpers.sendEventToAnalytics(AppEvents.VD_Open_Details);

    CommonFunctions.sendEventToAnalytics(AppEvents.vhrRequest);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.startServiceRetrieveImpoundedVehicle);
  }

  @override
  Widget build(BuildContext context) {
    CreateRetrivePageParams params =
        ModalRoute.of(context)!.settings.arguments as CreateRetrivePageParams;

    return BlocProvider(
      create: (context) => CreateRetriveCarBloc(vehicleItem: params.item),
      child: BlocConsumer<CreateRetriveCarBloc, CreateRetriveCarState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context.read<CreateRetriveCarBloc>().add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<CreateRetriveCarBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: DetailsAppBar(
                  currentStep: state.currentPageValue + 1,
                  backOnPress: () => context
                      .read<CreateRetriveCarBloc>()
                      .add(GoToPreviousPageEvent()),
                ),
                body: Stack(
                  children: [
                    PageView.builder(
                        itemCount: context
                            .read<CreateRetriveCarBloc>()
                            .pagesList
                            .length,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        controller:
                            context.read<CreateRetriveCarBloc>().controller,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 300),
                            child: context
                                .read<CreateRetriveCarBloc>()
                                .pagesList[position],
                          );
                        }),
                    if (state.status == BlocStatus.loading)
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
