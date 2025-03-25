import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class FreelanceCertificateStateScreen extends StatelessWidget {
  final FreelanceCertificateState state;
  const FreelanceCertificateStateScreen({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Expanded(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomTextWidget(
                        "no_have_freelancer_certificate_certified_observer".tr(),
                        fontSize: 16,
                        fontWeight: AppFontWeight.medium,
                        fontColor: AppColor.black500,
                        height: 1.4,
                        maxLines: 4,
                        textAlign: TextAlign.center,
                      ),
                      const CustomVerticalSpace(height: 32),
                    ],
                  ),
                ),
              ),
              CustomElevatedButtonWidget(
                btnColor: AppColor.primary800Light,
                textStyle: AppStyle.elevatedButtonStyle.copyWith(
                  color: AppColor.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                btnHeight: 56,
                text: "issue_new_freelancer_certificate_certified_observer".tr(),
                onPressed: () {


                },
              ),
              const SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}
