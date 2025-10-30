import 'package:balady_plus/app/commercial_model/features/commercial_debts/data/models/commercial_debts_steps.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/bloc/check_debts/commercial_check_debts_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_debts/presentation/pages/check_debts/commercial_debts_screen.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';

import '../../../../../../features/_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/radio_buttons/vertical_radio_group_component.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/commercial_model/features/comercial_license_renew/presentation/commercial_license/widgets/cr_header_desc.dart';
import '../../../../commercial_license/domain/entities/investment_contracts_response.dart';
import '../../../../commercial_license/presentation/step4/widgets/investment_contract_card.dart';
import '../../../old_owner_transfer/persentation/interface/step_interface.dart';
import '../blocs/request_approval_sequence_cubit.dart';

class ApprovalSequenceShopLocationScreen extends StatefulWidget {
  StepInterface stepInterface;

  ApprovalSequenceShopLocationScreen({Key? key, required this.stepInterface})
      : super(key: key);

  @override
  State<ApprovalSequenceShopLocationScreen> createState() =>
      _ApprovalSequenceShopLocationScreenState();
}

class _ApprovalSequenceShopLocationScreenState
    extends State<ApprovalSequenceShopLocationScreen> {
  TextEditingController _deedServiceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context.read<RequestApprovalSequenceCubit>().InitForm();
      context.read<RequestApprovalSequenceCubit>().getDeedOwnerShipsTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return CommercialDebtsScreen(
      transactionType: TransactionType.REQUEST,
      transactionId:
          context.read<RequestApprovalSequenceCubit>().requestNumber!,
      steps: const [OwnershipTransferSteps.saveOwnershipInfo],
      serviceId: CommercialLicenseServiceId.ownershipTransferCommercialLicense,
      child: getBody(),
    );
  }

  Widget getBody() {
    return BlocConsumer<RequestApprovalSequenceCubit,
        RequestApprovalSequenceState>(listener: (context, state) {
      if ((state is DTOState &&
              (state as DTOState).deedOptionsStatus == BlocStatus.failure) ||
          ((state as DTOState).status == BlocStatus.failure) ||
          (state as DTOState).investmentListStatus == BlocStatus.failure) {
        CommonFunctions.showError(state.errorMessage ?? "");
      }
    }, builder: (context, state) {
      return Stack(
        children: [
          if (state is DTOState)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CRHeaderDesc(header: "step4Title".tr()),
                          const SizedBox(height: 16),

                          HorizontalRadioGroup<CRSubmitterType>(
                            groupName: "ekramApplicantType".tr(),
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
                                  .read<RequestApprovalSequenceCubit>()
                                  .updateSubmitterType(value!);
                            },
                          ),
                          if (state.crSubmitterType == CRSubmitterType.owner)
                            HorizontalRadioGroup(
                              groupName: "contractOption".tr(),
                              currentItem: state.crContractType,
                              items: [
                                RadioItem<CRContractType>(
                                    radioText: "ratio1".tr(),
                                    radioValue: CRContractType.deed),
                              ],
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateCRContractType(value!);
                              },
                            ),
                          if (state.crContractType == CRContractType.deed &&
                              state.crSubmitterType == CRSubmitterType.owner)
                            HorizontalRadioGroup<CRContractOption>(
                              groupName: "enter_contract_method".tr(),
                              currentItem: state.crContractOption,
                              items: [
                                if (state.showAttachDeed())
                                  RadioItem<CRContractOption>(
                                      radioText: "cr_attach_file".tr(),
                                      radioValue: CRContractOption.attach),
                                if (state.showServicehDeed())
                                  RadioItem<CRContractOption>(
                                      radioText: "deed_electrnoic_no".tr(),
                                      radioValue: CRContractOption.service),
                              ],
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateCRContractOption(value!);
                              },
                            ),
                          if (state.crContractType == CRContractType.deed &&
                              state.crSubmitterType == CRSubmitterType.owner &&
                              state.crContractOption ==
                                  CRContractOption.attach) ...[
                            CustomTextFieldWidget(
                              label: "deed_owner_no".tr(),
                              hintText: "deed_owner_no".tr(),
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              initialValue: state.contractNumber,
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateContractNumber(value);
                              },
                            ),
                            HijriCalendarAddetionalField(
                              fieldName: "contractDate".tr(),
                              isMandatory: true,
                              currentVlaue: state.contractDate,
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateContractDate(value ?? "");
                              },
                            ),
                          ],

                          if (state.crContractType == CRContractType.deed &&
                              state.crSubmitterType == CRSubmitterType.owner &&
                              state.crContractOption ==
                                  CRContractOption.service) ...[
                            VerticalRadioGroup<String>(
                              groupName: '',
                              currentItem: state.deedInfoRequst?.ownershipType,
                              items: (state.deedOptions ?? []).map((e) {
                                return RadioItem<String>(
                                    radioText: e.tr(), radioValue: e);
                              }).toList(),
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateDeedInfo(ownershipType: value);
                              },
                            ),
                            TextWithCheckBtn(
                              title: "deed_owner_no".tr(),
                              hint: "deed_owner_no".tr(),
                              validate: (String? t) => //&& t!.length > 11
                                  ((t?.isNotEmpty ?? false))
                                      ? null
                                      : "required_field_must_number".tr(),
                              controller: _deedServiceController,
                              isValidate: state.deedVerified ?? false,
                              currentValue: state.contractNumber,
                              verify: () {
                                //check contract number
                                RequestApprovalSequenceCubit bloc = context
                                    .read<RequestApprovalSequenceCubit>();
                                DTOState state = context
                                    .read<RequestApprovalSequenceCubit>()
                                    .state as DTOState;
                                if (state.deedInfoRequst?.ownershipType
                                        ?.isNotEmpty ??
                                    false) {
                                  if (state.deedInfoRequst?.deedNumber
                                          ?.isNotEmpty ??
                                      false) {
                                    bloc.getDeedInfoHandler();
                                  }
                                } else {
                                  //
                                  CommonFunctions.showError(
                                    "most_selected_ownershipType".tr(),
                                  );
                                }
                              },
                              onTextChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateDeedInfo(deedNumber: value);
                              },
                            ),
                          ],
                          if (state.crSubmitterType == CRSubmitterType.rental)
                            HorizontalRadioGroup(
                              groupName: "contractOption".tr(),
                              currentItem: state.crContractType,
                              items: [
                                RadioItem<CRContractType>(
                                    radioText: "cr_rent_contrat".tr(),
                                    radioValue: CRContractType.ejar),
                                RadioItem<CRContractType>(
                                    radioText: "cr_invest_contract".tr(),
                                    radioValue: CRContractType.invest),
                              ],
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateCRContractType(value!);
                              },
                            ),
                          if (state.crContractType == CRContractType.ejar &&
                              state.crSubmitterType ==
                                  CRSubmitterType.rental) ...[
                            NotesWidget(
                              notes: [
                                "${"ejar_note".tr()}<br> ${"ejarAPP".tr()}"
                              ],
                            ),
                            // NotesWidget(
                            //   notes: ["ejarAPP".tr()],
                            // ),

                            HorizontalRadioGroup<CRContractOption>(
                              groupName: "enter_contract_method".tr(),
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
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateCRContractOption(value!);
                              },
                            )
                          ],
                          if (state.crContractType == CRContractType.ejar &&
                              state.crSubmitterType == CRSubmitterType.rental &&
                              state.crContractOption ==
                                  CRContractOption.attach) ...[
                            CustomTextFieldWidget(
                              label: "ejar_no".tr(),
                              hintText: "ejar_no".tr(),
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              initialValue: state.contractNumber,
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateContractNumber(value);
                              },
                            ),
                            HijriCalendarAddetionalField(
                              fieldName: "ejar_end_date".tr(),
                              isMandatory: true,
                              currentVlaue: state.contractDate,
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateContractDate(value ?? "");
                              },
                            ),
                          ],
                          if (state.crContractType == CRContractType.ejar &&
                              state.crSubmitterType == CRSubmitterType.rental &&
                              state.crContractOption ==
                                  CRContractOption.service &&
                              state.showServiceEjar()) ...[
                            CustomTextFieldWidget(
                              label: "cr_clean_contract_number".tr(),
                              hintText: "cr_clean_contract_number".tr(),
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              initialValue:
                                  state.ejarInfoRequst?.tenancyContractNumber,
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateTenancyInfo(
                                        tenancyContractNumber: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              label: "version_no".tr(),
                              hintText: "version_no".tr(),
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              initialValue: state.ejarInfoRequst?.versionNumber,
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
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
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateTenancyInfo(id: value);
                              },
                            ),
                            ElevatedButtonWidget.verify(
                                text: (state.ejarVerified ?? false)
                                    ? "done_check".tr()
                                    : "verify".tr(),
                                onPressed: () {
                                  context
                                      .read<RequestApprovalSequenceCubit>()
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
                                      radioText:
                                          "user_attach_invest_contract".tr(),
                                      radioValue: CRContractOption.service),
                              ],
                              onChanged: (value) {
                                context
                                    .read<RequestApprovalSequenceCubit>()
                                    .updateCRContractOption(value!);
                              },
                            ),
                          // if (state.crContractType == CRContractType.invest &&
                          //     state.crSubmitterType == CRSubmitterType.rental &&
                          //     state.crContractOption ==
                          //         CRContractOption.attach) ...[
                          //   NotesWidget(notes: ["cr_contrct_type".tr()]),
                          // ],
                          if (state.crContractType == CRContractType.invest &&
                              state.crSubmitterType == CRSubmitterType.rental &&
                              state.crContractOption ==
                                  CRContractOption.service &&
                              state.investmentListStatus != null &&
                              state.investmentListStatus!
                                  .isSubmissionSuccess) ...[
                            MediaQuery.removePadding(
                              removeTop: true,
                              context: context,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: state.investmentContractResponse
                                          ?.items?.length ??
                                      0,
                                  itemBuilder: (ctx, index) {
                                    return InvestMentContractCard(
                                        item: state.investmentContractResponse!
                                            .items![index],
                                        onSelect:
                                            (InvestmentContractItem? item) {
                                          context
                                              .read<
                                                  RequestApprovalSequenceCubit>()
                                              .selectInvestmentContract(item);
                                        },
                                        selected:
                                            state.selectedInvestmentContract);
                                  }),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(36),
                        topRight: Radius.circular(36),
                      ),
                      color: Colors.white),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
                  child: state is LoadingState ||
                          ((state is DTOState) &&
                              (state as DTOState).status == BlocStatus.loading)
                      ? const CustomCircularLoadingWidget()
                      : ElevatedButtonWidget.next(
                          onPressed: () {
                            //  if (!state.isFormValid()) {
                            context
                                .read<RequestApprovalSequenceCubit>()
                                .saveData(widget.stepInterface);
                          },
                        ),
                ),
              ],
            ),
          if (state is DTOState &&
              (state as DTOState).deedOptionsStatus == BlocStatus.failure)
            RetryWidget(
              onRetry: () {
                context
                    .read<RequestApprovalSequenceCubit>()
                    .getDeedOwnerShipsTypes();
              },
            ),
          if (state == BlocStatus.loading) const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
