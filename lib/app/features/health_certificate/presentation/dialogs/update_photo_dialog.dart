import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/home_page/home_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/custom_spaces_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import '../blocs/update_photo_certificate_bloc/update_photo_certificate_bloc.dart';

class UpdateHealthCerificatePhotoDialog extends StatelessWidget {
  final Function onUpdated;
  final int requestId;
  final String certificateUUID;

  const UpdateHealthCerificatePhotoDialog(
      {Key? key,
      required this.onUpdated,
      required this.requestId,
      required this.certificateUUID})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UpdatePhotoCertificateCubit(
          requestId: requestId,
          certificateUUID: certificateUUID,
          onUpdate: onUpdated),
      child: BlocConsumer<UpdatePhotoCertificateCubit,
          UpdatePhotoCertificateState>(
        listener: (context, state) {
          if (state.status == BlocStatus.failure) {
            CommonFunctions.showError(state.errorMessage ?? "");
          }
        },
        builder: (context, state) {
          return Container(
            color: AppColor.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Constants.mediumPadding,
                vertical: Constants.semiLargePadding,
              ),
              child: Stack(
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CustomTextWidget(
                            Helpers.translatingWord("update_photo"),
                            fontColor: AppColor.blackModern900Light,
                            fontWeight: AppFontWeight.bold,
                            maxLines: 10,
                          ),
                          InkWell(
                              onTap: () => Navigator.pop(context),
                              child: CircleIcon(
                                icon: Icons.close,
                                iconColor: AppColor.primary600Light,
                                backgroundColor:
                                    AppColor.geyser.withOpacity(0.4),
                                iconSize: 18,
                              )),
                        ],
                      ),

                      const CustomVerticalSpace(height: 16),
                      // subtitle

                      CustomTextWidget(
                        Helpers.translatingWord("please_fill_all_info"),
                        fontColor: AppColor.warmGrey2,
                        fontWeight: AppFontWeight.medium,
                        maxLines: 10,
                      ),

                      CustomVerticalSpace(height: 20),

                      CustomTextFieldWidget(
                        hintText: "version_no".tr(),
                        label: "version_no".tr(),
                        keyboardType: TextInputType.number,
                        isDigitsOnly: true,
                        onChanged: (String? value) {
                          context
                              .read<UpdatePhotoCertificateCubit>()
                              .updateVersionNo(value ?? "");
                        },
                      ),
                      CustomVerticalSpace(height: 16),

                      CustomTextWidget(
                        "id_version_number".tr(),
                        fontSize: 14,
                        fontWeight: AppFontWeight.bold,
                        fontColor: AppColor.blackModern500Light,
                      ),
                      CustomVerticalSpace(height: 16),

                      HijriCalendarAddetionalField(
                        fieldName: "date_of_birth".tr(),
                        isMandatory: true,
                        currentVlaue: state.birthDate,
                        onChanged: (String? value) {
                          context
                              .read<UpdatePhotoCertificateCubit>()
                              .updateDate(CommonFunctions
                                  .replaceArabicNumberWithEnglish(value ?? ""));
                        },
                      ),
                      CustomVerticalSpace(height: 16),

                      Container(
                          height: 44,
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 12),
                          decoration: ShapeDecoration(
                            color: AppColor.primary100Light,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          alignment: Alignment.center,
                          child: CustomTextWidget(
                            "otp_will_be_sent".tr(),
                            fontSize: 14,
                            fontWeight: AppFontWeight.bold,
                            fontColor: AppColor.blackModern500Light,
                          )),
                      const CustomVerticalSpace(height: 40),

                      ElevatedButtonWidget.custom(
                          onPressed: () {
                            context
                                .read<UpdatePhotoCertificateCubit>()
                                .sendOTP();
                          },
                          text: "updateButton".tr(),
                          isDisabled: !state.isFormValid),

                      const CustomVerticalSpace(height: 40),
                      // buttons
                    ],
                  ),
                  if (state.status == BlocStatus.loading)
                    const CustomCircularLoadingWidget(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ConfirmCancelLicenseDialogButtons extends StatelessWidget {
  final Function? onCancel;

  const _ConfirmCancelLicenseDialogButtons({Key? key, this.onCancel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EnhancedCustomElevatedButtonWidget(
          btnPressed: () {
            if (onCancel != null) {
              onCancel!();
            }
          },
          btnColor: Colors.transparent,
          btnBorderColor: Color(0xFFDC2828), // as Scaffold background
          btnBorderWidth: 2.0,
          btnRadius: 8,
          btnText:
              Helpers.translatingWord('confirmCancelLicenseConfirmButtonWord'),
          btnTextColor: Color(0xFFDC2828),
          btnTextWeight: AppFontWeight.medium,
        ),
        Constants.verticalSpaceSmall,
        EnhancedCustomElevatedButtonWidget(
          btnPressed: () => Navigator.of(context).pop(),
          btnText:
              Helpers.translatingWord("confirmCancelLicenseCancelButtonWord"),
          btnBorderWidth: 2.0,
          btnRadius: 8,
          btnTextSize: 16.0,
          btnColor: AppColor.primary900Light, // as Scaffold background

          btnTextColor: AppColor.white,
          btnTextWeight: AppFontWeight.medium,
        ),
      ],
    );
  }
}
