import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/bloc/msr_bloc/msr_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/utils/app_analytics_events.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../core/view_models/msr/new_msr_details_view_model.dart';
import '../widgets/details_app_bar.dart';

class NewMSRPage extends StatefulWidget {
  const NewMSRPage({super.key});

  @override
  State<NewMSRPage> createState() => _NewMSRPageState();
}





class _NewMSRPageState extends State<NewMSRPage> {
  @override
  void initState() {
    super.initState();
    //MM  Helpers.sendEventToAnalytics(AppEvents.VD_Open_Details);

    CommonFunctions.sendEventToAnalytics(AppEvents.municipalRequest);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.MunicipalServiceRequest_Open_Details_Step_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MSRBloc>(
      create: (context) => MSRBloc(),
      child: BlocConsumer<MSRBloc, MSRState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context.read<MSRBloc>().add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<MSRBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: DetailsAppBar(
                  currentStep: state.currentPageValue + 1,
                  backOnPress: () =>
                      context.read<MSRBloc>().add(GoToPreviousPageEvent()),
                ),
                body: ChangeNotifierProvider<NewMSRDetailsViewModel>(
                  create: (context) => NewMSRDetailsViewModel(),
                  builder: (context, child) {
                    NewMSRDetailsViewModel model =
                        Provider.of<NewMSRDetailsViewModel>(context,
                            listen: true);
                    return Stack(
                      children: [
                        PageView.builder(
                            itemCount: context.read<MSRBloc>().pagesList.length,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            controller: context.read<MSRBloc>().controller,
                            itemBuilder: (context, position) {
                              return AnimatedContainer(
                                curve: Curves.easeIn,
                                duration: Duration(milliseconds: 300),
                                child:
                                    context.read<MSRBloc>().pagesList[position],
                              );
                            }),
                        if (state.status == BlocStatus.loading)
                          const CustomCircularLoadingWidget(),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
