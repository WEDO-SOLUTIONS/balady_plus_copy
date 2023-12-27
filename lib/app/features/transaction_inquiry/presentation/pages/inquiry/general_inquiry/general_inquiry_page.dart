import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../../core/utils/app_analytics_events.dart';
import '../../../../../../core/utils/common_functions.dart';
import '../../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../../core/utils/enums/bloc_status.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../data/general_inquiry_data.dart';
import '../../../core/bloc/general_inquiry_bloc/general_inquiry_bloc.dart';
import '../../../core/view_models/inquiry/new_inquiry_view_model.dart';
import 'details_app_bar.dart';

class GeneralInquiryPage extends StatefulWidget {
  const GeneralInquiryPage({super.key});

  @override
  State<GeneralInquiryPage> createState() => _GeneralInquiryPageState();
}

class _GeneralInquiryPageState extends State<GeneralInquiryPage> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendEventToAnalytics(AppEvents.generalInq);

    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceGeneralInquiries);

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.General_Inquiries_Open_Create_Details_Event);
  }

  @override
  Widget build(BuildContext context) {
    CustomerVoiceReportTypeModel inqTypeModel = ModalRoute.of(context)!
        .settings
        .arguments as CustomerVoiceReportTypeModel;

    return BlocProvider<GeneralInquiryBloc>(
      create: (context) => GeneralInquiryBloc(),
      child: BlocConsumer<GeneralInquiryBloc, GeneralInquiryState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context.read<GeneralInquiryBloc>().add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<GeneralInquiryBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: DetailsAppBar(
                  currentStep: state.currentPageValue + 1,
                  backOnPress: () => context
                      .read<GeneralInquiryBloc>()
                      .add(GoToPreviousPageEvent()),
                ),
                body: ChangeNotifierProvider<NewInquiryViewModel>(
                  create: (context) => NewInquiryViewModel(inqTypeModel),
                  builder: (context, child) {
                    NewInquiryViewModel model =
                        Provider.of<NewInquiryViewModel>(context, listen: true);
                    return Stack(
                      children: [
                        PageView.builder(
                            itemCount: context
                                .read<GeneralInquiryBloc>()
                                .pagesList
                                .length,
                            scrollDirection: Axis.vertical,
                            physics: NeverScrollableScrollPhysics(),
                            controller:
                                context.read<GeneralInquiryBloc>().controller,
                            itemBuilder: (context, position) {
                              return AnimatedContainer(
                                curve: Curves.easeIn,
                                duration: Duration(milliseconds: 300),
                                child: context
                                    .read<GeneralInquiryBloc>()
                                    .pagesList[position],
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
