import 'package:balady_plus/app/commercial_model/commercial_routes/commercial_route_names.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/constants/app_style.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../../../features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../data/data_source/remote_data_source.dart';
import '../../data/repositories/repository_implementation.dart';
import '../../domain/use_cases/get_commercial_license_query_data.dart';
import '../bloc/commercial_license_query_details_cubit.dart';

class CommercialLicenseQueryScreen extends StatefulWidget {
  const CommercialLicenseQueryScreen({Key? key}) : super(key: key);

  @override
  State<CommercialLicenseQueryScreen> createState() =>
      _CommercialLicenseQueryScreenState();
}

class _CommercialLicenseQueryScreenState
    extends State<CommercialLicenseQueryScreen> {
  final TextEditingController _licenseNumberController =
      TextEditingController();
  final TextEditingController _agentNumberController = TextEditingController();
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
                          label: "${"license_nubmer".tr()} *",
                          controller: _licenseNumberController,
                          focusNode: _licenseNumberDescFocusNode,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          fillColor: Colors.transparent,
                          onValidate: (text) {
                            if (text.toString().isEmpty) {
                              return ("commercial_license_error").tr();
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          spacerSize: 10,
                        ),
                        CustomTextFieldWidget(
                          label: "${"agentNumber".tr()} *",
                          controller: _agentNumberController,
                          keyboardType: TextInputType.number,
                          fillColor: Colors.transparent,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onValidate: (text) {
                            if (text.toString().isEmpty) {
                              return ("agentNumberError").tr();
                            }
                            return null;
                          },
                          textInputAction: TextInputAction.done,
                          spacerSize: 10,
                        ),
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

                navigator.pushNamed(
                  CommercialRouteName.commercialLicenseQueryDetails,
                  arguments: CommercialLicenseQueryDetailsCubit(
                      GetCommercialLicenseQueryData(
                        repository: CommercialLicenseQueryRepositoryImplementation(
                            remoteDataSource:
                                CommercialLicenseQueryRemoteDataSourceImplementation(
                                    webService: sl())),
                      ),
                      int.parse(_licenseNumberController.text),
                      int.parse(_agentNumberController.text)),
                );
              }
            },
          ),
        )
      ],
    );
  }
}
