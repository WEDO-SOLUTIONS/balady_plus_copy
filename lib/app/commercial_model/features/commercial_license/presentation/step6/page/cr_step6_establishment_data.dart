import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license/presentation/step6/bloc/cr_step6_establishment_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/enums.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/check_boxes/text_field_with_check_btn.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import 'package:balady_plus/app/features/vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
import '../../../commercial_license_exports.dart'
    show
        CRHeaderDesc,
        CRPreviousNextButtons,
        ManagerInfoCard,
        OwnerInfoCard,
        YesNoRadioGroupWidget;
import '../../../data/models/qr/apply_commercial_response_model.dart';
import '../widgets/qr_building_nature_dropdown.dart';
import '../widgets/qr_site_nature_dropdown.dart';

class CRStep6EstablishmentData extends StatefulWidget {
  const CRStep6EstablishmentData({Key? key}) : super(key: key);

  @override
  State<CRStep6EstablishmentData> createState() =>
      _CRStep6EstablishmentDataState();
}

class _CRStep6EstablishmentDataState extends State<CRStep6EstablishmentData> {
  final TextEditingController _managerMobileNumberControler =
      TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<CRStep6EstablishmentCubit>().getApplyCommercialRequest();
    context.read<CRStep6EstablishmentCubit>().getBuildingNature();
    context.read<CRStep6EstablishmentCubit>().getPaymentMethods();
    context.read<CRStep6EstablishmentCubit>().getSiteNature();
    context.read<CRStep6EstablishmentCubit>().updateContactInfo();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CRStep6EstablishmentCubit, CRStep6EstablishmentState>(
        listener: (context, state) {
      if (state.isFailure) CommonFunctions.showError(state.errorMessage ?? "");
    }, builder: (context, state) {
      return Stack(
        children: [
          if (state.applyStatus == BlocStatus.failure)
            RetryWidget(
              onRetry: () {
                context
                    .read<CRStep6EstablishmentCubit>()
                    .getApplyCommercialRequest();
              },
            ),
          if (state.applyStatus == BlocStatus.success)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CRHeaderDesc(header: "step6title".tr()),
                          const SizedBox(height: 16),
                          HorizontalRadioGroup<QRSiteLocationType>(
                            groupName: "step6groupName".tr(),
                            currentItem: state.siteLocationType,
                            items: [
                              RadioItem<QRSiteLocationType>(
                                radioValue: QRSiteLocationType.INSIDE_BUILDING,
                                radioText: "step6Ratio1".tr(),
                              ),
                              RadioItem<QRSiteLocationType>(
                                radioValue: QRSiteLocationType.ON_STREET,
                                radioText: "step6Ratio2".tr(),
                              ),
                            ],
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateQRSiteLocationType(value!);
                            },
                          ),
                          if (state.siteLocationType ==
                              QRSiteLocationType.INSIDE_BUILDING) ...[
                            const QrBuildingNatureDropDown(),
                            CustomTextFieldWidget(
                              key: const ValueKey("buildingName"),
                              label: "step6Buildingname".tr(),
                              hintText: "step6Buildingname".tr(),
                              initialValue: state.buildingName,
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(buildingName: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              key: const ValueKey("buildingUnit"),
                              label: "step6groupNumber".tr(),
                              hintText: "step6groupNumber".tr(),
                              isDigitsOnly: true,
                              initialValue: state.buildingUnit,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(buildingUnit: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              key: const ValueKey("buildingFloor"),
                              label: "step6floor".tr(),
                              hintText: "step6floor".tr(),
                              isDigitsOnly: true,
                              initialValue: state.buildingFloor,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(buildingFloor: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              key: const ValueKey("buildingDirections"),
                              label: "step6DoorTrack".tr(),
                              maxLines: 3,
                              initialValue: state.buildingDirections,
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(buildingDirections: value);
                              },
                            ),
                          ],
                          if (state.siteLocationType ==
                              QRSiteLocationType.ON_STREET) ...[
                            const QrSiteNatureDropDown(),
                            CustomTextFieldWidget(
                              key: const ValueKey("siteName"),
                              label: "cr_site_name".tr(),
                              hintText: "cr_site_name".tr(),
                              initialValue: state.siteName,
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(siteName: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              key: const ValueKey("siteDesc"),
                              label: "cr_site_desc".tr(),
                              hintText: "cr_site_desc".tr(),
                              initialValue: state.siteDesc,
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(siteDesc: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              key: const ValueKey("siteLandmark"),
                              label: "cr_near_landmark".tr(),
                              hintText: "cr_near_landmark".tr(),
                              initialValue: state.siteLandmark,
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(siteLandmark: value);
                              },
                            ),
                          ],
                          CustomTextFieldWidget(
                            label: "step6buildingNumber".tr(),
                            hintText: "step6buildingNumber".tr(),
                            isDigitsOnly: true,
                            initialValue: state.buildingNumber,
                            keyboardType: TextInputType.number,
                            spacerSize: 24,
                            showOptional: true,
                            onValidate: (_) {},
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateFields(buildingNumber: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "step6AdditionNumber".tr(),
                            hintText: "step6AdditionNumber".tr(),
                            initialValue: state.addetionalNumber,
                            isDigitsOnly: true,
                            onValidate: (_) {},
                            keyboardType: TextInputType.number,
                            spacerSize: 24,
                            showOptional: true,
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateFields(addetionalNumber: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "step6Email".tr(),
                            hintText: "step6Email".tr(),
                            isDigitsOnly: true,
                            initialValue: state.postalCode,
                            onValidate: (_) {},
                            keyboardType: TextInputType.number,
                            spacerSize: 24,
                            showOptional: true,
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateFields(postalCode: value);
                            },
                          ),
                          CRHeaderDesc(header: "cr_owners".tr()),
                          ListView.builder(
                              shrinkWrap: true,
                              itemCount: state.crOwners?.length ?? 0,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (ctx, index) {
                                return OwnerInfoCard(
                                    index: index,
                                    item: state.crOwners![index],
                                    onUpdate: (CrOwner item) {
                                      context
                                          .read<CRStep6EstablishmentCubit>()
                                          .updateCrOwner(
                                              item: item, index: index);
                                    });
                              }),
                          CRHeaderDesc(header: "step11title5".tr()),
                          const SizedBox(height: 16),
                          CustomTextFieldWidget(
                            label: "managerId".tr(),
                            hintText: "managerEntry".tr(),
                            initialValue: state.nationalId,
                            isDigitsOnly: true,
                            onValidate: (p0) {},
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            onChanged: (String? value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateManagerData(id: value);
                            },
                          ),
                          HijriCalendarAddetionalField(
                            fieldName: "birth".tr(),
                            currentVlaue: state.birthDate,
                            isMandatory: true,
                            onChanged: (date) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateManagerData(birthDate: date);
                            },
                          ),
                          ElevatedButtonWidget.verify(
                              text: (state.managerInfo != null)
                                  ? "done_check".tr()
                                  : "verify".tr(),
                              onPressed: () {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .getCizienInfo();
                              }),
                          const SizedBox(height: 24),
                          if (state.managerInfo != null)
                            const ManagerInfoCard(),
                          TextWithCheckBtn(
                            maxLength: 10,
                            backgroundColor: Colors.transparent,
                            validate: (String? t) {},
                            controller: _managerMobileNumberControler,
                            isValidate:
                                state.managerMobileNumberVerified ?? false,
                            currentValue: state.managerMobileNumber,

                            onTextChanged: (String text) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateManagerMobileNumber(mobile: text);
                            },
                            title: ("vd_mobile_number").tr(),
                            errorText: state.phoneErrorText,
                            verify: () {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .sendOTPHandler(showOTPPage: true);
                            },
                            //currentValue: "ww",
                            hint: ("vd_mobile_number").tr(),
                          ),
                          NotesWidget(
                            notes: [
                              "notification_recived_on_registred_mobile".tr()
                            ],
                          ),
                          CustomTextFieldWidget(
                            label: "health_submitter_mail".tr(),
                            hintText: "health_submitter_mail".tr(),
                            errorText: state.emailErrorText,
                            initialValue: state.contactInfo?.mail,
                            bottomMargin: 24,
                            onValidate: (p0) {},
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(mail: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "phone".tr(),
                            hintText: "phone".tr(),
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            initialValue: state.contactInfo?.phone,
                            spacerSize: 24,
                            showOptional: true,
                            onValidate: (p0) {},
                            onChanged: (String? value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(phone: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "cr_customer_service_no".tr(),
                            hintText: "cr_customer_service_no".tr(),
                            initialValue:
                                state.contactInfo?.enterpriseUniqueCode,
                            isDigitsOnly: true,
                            showOptional: true,
                            keyboardType: TextInputType.number,
                            spacerSize: 24,
                            onValidate: (p0) {},
                            onChanged: (String? value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(
                                      enterpriseUniqueCode: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "event_website".tr(),
                            hintText: "event_website".tr(),
                            spacerSize: 24,
                            showOptional: true,
                            initialValue: state.contactInfo?.website,
                            onValidate: (p0) {},
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(website: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "cr_twitter_account".tr(),
                            hintText: "cr_twitter_account".tr(),
                            initialValue: state.contactInfo?.twitter,
                            showOptional: true,
                            spacerSize: 24,
                            onValidate: (p0) {},
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(twitter: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "cr_instagram_account".tr(),
                            hintText: "cr_instagram_account".tr(),
                            initialValue: state.contactInfo?.instegram,
                            showOptional: true,
                            spacerSize: 24,
                            onValidate: (p0) {},
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(instegram: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "cr_snapchat_account".tr(),
                            hintText: "cr_snapchat_account".tr(),
                            initialValue: state.contactInfo?.snapchat,
                            showOptional: true,
                            spacerSize: 24,
                            onValidate: (p0) {},
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(snapchat: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "cr_facebook_account".tr(),
                            hintText: "cr_facebook_account".tr(),
                            initialValue: state.contactInfo?.facebook,
                            showOptional: true,
                            spacerSize: 24,
                            onValidate: (p0) {},
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(facebook: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "cr_whats_account".tr(),
                            hintText: "cr_whats_account".tr(),
                            initialValue: state.contactInfo?.whatsApp,
                            showOptional: true,
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            spacerSize: 24,
                            onValidate: (p0) {},
                            onChanged: (String? value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(whatsApp: value);
                            },
                          ),
                          const SizedBox(height: 16),
                          YesNoRadioGroupWidget(
                            groupName: "cr_payment_options".tr(),
                            currentValue: state.hasPaymentMethods,
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateFields(paymentMethods: value);
                            },
                          ),
                          if (state.paymentsMethodsStatus ==
                                  BlocStatus.success &&
                              state.hasPaymentMethods == true)
                            CustomTextWidget(
                              "cr_payment_options2".tr(),
                              fontWeight: AppFontWeight.bold,
                              fontSize: 16,
                              fontColor: AppColor.blackModern700Light,
                            ),
                          const SizedBox(height: 16),
                          if (state.paymentsMethodsStatus == BlocStatus.failure)
                            RetryWidget(
                              onRetry: () {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .getPaymentMethods();
                              },
                            ),
                          if (state.paymentsMethodsStatus ==
                                  BlocStatus.success &&
                              state.hasPaymentMethods == true)
                            ListView.builder(
                                shrinkWrap: true,
                                itemCount: state.paymentsMethods?.length ?? 0,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (ctx, index) {
                                  return CheckBoxWithTitle(
                                    initialValue:
                                        state.paymentsMethods?[index].selected,
                                    title: state.paymentsMethods?[index].name ??
                                        "",
                                    onChanged: (value) {
                                      context
                                          .read<CRStep6EstablishmentCubit>()
                                          .updatePaymentsMethods(
                                              index: index,
                                              value: value ?? false);
                                    },
                                  );
                                }),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
                (state.status.isSubmissionLoading)
                    ? const Center(child: CustomCircularLoadingWidget())
                    : CRPreviousNextButtons(
                    onPressed: () {
                      context.read<CRStep6EstablishmentCubit>().save();
                    },
                    isBtnDisabled: !state.isFormValid()),
              ],
            ),
          if (state.isLoading) const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
