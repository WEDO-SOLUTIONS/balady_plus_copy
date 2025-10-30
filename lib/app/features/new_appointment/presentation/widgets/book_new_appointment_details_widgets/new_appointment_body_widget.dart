import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/check_boxes/checkbox_with_title.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/extensions/arabic_number_text_input_formatter.dart';
import '../../../../_shared_feature_/data/entities/drop_down_item.dart';
import '../../../../_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../core/models/service_config_reseponse.dart';
import '../../core/services/view_models/new_appointment_first_step_view_model.dart';
import '../book_new_appointment_widgets/book_appointment_attachments_widget_new.dart';
import '../book_new_appointment_widgets/book_appointment_special_needs_widget.dart';

class NewAppointmentBody extends StatefulWidget {
  const NewAppointmentBody({Key? key}) : super(key: key);

  @override
  _NewAppointmentBody createState() => _NewAppointmentBody();
}

class _NewAppointmentBody extends State<NewAppointmentBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    NewAppointmentFirstStepViewModel model =
        Provider.of<NewAppointmentFirstStepViewModel>(context, listen: true);
    //LookUpList? submitterList = model.getSubmitterTypeList;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.only(bottom: 85),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //appointment info Section
                const AppointmentInfoSection(),
                // appointment type "radio button"
                if (model.appointmentTypeList != null &&
                    model.appointmentTypeList!.isNotEmpty)
                  const AppointmentTypeWidget(),

                const CustomVerticalSpace(height: 30.0),

                model.serviceConfigResponse?.data?.result!.first
                            .askForWakeelVisit ==
                        true
                    ? CheckBoxWithTitle(
                        title: "did_visit_wakeel".tr(),
                        onChanged: (value) {
                          if (value != null)
                            model.setExistedWakeelVisit = value;
                          model.validateForm();
                        },
                        fontSize: 20,
                      )
                    : const SizedBox.shrink(),
                Constants.verticalSpaceMedium,

                model.serviceConfigResponse?.data?.result!.first
                            .commitmentable ==
                        true
                    ? CheckBoxWithTitle(
                        title: "accepted_agreement".tr(),
                        maxlines: 5,
                        height: 1.2,
                        onChanged: (value) {
                          if (value != null) model.setAgreementStatus = value;
                          model.validateForm();
                        },
                        fontSize: 20,
                      )
                    : const SizedBox.shrink(),

                Constants.verticalSpaceMedium,

                const AppointmentAttachmentSection(),

                Constants.verticalSpaceMedium,
                // special needs
                // if (model.showSpecialConditionSection())
                //   BookAppointmentSpecialNeedsWidget(
                //     value: model.isSpecialConditionChecked,
                //     onSelected: (bool? isChecked) {
                //       model.hideKeyboard();
                //       model.isSpecialConditionChecked = isChecked;
                //     },
                //   ),
                // Constants.verticalSpaceMedium,
              ]),
        ),
      ),
    );
  }
}

class AppointmentInfoSection extends StatefulWidget {
  const AppointmentInfoSection({Key? key}) : super(key: key);

  @override
  State<AppointmentInfoSection> createState() => _AppointmentInfoSection();
}

class _AppointmentInfoSection extends State<AppointmentInfoSection> {
  final FocusNode _descFocusNode = FocusNode();
  final FocusNode _transactionNoFocusNode = FocusNode();

  final FocusNode _otherServiceNameNoFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    //modelGlobal.resetVariables();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("HERRR");
    NewAppointmentFirstStepViewModel model =
        Provider.of<NewAppointmentFirstStepViewModel>(context, listen: true);
    return Column(
      children: <Widget>[
        //MM
        /* CustomSectionHeaderWithImg(
          title: Helpers.translatingWord(
              'bookNewAppointmentAppointmentInformationWord'),
          img: "titleItemsIconAppointment@3x.png",
        ),*/
        const CustomVerticalSpace(height: 16),
        if (model.categoriesList.isNotEmpty)
          CustomTapWidgetForLongDialog(
            items: model.categoriesList,
            value: model.catetgoryType,
            onChangeType: (DropDownItem? item) {
              print(item);
              if (item != null) model.catetgoryType = item;
              model.validateForm();
            },
            label: ("bookNewAppointmentVisitCategoryWord").tr(),
            hint: ("bookNewAppointmentVisitCategoryWord").tr(),
            searchHint: ("searchFor").tr(),
          ),

        CustomTapWidgetForLongDialog(
          items: model.municipalitiesList,
          value: model.municipalityType,
          onChangeType: (DropDownItem? item) {
            if (item != null && item.externalSystem == false) {
              model.getSubMunicipalities(item);
              model.validateForm();
            } else if (item != null && item.externalSystem == true) {
              CommonFunctions.showError(
                  "${"redircetionMessage1".tr()}${item.name}${"redircetionMessage2".tr()}"
                  "<a href=\"${item.externalSystemUrl}\"> ${"here".tr()}</a>",
                  true);

              //
            }
          },
          label: ("homeUpComingAppointmentMunicipality").tr(),
          hint: ("bookNewAppointmentMunicipalityDropDownHintWord").tr(),
          searchHint: ("search_for_municipality").tr(),
        ),
        CustomTapWidgetForLongDialog(
          items: model.subMunicipalitiesList,
          value: model.subMunicipalityType,
          onChangeType: (DropDownItem? item) {
            if (item != null) model.getMainClassifications(item);
            model.validateForm();
          },
          label: ("homeUpComingAppointmentMunicipalEntity").tr(),
          hint: ("bookNewAppointmentMunicipalDropDownHintWord").tr(),
          searchHint: ("search_for_sub_municipality").tr(),
          errorText: ('select_municipality_first').tr(),
        ),
        CustomTapWidgetForLongDialog(
          items: model.mainClassList,
          value: model.mainClassType,
          onChangeType: (DropDownItem? item) {
            if (item != null) model.getSubClassifications(item);
            model.validateForm();
          },
          label: ("service_main_classification").tr(),
          hint: ("service_main_classification_hint").tr(),
          searchHint: ("search_for_main_classification").tr(),
          errorText: ('select_sub_municipality_first').tr(),
          showOptional: false,
        ),
        CustomTapWidgetForLongDialog(
          items: model.subClassList,
          value: model.subClassType,
          onChangeType: (DropDownItem? item) {
            if (item != null) model.getServiceConfig(item);
            model.validateForm();
          },
          label: ("service_sub_main_classification").tr(),
          hint: ("service_sub_main_classification_hint").tr(),
          searchHint: ("search_for_sub_classification").tr(),
          errorText: ('select_main_classification_first').tr(),
          showOptional: false,
        ),
        // CustomTapWidgetForLongDialog(
        //   items: model.departmentsList,
        //   value: model.departmentType,
        //   onChangeType: (DropDownItem? item) {
        //     setState(() {
        //       model.departmentType = item;
        //     });
        //     //  if (item != null) model.getDepartment1(item);
        //   },
        //   label: Helpers.translatingWord(
        //       "bookNewAppointmentDesiredServiceDropDownTitleWord"),
        //   hint: Helpers.translatingWord(
        //       "bookNewAppointmentDesiredServiceDropDownHintWord"),
        //   searchHint: Helpers.translatingWord("search_for_service"),
        // ),
        /*if (model.selectedSubClassItem?.isOther == true)
          CustomTextFieldWidget(
            controller: model.otherServiceNameController,
            focusNode: _otherServiceNameNoFocusNode,
            label: ("service_name").tr(),
            hintText: ("service_name_hint").tr(),
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.next,
            fillColor: Colors.transparent,
            onSubmitted: (_) {
              FocusScope.of(context).requestFocus(model.withPreviousTransaction
                  ? _transactionNoFocusNode
                  : _descFocusNode);
            },
            onValidate: (text) {
              if (text.toString().isEmpty) {
                return ('text_field_error').tr();
              }
              return null;
            },
            onChanged: (text) {
              model.setServiceName = text;
              model.validateForm();
            },
          ),*/
        const CustomVerticalSpace(height: 16),
        CustomTextFieldWidgetWithOptinal(
          controller: model.dataModel.transactionNoController,
          focusNode: _transactionNoFocusNode,
          label: model.serviceConfigResponse?.data?.result?.first
                      .prevTransNoRequired ==
                  true
              ? ("bookNewAppointmentServiceNumberFieldLabelWord").tr()
              : ("bookNewAppointmentServiceNumberFieldLabelWord").tr(),
          hintText: ("bookNewAppointmentServiceNumberFieldHintWord").tr(),
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          fillColor: Colors.transparent,
          onSaved: (_) {
            FocusScope.of(context).requestFocus(_descFocusNode);
          },
          inputFormatter: [
            FilteringTextInputFormatter.allow(RegExp(r'[\u0600-\u06FF0-9]')),
            LengthLimitingTextInputFormatter(50)
          ],
          validator: (text) {
            if (text.toString().isEmpty) {
              return ('text_field_error').tr();
            }
            return null;
          },
          onChanged: (text) {
            model.setTransactionNo = text;
            model.validateForm();
          },
        ),
        const CustomVerticalSpace(height: 16),
        if (model.serviceConfigResponse?.getDepartmentName() != null)
          FieldData(
              title: ("bookNewAppointmentAppointmentAreaWord").tr(),
              subTitle: model.serviceConfigResponse?.getDepartmentName()),
        const CustomVerticalSpace(height: 16),

        if (model.dataModel.isRealEstate()) ...[
          TextWithCheckBtn(
            title: "realEstateRequestId".tr(),
            hint: "realEstateRequestId".tr(),
            textInputType: TextInputType.text,
            backgroundColor: Colors.transparent,
            controller: model.dataModel.realEstateRequestIdController,
            validate: (String? t) {},
            isValidate: model.dataModel.requestRealStateVerified ?? false,
            currentValue: model.dataModel.realEstateRequestId,
            verify: () {
              model.checkRealStateRequest();
            },
            onTextChanged: (value) {
              model.dataModel.realEstateRequestId = value;
              model.dataModel.requestRealStateVerified = false;
              model.validateForm();
            },
            showToolTip: true,
            toolTipMessage: "realEstateRequestIdNote".tr(),
          ),
          const CustomVerticalSpace(height: 16),
          CustomTextFieldWidget(
            controller: model.dataModel.realEstateSurveyIdController,
            fillColor: Colors.transparent,
            label: ("realEstateSurveyId").tr(),
            hintText: ("realEstateSurveyId").tr(),
            maxLines: 1,
            keyboardType: TextInputType.text,
            inputFormatters: const [],
            onValidate: (text) {
              if (text.toString().isEmpty) {
                return ('text_field_error').tr();
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              model.dataModel.realEstateSurveyId = text;
              model.validateForm();
            },
          ),
          const CustomVerticalSpace(height: 16),
          CustomTextFieldWidget(
            controller: model.dataModel.realEstateIdController,
            fillColor: Colors.transparent,
            label: ("realEstateId").tr(),
            hintText: ("realEstateId").tr(),
            maxLines: 1,
            keyboardType: TextInputType.text,
            inputFormatters: const [],
            onValidate: (text) {
              return null;
            },
            textInputAction: TextInputAction.done,
            onChanged: (text) {
              model.dataModel.realEstateId = text;
              model.validateForm();
            },
          ),
          const CustomVerticalSpace(height: 16),
        ],

        CustomTextFieldWidget(
          controller: model.dataModel.descController,
          focusNode: _descFocusNode,
          fillColor: Colors.transparent,
          label: ("bookNewAppointmentNotesFieldLabelWord").tr(),
          hintText: ("appointment_purpose_hint").tr(),
          maxLength: 500,
          maxLines: 4,
          keyboardType: TextInputType.multiline,
          inputFormatters: [
            ArabicNumberTextInputFormatter(onError: (bool isValid) {
              //  if (!isValid)
              //    CommonFunctions.showError("only_english_numbers".tr());
            }),
          ],
          onValidate: (text) {
            if (text.toString().isEmpty) {
              return ('text_field_error').tr();
            } else {
              if (!CommonFunctions.hasArabicCharacters(text.toString()) &&
                  CommonFunctions.isAppAR) {
                return ("error_only_arabic").tr();
              }
              if (!CommonFunctions.hasArabicAndEnglishCharacters(
                      text.toString()) &&
                  !CommonFunctions.isAppAR) {
                return ("error_only_arabic").tr();
              }
              if (text.toString().length < 20) {
                return ("error_less_20").tr();
              }
            }
            return null;
          },
          textInputAction: TextInputAction.done,
          onChanged: (text) {
            model.setAppointmentDetails = text;
            model.validateForm();
          },
        ),
      ],
    );
  }
}

class AppointmentTypeWidget extends StatefulWidget {
  const AppointmentTypeWidget({Key? key}) : super(key: key);

  @override
  _AppointmentTypeWidgetState createState() => _AppointmentTypeWidgetState();
}

class _AppointmentTypeWidgetState extends State<AppointmentTypeWidget> {
  /*List<LookUpItem> list = [
    LookUpItem(
        id: 1,
        name: Helpers.translatingWord(
            'bookNewAppointmentPresenceRadioButtonWord')),
    LookUpItem(
        id: 2,
        name: Helpers.translatingWord(
            'bookNewAppointmentRemotelyRadioButtonWord'))
  ];*/
  // LookUpItem? currentSelected;

  @override
  Widget build(BuildContext context) {
    NewAppointmentFirstStepViewModel model =
        Provider.of<NewAppointmentFirstStepViewModel>(context, listen: true);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //MM
        /*CustomSectionHeaderWithImg(
          title:
              ('bookNewAppointmentAppointmentTypeWord').tr(),
          img: "titleItemsIconAppointment@3x.png",
        ),*/

        // types
        ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: model.appointmentTypeList?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (ctx, index) {
              return CustomRadioButtonEnd<VisitType>(
                title: model.appointmentTypeList![index].name ?? "",
                value: model.appointmentTypeList![index],
                currentSelected: model.appointmentTypeItem,
                onChange: onItemChanged,
                endRadio: false,
                unSelectedBackgroundColor: Colors.transparent,
                textSize: 16,
              );
            }),
      ],
    );
  }

  void onItemChanged(VisitType? item) {
    NewAppointmentFirstStepViewModel model =
        Provider.of<NewAppointmentFirstStepViewModel>(context, listen: false);
    model.hideKeyboard();
    setState(() {
      if (item?.id != null) {
        model.setAppointmentTypeItem = item;
        model.validateForm();
      }
    });
  }
}
