import 'package:balady_plus/app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/utils/app_analytics_events.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../blocs/new_health_certificate_bloc/new_health_certificate_bloc.dart';
import '../../core/services/view_models/new_details_health_license_view_model.dart';
import '../../widgets/new_health_certificate_widgets/details_app_bar.dart';

class NewHealthCertificatePage extends StatefulWidget {
  const NewHealthCertificatePage({
    super.key,
  });

  @override
  State<NewHealthCertificatePage> createState() =>
      _NewHealthCertificatePageState();
}

class _NewHealthCertificatePageState extends State<NewHealthCertificatePage> {
  @override
  void initState() {
    super.initState();

    CommonFunctions.sendEventToAnalytics(AppEvents.IssuHealthCert);
    CommonFunctions.sendUXCamEvent(UXCamEvents.startServiceHealthCertificate);
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context)!.settings.arguments;
    bool renew = data is bool ? data : false;

    return BlocProvider<NewHealthCertificateBloc>(
      create: (context) => NewHealthCertificateBloc(renew: renew),
      child: BlocConsumer<NewHealthCertificateBloc, NewHealthCertificateState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () {
              context
                  .read<NewHealthCertificateBloc>()
                  .add(GoToPreviousPageEvent());
              return Future<bool>.value(false);
            },
            child: GestureDetector(
              onTap: () {
                context.read<NewHealthCertificateBloc>().hideKeyboard();
              },
              child: Scaffold(
                appBar: DetailsAppBar(
                  currentStep: state.currentPageValue + 1,
                  backOnPress: () => context
                      .read<NewHealthCertificateBloc>()
                      .add(GoToPreviousPageEvent()),
                ),
                body: Stack(
                  children: [
                    PageView.builder(
                        itemCount: context
                            .read<NewHealthCertificateBloc>()
                            .pagesList
                            .length,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        controller:
                            context.read<NewHealthCertificateBloc>().controller,
                        itemBuilder: (context, position) {
                          return AnimatedContainer(
                            curve: Curves.easeIn,
                            duration: Duration(milliseconds: 300),
                            child: context
                                .read<NewHealthCertificateBloc>()
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
