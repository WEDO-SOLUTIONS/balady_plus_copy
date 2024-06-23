import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/summery_widgets/field_data.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/base/base_view.dart';
import '../../../../../core/base/base_view_model.dart';
import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../../core/utils/enums/license_types.dart';
import '../../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../../_shared_feature_/presentation/dialogs/incident_type_with_search_dialog.dart';
import '../../../../_shared_feature_/presentation/fields/read_only_field.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_cupertino_drop_down_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_popups_widgets.dart';

import '../../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../../vd/presentation/widgets/vd_header_desc_widget.dart';
import '../../blocs/new_health_certificate_bloc/new_health_certificate_bloc.dart';
import '../../core/models/license_for_health_information_response.dart';
import '../../core/models/licesnse_type.dart';
import '../../core/models/list_response.dart';
import '../../core/services/view_models/new_details_health_license_view_model.dart';
import '../../core/services/view_models/new_health_license_view_model.dart';
import '../../core/services/view_models/new_terms_health_license_view_model.dart';
import '../../widgets/new_health_certificate_widgets/previous_next_buttons.dart';

ScrollController scrollController = ScrollController();

class CertificateInfoStepScreen extends StatefulWidget {
  final bool? isRenew;

  const CertificateInfoStepScreen({Key? key, this.isRenew}) : super(key: key);

  @override
  _CertificateInfoStepScreenState createState() =>
      _CertificateInfoStepScreenState();
}

class _CertificateInfoStepScreenState extends State<CertificateInfoStepScreen> {
  final model = locator<NewDetailsHealthLicenseViewModel>();

  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    //MM Helpers.sendEventToAnalytics(AppEvents.HealthCertificate_Apply_Details);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewHealthCertificateBloc, NewHealthCertificateState>(
      builder: (context, state) {
        bool isLastPage = context.read<NewHealthCertificateBloc>().isLastPage();

        return BaseView<NewTermsHealthLicenseViewModel>(
            onModelReady: (model) {},
            builder: (context, pledgeModel, child) {
              return BaseView<NewDetailsHealthLicenseViewModel>(
                  onModelReady: (model) {},
                  builder: (context, model, child) {
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Container(
                              padding: const EdgeInsets.only(bottom: 85),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    //personal info Section
                                    PersonalInfoSection(),
                                    //location section
                                    JobLocationSection(),
                                  ]),
                            ),
                          ),
                        ),
                        //MM

                        PreviousNextButtons(
                          isFormValid: model.isFormValid,
                          onConfirm: () async {
                            final model = locator<HealthLicenseViewModel>();

                            List<String>? terms = await model.getTerms();
                            print("terms $terms");
                            if (terms == null) return;
                            model.hideKeyboard();
                            if (!isLastPage && terms.isNotEmpty) {
                              context
                                  .read<NewHealthCertificateBloc>()
                                  .add(GoToNextPageEvent());
                            } else {
                              model.hideKeyboard();
                              pledgeModel.submit().then((value) {});
                            }
                          },
                        )
                      ],
                    );
                  });
            });
      },
    );
  }
}

class PersonalInfoSection extends StatefulWidget {
  const PersonalInfoSection({Key? key}) : super(key: key);

  @override
  State<PersonalInfoSection> createState() => _PersonalInfoSectionState();
}

class _PersonalInfoSectionState extends State<PersonalInfoSection> {
  final model = locator<NewDetailsHealthLicenseViewModel>();

  //final FocusNode _nameFocusNode = FocusNode();

  //final FocusNode _phoneFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nameController.text = model.userFullName;
    _phoneController.text = model.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomVerticalSpace(height: 16),
        VdHeaderDesc(
          header: ("moreSectionAccountPersonalInfoWord").tr(),
          desc: Helpers.translatingWord('check_info_desc'),
        ),
        ReadOnlyField(
          title: Helpers.translatingWord("full_name"),
          subTitle: model.userFullName,
        ),
        ReadOnlyField(
          title: Helpers.translatingWord("lbl_mobile_hint1"),
          subTitle: model.mobile,
        )
      ],
    );
  }
}

class JobLocationSection extends StatefulWidget {
  const JobLocationSection({Key? key}) : super(key: key);

  @override
  State<JobLocationSection> createState() => _JobLocationSectionState();
}

class _JobLocationSectionState extends State<JobLocationSection> {
  final model = locator<NewDetailsHealthLicenseViewModel>();

  @override
  Widget build(BuildContext context) {
    return BaseView<NewDetailsHealthLicenseViewModel>(
        onModelReady: (model) {},
        builder: (context, model, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CustomVerticalSpace(height: 16),
              VdHeaderDesc(
                header: ("job_location").tr(),
                desc: Helpers.translatingWord('job_location_desc'),
              ),

              CustomHeaderAndDescOnTapWidget(
                label: Helpers.translatingWord("job_address"),
                hintText: Helpers.translatingWord("select_address_from_map"),
                textValue: model.getAddress(),
                materialIconDirection: Helpers.isArabic(context)
                    ? MATERIAL_ICON_DIRECTION.left
                    : MATERIAL_ICON_DIRECTION.right,
                onTap: () {
                  model.hideKeyboard();
                  /* setState(() {
                          showLocationInfo = true;
                          // showCommercialSection = true;
                          showLicenseSection = true;
                        });

                        WidgetsBinding.instance
                            ?.addPostFrameCallback((_) => _scrollToEnd());*/

                  model.navigateToMapScreen(context).then((value) {
                    WidgetsBinding.instance
                        ?.addPostFrameCallback((_) => _scrollToEnd());
                    model.validateForm();
                    setState(() {});
                  });
                },
                icon: const Icon(Icons.location_on,
                    color: AppColor.primary900Light),
              ),

              // location info section
              Visibility(
                visible: model.getAddress() != null,
                child: LocationInfoSection(
                  district: model.gisLocationResult?.Balady_DistrictName ?? "",
                  municipality:
                      model.gisLocationResult?.adminMunicipalityName ?? "",
                  subMunicipality:
                      model.gisLocationResult?.subMunicipalityName ?? "",
                  region: model.gisLocationResult?.region ?? "",
                ),
              ),
              HealthCentersSection(),
              // Commercial Register Section
              Visibility(
                visible: model.showCommercialNo(),
                child: CommercialRegisterSection(),
              ),
              Visibility(visible: model.showLicense(), child: LicenseSection()),
            ],
          );
        });
  }
}

class LocationInfoSection extends StatelessWidget {
  final String region;
  final String district;
  final String municipality;
  final String subMunicipality;

  LocationInfoSection(
      {Key? key,
      required this.district,
      required this.municipality,
      required this.region,
      required this.subMunicipality})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomVerticalSpace(height: 16),
        VdHeaderDesc(
          header: ("address_details").tr(),
          desc: Helpers.translatingWord('check_location_info'),
        ),
        ReadOnlyField(
            title: Helpers.translatingWord("region"), subTitle: region),
        ReadOnlyField(
            title: Helpers.translatingWord("district"), subTitle: district),
        ReadOnlyField(
            title: Helpers.translatingWord(
                "homeUpComingAppointmentMunicipalityWord"),
            subTitle: municipality),
        ReadOnlyField(
            title:
                Helpers.translatingWord("homeUpComingAppointmentMunicipalWord"),
            subTitle: subMunicipality),
      ],
    );
  }
}

class HealthCentersSection extends StatelessWidget {
  HealthCentersSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = locator<NewDetailsHealthLicenseViewModel>();
    return Visibility(
      visible: model.isCenterRequired(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomVerticalSpace(height: 16),
          /* CustomSectionHeaderWithImg(
              title: Helpers.translatingWord('address_details'),
              img: "titleItemsIconLocation@3x.png",
              desc: Helpers.translatingWord('check_location_info')),*/

          if (model.dataModel.cities.isNotEmpty)
            CustomHeaderAndDescOnTapWidget(
              label: Helpers.translatingWord("city"),
              hintText: Helpers.translatingWord("city_select"),
              textValue: model.dataModel.selectedCity?.name,
              onTap: () async {
                model.hideKeyboard();
                await CustomPopUpsWidgets.showBottomSheet(
                  NavigationService.navigatorKey.currentContext!,
                  child: IncidentTypeWithSearchDialog(
                    title: Helpers.translatingWord('city_select'),
                    searchHint: Helpers.translatingWord('city_select'),
                    onSelect: (DropDownItem item) async {
                      bool isSuccess = await model.getCenters(item.id ?? "");

                      if (isSuccess) {
                        model.dataModel.selectedHealthCentres = null;
                        model.dataModel.selectedCity = ListItem(
                            id: item.id,
                            idNumber: int.tryParse(item.id ?? ""),
                            name: item.name);
                      } else {
                        model.dataModel.selectedCity = null;
                        model.dataModel.healthCentres = [];
                      }
                      model.validateForm();
                      model.notifyListeners();
                    },
                    items: model.dataModel.cities
                        .map((e) => DropDownItem(name: e.name ?? "", id: e.id))
                        .toList(),
                    selectedItem: DropDownItem(
                        id: model.dataModel.selectedCity?.id,
                        name: model.dataModel.selectedCity?.name ?? ""),
                  ),
                );
              },
            ),
          if (model.dataModel.healthCentres.isNotEmpty)
            CustomHeaderAndDescOnTapWidget(
              label: Helpers.translatingWord("health_center"),
              hintText: Helpers.translatingWord("health_center_select"),
              textValue: model.dataModel.selectedHealthCentres?.name,
              onTap: () async {
                model.hideKeyboard();
                await CustomPopUpsWidgets.showBottomSheet(
                  NavigationService.navigatorKey.currentContext!,
                  child: IncidentTypeWithSearchDialog(
                    title: Helpers.translatingWord('health_center_select'),
                    searchHint: Helpers.translatingWord('health_center_select'),
                    onSelect: (DropDownItem item) {
                      model.dataModel.selectedHealthCentres = ListItem(
                          id: item.id,
                          idNumber: int.tryParse(item.id ?? ""),
                          name: item.name);
                      model.validateForm();

                      model.notifyListeners();
                    },
                    items: model.dataModel.healthCentres
                        .map((e) => DropDownItem(name: e.name ?? "", id: e.id))
                        .toList(),
                    selectedItem: DropDownItem(
                        id: model.dataModel.selectedHealthCentres?.id,
                        name: model.dataModel.selectedCity?.name ?? ""),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class CommercialRegisterSection extends StatefulWidget {
  CommercialRegisterSection({Key? key}) : super(key: key);

  @override
  State<CommercialRegisterSection> createState() =>
      _CommercialRegisterSection();
}

class _CommercialRegisterSection extends State<CommercialRegisterSection> {
  final model = locator<NewDetailsHealthLicenseViewModel>();
  final FocusNode _commercialFocusNode = FocusNode();
  final TextEditingController _commercialController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _commercialController.text = model.dataModel.crNumber ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        /*   CustomSectionHeaderWithImg(
            title: Helpers.translatingWord('commercial_register'),
            img: "iconContractInfo@3x.png",
            desc: Helpers.translatingWord('commercial_register_desc')),*/
        CustomTextFieldWidget(
          controller: _commercialController,
          focusNode: _commercialFocusNode,
          label: Helpers.translatingWord("commercial_register"),
          hintText: Helpers.translatingWord("commercial_register"),
          obsecureText: false,
          fillColor: Colors.transparent,
          keyboardType: TextInputType.number,
          onChanged: (String v) {
            model.crNumber = v;
            model.changeCRAndLicenseValidation();
          },
          onValidate: (text) {
            /*if (!Helpers.doesContainsLettrs(text.toString())) {
              return Helpers.translatingWord('text_field_error');
            }*/
            return null;
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (model.isCrVerified)
                Image.asset(
                  Constants.imgPath + "circle_check@3x.png",
                  height: 12,
                  width: 12,
                ),
              const CustomHorizontalSpace(width: 5),
              CustomTextButtonWidget(
                  onPressed: !model.isCrVerified
                      ? () {
                          if (_commercialController.text.isNotEmpty) {
                            model
                                .getCrInfo(_commercialController.text)
                                .then((value) {
                              if (value) {
                                FocusScope.of(context).unfocus();
                                WidgetsBinding.instance?.addPostFrameCallback(
                                    (_) => _scrollToEnd());
                                setState(() {});
                                model.validateForm();
                              }
                            });
                          } else {
                            CommonFunctions.showError(
                                Helpers.translatingWord("cr_hint"));
                          }
                        }
                      : () {},
                  text: model.isCrVerified
                      ? Helpers.translatingWord('recall_done')
                      : Helpers.translatingWord('recall'),
                  btnTextColor: AppColor.baladyDarkGreen2,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextSize: 13,
                  btnAlignment: AlignmentDirectional.centerEnd,
                  haveUnderline: model.isCrVerified ? false : true),
            ],
          ),
        ),
        CustomVerticalSpace(height: 16),
        Visibility(
          visible: model.isCrVerified,
          child: CommercialRegisterationInfoSection(
            commercialIssue:
                model.crInformation?.data?.result?.crInfo?.cityAr ?? "",
            facilityName:
                model.crInformation?.data?.result?.crInfo?.nameAr ?? "",
            facilityNumber:
                model.crInformation?.data?.result?.crInfo?.nationalNumber ?? "",
          ),
        )
      ],
    );
  }
}

class CommercialRegisterationInfoSection extends StatelessWidget {
  final String facilityName;
  final String facilityNumber;
  final String commercialIssue;

  const CommercialRegisterationInfoSection(
      {Key? key,
      required this.commercialIssue,
      required this.facilityName,
      required this.facilityNumber})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ReadOnlyField(
            title: Helpers.translatingWord("facility_name"),
            subTitle: facilityName),
        ReadOnlyField(
            title: Helpers.translatingWord("facility_number"),
            subTitle: facilityNumber),
        ReadOnlyField(
            title: Helpers.translatingWord("commercial_register_source"),
            subTitle: commercialIssue),
      ],
    );
  }
}

class LicenseSection extends StatefulWidget {
  LicenseSection({Key? key}) : super(key: key);

  @override
  _LicenseSectionState createState() => _LicenseSectionState();
}

class _LicenseSectionState extends State<LicenseSection> {
  final model = locator<NewDetailsHealthLicenseViewModel>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomVerticalSpace(height: 16),
        VdHeaderDesc(
          header: ("registered_license").tr(),
          desc: Helpers.translatingWord('registered_license_info'),
        ),
        radioButtonQuestion(),
      ],
    );
  }

  Widget radioButtonQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        CustomTextWidget(
          Helpers.translatingWord("license_for_facility"),
          fontColor: AppColor.blackModern700Light,
          fontWeight: AppFontWeight.bold,
          fontSize: 16,
          textAlign: TextAlign.start,
        ),
        const CustomVerticalSpace(height: 10),
        CustomRadioButtonWithoutDecoration(
            title: Helpers.translatingWord(
                'bookNewAppointmentYesSpecialNeedsWord'),
            value: "1",
            currentSelected: model.shopHasLicense,
            onChange: onItemChanged),
        CustomRadioButtonWithoutDecoration(
            title:
                Helpers.translatingWord('bookNewAppointmentNoSpecialNeedsWord'),
            value: "2",
            currentSelected: model.shopHasLicense,
            onChange: onItemChanged),
        CustomVerticalSpace(height: 16),
        if (model.shopHasLicense == "1") LicenseNumberSection(),
        if (model.shopHasLicense == "2") const NoLicenseSection()
      ],
    );
  }

  void onItemChanged(String id) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToEnd());
    model.hideKeyboard();
    model.changeCRAndLicenseValidation();
    // model.validateForm;

    setState(() {
      // itemSelected = true;
      // currentSelected = id;
      model.shopHasLicense = id;
    });
    model.validateForm();
  }
}

_scrollToEnd() async {
  scrollController.animateTo(scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 400), curve: Curves.ease);
}

class LicenseNumberSection extends StatefulWidget {
  LicenseNumberSection({Key? key}) : super(key: key);

  @override
  State<LicenseNumberSection> createState() => _LicenseNumberSection();
}

class _LicenseNumberSection extends State<LicenseNumberSection> {
  final FocusNode _licenseNoFocusNode = FocusNode();
  final TextEditingController _licenseNoController = TextEditingController();
  final model = locator<NewDetailsHealthLicenseViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _licenseNoController.text = model.dataModel.licenseNumber ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const CustomVerticalSpace(height: 14),
        DropDownWithTitle(
          title: "health_license_type".tr(),
          selectedValue: model.selectedLicesnseType?.text,
          onRetry: () {},
          onTap: () {
            // if (state.requestDetails?.usageDisable == true) return;
            BottomSheetDialog.showDraggableSheet(
              context,
              child: GenericBottomSheetList<LicenseType>(
                title: "health_license_type".tr(),
                items: [
                  LicenseType(value: "COMMERCIAL"),
                  LicenseType(value: "STREET_VENDOR"),
                  LicenseType(value: "VEHICLE"),
                ],
                selectedValue: model.selectedLicesnseType,
                onTap: (item) {
                  model.selectedLicesnseType = item;

                  Navigator.pop(context);
                },
              ),
            );
          },
        ),
        const CustomVerticalSpace(height: 16),
        CustomTextFieldWidget(
          controller: _licenseNoController,
          focusNode: _licenseNoFocusNode,
          label: Helpers.translatingWord("unified_license_number"),
          hintText: Helpers.translatingWord("unified_license_number"),
          obsecureText: false,
          fillColor: Colors.transparent,
          keyboardType: TextInputType.number,
          onChanged: (String v) {
            model.licenseNumber = v;
            model.changeCRAndLicenseValidation();
          },
          onValidate: (text) {
            /* if (!Helpers.doesContainsLettrs(text.toString())) {
              return Helpers.translatingWord('text_field_error');
            }*/
            return null;
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (model.isLicenseVerified)
                Image.asset(
                  Constants.imgPath + "circle_check@3x.png",
                  height: 12,
                  width: 12,
                ),
              const CustomHorizontalSpace(width: 5),
              CustomTextButtonWidget(
                  onPressed: !model.isLicenseVerified
                      ? () {
                          if (model.selectedLicesnseType != null &&
                              _licenseNoController.text.isNotEmpty) {
                            model
                                .getHealthLicenseInfo(_licenseNoController.text,
                                    model.selectedLicesnseType?.value ?? "")
                                .then((value) {
                              if (value) {
                                FocusScope.of(context).unfocus();
                                WidgetsBinding.instance?.addPostFrameCallback(
                                    (_) => _scrollToEnd());
                                setState(() {});
                                model.validateForm();
                              }
                            });
                          } else {
                            CommonFunctions.showError(
                                "health_license_type_error".tr());
                          }
                        }
                      : () {},
                  text: model.isLicenseVerified
                      ? Helpers.translatingWord('recall_done')
                      : Helpers.translatingWord('recall'),
                  btnTextColor: AppColor.baladyDarkGreen2,
                  btnTextWeight: AppFontWeight.bold,
                  btnTextSize: 13,
                  btnAlignment: AlignmentDirectional.centerEnd,
                  haveUnderline: model.isLicenseVerified ? false : true),
            ],
          ),
        ),
        Visibility(
            visible: model.isLicenseVerified,
            child: LicenseInfoSection(
              license: model.licenseForHealthInformationResponse,
            ))
      ],
    );
  }
}

class LicenseInfoSection extends StatelessWidget {
  final LicenseForHealthInformationResponse? license;

  const LicenseInfoSection({Key? key, this.license}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomVerticalSpace(height: 16),
        VdHeaderDesc(
          header: Helpers.translatingWord('license_info'),
          desc: Helpers.translatingWord('license_info_desc'),
        ),
        ReadOnlyField(
            title: Helpers.translatingWord("license_shop_name"),
            subTitle: license?.data?.result?.shopName),
        ReadOnlyField(
            title: Helpers.translatingWord("license_health_number"),
            subTitle: license?.data?.result?.crNumber),
        ReadOnlyField(
            title: Helpers.translatingWord("license_health_municipality"),
            subTitle: license?.data?.result?.municipalityName),
        ReadOnlyField(
            title: Helpers.translatingWord("license_health_subMunicipality"),
            subTitle: license?.data?.result?.subMunicipalityName),
        ReadOnlyField(
            title: Helpers.translatingWord("license_health_entityName"),
            subTitle: license?.data?.result?.entityName),
        ReadOnlyField(
            title: Helpers.translatingWord("license_health_activityName"),
            subTitle: license?.data?.result?.activityName),
        ReadOnlyField(
            title: Helpers.translatingWord("isic_activity"),
            subTitle: license?.data?.result?.isicName),
        ReadOnlyField(
            title: Helpers.translatingWord("license_health_start_date"),
            subTitle: license?.data?.result?.licenseStartDate),
        ReadOnlyField(
            title: Helpers.translatingWord("license_health_end_date"),
            subTitle: license?.data?.result?.licenseEndDate),
      ],
    );
  }
}

class NoLicenseSection extends StatefulWidget {
  const NoLicenseSection({Key? key}) : super(key: key);

  @override
  _NoLicenseSection createState() => _NoLicenseSection();
}

class _NoLicenseSection extends State<NoLicenseSection> {
  final model = locator<NewDetailsHealthLicenseViewModel>();

  @override
  Widget build(BuildContext context) {
    return model.showAreaNoLicencePermit()
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const CustomVerticalSpace(height: 10),
              CustomTextWidget(
                Helpers.translatingWord("no_license_purpose"),
                fontColor: AppColor.baladyDarkGreen2,
                fontWeight: AppFontWeight.bold,
                fontSize: 13,
                textAlign: TextAlign.start,
              ),
              const CustomVerticalSpace(height: 10),
              CustomRadioButtonWithoutDecoration(
                  title: Helpers.translatingWord('no_facility_license_issued'),
                  value: "1",
                  currentSelected: model.noLicenseReason,
                  onChange: onItemChanged),
              CustomRadioButtonWithoutDecoration(
                  title: Helpers.translatingWord('issue_license_not_permitted'),
                  value: "2",
                  currentSelected: model.noLicenseReason,
                  onChange: onItemChanged),
              const DrawLineWidget(
                verticalMargin: 10,
              ),
              if (model.noLicenseReason == "1") errorContainer()
            ],
          )
        : errorContainer();
  }

  Widget errorContainer() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextWidget(
              Helpers.translatingWord("no_license_issue_error_title"),
              fontColor: Color(0xff9a1111),
              fontSize: 13,
              textAlign: TextAlign.start,
            ),
            Constants.verticalSpaceSmall,
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: "no_license_issue_error_subtitle".tr(),
                      style: TextStyle(
                        color: const Color.fromRGBO(153, 153, 153, 1),
                        fontWeight: FontWeight.w500,
                        fontFamily: GeneralKey.appFontType,
                        fontSize: 13,
                        height: 1.6,
                      )),
                  TextSpan(
                    text: " " + "click_here".tr() + " ",
                    style: TextStyle(
                      color: AppColor.primary900Light,
                      fontFamily: GeneralKey.appFontType,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      decoration: TextDecoration.none,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        CommonFunctions.openBaladyWebView(
                            "${RemoteConfig.webSiteUrl}/ar/services/11010");
                      },
                  ),
                  TextSpan(
                      text: "no_license_issue_error_subtitle2".tr(),
                      style: TextStyle(
                        fontFamily: GeneralKey.appFontType,
                        color: const Color.fromRGBO(153, 153, 153, 1),
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        height: 1.6,
                      )),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(2)),
            border: Border.all(color: AppColor.redBrown, width: 1),
            color: AppColor.red200));
  }

  void onItemChanged(String id) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _scrollToEnd());
    model.hideKeyboard();
    setState(() {
      model.noLicenseReason = id;
    });
    model.validateForm();
  }
}
