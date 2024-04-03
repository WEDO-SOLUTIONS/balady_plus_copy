import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/data/entities/custom_expansion_panel.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/under_testing/custom_enhanced_expansion_panel_list_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_event.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/bloc/compliance_state.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_submission/previous_next_buttons.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/radio_custom.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/features/create_compliance/presentation/widgets/compliance_title_widget.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/dialog_names.dart';
import '../../../../_shared_feature_/presentation/components/bottom_sheets/bottom_sheet_list.dart';
import '../../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../../_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../../_shared_feature_/presentation/widgets/pickers/filter_date_picker.dart';
import '../../../../vd/domain/entities/map/map_screen_params.dart';
import '../../../domain/entities/ownership_doc_type_response.dart';
import '../../bloc/compliance_bloc.dart';
import '../bottom_sheet_list.dart';
import '../compliance_consetnt.dart';
import '../compliance_date_picker.dart';
import '../compliance_ownership_field.dart';
import '../fields/deed/deed_number_date_field.dart';
import '../fields/deed/deed_number_text_field.dart';
import '../fields/deed/deed_type_widget.dart';
import '../fields/electricity/electricity_number_date_field.dart';
import '../fields/electricity/electricity_number_text_field.dart';
import '../fields/electricity/electricity_recipt_type_field.dart';
import '../fields/eskan/eskan_num_text_field.dart';
import '../fields/eskan/eskan_number_date_field.dart';
import '../fields/eskan/eskan_number_text_field.dart';
import '../fields/estehkam/estehkam_number_date_field.dart';
import '../fields/estehkam/estehkam_number_text_field.dart';
import '../fields/investment/investment_number_date_field.dart';
import '../fields/investment/investment_number_text_field.dart';
import '../license_item_widget.dart';

class ThirdSubmissionCompliance extends StatelessWidget {
  const ThirdSubmissionCompliance({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplianceBloc, ComplianceState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ComplianceSubmitTitle(
                  title: 'submission_document'.tr(),
                  subtitle: "",
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextWidget(
                  'choose_document'.tr(),
                  textStyle: AppStyle.complianceDocumentTitleStyle,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleRatioOption(
                      value: 1,
                      selected: state.documentTypeSelection,
                      width: MediaQuery.of(context).size.width * 0.4,
                      title: 'document_1'.tr(),
                      titleStyle: AppStyle.createComplianceRiyadhRadioStyle,
                      onChanged: (int val) {
                        context
                            .read<ComplianceBloc>()
                            .add(UpdateFieldsEvent(documentTypeSelection: 1));

                        context.read<ComplianceBloc>().add(GetLicensesEvent());
                      },
                    ),
                    SingleRatioOption(
                      value: 2,
                      selected: state.documentTypeSelection,
                      width: MediaQuery.of(context).size.width * 0.4,
                      title: 'document_2'.tr(),
                      titleStyle: AppStyle.createComplianceRiyadhRadioStyle,
                      onChanged: (int val) {
                        context
                            .read<ComplianceBloc>()
                            .add(UpdateFieldsEvent(documentTypeSelection: 2));
                      },
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                if (state.documentTypeSelection == 1) ...[
                  Container(
                    width: 321,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: AppColor.primary100Light,
                    ),
                    child: CustomTextWidget(
                      'document_message'.tr(),
                      maxLines: 3,
                      textAlign: TextAlign.right,
                      textStyle: AppStyle.comlianceDocumentMessageStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  CustomTextWidget(
                    'document_dropdown_title'.tr(),
                    textStyle: AppStyle.complianceDocumentTitleStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  DropDownWithTitle(
                    title: "choose_license1".tr(),
                    selectedValue:
                        state.selectedLicense?.licenseId?.toInt().toString() ??
                            "",
                    status: state.licenseStatus,
                    onRetry: () {
                      context.read<ComplianceBloc>().add(
                            const GetLicensesEvent(),
                          );
                    },
                    onTap: () {
                      BottomSheetDialog.showDraggableSheet(
                        context,
                        dialogKeyName: DialogName.complianceChooseLicenseDialog,
                        currentRouteName: RouteName.submitCompliancePage,
                        child: LicenseBottomSheetList(
                          title: "choose_license1".tr(),
                          items: state.licenes?.items ?? [],
                          selectedValue: state.selectedLicense,
                          onTap: (item) {
                            final selectedItem = item;
                            context.read<ComplianceBloc>().add(
                                  UpdateFieldsEvent(
                                    selectedLicense: selectedItem,
                                  ),
                                );
                            Navigator.pop(context);
                          },
                        ),
                      );
                    },
                  ),
                  if (state.selectedLicense != null)
                    ComplianceLicenseItemWidget(
                      status: state.selectedLicense?.statusName,
                      expiryDate: state.selectedLicense?.expirationDate,
                      dueDate: state.selectedLicense?.issuingDate,
                      licenseNo: "${state.selectedLicense?.licenseId?.toInt()}",
                      licenseType: state.selectedLicense?.licenseType,
                      municipality: state.selectedLicense?.municipalityName,
                    ),
                ],
                if (state.documentTypeSelection == 2) ...[
                  /*   DropDownWithTitle(
                    title: "الموقع الجغرافي".tr(),
                    selectedValue: state.gisResponse?.getFullAddress(),
                    onRetry: () {
                      context.read<ComplianceBloc>().add(
                            const GetSubUsagesEvent(),
                          );
                    },
                    onTap: () async {
                      await NavigationService.navigatorKey.currentState!
                          .pushNamed(RouteName.complinaceMapView,
                              arguments: MapScreenParams(
                                  gisParams: state.gisParams,
                                  complianceGIS: state.gisResponse,
                                  requestNo: state.requestId))
                          .then((value) {
                        if (value != null) {
                          MapScreenParams? params = value as MapScreenParams;
                          context.read<ComplianceBloc>().emit(state.copyWith(
                              gisResponse: params.complianceGIS,
                              gisParams: params.gisParams));
                        }
                      });
                    },
                  ),*/
                  DropDownWithTitle(
                    title: "compliance_ownership_type".tr(),
                    selectedValue: state.selectedOwnerShip?.name,
                    status: state.ownerShipsStatus,
                    onRetry: () {
                      context.read<ComplianceBloc>().add(
                            const GetOwnerShipTypesEvent(),
                          );
                    },
                    onTap: () {
                      final List<String> items =
                          (state.ownerShipsTypes?.items ?? [])
                              .map((e) => e.name ?? "")
                              .toList();
                      BottomSheetDialog.showDraggableSheet(context,
                          dialogKeyName: DialogName.complianceOwnerShipseDialog,
                          currentRouteName: RouteName.submitCompliancePage,
                          child: GenericBottomSheetList<ComplinaceLookUpItem>(
                            title: "compliance_ownership_type".tr(),
                            items: (state.ownerShipsTypes?.items ?? [])
                                .where((element) {
                              if (CommonProperties.getCurrentUserProfile()
                                          ?.profileType ==
                                      UserProfileType.Delegator &&
                                  element.id == 146) {
                                return false;
                              }
                              return true;
                            }).toList(),
                            selectedValue: state.selectedOwnerShip,
                            onTap: (item) {
                              final selectedItem =
                                  (state.ownerShipsTypes?.items ?? [])
                                      .where((e) => e == item)
                                      .first;
                              context.read<ComplianceBloc>().add(
                                    UpdateFieldsEvent(
                                      selectedOwnerShip: selectedItem,
                                    ),
                                  );
                              Navigator.pop(context);
                            },
                          ));
                    },
                  ),

                  // صك
                  if (state.selectedOwnerShip?.id == 112) ...[
                    CustomVerticalSpace(height: 12),
                    DeedTypeWidget(),
                    CustomVerticalSpace(height: 12),
                    if (state.isDeedPaper != null) ...[
                      DeadNumberTextField(),
                      CustomVerticalSpace(height: 12),
                      DeedNumberDateField(),
                    ]
                  ],

//عقد اسكان
                  if (state.selectedOwnerShip?.id == 146) ...[
                    CustomVerticalSpace(height: 12),
                    if (state.showEksanId != false) EskanNumberTextField(),
                    if (state.showEksanId == false) ...[
                      EskanNumTextField(),
                      CustomVerticalSpace(height: 12),
                      EskanNumberDateField()
                    ],
                    if (state.landSubsidyContract != null) ...[
//عقد اسكان
                      CustomVerticalSpace(height: 12),
                      ReadOnlyField(
                          title: ("compliance_land_number").tr(),
                          subTitle: state.landSubsidyContract?.contractNumber),
                      CustomVerticalSpace(height: 8),
                      ReadOnlyField(
                          title: ("compliance_land_date").tr(),
                          subTitle: state.landSubsidyContract?.getDate()),
                    ],
                  ],

//ايصال كهرباء او مياه
                  if (state.selectedOwnerShip?.id == 340) ...[
                    ElectricityReciptTypeField(),
                    CustomVerticalSpace(height: 12),
                    ElectricityNumberTextField(),
                    CustomVerticalSpace(height: 12),
                    ElectricityNumberDateField(),
                  ],

                  // عقد استثماري - تخصيص حكومي
                  if (state.selectedOwnerShip?.id == 664) ...[
                    InvestmentNumberTextField(),
                    CustomVerticalSpace(height: 12),
                    InvestmentNumberDateField(),
                  ],
// حجة استحكام
                  if (state.selectedOwnerShip?.id == 690) ...[
                    EstehkamNumberTextField(),
                    CustomVerticalSpace(height: 12),
                    EstehkamNumberDateField()
                  ],

                  /* ComplianceOwnerShipField(),
                  CustomVerticalSpace(height: 12),
                  ComplianceDatePicker(
                    title: "compliance_ownership_date".tr(),
                    initialDateForm: state.form ?? DateForm.hijri,
                    initialDate: state.ownershipDate != null
                        ? state.getOwnerShipDate()
                        : null,
                    endDate: DateTime.now(),
                    onChange: (DateTime time, DateForm form) {
                      context.read<ComplianceBloc>().add(UpdateFieldsEvent(
                          form: form,
                          ownershipDate: time.toHijriFormattedDate1()));
                    },
                  ),*/

                  ComplianceConsent(
                    body: "compliance_ownerShip_body".tr(),
                    agreement: state.ownerShipAgreement ?? false,
                    onChanged: (val) {
                      context.read<ComplianceBloc>().add(
                          UpdateFieldsEvent(ownershipAgreement: val ?? false));
                    },
                  )
                ],
                SizedBox(
                  height: 32,
                ),
                PreviousNextButtons()
              ],
            ),
          ),
        );
      },
    );
  }
}
