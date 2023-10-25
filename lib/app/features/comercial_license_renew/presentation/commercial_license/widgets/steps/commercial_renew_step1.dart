import 'package:balady_plus/app/core/utils/enums/bloc_status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../_shared_feature_/data/entities/radio_item.dart';
import '../../../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_list.dart';
import '../../../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../../_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../../_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../../../_shared_feature_/presentation/widgets/notes_widget.dart';
import '../../../../../_shared_feature_/presentation/widgets/radio_buttons/horizontal_radio_group_component.dart';
import '../../../../../_shared_feature_/presentation/widgets/radio_buttons/vertical_radio_group_component.dart';
import '../../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import '../../../../renew_commercial_license_exports.dart'
    show
        CRPreviousNextButtons,
        CleanContractItem,
        GetRenewYearsEvent,
        GetRequestInfoEvent,
        InvestmentContractItem,
        RenewCommercialLicenseBloc,
        RenewCommercialLicenseState,
        UpdateRenewYearsEvent;
import '../clean_contract_card.dart';
import '../investment_contract_card.dart';

class CommercialRenewStep1 extends StatefulWidget {
  const CommercialRenewStep1({super.key});

  @override
  State<CommercialRenewStep1> createState() => _CommercialRenewStep1State();
}

class _CommercialRenewStep1State extends State<CommercialRenewStep1> {
  TextEditingController _deedServiceController = TextEditingController();

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
                  children: [
                    DropDownWithTitle(
                      title: "مدة التجديد بالسنوات".tr(),
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
                          // currentRouteName: RouteName.objectableTransactions,
                          child: BottomSheetList(
                            title: "مدة التجديد بالسنوات".tr(),
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
                    if (state.info?.ownershipResponseDto
                            ?.modifyOwnershipWarning !=
                        null)
                      NotesWidget(
                        notes: [
                          state.info!.ownershipResponseDto!
                              .modifyOwnershipWarning!
                        ],
                      ),
                    HorizontalRadioGroup<CRSubmitterType>(
                      groupName: 'صفة صاحب المحل',
                      currentItem: state.crSubmitterType,
                      items: [
                        RadioItem<CRSubmitterType>(
                            radioValue: CRSubmitterType.owner,
                            radioText: "مالك"),
                        RadioItem<CRSubmitterType>(
                            radioValue: CRSubmitterType.rental,
                            radioText: "مستأجر"),
                      ],
                      onChanged: (value) {
                        context
                            .read<RenewCommercialLicenseBloc>()
                            .updateSubmitterType(value!);
                      },
                    ),
                    if (state.crSubmitterType == CRSubmitterType.owner)
                      HorizontalRadioGroup(
                        groupName: 'نوع العقد',
                        currentItem: state.crContractType,
                        items: [
                          RadioItem<CRContractType>(
                              radioText: "عقد تملك",
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
                        groupName: 'ارفاق العقد',
                        currentItem: state.crContractOption,
                        items: [
                          RadioItem<CRContractOption>(
                              radioText: "ارفاق عقد التملك",
                              radioValue: CRContractOption.attach),
                          RadioItem<CRContractOption>(
                              radioText: "استخدام رقم عقد الصك الالكتروني",
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
                        label: "رقم عقد التملك",
                        hintText: "رقم عقد التملك",
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
                        fieldName: 'تاريخ عقد التملك',
                        isMandatory: true,
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
                      TextWithCheckBtn(
                        title: "رقم عقد التملك",
                        hint: "رقم عقد التملك",
                        validate: (String? t) {},
                        controller: _deedServiceController,
                        isValidate: false,
                        currentValue: state.contractNumber,
                        verify: () {},
                        onTextChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateContractNumber(value ?? "");
                        },
                      ),
                    ],
                    if (state.crSubmitterType == CRSubmitterType.rental)
                      HorizontalRadioGroup(
                        groupName: 'نوع العقد',
                        currentItem: state.crContractType,
                        items: [
                          RadioItem<CRContractType>(
                              radioText: "عقد الإيجار",
                              radioValue: CRContractType.ejar),
                          RadioItem<CRContractType>(
                              radioText: "عقد استثمار",
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
                        groupName: 'ارفاق العقد',
                        currentItem: state.crContractOption,
                        items: [
                          RadioItem<CRContractOption>(
                              radioText: "إرفاق عقد الإيجار",
                              radioValue: CRContractOption.attach),
                          RadioItem<CRContractOption>(
                              radioText: "استخدام رقم عقد الإيجار الالكتروني",
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
                        state.crContractOption == CRContractOption.attach) ...[
                      CustomTextFieldWidget(
                        label: "رقم عقد الايجار",
                        hintText: "رقم عقد الايجار",
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
                        fieldName: "تاريخ انتهاء عقد الايجار",
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
                        state.crContractOption == CRContractOption.service) ...[
                      CustomTextFieldWidget(
                        label: "رقم العقد",
                        hintText: "رقم العقد",
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: "",
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateTenancyInfo(tenancyContractNumber: value);
                        },
                      ),
                      CustomTextFieldWidget(
                        label: "رقم النسخة",
                        hintText: "رقم النسخة",
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: "",
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateTenancyInfo(versionNumber: value);
                        },
                      ),
                      CustomTextFieldWidget(
                        label: "رقم هوية ممثل المستأجر",
                        hintText: "رقم هوية ممثل المستأجر",
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: "",
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateTenancyInfo(id: value);
                        },
                      ),
                      ElevatedButtonWidget.verify(onPressed: () {
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
                        groupName: 'طريقة ادخال العقد',
                        currentItem: state.crContractOption,
                        items: [
                          RadioItem<CRContractOption>(
                              radioText: "إرفاق عقد الاستثمار",
                              radioValue: CRContractOption.attach),
                          RadioItem<CRContractOption>(
                              radioText: "استخدام رقم عقد الاستثمار الالكتروني",
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
                        state.crContractOption == CRContractOption.service) ...[
                      CustomTextFieldWidget(
                        label: "رقم عقد الإستثمار",
                        hintText: "رقم عقد الإستثمار",
                        isDigitsOnly: true,
                        keyboardType: TextInputType.number,
                        bottomMargin: 24,
                        initialValue: "",
                        onChanged: (value) {
                          context
                              .read<RenewCommercialLicenseBloc>()
                              .updateInvestmentContractNumber(value);
                        },
                      ),
                    ],

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
                      groupName: 'رسوم وعقود النظافة',
                      currentItem: state.crContractCleanRenewOptions,
                      items: [
                        RadioItem<CRContractCleanRenewOptions>(
                            radioValue: CRContractCleanRenewOptions.service,
                            radioText:
                                "التعاقد مع شركات النظافة المؤهلة من الأمانة"),
                        RadioItem<CRContractCleanRenewOptions>(
                            radioValue: CRContractCleanRenewOptions.payAll,
                            radioText: "دفع رسوم جميع النفايات"),
                        RadioItem<CRContractCleanRenewOptions>(
                            radioValue: CRContractCleanRenewOptions.attach,
                            radioText: "عقد نظافة مرفق"),
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
                        fieldName: 'تاريخ انتهاء عقد النظافة',
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
                          physics: NeverScrollableScrollPhysics(),
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
                    CRPreviousNextButtons(
                      isBtnDisabled: false,
                      /* onPressed: () {
                        context
                            .read<RenewCommercialLicenseBloc>()
                            .saveInfoRequest();
                      },*/
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
