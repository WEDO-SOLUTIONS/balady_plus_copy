import 'package:balady_plus/app/core/utils/constants/dialog_names.dart';
import 'package:balady_plus/app/core/utils/constants/paths/image_paths.dart';
import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_with_actions.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:balady_plus/app/features/services/presentation/mvvm/service_data_view_model.dart';
import 'package:balady_plus/app/features/services/presentation/widgets/service_cards_dynamic/costume_list_tile.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/constants/paths/icon_paths.dart';
import '../../../../../events_logs/controller/logs_controller.dart';
import '../../../../../events_logs/events_names.dart';
import '../../../../../events_logs/models/error_exception_model.dart';
import '../../../../_shared_feature_/balady_features/widgets/shared/circle_icon.dart';
import '../../../../profile_features/delegators/presentation/delegators_cubit/delegators_cubit.dart';
import '../../../../profile_features/delegators/presentation/widgets/delegator_list.dart';

class ServiceCardDescDynamicWidget extends StatelessWidget {
    final bool? showDelagator;
    final bool? openFromCompliance;
   const ServiceCardDescDynamicWidget({super.key,this.showDelagator,this.openFromCompliance});

  @override
  Widget build(BuildContext context) {
    ServiceDataViewModel viewModel = context.watch<ServiceDataViewModel>();
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Image.asset(
          ImagePath.backgroundServiceCard,
          height: MediaQuery.of(context).size.height * .37,
          width: double.maxFinite,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Selector<ServiceDataViewModel, bool>(
            selector: (_, provider) => provider.isLoading,
            builder: (context, isLoading, child) {
              return isLoading
                  ?  const CustomLoadingWidget()
                  : viewModel.servicesCardsDetails != null
                      ? SizedBox.expand(
                          child: Column(
                            children: [
                              Expanded(
                                flex: 47,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context)
                                          .viewPadding
                                          .top,
                                    ),
                                     Row(
                                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const BackButton(color: Colors.white),
                                        showDelagator==true?
                                        InkWell(
                                          onTap: () async {
                                            try {
                                              sl<DelegatorsCubit>().getDelegators();
                                              sl<DelegatorsCubit>().getAgents();
                                              await BottomSheetDialog.showDraggableSheet(
                                                context,
                                                dialogKeyName: DialogName.delegatorsDialog,
                                                currentRouteName: RouteName.createCompliancePage,
                                                child: DelegatorList(
                                                  fromService: true,
                                                  delegatorsCubit: sl<DelegatorsCubit>(),
                                                ),
                                              );
                                            } catch (error, stackTrace) {
                                              LogsViewModel().sendEventFromModel(
                                                event: ErrorExceptionModel(
                                                  nameEvent: EventsName.handledException,
                                                  message: error.toString(),
                                                  stackTrace: stackTrace.toString(),
                                                ),
                                              );
                                            }
                                          },
                                          child: CircleIcon(
                                            icon: IconPath.switchProfileIcon,
                                            iconColor: AppColor.primary600Light,
                                            backgroundColor: AppColor.white,
                                            iconSize: 18,
                                          ),
                                        ):Container()
                                      ],
                                    ),
                                    Text(
                                      viewModel.servicesCardsDetails!.title ??
                                          '',
                                      style: AppStyle.violationCreateTitle
                                          .copyWith(color: Colors.white),
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          IconPath.starNew,
                                          width: 16,
                                          height: 16,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          viewModel.servicesCardsDetails!
                                                  .fieldServiceRank ??
                                              '0.0',
                                          style: AppStyle.dateTextStyle
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            viewModel.servicesCardsDetails!
                                                            .fieldDescriptionService !=
                                                        null &&
                                                    viewModel
                                                        .servicesCardsDetails!
                                                        .fieldDescriptionService!
                                                        .isNotEmpty
                                                ? viewModel
                                                    .servicesCardsDetails!
                                                    .fieldDescriptionService!
                                                    .replaceAll("<br />", "")
                                                : "",
                                            style: AppStyle
                                                .resultsLastDescription
                                                .copyWith(
                                              color: AppColor.primary300Light,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 20),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        IconPath.switchProfileIcon,
                                        colorFilter: const ColorFilter.mode(
                                          AppColor.primary900Light,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          viewModel.servicesCardsDetails!
                                              .fieldTargetCategories ??
                                              '',
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
                                          softWrap: false,
                                          style: AppStyle
                                              .complianceFirstSubmitSubtitleStyle
                                              .copyWith(color: Colors.black),
                                        ),
                                      ),


                                      Container(
                                        decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color(0xffA7D378),
                                                Color(0xff66C1C0)
                                              ],
                                              begin: Alignment.topRight,
                                              end: Alignment.bottomLeft,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(12))),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8.0,
                                            horizontal: 16,
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${viewModel.servicesCardsDetails!.fieldTimeFrom ?? ''} - ${viewModel.servicesCardsDetails!.fieldTimeTo ?? ''}',
                                                style: AppStyle.eventsDayStyle
                                                    .copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                              Text(
                                                viewModel.servicesCardsDetails!
                                                        .fieldPeriod ??
                                                    '',
                                                style: AppStyle
                                                    .semiBoldTextStyle
                                                    .copyWith(
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 70,
                                child: SingleChildScrollView(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          CostumeListTile(
                                            title: Text(
                                              'submission_channels'.tr(),
                                              style: AppStyle
                                                  .complianceSubtitleLicenseStyle,
                                            ),
                                            trailing: Wrap(
                                              children: viewModel
                                                      .servicesCardsDetails!
                                                      .fieldServiceChanelsExport
                                                      ?.map(
                                                        (e) => SvgPicture.asset(
                                                          e.id == 10110
                                                              ? IconPath
                                                                  .mobileEmpty
                                                              : IconPath
                                                                  .monitorIcon,
                                                        ),
                                                      )
                                                      .toList() ??
                                                  [],
                                            ),
                                          ),
                                          viewModel.servicesCardsDetails!
                                                          .fieldFees ==
                                                      "نعم" ||
                                                  viewModel
                                                          .servicesCardsDetails!
                                                          .fieldFees ==
                                                      "yes"
                                              ? CostumeListTile(
                                                  title: Text(
                                                    'payment_method'.tr(),
                                                    style: AppStyle
                                                        .complianceSubtitleLicenseStyle,
                                                  ),
                                                  trailing: Row(
                                                    children: [
                                                      SvgPicture.asset(
                                                        IconPath.sadaddIcon,
                                                        width: 17,
                                                        height: 12,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      SvgPicture.asset(
                                                        IconPath.visaIcon,
                                                        width: 17,
                                                        height: 12,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      SvgPicture.asset(
                                                        IconPath.masterCardIcon,
                                                        width: 20,
                                                        height: 15,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      SvgPicture.asset(
                                                        IconPath.madaIcon,
                                                        width: 17,
                                                        height: 12,
                                                      ),
                                                      const SizedBox(width: 2),
                                                      SvgPicture.asset(
                                                        IconPath.applePayIcon,
                                                        width: 20,
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              : const SizedBox(),
                                          viewModel.servicesCardsDetails!
                                                          .fieldFees ==
                                                      "نعم" ||
                                                  viewModel
                                                          .servicesCardsDetails!
                                                          .fieldFees ==
                                                      "yes"
                                              ? CostumeListTile(
                                                  onTap: () {},
                                                  title: Text(
                                                    'cost_card'.tr(),
                                                    style: AppStyle
                                                        .complianceSubtitleLicenseStyle,
                                                  ),
                                                  trailing:
                                                      CustomUnderlineTextdButtonWidget(
                                                    onPressed: () {
                                                      Navigator.pushNamed(
                                                          context,
                                                          RouteName
                                                              .calculatorMapRoute);
                                                    },
                                                    text:
                                                        "go_to_calculator_cost"
                                                            .tr(),
                                                  ),
                                                )
                                              : const SizedBox(),
                                          CostumeListTile(
                                            onTap: () {
                                              BottomSheetDialog
                                                  .showDraggableSheet(
                                                context,
                                                dialogKeyName: DialogName
                                                    .howToApplySheetDialog,
                                                // currentRouteName: RouteName.commercialLicenseDetails,
                                                child: BottomSheetWithActions(
                                                  title: "how_to_apply".tr(),
                                                  body: Html(
                                                      data: viewModel
                                                              .servicesCardsDetails!
                                                              .fieldHowToApply ??
                                                          ''),
                                                ),
                                                isFullHeight: false,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                              );
                                            },
                                            leading: SvgPicture.asset(
                                                IconPath.taskSquareList),
                                            title: Text(
                                              'how_to_apply'.tr(),
                                              style: AppStyle
                                                  .complianceSubtitleLicenseStyle,
                                            ),
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                            ),
                                          ),
                                          CostumeListTile(
                                            onTap: () {
                                              BottomSheetDialog
                                                  .showDraggableSheet(
                                                context,
                                                dialogKeyName: DialogName
                                                    .requirementsSheetDialog,
                                                child: BottomSheetWithActions(
                                                  title: "requirements".tr(),
                                                  body: Html(
                                                      data: viewModel
                                                              .servicesCardsDetails!
                                                              .fieldRequirements ??
                                                          ''),
                                                ),
                                                isFullHeight: false,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.5,
                                              );
                                            },
                                            leading: SvgPicture.asset(
                                              IconPath.element_3Icon,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                AppColor.primary900Light,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                            title: Text(
                                              'requirements'.tr(),
                                              style: AppStyle
                                                  .complianceSubtitleLicenseStyle,
                                            ),
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                            ),
                                          ),


                                          CostumeListTile(
                                            onTap: () {
                                              // if(openFromCompliance==true)
                                              //   {
                                              //     CommonFunctions.openComplianceTerms();
                                              //   }
                                              //   else {
                                                BottomSheetDialog
                                                    .showDraggableSheet(
                                                  context,
                                                  dialogKeyName: DialogName
                                                      .requirementsFinesSheetDialog,
                                                  child: BottomSheetWithActions(
                                                    title: "requirements_fines"
                                                        .tr(),
                                                    body: (viewModel
                                                        .servicesCardsDetails
                                                        ?.fieldServiceRequirements
                                                        ?.isEmpty ?? true) &&
                                                        (viewModel
                                                            .servicesCardsDetails
                                                            ?.fieldViolationsAndFines
                                                            ?.isEmpty ?? true)
                                                        ? Text("nothing".tr())
                                                        : Column(
                                                      mainAxisAlignment: MainAxisAlignment
                                                          .start,
                                                      crossAxisAlignment: CrossAxisAlignment
                                                          .start,
                                                      children: [
                                                        const SizedBox(
                                                            height: 14),
                                                        Text(
                                                          "government_requirements_approvals"
                                                              .tr(),
                                                        ),
                                                        Card(
                                                          color: AppColor
                                                              .primary200Light,
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                8.0),
                                                          ),
                                                          margin:
                                                          const EdgeInsets
                                                              .only(
                                                              top: 12),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                16.0),
                                                            child: InkWell(
                                                              onTap: () async {


                                                                print(viewModel
                                                                    .servicesCardsDetails
                                                                !.fieldServiceRequirements);
                                                                if (viewModel
                                                                    .servicesCardsDetails
                                                                !.fieldServiceRequirements != null&&!await launchUrl(Uri.parse(viewModel
                                                                    .servicesCardsDetails
                                                                    !.fieldServiceRequirements!.replaceAll("\n", "")))) {
                                                                throw Exception('Could not launch url');
                                                                }

                                                                // Navigator.of(
                                                                //     context).pushNamed(RouteName.inappWebview, arguments: (requestNum:
                                                                //   'fines_penalties'
                                                                //       .tr(),
                                                                //   url: viewModel
                                                                //       .servicesCardsDetails
                                                                //       ?.fieldServiceRequirements,
                                                                //   isObjections:
                                                                //   false
                                                                //   ),
                                                                // );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Flexible(
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                    Text(
                                                                      "service_requirements_conditions"
                                                                          .tr(),
                                                                    ),
                                                                  ),
                                                                  SvgPicture
                                                                      .asset(
                                                                      IconPath
                                                                          .downloadButton)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        //////////////////////////////
                                                        const SizedBox(
                                                            height: 20),
                                                        //////////////////////////////
                                                        Text(
                                                          "fines_penalties_title"
                                                              .tr(),
                                                        ),
                                                        Card(
                                                          color: AppColor
                                                              .primary200Light,
                                                          shape:
                                                          RoundedRectangleBorder(
                                                            borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                8.0),
                                                          ),
                                                          margin:
                                                          const EdgeInsets
                                                              .only(
                                                              top: 12),
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(
                                                                16.0),
                                                            child: InkWell(
                                                              onTap: () {
                                                                Navigator.of(
                                                                    context)
                                                                    .pushNamed(
                                                                  RouteName
                                                                      .inappWebview,
                                                                  arguments: (
                                                                  requestNum:
                                                                  'list_penalties_municipal_violations'
                                                                      .tr(),
                                                                  url: viewModel
                                                                      .servicesCardsDetails
                                                                      ?.fieldViolationsAndFines,
                                                                  isObjections:
                                                                  false
                                                                  ),
                                                                );
                                                              },
                                                              child: Row(
                                                                children: [
                                                                  Flexible(
                                                                    fit: FlexFit
                                                                        .tight,
                                                                    child:
                                                                    Text(
                                                                      "list_penalties_municipal_violations"
                                                                          .tr(),
                                                                    ),
                                                                  ),
                                                                  SvgPicture
                                                                      .asset(
                                                                      IconPath
                                                                          .linkSquare2)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  isFullHeight: false,
                                                  height: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .height *
                                                      0.5,
                                                );
                                             // }
                                            },
                                            leading: SvgPicture.asset(
                                                IconPath.flag2Icon),
                                            title: Text(
                                              'requirements_fines'.tr(),
                                              style: AppStyle
                                                  .complianceSubtitleLicenseStyle,
                                            ),
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                            ),
                                            showDivider: false,
                                          ),



                                        CostumeListTile(
                                            onTap: () {


                                                CommonFunctions.openComplianceFaq("${viewModel.serviceId}");

                                            },
                                            leading: Icon(
                                              Icons.question_mark,
                                              color: AppColor.greenOpacity,
                                            ),
                                            title: Text(
                                              'complianceFAQ'.tr(),
                                              style: AppStyle
                                                  .complianceSubtitleLicenseStyle,
                                            ),
                                            trailing: const Icon(
                                              Icons.arrow_forward_ios,
                                              size: 16,
                                            ),
                                            showDivider: false,
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox.expand(
                          child: Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).viewPadding.top,
                              ),
                              Row(
                                children: [
                                  const BackButton(color: Colors.white),
                                  Text(
                                    'error'.tr(),
                                    style: AppStyle.violationCreateTitle
                                        .copyWith(color: Colors.white),
                                  ),
                                ],
                              ),
                              ReloadWidget(
                                onTab: () {
                                  viewModel.getServicesCards();
                                },
                              ),
                            ],
                          ),
                        );
            },
          ),
        ),
      ],
    );
  }
}
