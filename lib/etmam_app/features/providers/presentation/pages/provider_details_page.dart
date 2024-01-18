import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, IconPath, trans;
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

import '../../../_shared_feature_/shared/presentation/widgets/rating_evaluation_widget.dart';
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show CustomVerticalSpace, CustomLoadingWidget;
import '../../../services/presentation/widgets/service_provider_details_widgets/service_details_header_widget.dart';
import '../../../services/services_exports.dart';
import '../blocs/provider_details_bloc/provider_details_bloc.dart';
import '../widgets/provider_details/provider_content.dart';

class ProviderDetailsPage extends StatefulWidget {
  const ProviderDetailsPage({Key? key}) : super(key: key);

  @override
  State<ProviderDetailsPage> createState() => _ProviderDetailsPageState();
}

class _ProviderDetailsPageState extends State<ProviderDetailsPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.ProviderDetails);
  }

  late ProviderDetailsResponse args;

  @override
  Widget build(BuildContext context) {
    args =
        ModalRoute.of(context)!.settings.arguments as ProviderDetailsResponse;

    return BlocProvider(
      create: (context) =>
          ProviderDetailsBloc(args: args, getServiceDetails: sl()),
      child: BlocBuilder<ProviderDetailsBloc, ProviderDetailsState>(
        builder: (context, state) {
          return Scaffold(
            appBar: DefaultAppBarWidget(
              title: state.args.name,
            ),
            body: BlocConsumer<ProviderDetailsBloc, ProviderDetailsState>(
              listener: (context, state) {
                if (state.status == BlocStatus.failure) {
                  CommonFunctions.showError(state.errorMessage ?? "");
                }
              },
              builder: (context, state) {
                return Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const EtmamProviderMainInfo(),
                            if ((state.args.projects?.length ?? 0) > 0) ...[
                              const SizedBox(height: 24),
                              CustomTextWidget(
                                trans("prevoius_works"),
                                fontColor: AppColor.blackModern800Light,
                                fontWeight: AppFontWeight.bold,
                                fontSize: 16,
                              ),
                              PreviousWorks(
                                projects: state.args.projects,
                              ),
                              const SizedBox(height: 24),
                            ],
                            const ProviderServicesSection(),
                          ],
                        ),
                      ),
                    ),
                    if (state.status == BlocStatus.loading)
                      const CustomLoadingWidget()
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
