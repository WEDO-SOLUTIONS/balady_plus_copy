import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_expansion_panel_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/objectable_transactions/presentation/widgets/summery_widgets/field_data.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show AuthStatus, CommonFunctions, trans;
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show AppColor, AuthStatus, BlocStatus;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomLoadingWidget, CustomTextButtonWidget, CustomVerticalSpace, EtmamRatingEvaluationWidget;
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services_exports.dart'
    show
        PreviousWorksWidgets,
        ProviderDetailsHeader,
        ServiceDetailsBloc,
        ServiceDetailsResponse,
        ServiceDetailsState,
        ServiceFaqSection,
        ServiceInfoWidget,
        ServiceProviderMainInfo;
import '../widgets/service_provider_details_widgets/service_details_buttons.dart';

class ServiceDetailsPage extends StatefulWidget {
  ServiceDetailsResponse serviceDetailsResponse;

  ServiceDetailsPage({Key? key, required this.serviceDetailsResponse})
      : super(key: key);

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.ServiceDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: BlocProvider(
      create: (context) => ServiceDetailsBloc(
          response: widget.serviceDetailsResponse, getRelations: sl()),
      child: BlocConsumer<ServiceDetailsBloc, ServiceDetailsState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              const Column(children: [
                // ProviderDetailsHeader(
                //   imageUrl: state.response.provider?.logoUrl ?? "",
                //   providerName: state.response.provider?.name ?? "",
                // ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 30),
                      child: Column(
                        children: [
                          // CustomExpansionPanelWidget(
                          //   leading: CustomSvgIconWidget(
                          //     IconPath.personalInformation,
                          //     iconSize: 20,
                          //     iconColor: AppColor.primary900Light,
                          //   ),
                          //   title: "بيانات المكتب",
                          //   children: [
                          //     FieldData(
                          //       title:  trans('main_branch'),
                          //       subTitle: state.response.provider?.mainBranchAddress,
                          //     ),
                          //     SizedBox(height: 8),
                          //     FieldData(
                          //       title:  trans('lbl_more_contactInfo'),
                          //       subTitle: state.response.provider?.mainBranchContact,
                          //     ),
                          //     SizedBox(height: 8),
                          //     FieldData(
                          //       title:  trans('evaluate_office'),
                          //       subTitle: "${state.response.service?.rating}/5   ${state.response.service?.ratingsCount}",
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height: 32),
                          // CustomExpansionPanelWidget(
                          //   leading: CustomSvgIconWidget(
                          //     IconPath.personalInformation,
                          //     iconSize: 20,
                          //     iconColor: AppColor.primary900Light,
                          //   ),
                          //   title: "بيانات الخدمة",
                          //   children: [
                          //   ],
                          // ),
                          ServiceProviderMainInfo(),
                          // CustomVerticalSpace(height: 12),
                          ServiceInfoWidget(),
                          ServiceFaqSection(),
                          PreviousWorksWidgets(),
                          CustomVerticalSpace(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                ServiceDetailsButton(),
              ]),
              BlocBuilder<EntryPointCubit, EntryPointState>(
                  bloc: sl(),
                  builder: (context, authState) {
                    return (state.status == BlocStatus.loading ||
                            authState.status == AuthStatus.loading)
                        ? const CustomLoadingWidget()
                        : Container();
                  })
            ],
          );
        },
      ),
    ));
  }
}
