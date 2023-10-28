import 'package:balady_plus/app/features/commercial_license/presentation/step6/bloc/cr_step6_establishment_data_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart'
    show CRHeaderDesc, CRPreviousNextButtons, OwnerInfoCard;
import '../../../data/models/qr/apply_commercial_response_model.dart';
import '../widgets/qr_building_nature_dropdown.dart';
import '../widgets/qr_site_nature_dropdown.dart';

class CRStep6EstablishmentData extends StatelessWidget {
  const CRStep6EstablishmentData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CRStep6EstablishmentCubit, CRStep6EstablishmentState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Column(
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
                          currentItem: null,
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
                        CustomTextFieldWidgetWithOptinal(
                          label: "رقم المبني",
                          hintText: "رقم المبني",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          spacerSize: 24,
                          showOptional: true,
                          onChanged: (value) {
                            context
                                .read<CRStep6EstablishmentCubit>()
                                .updateFields(buildingNumber: value);
                          },
                        ),
                        CustomTextFieldWidgetWithOptinal(
                          label: "الرقم الاضافي",
                          hintText: "الرقم الاضافي",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          spacerSize: 24,
                          showOptional: true,
                          onChanged: (value) {
                            context
                                .read<CRStep6EstablishmentCubit>()
                                .updateFields(addetionalNumber: value);
                          },
                        ),
                        CustomTextFieldWidgetWithOptinal(
                          label: "الرمز البريدي",
                          hintText: "الرمز البريدي",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          spacerSize: 24,
                          showOptional: true,
                          onChanged: (value) {
                            context
                                .read<CRStep6EstablishmentCubit>()
                                .updateFields(postalCode: value);
                          },
                        ),
                        const CRHeaderDesc(header: "بيانات مالك/ ملاك المنشأة"),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: state.crOwners?.length ?? 0,
                            physics: const NeverScrollableScrollPhysics(),
                            itemBuilder: (ctx, index) {
                              return OwnerInfoCard(
                                  index: index,
                                  item: state.crOwners![index],
                                  onUpdate: (CrOwner item) {});
                            })
                      ],
                    ),
                  ),
                ),
              ),
              const CRPreviousNextButtons(isBtnDisabled: false),
            ],
          );
        });
  }
}
