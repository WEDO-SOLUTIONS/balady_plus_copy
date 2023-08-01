import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/features/providers/providers_exports.dart'
    show
        AboutProviderOfficeWidget,
        EtmamProviderMainInfo,
        ProviderBranchesWidget,
        ProviderDetailsResponse,
        ProviderPreviousWorksWidgets,
        ProviderServicesSection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, CustomLoadingWidget;
import '../../../services/presentation/widgets/service_provider_details_widgets/service_details_header_widget.dart';
import '../blocs/provider_details_bloc/provider_details_bloc.dart';

class ProviderDetailsPage extends StatefulWidget {
  ProviderDetailsResponse args;

  ProviderDetailsPage({Key? key, required this.args}) : super(key: key);

  @override
  State<ProviderDetailsPage> createState() => _ProviderDetailsPageState();
}

class _ProviderDetailsPageState extends State<ProviderDetailsPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.ProviderDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) =>
            ProviderDetailsBloc(args: widget.args, getServiceDetails: sl()),
        child: BlocConsumer<ProviderDetailsBloc, ProviderDetailsState>(
          listener: (context, state) {
            if (state.status == BlocStatus.failure) {
              CommonFunctions.showError(state.errorMessage ?? "");
            }
          },
          builder: (context, state) {
            return Stack(
              children: [
                // Image.asset(
                //   ImagePath.providerDetailsImgExample,
                //   fit: BoxFit.fill,
                //   width: double.infinity,
                //   height: MediaQuery.of(context).size.height * 0.275,
                // ),
                // Positioned(
                //   top: MediaQuery.of(context).size.height * 0.25,
                //   child: Container(
                //     color: Colors.white,
                //   ),
                // ),
                Column(
                  children: [
                    ProviderDetailsHeader(
                      imageUrl: state.args.logoUrl ?? "",
                      providerName: state.args.name ?? "",
                    ),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            EtmamProviderMainInfo(),
                            CustomVerticalSpace(height: 12),
                            AboutProviderOfficeWidget(),
                            ProviderBranchesWidget(),
                            ProviderServicesSection(),
                            ProviderPreviousWorksWidgets(),
                            CustomVerticalSpace(height: 12),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (state.status == BlocStatus.loading)
                  const CustomLoadingWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}
