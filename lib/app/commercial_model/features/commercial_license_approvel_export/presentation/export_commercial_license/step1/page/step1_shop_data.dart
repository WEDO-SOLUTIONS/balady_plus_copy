import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/export_commercial_license/step1/bloc/step1_shop_data_cubit.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license_approvel_export/presentation/export_commercial_license/step1/widgets/yes_no_radio_group_widget.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';

import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';

import '../../../../../../../features/_shared_feature_/data/entities/radio_item.dart';
import '../../../../../../../features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/notes_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/radio_buttons/horizontal_radio_group_component.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/radio_buttons/vertical_radio_group_component.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/retry_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../../../features/_shared_feature_/presentation/widgets/undertaking_widget.dart';
import '../../../../data/models/board_contract_responseModel.dart';
import '../../../../data/models/clean_contracts_response_entity.dart';
import '../../../../data/models/investment_contracts_response_model.dart';
import '../../../intial_approval/commercial_license/widgets/cr_header_desc.dart';
import '../../../intial_approval/commercial_license/widgets/previous_next_button.dart';
import '../widgets/billboard_component.dart';
import '../widgets/board_contract_card.dart';
import '../widgets/clean_contract_card.dart';
import '../widgets/investment_contract_card.dart';
import '../widgets/is_shop_inside_petorl.dart';
import '../widgets/malls_dropDown.dart';

class Step1ShopData extends StatefulWidget {
  const Step1ShopData({Key? key}) : super(key: key);

  @override
  State<Step1ShopData> createState() => _Step1ShopDataState();
}

class _Step1ShopDataState extends State<Step1ShopData> {
  TextEditingController _deedServiceController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      context.read<Step1ShopDataCubit>().initForm();
      context.read<Step1ShopDataCubit>().salamaBillFawery();
      context.read<Step1ShopDataCubit>().salamaReportFawery();
      context.read<Step1ShopDataCubit>().getDeedOwnerShipsTypes();
      context.read<Step1ShopDataCubit>().getCleanOptions();
      context.read<Step1ShopDataCubit>().getMalls();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<Step1ShopDataCubit, Step1ShopDataState>(
        listener: (context, state) {
      if (state.status == BlocStatus.failure ||
          state.deedOptionsStatus == BlocStatus.failure ||
          state.cleanOptionsStatus == BlocStatus.failure ||
          state.contractsListStatus == BlocStatus.failure ||
          state.investmentListStatus == BlocStatus.failure) {
        CommonFunctions.showError(state.errorMessage ?? "");
      }
    }, builder: (context, state) {

      return Stack(
        children: [

          if (state.draftStatus == BlocStatus.success)
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
                          if (state.samalaBillFawryStatus == BlocStatus.failure)
                            RetryWidget(
                              onRetry: () {
                                context
                                    .read<Step1ShopDataCubit>()
                                    .salamaBillFawery();
                              },
                            ),
                          if (state.samalaReportFawryStatus ==
                              BlocStatus.failure)
                            RetryWidget(
                              onRetry: () {
                                context
                                    .read<Step1ShopDataCubit>()
                                    .salamaReportFawery();
                              },
                            ),
                          CRHeaderDesc(header: "step4Title".tr()),
                          const SizedBox(height: 16),
                          YesNoRadioGroupWidget(
                            groupName: "step4GroupName".tr(),
                            currentValue: state.brand,
                            onChanged: (value) {
                              context
                                  .read<Step1ShopDataCubit>()
                                  .updateFields(brand: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "step6label1".tr(),
                            hintText: "step6hint1".tr(),
                            bottomMargin: 24,
                            initialValue: state.shopName,
                            onChanged: (value) {
                              context
                                  .read<Step1ShopDataCubit>()
                                  .updateFields(shopName: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "step6label2".tr(),
                            hintText: "step6hint2".tr(),
                            isDigitsOnly: true,
                            initialValue: state.shopUnitNumber,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            onChanged: (value) {
                              context
                                  .read<Step1ShopDataCubit>()
                                  .updateFields(shopUnitNumber: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "step6label3".tr(),
                            hintText: "step6hint3".tr(),
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            showOptional: true,
                            initialValue: state.blockNumber,
                            onChanged: (value) {
                              context
                                  .read<Step1ShopDataCubit>()
                                  .updateFields(blockNumber: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "step4label4".tr(),
                            hintText: "step4hint4".tr(),
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            initialValue: state.holesCount,
                            onChanged: (value) {
                              context
                                  .read<Step1ShopDataCubit>()
                                  .updateFields(holesCount: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "step4label5".tr(),
                            hintText: "step4hint5".tr(),
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            initialValue: state.floorCount,
                            onChanged: (value) {
                              context
                                  .read<Step1ShopDataCubit>()
                                  .updateFields(floorCount: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "step4label6".tr(),
                            hintText: "step4hint6".tr(),
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            initialValue: state.noOfCameras,
                            bottomMargin: 24,
                            onChanged: (value) {
                              context
                                  .read<Step1ShopDataCubit>()
                                  .updateFields(noOfCameras: value);
                            },
                          ),
                          if (context
                              .read<Step1ShopDataCubit>()
                              .cameraEndorsmentText
                              .isNotEmpty)
                            UndertakingWidget(
                              text: "cr_pleadge_title".tr(),
                              desc: context
                                  .read<Step1ShopDataCubit>()
                                  .cameraEndorsmentText,
                              onChange: (value) {
                                context
                                    .read<Step1ShopDataCubit>()
                                    .updateEndorsmentAgreement(value);
                              },
                              initialValue: state.endorsmentAgreement ?? false,
                            ),
                          YesNoRadioGroupWidget(
                            groupName: "step4groupName1".tr(),
                            currentValue: state.hasElevator,
                            onChanged: (value) {
                              context
                                  .read<Step1ShopDataCubit>()
                                  .updateFields(hasElevator: value);
                            },
                          ),
                          YesNoRadioGroupWidget(
                            groupName: "step4groupName2".tr(),
                            currentValue: state.existInMall,
                            onChanged: (value) {
                              context
                                  .read<Step1ShopDataCubit>()
                                  .updateExistsInMallFields(existInMall: value);
                            },
                          ),
                          if (state.existInMall == true) ...[
                            MallsDropDown(),
                            CustomTextFieldWidget(
                              label: "step4label8".tr(),
                              hintText: "step4hint8".tr(),
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              initialValue: state.floorNumber,
                              onChanged: (value) {
                                context
                                    .read<Step1ShopDataCubit>()
                                    .updateFields(floorNumber: value);
                              },
                            ),
                          ],
                          IsShopInsidePetroStationWidget(),
                          YesNoRadioGroupWidget(
                            groupName: "step4groupName3".tr(),
                            currentValue: state.isCitizenPledgedToClean,
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<Step1ShopDataCubit>()
                                    .updateIsCitizenPledgedToClean(value);
                              }
                            },
                          ),
                          if (state.isCitizenPledgedToClean == true &&
                              state.cleanContractshowAttach() &&
                              // !state.cleanOptionCLEANCONTRACT() &&
                              !state.cleanOptionBALADIASADAD())
                            HijriCalendarAddetionalField(
                              fieldName: "cr_end_clean_contract".tr(),
                              isMandatory: true,
                              currentVlaue: state.cleanContractEndDate,
                              onChanged: (value) {
                                context
                                    .read<Step1ShopDataCubit>()
                                    .updateCleanContractDate(value ?? "");
                              },
                            ),
                          if (state.isCitizenPledgedToClean == true &&
                              (state.cleanContractshowService() &&
                                  (state.cleanOptionCLEANCONTRACT() ||
                                      state.cleanOptionOPTIONAL())) &&
                              state.contractsListStatus ==
                                  BlocStatus.success) ...[
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: state.cleanContractsResponse?.items
                                        ?.length ??
                                    0,
                                itemBuilder: (ctx, index) {
                                  return CleanContractCard(
                                      item: state.cleanContractsResponse!
                                          .items![index],
                                      onSelect: (CleanContractItemEntity? item) {
                                        context
                                            .read<Step1ShopDataCubit>()
                                            .selectCleanContract(item);
                                      },
                                      selected: state.selectedCleanContract);
                                }),
                          ],
                          if (context
                                  .read<Step1ShopDataCubit>()
                                  .saveLocationResponse
                                  ?.showSalamaPermit ==
                              true) ...[
                            YesNoRadioGroupWidget(
                              groupName: "step4groupName4".tr(),
                              currentValue: state.salamaPermitExist,
                              onChanged: (value) {
                                context
                                    .read<Step1ShopDataCubit>()
                                    .updateSalamaPermitExists(
                                        salamaPermitExist: value);
                              },
                            ),
                            if (state.isFawryReport == true &&
                                state.salamaPermitExist == false)
                              TextWithCheckBtn(
                                title: "slamaReportNumber".tr(),
                                hint: "slamaReportNumber".tr(),
                                textInputType: TextInputType.text,
                                validate: (String? t) {},
                                isValidate:
                                    state.isSalamaReportVerified ?? false,
                                currentValue: state.slamaReportNumber,
                                verify: () {
                                  context
                                      .read<Step1ShopDataCubit>()
                                      .verifySalamaReport();
                                },
                                onTextChanged: (value) {
                                  context
                                      .read<Step1ShopDataCubit>()
                                      .updateSalamaPermitReport(
                                          salamaReportNumber: value);
                                },
                              ),
                            if (state.isFawryBill == true &&
                                state.salamaPermitExist == false)
                              TextWithCheckBtn(
                                title: "bill_number_name".tr(),
                                hint: "write_hint".tr(),
                                validate: (String? t) {},
                                isValidate: state.isSalamaBillVerified ?? false,
                                currentValue: state.slamaBillNumber,
                                topPadding: CommonFunctions.isAppAR ? 0 : 60,
                                verify: () {
                                  context
                                      .read<Step1ShopDataCubit>()
                                      .verifySalamaBill();
                                },
                                onTextChanged: (value) {
                                  context
                                      .read<Step1ShopDataCubit>()
                                      .updateSalamaPermitBill(
                                          salamaBillNumber: value);
                                },
                              ),
                            if (state.salamaPermitExist == true)
                              TextWithCheckBtn(
                                title: "salamaIssueNo".tr(),
                                hint: "salamaIssueNo".tr(),
                                textInputType: TextInputType.text,
                                validate: (String? t) {},
                                isValidate:
                                    state.isSalamaPermitVerified ?? false,
                                currentValue: state.salamaPermitNumber,
                                verify: () {
                                  context
                                      .read<Step1ShopDataCubit>()
                                      .verifySalamaPermit();
                                },
                                onTextChanged: (value) {
                                  context
                                      .read<Step1ShopDataCubit>()
                                      .updateSalamaPermitNumber(
                                          salamaPermitNumber: value);
                                },
                              ),
                            const SizedBox(
                              height: 16,
                            ),
                          ],
                          if (state.crContractType == CRContractType.ejar &&
                              state.crContractOption ==
                                  CRContractOption.service)
                            NotesWidget(
                              notes: [CommonFunctions.getIssueCrWarning2()],
                            ),
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
                                  .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
                                    .updateContractNumber(value);
                              },
                            ),
                            HijriCalendarAddetionalField(
                              fieldName: "contractDate".tr(),
                              isMandatory: true,
                              currentVlaue: state.contractDate,
                              onChanged: (value) {
                                context
                                    .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
                                    .updateDeedInfo(ownershipType: value);
                              },
                            ),
                            TextWithCheckBtn(
                              title: "deed_owner_no".tr(),
                              hint: "deed_owner_no".tr(),
                              validate: (String? t) {},
                              controller: _deedServiceController,
                              isValidate: state.deedVerified ?? false,
                              currentValue: state.contractNumber,
                              verify: () {
                                context
                                    .read<Step1ShopDataCubit>()
                                    .getDeedInfoHandler();
                              },
                              onTextChanged: (value) {
                                context
                                    .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
                                    .updateCRContractType(value!);
                              },
                            ),
                          if (state.crContractType == CRContractType.ejar &&
                              state.crSubmitterType ==
                                  CRSubmitterType.rental) ...[
                            NotesWidget(
                              notes: ["ejar_note".tr()],
                            ),
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
                                    .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
                                    .updateContractNumber(value);
                              },
                            ),
                            HijriCalendarAddetionalField(
                              fieldName: "ejar_end_date".tr(),
                              isMandatory: true,
                              currentVlaue: state.contractDate,
                              onChanged: (value) {
                                context
                                    .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
                                    .updateTenancyInfo(id: value);
                              },
                            ),
                            ElevatedButtonWidget.verify(
                                text: (state.ejarVerified ?? false)
                                    ? "done_check".tr()
                                    : "verify".tr(),
                                onPressed: () {
                                  context
                                      .read<Step1ShopDataCubit>()
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
                                    .read<Step1ShopDataCubit>()
                                    .updateCRContractOption(value!);
                              },
                            ),
                          if (state.crContractType == CRContractType.invest &&
                              state.crSubmitterType == CRSubmitterType.rental &&
                              state.crContractOption ==
                                  CRContractOption.attach) ...[
                            NotesWidget(notes: ["cr_contrct_type".tr()]),
                          ],
                          if (state.crContractType == CRContractType.invest &&
                              state.crSubmitterType == CRSubmitterType.rental &&
                              state.crContractOption ==
                                  CRContractOption.service &&
                              state.investmentListStatus
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
                                            (InvestmentContractItemModel? item) {
                                          context
                                              .read<Step1ShopDataCubit>()
                                              .selectInvestmentContract(item);
                                        },
                                        selected:
                                            state.selectedInvestmentContract);
                                  }),
                            ),
                          ],
                          HorizontalRadioGroup<String>(
                            groupName: 'municipalAdvisorBoards'.tr(),
                            currentItem: state.boardContractSetting,
                            items: [
                              if (state.boardContractsOPTINAL() ||
                                  state.boardContractsContract())
                                RadioItem<String>(
                                    radioText: "cr_add_board_contract".tr(),
                                    radioValue: "CONTRACT"),
                              if (state.boardContractsOPTINAL() ||
                                  state.boardContractsMANUAL())
                                RadioItem<String>(
                                    radioText:
                                        "cr_add_board_data_contract".tr(),
                                    radioValue: "MANUAL"),
                            ],
                            onChanged: (value) {
                              if (value != null) {
                                context
                                    .read<Step1ShopDataCubit>()
                                    .updateBoardContractSetting(value);
                              }
                            },
                          ),
                          if ((state.boardContractSetting == "CONTRACT") &&
                              (state.boardContractsStatus ==
                                  BlocStatus.success)) ...[
                            ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                    state.boardContractItems?.length ?? 0,
                                itemBuilder: (ctx, index) {
                                  return BoardContractCard(
                                      item: state.boardContractItems![index],
                                      onSelect: (BoardContractItem? item) {
                                        context
                                            .read<Step1ShopDataCubit>()
                                            .selectBoardContractNumber(item!);
                                      },
                                      selected: state.boardContractNumber);
                                }),
                          ],
                          if (state.boardContractSetting == "MANUAL") ...[
                            const BillboardComponent(),
                            NotesWidget(
                              notes: [CommonFunctions.getIssueCrWarning3()],
                            ),
                          ]
                        ],
                      ),
                    ),
                  ),
                ),
                (state.status.isSubmissionLoading)
                    ? const Center(child: CustomCircularLoadingWidget())
                    : CRPreviousNextButtons(
                        isBtnDisabled: !state.isFormValid(),
                        onPressed: () {
                          context.read<Step1ShopDataCubit>().save();
                        },
                      ),
              ],
            ),
          if (state.deedOptionsStatus == BlocStatus.failure ||
              state.cleanOptionsStatus == BlocStatus.failure)
            RetryWidget(
              onRetry: () {
                context.read<Step1ShopDataCubit>().getDeedOwnerShipsTypes();
                context.read<Step1ShopDataCubit>().getCleanOptions();
              },
            ),
          if (state.status.isSubmissionLoading ||
              state.deedOptionsStatus == BlocStatus.loading ||
              state.cleanOptionsStatus == BlocStatus.loading ||
              state.contractsListStatus == BlocStatus.loading ||
              state.investmentListStatus == BlocStatus.loading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
