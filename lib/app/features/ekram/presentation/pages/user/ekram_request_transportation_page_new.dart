import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/ekram/ekram_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../vd/presentation/widgets/details_widgets/details_app_bar.dart';
import '../../../../vd/presentation/widgets/details_widgets/details_app_bar_two.dart';
import '../../../data/model/request_details_response_model/request_details_response_model.dart';

class EkramRequestTransportationPage extends StatefulWidget {
  const EkramRequestTransportationPage({
    super.key,
  });

  @override
  State<EkramRequestTransportationPage> createState() =>
      _EkramRequestTransportationPageState();
}

class _EkramRequestTransportationPageState
    extends State<EkramRequestTransportationPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceBodyTransportation);
    CommonFunctions.sendUXCamEvent(UXCamEvents
        .RequestsTransportingAndPreparingDeceased_Create_Details_Enter_Page_Event);
    CommonFunctions.sendUXCamEvent(UXCamEvents
        .RequestsTransportingAndPreparingDeceased_Open_Applicant_Info_Step_Event);
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)!.settings.arguments;
    EkramRequestTransportationBloc? bloc;
    RequestDetailsResponseModel? params;
    if (arguments is RequestDetailsResponseModel) {
      params = arguments;
    } else if(arguments is EkramRequestTransportationBloc) {
      bloc = arguments;
    }
    return BlocProvider(
      create: (context) => bloc ?? EkramRequestTransportationBloc(
              getCities: sl(),
              getRequestDetails: sl(),
              getHospitals: sl(),
              getNationalities: sl(),
              applyDeceasedTransport: sl(),
              getCemeteryTypesLookUp: sl(),
            ),
      child: BlocConsumer<EkramRequestTransportationBloc,
          EkramRequestTransportationState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          if (params != null && state.isDraft != true) {
            context
                .read<EkramRequestTransportationBloc>()
                .add(setInitialDataEvent(dataModel: params));
          }
          return WillPopScope(
            onWillPop: () {
              context
                  .read<EkramRequestTransportationBloc>()
                  .add(const GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<EkramRequestTransportationBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: DetailsAppBarTwo(
                  hideBtnBack: state.currentPageValue == 1 ? true : false,
                  currentStep: state.currentPageValue + 1,
                  pageLength: context
                      .read<EkramRequestTransportationBloc>()
                      .pagesList
                      .length,
                  backOnPress: () => context
                      .read<EkramRequestTransportationBloc>()
                      .add(const GoToPreviousPageEvent()),
                  onTapCloseAction: () {

                    FocusManager.instance.primaryFocus?.unfocus();
                    Navigator.of(context).pop();
                  },
                ),
                body: Stack(
                  children: [
                    PageView.builder(
                        itemCount: context
                            .read<EkramRequestTransportationBloc>()
                            .pagesList
                            .length,
                        scrollDirection: Axis.vertical,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: context
                            .read<EkramRequestTransportationBloc>()
                            .controller,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: const Duration(milliseconds: 300),
                            child: context
                                .read<EkramRequestTransportationBloc>()
                                .pagesList[position],
                          );
                        }),
                    if (state.status == BlocStatus.loading &&
                        state.currentPageValue != 1)
                      const CustomCircularLoadingWidget(),
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
