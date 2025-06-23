import 'dart:io';

import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import 'package:balady_plus/app/features/ceritified_observer/presentation/blocs/choose_muncipality_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_spaces_widgets.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class FreelanceCertificateStateScreen extends StatelessWidget {
  final FreelanceCertificateState state;

  const FreelanceCertificateStateScreen({Key? key, required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("certified_observer".tr()),
      ),


      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min ,
                children: [
                  SizedBox(
                    width: 155,
                    height: 155,
                    child: CircleAvatar(
                      backgroundColor: Colors.grey.shade100,
                      child: SvgPicture.asset(
                        state.icon,
                        width: 95,
                        height: 95,
                      ),
                    ),
                  ),
                  const CustomVerticalSpace(height: 32),
                  CustomTextWidget(
                    state.title.tr(),
                    fontSize: 18,
                    fontWeight: AppFontWeight.bold,
                    fontColor: AppColor.black,
                    height: 1.4,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  CustomTextWidget(
                    state.description.tr(),
                    fontSize: 16,
                    fontWeight: AppFontWeight.medium,
                    fontColor: AppColor.black600,
                    height: 1.4,
                    maxLines: 6,
                    textAlign: TextAlign.center,
                  ),
                  const CustomVerticalSpace(height: 32),
                  state.isLoading
                      ? const CustomCircularLoadingWidget()
                      : CustomElevatedButtonWidget(
                          btnColor: AppColor.primary800Light,
                          textStyle: AppStyle.elevatedButtonStyle.copyWith(
                            color: AppColor.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                          btnHeight: 56,
                          text: state.textAction.tr(),
                          onPressed: () {
                            if (state is NoHaveFreelanceCertificateState) {
                              context.read<ChooseMuncipalityBloc>().add(
                                    const CreateNewFreelancerCertificateEvent(),
                                  );
                            } else if (state is HaveFreelanceCertificateState) {
                              String uri =
                                  "https://apps.apple.com/sa/app/id6451137181";
                              if (Platform.isAndroid) {
                                uri =
                                    "https://play.google.com/store/apps/details?id=com.momra.momtathil&hl=ar";
                              }
                              launchUrl(Uri.parse(uri));
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
