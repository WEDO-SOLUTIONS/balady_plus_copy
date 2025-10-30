import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'package:balady_plus/app/core/utils/enums/enums.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/radio_buttons/vertical_radio_group_component.dart';
import '../../../../../commercial_license/presentation/step4/widgets/yes_no_radio_group_widget.dart';
import '../../../../renew_commercial_license_exports.dart'
    show
        CRPreviousNextButtons,
        CleanContractItem,
        GetRenewYearsEvent,
        GetRequestInfoEvent,
        RenewCommercialLicenseBloc,
        RenewCommercialLicenseState;
import '../clean_contract_card.dart';
import '../contracts_widgets/deed_service_contract.dart';
import '../contracts_widgets/ejar_attachment_contract.dart';
import '../contracts_widgets/ejar_service_contract.dart';
import '../contracts_widgets/investment_service_contract.dart';
import 'is_shop_inside_petorl.dart';

class CommercialRenewStep1 extends StatefulWidget {
  const CommercialRenewStep1({super.key});

  @override
  State<CommercialRenewStep1> createState() => _CommercialRenewStep1State();
}

class _CommercialRenewStep1State extends State<CommercialRenewStep1> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            BlocBuilder<RenewCommercialLicenseBloc,
                RenewCommercialLicenseState>(
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropDownWithTitle(
                      title: "no_renew_years".tr(),
                      selectedValue: state.licensePeriod != null
                          ? state.licensePeriod?.toString()
                          : null,
                      status: state.renewYearsStatus,
                      onRetry: () =>
                          context.read<RenewCommercialLicenseBloc>().add(
                                const GetRenewYearsEvent(),
                              ),
                      onTap: () {
                        BottomSheetDialog.showDraggableSheet<String>(
                          context,
                          // dialogKeyName: DialogName.objectablePageProductsFilters,
                          // currentRouteName: CommercialRouteName.objectableTransactions,
                          child: BottomSheetList(
                            title: "no_renew_years".tr(),
                            items: state.renewYears
                                    ?.map((e) => e.toString())
                                    .toList() ??
                                [],
                            selectedValue: state.licensePeriod != null
                                ? state.licensePeriod?.toString()
                                : null,
                            onTap: (item) {
                              context
                                  .read<RenewCommercialLicenseBloc>()
                                  .add(GetRequestInfoEvent(year: item));

                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    ),
                    if (state.calculateInfoRequestStatus == BlocStatus.failure)
                      RetryWidget(
                        onRetry: () {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .add(const GetRequestInfoEvent());
                        },
                      ),
                    if (state.info?.ownershipResponseDto
                            ?.modifyOwnershipWarning !=
                        null)
                      NotesWidget(
                        notes: [
                          state.info!.ownershipResponseDto!
                              .modifyOwnershipWarning!
                        ],
                      ),
                    if ((state.showDeedAttach() ||
                        state.showINVESTAttach() ||
                        state.showEJARAttach() ||
                        state.showDeedService() ||
                        state.showINVESTService() ||
                        state.showEJARService()))
                      LabelTextWithOptional(
                        label: "proof_location_data".tr(),
                        labelColor: AppColor.blackModern700Light,
                        labelSize: 16,
                        labelTextAlign: TextAlign.start,
                        showOptional: false,
                      ),
                    DeedServiceContract(),
                    EjarServiceContract(),
                    InvestmentServiceContract(),
                    AttachContract(),
                    CustomVerticalSpace(height: 16),
                    HorizontalRadioGroup<CRSubmitterType>(
                      groupName: "cr_renew_owner_type".tr(),
                      currentItem: state.crSubmitterType,
                      items: [
                        RadioItem<CRSubmitterType>(
                            radioValue: CRSubmitterType.owner,
                            radioText: "owner_card".tr()),
                        RadioItem<CRSubmitterType>(
                            radioValue: CRSubmitterType.rental,
                            radioText: "renter".tr()),
                      ],
                      onChanged: (value) {
                        context
                            .read<RenewCommercialLicenseBloc>()
                            .updateSubmitterType(value!);
                      },
                    ),
                    if (state.crSubmitterType == CRSubmitterType.owner)
                      HorizontalRadioGroup(
                        groupName: "contractOption".tr(),
                        currentItem: state.crContractType,
                        items: [
                          RadioItem<CRContractType>(
                              radioText: "cr_renew_ownership".tr(),
                              radioValue: CRContractType.deed),
                        ],
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateCRContractType(value!);
                        },
                      ),
                    if (state.crContractType == CRContractType.deed &&
                        state.crSubmitterType == CRSubmitterType.owner)
                      HorizontalRadioGroup<CRContractOption>(
                        groupName: "cr_renew_attach".tr(),
                        currentItem: state.crContractOption,
                        items: [
                          if (state.showAttachDeed())
                            RadioItem<CRContractOption>(
                                radioText: "cr_renew_attach_ownership".tr(),
                                radioValue: CRContractOption.attach),
                          if (state.showServicehDeed())
                            RadioItem<CRContractOption>(
                                radioText: "cr_renew_use_deed".tr(),
                                radioValue: CRContractOption.service),
                        ],
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateCRContractOption(value!);
                        },
                      ),
                    if (state.crContractType == CRContractType.deed &&
                        state.crSubmitterType == CRSubmitterType.owner &&
                        state.crContractOption == CRContractOption.attach) ...[
                      CustomTextFieldWidget(
                        label: "cr_ownership_no".tr(),
                        hintText: "cr_ownership_no".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: state.contractNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateContractNumber(value);
                        },
                      ),
                      HijriCalendarAddetionalField(
                        fieldName: "contractDate".tr(),
                        isMandatory: true,
                        currentVlaue: state.contractDate,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateContractDate(value ?? "");
                        },
                      ),
                    ],
                    if (state.crContractType == CRContractType.deed &&
                        state.crSubmitterType == CRSubmitterType.owner &&
                        state.crContractOption == CRContractOption.service) ...[
                      CustomTextFieldWidget(
                        label: "cr_ownership_no".tr(),
                        hintText: "cr_ownership_no".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: state.contractNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateDeedInfo(deedNumber: value);
                        },
                      ),
                      CustomTextFieldWidget(
                        label: "user_data_applicant_id".tr(),
                        hintText: "user_data_applicant_id".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        errorText: state.deedOwnerIdValidatorErrorText,
                        bottomMargin: 24,
                        initialValue: state.contractNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateDeedInfo(ownerId: value);
                        },
                      ),
                      CustomTextFieldWidget(
                        label: "user_data_applicant_type".tr(),
                        hintText: "user_data_applicant_type".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        enabled: false,
                        initialValue: "سجل تجاري",
                        onChanged: (value) {},
                      ),
                      ElevatedButtonWidget.verify(
                          text: (state.deedVerified ?? false)
                              ? "done_check".tr()
                              : "verify".tr(),
                          onPressed: () {
                            if (state.deedOwnerIdValidator.isValid) {
                              context
                                  .read<RenewCommercialLicenseBloc>()
                                  .getDeedInfoHandler();
                            } else {
                              CommonFunctions.showError(state
                                      .deedOwnerIdValidator.error?.message
                                      .tr() ??
                                  "");
                            }
                          }),
                      const CustomVerticalSpace(
                        height: 16,
                      )
                    ],
                    if (state.crSubmitterType == CRSubmitterType.rental)
                      HorizontalRadioGroup(
                        groupName: 'cr_investment_type'.tr(),
                        currentItem: state.crContractType,
                        items: [
                          RadioItem<CRContractType>(
                              radioText: "rent_contract_1".tr(),
                              radioValue: CRContractType.ejar),
                          RadioItem<CRContractType>(
                              radioText: "invest_contract_2".tr(),
                              radioValue: CRContractType.invest),
                        ],
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateCRContractType(value!);
                        },
                      ),
                    if (state.crContractType == CRContractType.ejar &&
                        state.crSubmitterType == CRSubmitterType.rental)
                      HorizontalRadioGroup<CRContractOption>(
                        groupName: "cr_renew_attach".tr(),
                        currentItem: state.crContractOption,
                        items: [
                          if (state.showAttachEjar())
                            RadioItem<CRContractOption>(
                                radioText: "attach_ejar".tr(),
                                radioValue: CRContractOption.attach),
                          if (state.showServiceEjar())
                            RadioItem<CRContractOption>(
                                radioText: "use_electronic_ejar".tr(),
                                radioValue: CRContractOption.service),
                        ],
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateCRContractOption(value!);
                        },
                      ),
                    if (state.crContractType == CRContractType.ejar &&
                        state.crSubmitterType == CRSubmitterType.rental &&
                        state.crContractOption == CRContractOption.attach &&
                        state.showAttachEjar()) ...[
                      CustomTextFieldWidget(
                        label: "ejar_no".tr(),
                        hintText: "ejar_no".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: state.contractNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateContractNumber(value);
                        },
                      ),
                      HijriCalendarAddetionalField(
                        fieldName: "ejar_end_date".tr(),
                        currentVlaue: state.contractDate,
                        isMandatory: true,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateContractDate(value ?? "");
                        },
                      ),
                    ],
                    if (state.crContractType == CRContractType.ejar &&
                        state.crSubmitterType == CRSubmitterType.rental &&
                        state.crContractOption == CRContractOption.service &&
                        state.showServiceEjar()) ...[
                      CustomTextFieldWidget(
                        label: "contract_number".tr(),
                        hintText: "contract_number".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue:
                            state.ejarInfoRequst?.tenancyContractNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateTenancyInfo(tenancyContractNumber: value);
                        },
                      ),
                      CustomTextFieldWidget(
                        label: "contract_version_no".tr(),
                        hintText: "contract_version_no".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: state.ejarInfoRequst?.versionNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateTenancyInfo(versionNumber: value);
                        },
                      ),
                      CustomTextFieldWidget(
                        label: "ejar_identity_rep".tr(),
                        hintText: "ejar_identity_rep".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: state.ejarInfoRequst?.getId(),
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateTenancyInfo(id: value);
                        },
                      ),
                      ElevatedButtonWidget.verify(
                          text: (state.ejarVerified ?? false)
                              ? "done_check".tr()
                              : "verify".tr(),
                          onPressed: () {
                            context
                                .read<RenewCommercialLicenseBloc>()
                                .getEjarInfoHandler();
                          }),
                      const CustomVerticalSpace(
                        height: 16,
                      )
                    ],
                    if (state.crContractType == CRContractType.invest &&
                        state.crSubmitterType == CRSubmitterType.rental)
                      HorizontalRadioGroup<CRContractOption>(
                        groupName: "enter_contract_method".tr(),
                        currentItem: state.crContractOption,
                        items: [
                          if (state.showAttachInvest())
                            RadioItem<CRContractOption>(
                                radioText: "attach_invest_contract".tr(),
                                radioValue: CRContractOption.attach),
                          if (state.showServiceInvest())
                            RadioItem<CRContractOption>(
                                radioText: "user_attach_invest_contract".tr(),
                                radioValue: CRContractOption.service),
                        ],
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateCRContractOption(value!);
                        },
                      ),
                    if (state.crContractType == CRContractType.invest &&
                        state.crSubmitterType == CRSubmitterType.rental &&
                        state.crContractOption == CRContractOption.service &&
                        state.showServiceInvest()) ...[
                      CustomTextFieldWidget(
                        label: "contract_investment_no".tr(),
                        hintText: "contract_investment_no".tr(),
                        keyboardType: TextInputType.text,
                        bottomMargin: 24,
                        initialValue: state.investmentContractNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateInvestmentContractNumber(value);
                        },
                      ),
                    ],
                    if (state.info?.ownershipResponseDto?.contractWarnings !=
                            null &&
                        state.info!.ownershipResponseDto!.contractWarnings!
                            .isNotEmpty)
                      NotesWidget(notes: [
                        state.info!.ownershipResponseDto!.contractWarnings!
                      ]),

                    /* if (state.crContractType == CRContractType.invest &&
                        state.crSubmitterType == CRSubmitterType.rental &&
                        state.crContractOption == CRContractOption.service &&
                        state.investmentListStatus.isSubmissionSuccess) ...[
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount:
                              state.investmentContractResponse?.items?.length ??
                                  0,
                          itemBuilder: (ctx, index) {
                            return InvestMentContractCard(
                                item: state
                                    .investmentContractResponse!.items![index],
                                onSelect: (InvestmentContractItem? item) {
                                  context
                                      .read<RenewCommercialLicenseBloc>()
                                      .selectInvestmentContract(item);
                                },
                                selected: state.selectedInvestmentContract);
                          }),
                    ],*/

                    VerticalRadioGroup<CRContractCleanRenewOptions>(
                      groupName: "clean_contracts_fees".tr(),
                      currentItem: state.crContractCleanRenewOptions,
                      items: [
                        if (state.cleanContractshowService())
                          RadioItem<CRContractCleanRenewOptions>(
                              radioValue: CRContractCleanRenewOptions.service,
                              radioText: "clean_contrat_baladiyah".tr()),
                        if (state.cleanContractshowPayAll())
                          RadioItem<CRContractCleanRenewOptions>(
                              radioValue: CRContractCleanRenewOptions.payAll,
                              radioText: "clean_contracts_saddad".tr()),
                        if (state.cleanContractshowAttach())
                          RadioItem<CRContractCleanRenewOptions>(
                              radioValue: CRContractCleanRenewOptions.attach,
                              radioText: "clean_contracts_attached".tr()),
                      ],
                      onChanged: (value) {
                        context
                            .read<RenewCommercialLicenseBloc>()
                            .updateCleanOptions(value!);
                      },
                    ),
                    if (state.crContractCleanRenewOptions ==
                        CRContractCleanRenewOptions.attach)
                      HijriCalendarAddetionalField(
                        fieldName: "cr_end_clean_contract".tr(),
                        isMandatory: true,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateCleanContractDate(value ?? "");
                        },
                      ),
                    if (state.crContractCleanRenewOptions ==
                            CRContractCleanRenewOptions.service &&
                        state.contractsListStatus == BlocStatus.success) ...[
                      ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              state.cleanContractsResponse?.items?.length ?? 0,
                          itemBuilder: (ctx, index) {
                            return CleanContractCard(
                                item:
                                    state.cleanContractsResponse!.items![index],
                                onSelect: (CleanContractItem? item) {
                                  context
                                      .read<RenewCommercialLicenseBloc>()
                                      .selectCleanContract(item);
                                },
                                selected: state.selectedCleanContract);
                          }),
                    ],
                    if (state.info?.cleanContractResponseDto?.warnings !=
                            null &&
                        state.info!.cleanContractResponseDto!.warnings!
                            .isNotEmpty)
                      NotesWidget(notes: [
                        state.info!.cleanContractResponseDto!.warnings!
                      ]),
                    if (state.showSalmaExists())
                      YesNoRadioGroupWidget(
                        groupName: "renew_salama_permit_question".tr(),
                        currentValue: state.salamaExists,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateSalamaExists(value);
                        },
                      ),
                    if ((state.showSalamaReport() &&
                            !state.showSalmaExists()) ||
                        (state.showSalamaReport() &&
                            state.salamaExists == false))
                      CustomTextFieldWidget(
                        key: const Key("slamaReportNumber"),
                        label: "slamaReportNumber".tr(),
                        hintText: "slamaReportNumber".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: state.salamaReportNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateSalama(salamaReport: value);
                        },
                      ),
                    if ((state.showSalamaReport() &&
                            !state.showSalmaExists()) ||
                        (state.showSalamaReport() &&
                            state.salamaExists == false))
                      NotesWidget(showText: true, notes: [
                        (state.info?.salamaResponseDto
                                    ?.salamaReportInstructions ??
                                "")
                            .replaceAll("<", "")
                            .replaceAll(">", "")
                      ]),
                    if ((state.showSalamaBill() && !state.showSalmaExists()) ||
                        (state.showSalamaBill() && state.salamaExists == false))
                      CustomTextFieldWidget(
                        key: const Key("slamaBillNumber"),
                        label: "bill_number_name".tr(),
                        hintText: "bill_number_name".tr(),
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: state.salamaBillNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateSalama(salamaBill: value);
                        },
                      ),
                    if ((state.showSalamaBill() && !state.showSalmaExists()) ||
                        (state.showSalamaBill() && state.salamaExists == false))
                      NotesWidget(showText: true, notes: [
                        state.info?.salamaResponseDto?.salamaBillInstructions ??
                            ""
                      ]),
                    if ((state.showSalamaPermit() &&
                            !state.showSalmaExists()) ||
                        (state.showSalamaPermit() &&
                            state.salamaExists == true))
                      CustomTextFieldWidget(
                        key: const Key("slamaNumber"),
                        label: "salamaIssueNo".tr(),
                        hintText: "salamaIssueNo".tr(),
                        bottomMargin: 24,
                        initialValue: state.salamaPermitNumber,
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateSalama(salamaPermit: value);
                        },
                      ),
                    IsShopInsidePetroStationWidget(),
                    (state.status.isSubmissionLoading)
                        ? const Center(child: CustomCircularLoadingWidget())
                        : CRPreviousNextButtons(
                      isBtnDisabled: !state.isFormValid(),
                      onPressed: () {
                        context
                            .read<RenewCommercialLicenseBloc>()
                            .saveInfoRequest();
                      },
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
