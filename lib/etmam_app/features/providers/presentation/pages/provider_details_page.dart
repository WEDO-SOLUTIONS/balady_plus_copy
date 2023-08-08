import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions;
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show AppFontWeight, BlocStatus;

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
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/shared/presentation/widgets/rating_evaluation_widget.dart';
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, CustomLoadingWidget;
import '../../../services/presentation/widgets/service_provider_details_widgets/service_details_header_widget.dart';
import '../blocs/provider_details_bloc/provider_details_bloc.dart';
import '../widgets/provider_details/provider_content.dart';

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
                Positioned(
                  left: 0,
                  right: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.275,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(ImagePath.providerDetailsImgExample),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: MediaQuery.of(context).size.height * 0.24,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.76,
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: AppColor.white4,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ProviderDetailsHeader(
                            providerName: state.args.name ?? "",
                            providerAdress: state.args.mainBranchAddress ?? "",
                          ),
                          ProviderDetailsContentContainer(
                            title: 'evaluate_office'.tr(),
                            content: EtmamRatingEvaluationWidget(
                              rating: state.args.rating ?? 0,
                              totalEvaluation: state.args.ratingsCount ?? 0,
                              withDot: false,
                              isCenter: true,
                            ),
                            isCenter: true,
                          ),
                          const EtmamProviderMainInfo(),
                          const ProviderServicesSection(),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.06,
                  right: 13,
                  child: IconButton(
                    onPressed: Navigator.of(context).pop,
                    icon: const Icon(Icons.close, color: AppColor.white4),
                  ),
                ),

                // Column(
                //   children: [
                // ProviderDetailsHeader(
                //   imageUrl: state.args.logoUrl ?? "",
                //   providerName: state.args.name ?? "",
                // ),
                //     const Expanded(
                //       child: SingleChildScrollView(
                //         child: Column(
                //           children: [
                // EtmamProviderMainInfo(),
                //             CustomVerticalSpace(height: 12),
                //             AboutProviderOfficeWidget(),
                // ProviderBranchesWidget(),
                //             ProviderServicesSection(),
                //             ProviderPreviousWorksWidgets(),
                //             CustomVerticalSpace(height: 12),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

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
