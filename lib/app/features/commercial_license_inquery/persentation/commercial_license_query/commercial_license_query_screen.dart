import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_field_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../create_compliance/presentation/widgets/summery_widgets/field_data.dart';

class CommercialLicenseQueryScreen extends StatefulWidget {
  const CommercialLicenseQueryScreen({Key? key}) : super(key: key);

  @override
  State<CommercialLicenseQueryScreen> createState() => _CommercialLicenseQueryScreenState();
}

class _CommercialLicenseQueryScreenState extends State<CommercialLicenseQueryScreen> {

  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _agentNumberController = TextEditingController();
  final FocusNode _licenseNumberDescFocusNode = FocusNode();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {


    return  Scaffold(
      appBar: DefaultAppBarWidget(
        title: "back".tr(),
        showBack: true,

      ),
      body: getBody(),
    );
  }


  Widget getBody(){

    return Padding(
      padding:  const EdgeInsets.only(bottom: 30, right: 30, left: 30, top: 32),
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [


          CustomTextWidget(
            "user_data_applicant".tr(),
            fontColor: AppColor.blackModern700Light,
            maxLines: 4,

          ),

          const SizedBox(
            height: 10,
          ),
          CustomTextWidget(
            "commercial_desc".tr(),
            fontColor: AppColor.blackModern700Light,
            maxLines: 4,

          ),

          const SizedBox(
            height: 20,
          ),
          CustomTextFieldWidget(
            label: "license_no".tr(),
            controller: _licenseNumberController,
            focusNode: _licenseNumberDescFocusNode,
            keyboardType: TextInputType.number,
            fillColor: Colors.transparent,
            onChanged: (txt) {
             // changeBtnColor(_selectedServiceId, _selectedActionId);
            },
            onValidate: (text) {
              if (!CommonFunctions.doesContainsLettrs(text.toString())) {
                return ("health_license_type_error").tr();
              }
              return null;
            },

            textInputAction: TextInputAction.done,
            spacerSize: 20,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomTextFieldWidget(
            label: "agentNumber".tr(),
            controller: _agentNumberController,

            keyboardType: TextInputType.number,
            fillColor: Colors.transparent,
            onChanged: (txt) {
              // changeBtnColor(_selectedServiceId, _selectedActionId);
            },
            onValidate: (text) {
              if (!CommonFunctions.doesContainsLettrs(text.toString())) {
                return ("health_license_type_error").tr();
              }
              return null;
            },

            textInputAction: TextInputAction.done,
            spacerSize: 20,
          ),
          CustomElevatedButtonWidget(text: "query".tr()),

        ],
      ),
    );
  }
}
