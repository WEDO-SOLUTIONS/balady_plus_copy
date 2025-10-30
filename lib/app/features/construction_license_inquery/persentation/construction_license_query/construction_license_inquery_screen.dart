import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/dependency_injection/injection_container.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../create_compliance/presentation/widgets/summery_widgets/field_data.dart';
import '../../data/data_source/remote_data_source.dart';
import '../../data/repositories/repository_implementation.dart';
import '../../domain/use_cases/get_construction_license_inquery_data.dart';
import '../bloc/construction_license_inquery_details_cubit.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/enhanced_widgets/pickers/hijri_picker/hijri_picker.dart'
    as hijri_picker;

class ConstructionLicenseInqueryScreen extends StatefulWidget {
  const ConstructionLicenseInqueryScreen({Key? key}) : super(key: key);

  @override
  State<ConstructionLicenseInqueryScreen> createState() =>
      _ConstructionLicenseInqueryScreenState();
}

class _ConstructionLicenseInqueryScreenState
    extends State<ConstructionLicenseInqueryScreen> {
  final TextEditingController _licenseNumberController =
      TextEditingController();

  final TextEditingController _licenseDateController = TextEditingController();
  final FocusNode _licenseNumberDescFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      resizeToAvoidBottomInset: true,
      appBar: DefaultAppBarWidget(
        title: "back".tr(),
        showBack: true,
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      bottom: 30, right: 30, left: 30, top: 32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomTextWidget(
                          "commercial_licenseـquery_title".tr(),
                          textStyle: AppStyle.complianceTitleStyle,
                          maxLines: 4,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomTextFieldWidget(
                          label: "${"unified_license_number".tr()} *",
                          controller: _licenseNumberController,
                          focusNode: _licenseNumberDescFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          fillColor: Colors.transparent,
                          onValidate: (text) {
                            if (text.toString().isEmpty) {
                              return ("unified_license_number_error").tr();
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          spacerSize: 10,
                        ),
                        CustomTextFieldWidget(
                            label: "${"license_issue_date".tr()} *",
                            controller: _licenseDateController,
                            fillColor: Colors.transparent,
                            onTap: () {
                              hijri_picker.Picker(
                                isAr: CommonFunctions.isAppAR,
                                confirmTextStyle:
                                    AppStyle.textButtonStyle.copyWith(
                                  color: AppColor.primary900Light,
                                ),
                                cancelTextStyle:
                                    AppStyle.textButtonStyle.copyWith(
                                  color: AppColor.primary900Light,
                                ),
                                headercolor: AppColor.paleGrey,
                                height: 270,
                                confirmText: 'choose'.tr(),
                                title: CustomTextWidget(
                                  'license_issue_date'.tr(),
                                  textStyle: AppStyle.dropDownTitleTextStyle,
                                ),
                                hideHeader: false,
                                adapter: hijri_picker.DateTimePickerAdapter(
                                  // minValue: HijriCalendar.fromDate(DateTime.now()),
                                  maxValue:
                                      HijriCalendar.fromDate(DateTime.now()),
                                  customColumnType: CommonFunctions.isAppAR
                                      ? [2, 1, 0]
                                      : [0, 1, 2],
                                  value: HijriCalendar.fromDate(DateTime.now()),
                                ),
                                selectedTextStyle: const TextStyle(
                                    color: AppColor.primary900Light),
                                onConfirm: (picker, value) {
                                  final date = (picker.adapter
                                          as hijri_picker.DateTimePickerAdapter)
                                      .value;
                                  if (date != null) {
                                    setState(() {
                                      setState(() {
                                        _licenseDateController.text =
                                            "${date.hYear}/${date.hMonth.toString().padLeft(2, '0')}/${date.hDay.toString().padLeft(2, '0')}";
                                        ;
                                      });
                                    });

                                    // bloc.add(
                                    //     SelectHijriCalendar(date));
                                  }
                                },
                                cancelText: 'cancel'.tr(),
                              ).showModal(context);
                            },
                            suffixIcon: InkWell(
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(Icons.clear),
                              ),
                              onTap: () {
                                setState(() {
                                  _licenseDateController.text = "";
                                });
                                // bloc.add(
                                //     const SelectHijriCalendar(null));
                              },
                            ),
                            //controller: bloc.controller,
                            readOnly: true,
                            disabledColor: Colors.transparent,
                            onValidate: (date) => date?.isNotEmpty ?? false
                                ? null
                                : "license_date_error".tr()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
              color: Colors.white),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 26),
          child: CustomElevatedButtonWidget(
            btnColor: AppColor.primary800Light,
            textStyle: AppStyle.elevatedButtonStyle.copyWith(
              color: AppColor.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            btnHeight: 56,
            text: "query".tr(),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                NavigatorState navigator = Navigator.of(context);

                String date =
                    _licenseDateController.text.toString().replaceAll("/", "");
                navigator.pushNamed(
                  RouteName.constructionLicenseInqueryDetails,
                  arguments: ConstructionLicenseInqueryDetailsCubit(
                      GetConstructionLicenseInqueryData(
                        repository:
                            ConstructionLicenseInqueryRepositoryImplementation(
                                remoteDataSource:
                                    ConstructionLicenseInqueryRemoteDataSourceImplementation(
                                        webService: sl())),
                      ),
                      int.parse(_licenseNumberController.text),
                      date),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
