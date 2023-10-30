import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/commercial_license/presentation/step6/bloc/cr_step6_establishment_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../../vd/presentation/widgets/details_widgets/incident_desc_widgets/vd_create_incident_addetional_fields.dart';
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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<CRStep6EstablishmentCubit>().getApplyCommercialRequest();
    context.read<CRStep6EstablishmentCubit>().getBuildingNature();
    context.read<CRStep6EstablishmentCubit>().getPaymentMethods();
    context.read<CRStep6EstablishmentCubit>().getSiteNature();
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
                          const CRHeaderDesc(header: "بيانات المنشآه"),
                          const SizedBox(height: 16),
                          HorizontalRadioGroup<QRSiteLocationType>(
                            groupName: 'بيانات موقع المنشأة',
                            currentItem: state.siteLocationType,
                            items: [
                              RadioItem<QRSiteLocationType>(
                                radioValue: QRSiteLocationType.INSIDE_BUILDING,
                                radioText: "داخل مبني",
                              ),
                              RadioItem<QRSiteLocationType>(
                                radioValue: QRSiteLocationType.ON_STREET,
                                radioText: "علي الشارع",
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
                              label: "اسم المبني",
                              hintText: "اسم المبني",
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(buildingName: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              label: "رقم الوحده",
                              hintText: "رقم الوحده",
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(buildingUnit: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              label: "الطابق",
                              hintText: "الطابق",
                              isDigitsOnly: true,
                              keyboardType: TextInputType.number,
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(buildingFloor: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              label: "ارشادات الوصول من البوابة الرئيسية",
                              maxLines: 3,
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
                              label: "اسم الموقع",
                              hintText: "اسم الموقع",
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(siteName: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              label: "وصف الموقع",
                              hintText: "وصف الموقع",
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(siteDesc: value);
                              },
                            ),
                            CustomTextFieldWidget(
                              label: "اقرب معلم بارز",
                              hintText: "اقرب معلم بارز",
                              bottomMargin: 24,
                              onChanged: (value) {
                                context
                                    .read<CRStep6EstablishmentCubit>()
                                    .updateFields(siteLandmark: value);
                              },
                            ),
                          ],
                          CustomTextFieldWidget(
                            label: "رقم المبني",
                            hintText: "رقم المبني",
                            isDigitsOnly: true,
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
                            label: "الرقم الاضافي",
                            hintText: "الرقم الاضافي",
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
                            label: "الرمز البريدي",
                            hintText: "الرمز البريدي",
                            isDigitsOnly: true,
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
                          const CRHeaderDesc(
                              header: "بيانات مالك/ ملاك المنشأة"),
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
                          const CRHeaderDesc(header: "بيانات تواصل المنشأة"),
                          const SizedBox(height: 16),
                          CustomTextFieldWidget(
                            label: "هويه مدير الموقع",
                            hintText: "ادخل هويه مدير الموقع",
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
                            fieldName: "تاريخ الميلاد",
                            isMandatory: true,
                            onChanged: (date) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateManagerData(birthDate: date);
                            },
                          ),
                          //  ElevatedButtonWidget.verify(onPressed: () {}),
                          const SizedBox(height: 24),
                          //const ManagerInfoCard(),
                          CustomTextFieldWidget(
                            label: "رقم الجوال",
                            hintText: "رقم الجوال",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            onValidate: (p0) {},
                            initialValue:
                                CommonProperties.userInfo?.getPhone() ?? "",
                            bottomMargin: 24,
                            onChanged: (String? v) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(mobile: v);
                            },
                          ),
                          const NotesWidget(
                            notes: [
                              "سوف يتم استلام جميع الاشعارات على رقم الجوال المسجل في النظام"
                            ],
                          ),
                          CustomTextFieldWidget(
                            label: "البريد الالكتروني",
                            hintText: "ادخل البريد الالكتروني",
                            bottomMargin: 24,
                            onValidate: (p0) {},
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(website: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "هاتف المنشاه",
                            hintText: "هاتف المنشأة",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
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
                            label: "رقم خدمة العملاء للمنشأة",
                            hintText: "رقم خدمة العملاء للمنشأة",
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
                            label: "الموقع الالكتروني",
                            hintText: "الموقع الالكتروني",
                            spacerSize: 24,
                            showOptional: true,
                            onValidate: (p0) {},
                            onChanged: (value) {
                              context
                                  .read<CRStep6EstablishmentCubit>()
                                  .updateContactInfo(website: value);
                            },
                          ),
                          CustomTextFieldWidget(
                            label: "حساب تويتر",
                            hintText: "حساب تويتر",
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
                            label: "حساب انستغرام",
                            hintText: "حساب انستغرام",
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
                            label: "حساب سناب شات",
                            hintText: "حساب سناب شات",
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
                            label: "حساب فيس بوك",
                            hintText: "حساب فيس بوك",
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
                            label: "رقم الواتس أب",
                            hintText: "رقم الواتس أب",
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
                            groupName: "هل يوجد لديك قنوات دفع ؟",
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
                            const CustomTextWidget(
                              "قنوات الدفع",
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
                CRPreviousNextButtons(
                    onPressed: () {
                      context.read<CRStep6EstablishmentCubit>().save();
                    },
                    isBtnDisabled: false),
              ],
            ),
          if (state.isLoading) const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
