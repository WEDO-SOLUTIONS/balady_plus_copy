import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/etmam_app/core/dependency_injection/injection_container.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/utils/enums/app_font_weight.dart';
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, IconPath, trans;
import 'package:balady_plus/app/core/services/local/navigation_services.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart'
    show AppColor, AuthStatus, BlocStatus, EtmamRoutesNames;
import 'package:balady_plus/app/features/entry_point/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared_feature_/shared/shared_feature_exports.dart';
import '../../services_exports.dart';
import '../widgets/service_provider_details_widgets/service_details_buttons.dart';

class ServiceDetailsPage extends StatefulWidget {
  const ServiceDetailsPage({Key? key}) : super(key: key);

  @override
  State<ServiceDetailsPage> createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  @override
  Widget build(BuildContext context) {
    ServiceDetailsResponse serviceDetailsResponse =
        ModalRoute.of(context)!.settings.arguments as ServiceDetailsResponse;

    return Scaffold(
        appBar: DefaultAppBarWidget(
          title: trans("order_info_service_details"),
        ),
        body: BlocProvider(
          create: (context) => ServiceDetailsBloc(
              response: serviceDetailsResponse, getRelations: sl()),
          child: BlocConsumer<ServiceDetailsBloc, ServiceDetailsState>(
            listener: (context, state) {
              if (state.status == BlocStatus.failure) {
                CommonFunctions.showError(state.errorMessage ?? "");
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  Column(children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CustomTextWidget(
                                trans("office_info"),
                                fontColor: AppColor.blackModern800Light,
                                fontWeight: AppFontWeight.bold,
                                fontSize: 16,
                              ),
                              const SizedBox(height: 16),
                              InfoCard(
                                iconPath: IconPath.locationSectionIcon,
                                title: trans('main_branch'),
                                value:
                                    state.response.provider?.mainBranchAddress,
                              ),
                              InfoCard(
                                iconPath: IconPath.call,
                                title: trans('lbl_more_contactInfo'),
                                value:
                                    state.response.provider?.mainBranchContact,
                                leading: GestureDetector(
                                  onTap: () {
                                    if (state.response.provider != null) {
                                      NavigationService.pushNamed(
                                          routeName:
                                              EtmamRoutesNames.officeInfoPage,
                                          args: state.response.provider!);
                                    }
                                  },
                                  child: CustomTextWidget(
                                    trans('lbl_more_contactInfo'),
                                    fontSize: 12,
                                    fontWeight: AppFontWeight.bold,
                                    fontColor: AppColor.primary900Light,
                                  ),
                                ),
                              ),
                              InfoCard(
                                iconPath: IconPath.medalStar,
                                title: trans('evaluate_office'),
                                value:
                                    "${state.response.provider?.rating} (${state.response.provider?.ratingsCount})",
                              ),
                              const SizedBox(height: 24),
                              CustomTextWidget(
                                trans("service_info"),
                                fontColor: AppColor.blackModern800Light,
                                fontWeight: AppFontWeight.bold,
                                fontSize: 16,
                              ),
                              const SizedBox(height: 16),
                              InfoCard(
                                iconPath: IconPath.building,
                                title: trans('service_desc'),
                                value: state.response.service?.description,
                              ),
                              InfoCard(
                                iconPath: IconPath.medalStar,
                                title: trans('service_evaluation'),
                                value:
                                    "${state.response.service?.rating} (${state.response.service?.ratingsCount})",
                              ),
                              if ((state.response.provider?.projects?.length ??
                                      0) >
                                  0) ...[
                                const SizedBox(height: 24),
                                CustomTextWidget(
                                  trans("prevoius_works"),
                                  fontColor: AppColor.blackModern800Light,
                                  fontWeight: AppFontWeight.bold,
                                  fontSize: 16,
                                ),
                                PreviousWorks(
                                    projects:
                                        state.response.provider?.projects),
                                const SizedBox(height: 24),
                              ],
                              if ((state.response.service?.faqs?.length ?? 0) >
                                  0) ...[
                                const SizedBox(height: 24),
                                CustomTextWidget(
                                  trans("faq"),
                                  fontColor: AppColor.blackModern800Light,
                                  fontWeight: AppFontWeight.bold,
                                  fontSize: 16,
                                ),
                                const ServiceFaqSection(),
                                const CustomVerticalSpace(height: 24),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    const ServiceDetailsButton(),
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
