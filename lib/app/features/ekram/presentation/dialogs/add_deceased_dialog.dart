// import 'package:balady_plus/app/core/utils/utils_exports.dart';
// import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
// import 'package:balady_plus/app/features/ekram/domain/entities/add_deceased_dialog_params.dart';
// import 'package:balady_plus/app/features/ekram/presentation/blocs/ekram_add_deceased/ekram_add_deceased_bloc.dart';
// import 'package:balady_plus/app/features/ekram/presentation/widgets/add_deceased/deceased_require_transfer_widget.dart';
// import 'package:balady_plus/app/features/ekram/presentation/widgets/add_deceased/select_burial_destination_widget.dart';
// import 'package:balady_plus/app/features/ekram/presentation/widgets/add_deceased/select_gender_widget.dart';
// import 'package:balady_plus/app/features/ekram/presentation/widgets/add_deceased/select_religion_widget.dart';
// import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:localize_and_translate/localize_and_translate.dart';
//
// import '../../../../core/dependency_injection/injection_container.dart';
// import '../../../../core/services/local/helpers.dart';
// import '../../../../core/utils/enums/bloc_status.dart';
// import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
// import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
// import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
// import '../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
// import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
// import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
// import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
// import '../../../new_appointment/presentation/core/models/lookup_list_model.dart';
// import '../../../vd/presentation/widgets/vd_header_desc_widget.dart';
// import '../widgets/add_deceased/cemetry_burial_date_gorgian.dart';
// import '../widgets/add_deceased/cemetry_burial_date_hijri.dart';
// import '../widgets/add_deceased/cemetry_is_epidamic_widget.dart';
// import '../widgets/add_deceased/cemetry_national_id_date_gorgian.dart';
// import '../widgets/add_deceased/cemetry_national_id_date_hijri.dart';
//
// class AddDeceasedDialog extends StatelessWidget {
//   final AddDeceasedDialogParams params;
//   const AddDeceasedDialog({super.key, required this.params});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) =>
//           EkramAddDeceasedBloc(getNationalities: sl(), params: params),
//       child: BlocConsumer<EkramAddDeceasedBloc, EkramAddDeceasedState>(
//         listener: (context, state) {
//           if (state.status == BlocStatus.failure) {
//             CommonFunctions.showError(state.errorMessage ?? "");
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: Colors.transparent,
//             body: Stack(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Row(
//                         children: [
//                           Expanded(
//                               child: CustomTextWidget(
//                             trans('addDeceased'),
//                             maxLines: 1,
//                             fontSize: 24,
//                             fontColor: AppColor.black,
//                             textAlign: TextAlign.start,
//                           )),
//                           CustomTextButtonWidget(
//                             onPressed: () => Navigator.of(context).pop(),
//                             text: "closeButton".tr(),
//                             btnTextColor: AppColor.grey1000,
//                             btnTextSize: 17.0,
//                             btnTextWeight: AppFontWeight.medium,
//                             btnAlignment: AlignmentDirectional.centerEnd,
//                           ),
//                         ],
//                       ),
//                       Expanded(child: DialogBody()),
//                       ElevatedButtonWidget.custom(
//                         isDisabled: !state.isFormValid(),
//                         text: ("confirm").tr(),
//                         onPressed: () {
//                           Navigator.of(context).pop(state.data);
//                           CommonFunctions.showSuccess(
//                               "add_deceassed_success".tr());
//                         },
//                       ),
//                     ],
//                   ),
//                 ),
//                 if (state.status == BlocStatus.loading)
//                   const CustomCircularLoadingWidget(),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
//
// class DialogBody extends StatefulWidget {
//   const DialogBody({super.key});
//
//   @override
//   State<DialogBody> createState() => _DialogBodyState();
// }
//
// class _DialogBodyState extends State<DialogBody> {
//   final fullNameTextEditController = TextEditingController();
//   final reasonForSpecialTransferTextEditController = TextEditingController();
//
//   final fullNameFocusNode = FocusNode();
//   final reasonForSpecialTransferFocusNode = FocusNode();
//
//   @override
//   void dispose() {
//     fullNameTextEditController.clear();
//     fullNameTextEditController.dispose();
//     reasonForSpecialTransferTextEditController.clear();
//     reasonForSpecialTransferTextEditController.dispose();
//
//     fullNameFocusNode.dispose();
//     reasonForSpecialTransferFocusNode.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<EkramAddDeceasedBloc, EkramAddDeceasedState>(
//       builder: (context, state) {
//         return SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               CustomVerticalSpace(height: 20),
//               VdHeaderDesc(header: "ekram_dead_deads_info".tr()),
//               CustomLookUpLongDialog(
//                 items: state.nationalTypes ?? [],
//                 value: state.data.selectedNationalType,
//                 isDisbaled: state.isFormDisabled(),
//                 onEmptyList: () async {
//                   return context
//                       .read<EkramAddDeceasedBloc>()
//                       .getNationalTypesHandler();
//                 },
//                 onChangeType: (LookUpItem? item) {
//                   print(item?.name);
//                   if (item != null) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeNationalType(item: item));
//                   }
//                 },
//                 label: "cemetry_national_type".tr(),
//                 hint: "cemetry_national_type".tr(),
//               ),
//               CustomTextFieldWidget(
//                   label: "cemetry_national_id".tr(),
//                   hintText: "cemetry_national_id".tr(),
//                   initialValue: state.data.deceassedId,
//                   // controller: otherHospitalTextEditController,
//                   //  focusNode: otherHospitalShipFocusNode,
//                   maxLines: 1,
//                   isDigitsOnly: context
//                       .read<EkramAddDeceasedBloc>()
//                       .numberOnlyInNationalId(),
//                   enabled: !state.isFormDisabled(),
//                   maxLength: 10,
//                   textInputAction: TextInputAction.done,
//                   keyboardType: context
//                           .read<EkramAddDeceasedBloc>()
//                           .numberOnlyInNationalId()
//                       ? TextInputType.number
//                       : TextInputType.text,
//                   onChanged: (String? text) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeNationalId(text: text));
//                   },
//                   onValidate: (String? value) {
//                     return context
//                         .read<EkramAddDeceasedBloc>()
//                         .validateNationalId(value);
//                   }),
//               CustomVerticalSpace(
//                 height: 16,
//               ),
//               CemetryNationalDobHijri(),
//               CemetryNationalDobGorgian(),
//               // if (state.data.selectedNationalType?.fillInfo == false ||)
//               ElevatedButtonWidget.verify(
//                   text: (state.data.userInfoResponse != null)
//                       ? "done_check".tr()
//                       : "verify".tr(),
//                   onPressed: () {
//                     if (state.data.deceassedDOBGorgian?.isEmpty ?? true) {
//                       CommonFunctions.showError("birthDate_required".tr());
//                       return;
//                     }
//
//                     if (context
//                             .read<EkramAddDeceasedBloc>()
//                             .validateNationalId(state.data.deceassedId ?? "") !=
//                         null) {
//                       CommonFunctions.showError("wrong_input_data".tr());
//                       return;
//                     }
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(CheckUserInfoEvent());
//                   }),
//               const CustomVerticalSpace(height: 16),
//               CustomTextFieldWidget(
//                   label: "ekram_first_name".tr(),
//                   hintText: "ekram_first_name".tr(),
//                   controller:
//                       context.read<EkramAddDeceasedBloc>().firstNameController,
//                   enabled: state.allowFillData() && !state.isFormDisabled(),
//                   onChanged: (String? text) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeNameEvent(firstName: text));
//                   },
//                   onValidate: (String? value) {
//                     return null;
//                   }),
//               const CustomVerticalSpace(height: 16),
//               CustomTextFieldWidget(
//                   label: "ekram_second_name".tr(),
//                   hintText: "ekram_second_name".tr(),
//                   controller:
//                       context.read<EkramAddDeceasedBloc>().secondNameController,
//                   enabled: state.allowFillData() && !state.isFormDisabled(),
//                   onChanged: (String? text) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeNameEvent(secondName: text));
//                   },
//                   onValidate: (String? value) {
//                     return null;
//                   }),
//               const CustomVerticalSpace(height: 16),
//               CustomTextFieldWidget(
//                   label: "ekram_third_name".tr(),
//                   hintText: "ekram_third_name".tr(),
//                   controller:
//                       context.read<EkramAddDeceasedBloc>().thirdNameController,
//                   enabled: state.allowFillData() && !state.isFormDisabled(),
//                   onChanged: (String? text) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeNameEvent(thirdName: text));
//                   },
//                   onValidate: (String? value) {
//                     return null;
//                   }),
//               const CustomVerticalSpace(height: 16),
//               CustomTextFieldWidget(
//                   label: "ekram_fourth_name".tr(),
//                   hintText: "ekram_fourth_name".tr(),
//                   enabled: state.allowFillData() && !state.isFormDisabled(),
//                   controller:
//                       context.read<EkramAddDeceasedBloc>().fourthNameController,
//                   onChanged: (String? text) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeNameEvent(fourthName: text));
//                   },
//                   onValidate: (String? value) {
//                     return null;
//                   }),
//               const CustomVerticalSpace(height: 16),
//               CustomLookUpLongDialog(
//                 items: state.nationalities ?? [],
//                 value: state.data.nationalityId,
//                 isDisbaled: state.isFormDisabled(),
//                 onEmptyList: () async {
//                   return context
//                       .read<EkramAddDeceasedBloc>()
//                       .getNationalitiesHandler();
//                 },
//                 onChangeType: (LookUpItem? item) {
//                   // if (item != null) {
//                   //   context
//                   //       .read<EkramAddDeceasedBloc>()
//                   //       .add(ChangeNationalityEvent(item: item));
//                   // }
//                 },
//                 label: ("nationality").tr(),
//                 hint: ("nationality").tr(),
//               ),
//               const CustomVerticalSpace(height: 16),
//               SelectReligionWidget(),
//               const CustomVerticalSpace(height: 16),
//
//               SelectGenderWidget(),
//               CustomVerticalSpace(height: 20),
//               VdHeaderDesc(
//                 header: "burialInfo".tr(),
//               ),
//               CemetryIsEpidamicWidget(),
//               CustomVerticalSpace(height: 16),
//
//               SelectBurialDestinationWidget(),
//               if (state.data.multipleCityRequest == true) ...[
//                 CustomVerticalSpace(height: 16),
//                 CustomLookUpLongDialog(
//                   items: state.burialCities() ?? [],
//                   value: state.data.burialCityId,
//                   isDisbaled: state.isFormDisabled(),
//                   onEmptyList: () async {
//                     return context
//                         .read<EkramAddDeceasedBloc>()
//                         .getCitiesHandler();
//                   },
//                   onChangeType: (LookUpItem? item) {
//                     print(item?.name);
//                     if (item != null) {
//                       context
//                           .read<EkramAddDeceasedBloc>()
//                           .add(ChangeBurialDestinationCityEvent(item: item));
//                     }
//                   },
//                   label: "cemetry_deceassed_burial_city".tr(),
//                   hint: "cemetry_deceassed_burial_city".tr(),
//                 ),
//               ],
//               const CustomVerticalSpace(height: 16),
//               const CemetryBurialDateHijri(),
//               const CemetryBurialDateGorgian(),
//               CustomLookUpLongDialog(
//                 items: state.burialTimeItems ?? [],
//                 value: state.data.selectedTime,
//                 isDisbaled: state.isFormDisabled(),
//                 onEmptyList: () async {
//                   return context
//                       .read<EkramAddDeceasedBloc>()
//                       .getBurialTimesItemsHandler();
//                 },
//                 onChangeType: (LookUpItem? item) {
//                   if (item != null) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeBurialTimevent(item: item));
//                   }
//                 },
//                 label: Helpers.translatingWord("cemetry_deceassed_burial_time"),
//                 hint: Helpers.translatingWord("cemetry_deceassed_burial_time"),
//               ),
//               if (state.data.selectedTime?.id == 30976)
//                 CustomHeaderAndDescOnTapWidget(
//                     label: "cemetry_deceassed_burial_time".tr(),
//                     hintText: state.data.otherTimeName == null
//                         ? "cemetry_deceassed_burial_time".tr()
//                         : state.data.otherTimeName ?? "",
//                     onTap: () {
//                       if (!state.isFormDisabled())
//                         context
//                             .read<EkramAddDeceasedBloc>()
//                             .add(ChangeBurialTimeOtherNameEvent());
//                     }),
//               CustomLookUpLongDialog(
//                 items: state.cemetryTypeItems ?? [],
//                 value: state.data.selectedCemetryType,
//                 isDisbaled: state.isFormDisabled(),
//                 onEmptyList: () async {
//                   return context
//                       .read<EkramAddDeceasedBloc>()
//                       .getCemetryTypeItemsHandler();
//                 },
//                 onChangeType: (LookUpItem? item) {
//                   if (item != null) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeCemetryTypeEvent(item: item));
//                   }
//                 },
//                 label: ("cemetry_type").tr(),
//                 hint: ("cemetry_type").tr(),
//               ),
//               CustomLookUpLongDialog(
//                 items: state.cemetries ?? [],
//                 value: state.data.selectedCemetry,
//                 isDisbaled: state.isCemetryDisabled(),
//                 onEmptyList: () async {
//                   return context
//                       .read<EkramAddDeceasedBloc>()
//                       .getCemetriesHandler();
//                 },
//                 onChangeType: (LookUpItem? item) {
//                   if (item != null) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeCemetryEvent(item: item));
//                   }
//                 },
//                 label: ("cemetry_name").tr(),
//                 hint: ("cemetry_name").tr(),
//               ),
//               NotesWidget(notes: ["ekram_cemetry_note".tr()]),
//
//               if (state.data.baqieApproval != null) ...[
//                 ReadOnlyField(
//                   title: "ekram_baquie_approval_status".tr(),
//                   subTitle: state.data.baqieApproval?.getStatusAr(),
//                 ),
//                 const CustomVerticalSpace(height: 16),
//                 ReadOnlyField(
//                   title: "ekram_baquie_approval_date".tr(),
//                   subTitle: state.data.baqieApproval?.getDate(),
//                 ),
//                 const CustomVerticalSpace(height: 16),
//               ],
//
//               CustomLookUpLongDialog(
//                 items: state.orgnizations ?? [],
//                 value: state.data.selectedOrgnization,
//                 onEmptyList: () async {
//                   return context.read<EkramAddDeceasedBloc>().getOrgnizations();
//                 },
//                 onChangeType: (LookUpItem? item) {
//                   if (item != null) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(SelectOrgnizationEvent(item: item));
//                   }
//                 },
//                 label: ("ekram_orgnization_name").tr(),
//                 hint: ("ekram_orgnization_name").tr(),
//               ),
//
//               NotesWidget(notes: ["ekram_org_note".tr()]),
//               CustomTextFieldWidget(
//                   label: "ekram_permit_no".tr(),
//                   hintText: "ekram_permit_no".tr(),
//                   onChanged: (String? text) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangePermitNumberEvent(text: text));
//                   },
//                   showOptional: true,
//                   onValidate: (String? value) {
//                     return null;
//                   }),
//               CustomVerticalSpace(height: 16),
//
//               VdHeaderDesc(
//                 header: "transferInfo".tr(),
//               ),
//               DeceasedRequiredTransferWidget(),
//               if (state.data.specialTransferNeeded == true) ...[
//                 CustomVerticalSpace(height: 16),
//                 CustomLookUpLongDialog(
//                   items: state.specialNeeds ?? [],
//                   value: state.data.specialTransferReasonId,
//                   onChangeType: (LookUpItem? item) {
//                     context
//                         .read<EkramAddDeceasedBloc>()
//                         .add(ChangeNeedSpecialTransferEvent(item: item));
//                   },
//                   onEmptyList: () async {
//                     return context
//                         .read<EkramAddDeceasedBloc>()
//                         .getSpecialReasonsLookUp();
//                   },
//                   label: ("reasonForSpecialTransfer").tr(),
//                   hint: ("reasonForSpecialTransfer").tr(),
//                 )
//               ],
//               if (state.data.specialTransferReasonId?.id == 30208) ...[
//                 CustomVerticalSpace(height: 16),
//                 CustomTextFieldWidget(
//                     label: trans("reasonForSpecialTransferText"),
//                     hintText: trans("reasonForSpecialTransferText"),
//                     controller: reasonForSpecialTransferTextEditController,
//                     focusNode: reasonForSpecialTransferFocusNode,
//                     maxLines: 1,
//                     textInputAction: TextInputAction.next,
//                     keyboardType: TextInputType.text,
//                     onChanged: (String? text) {
//                       context.read<EkramAddDeceasedBloc>().add(
//                           ChangeNeedSpecialTransferReasonEvent(text: text));
//                     },
//                     onValidate: (String? value) {
//                       return null;
//                     })
//               ],
//               CustomVerticalSpace(height: 10),
//               CustomVerticalSpace(height: 20),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
