import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/dependency_injection/injection_container.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../bloc/cr_step10_addetional_data_cubit.dart';

class CRStep10AdditionalData extends StatelessWidget {
  const CRStep10AdditionalData({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CRStep10AddetionalDataCubit, CRStep10AddetionalState>(
        listener: (context, state) {
      if (state.status == BlocStatus.failure)
        CommonFunctions.showError(state.errorMessage ?? "");
    }, builder: (context, state) {
      return Stack(
        children: [
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
                        const CRHeaderDesc(
                          header: "بيانات اضافية للمنشأة",
                          desc: "",
                        ),
                        const CustomTextWidget(
                          "اختر كل ما ينطبق على المنشأة",
                          fontWeight: AppFontWeight.bold,
                          fontSize: 16,
                          fontColor: AppColor.blackModern700Light,
                        ),
                        const SizedBox(height: 16),
                        CheckBoxWithTitle(
                          title: "يوجد مكان خارجي قابل للاستثمار",
                          onChanged: (value) {
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(
                                    thereIsOuterInvestablePlace: value);
                          },
                        ),
                        const SizedBox(height: 12),
                        CheckBoxWithTitle(
                          title: "يخدم الموقع الوصول لذوي الاحتياجات الخاصة",
                          onChanged: (value) {
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(serveDisabledPersons: value);
                          },
                        ),
                        const SizedBox(height: 12),
                        CheckBoxWithTitle(
                          title: "توجد مواقف مخصصة للمنشأة",
                          onChanged: (value) {
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateHasParking(hasParking: value);
                          },
                        ),
                        if (state.hasParking == true) ...[
                          const SizedBox(height: 16),
                          CustomTextFieldWidget(
                            label: "عدد المواقف",
                            hintText: "عدد المواقف",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            spacerSize: 24,
                            onValidate: (p0) {},
                            onChanged: (String? value) {
                              context
                                  .read<CRStep10AddetionalDataCubit>()
                                  .updateParkingCount(parkingCount: value);
                            },
                          ),
                        ],
                        const SizedBox(height: 16),
                        CheckBoxWithTitle(
                          title: "تتوفر خدمة البيع الالكتروني",
                          onChanged: (value) {
                            String v = value == true ? "YES" : "NO";
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(hasElectronicSale: v);
                          },
                        ),
                        const SizedBox(height: 12),
                        CheckBoxWithTitle(
                          title: "تتوفر خدمة التوصيل",
                          onChanged: (value) {
                            String v = value == true ? "YES" : "NO";
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(hasDelivery: v);
                          },
                        ),
                        const SizedBox(height: 12),
                        if (state.hasDelivery == "YES")
                          Container(
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              Expanded(
                                child: CheckBoxWithTitle(
                                  title: "نفس المنشأة",
                                  forceSelection:
                                      state.siteDeliveryType == "ITSELF",
                                  onChanged: (value) {
                                    String? v = value == true ? "ITSELF" : null;
                                    context
                                        .read<CRStep10AddetionalDataCubit>()
                                        .updateSiteDeliveryType(
                                            siteDeliveryType: v);
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              Expanded(
                                child: CheckBoxWithTitle(
                                  forceSelection:
                                      state.siteDeliveryType == "OUTERSITE",
                                  title: "جهة خارجية",
                                  onChanged: (value) {
                                    String? v =
                                        value == true ? "OUTERSITE" : null;
                                    context
                                        .read<CRStep10AddetionalDataCubit>()
                                        .updateSiteDeliveryType(
                                            siteDeliveryType: v);
                                  },
                                ),
                              ),
                            ]),
                          ),
                        if (state.siteDeliveryType == "OUTERSITE") ...[
                          const SizedBox(height: 12),
                          CustomTextFieldWidget(
                            label: "اسم الجهة",
                            hintText: "اسم الجهة",
                            isDigitsOnly: true,
                            keyboardType: TextInputType.number,
                            bottomMargin: 24,
                            onChanged: (value) {
                              context
                                  .read<CRStep10AddetionalDataCubit>()
                                  .updateFields(siteDeliveryName: value);
                            },
                          ),
                        ],
                        const SizedBox(height: 12),
                        CheckBoxWithTitle(
                          title: "تتوفر خدمة صف المركبات",
                          onChanged: (value) {
                            String v = value == true ? "YES" : "NO";
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(hasVehicleParking: v);
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextFieldWidget(
                          label: "رقم اشتراك الكهرباء",
                          hintText: "ادخل رقم اشتراك الكهرباء",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          bottomMargin: 24,
                          onChanged: (value) {
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(electAccountNumber: value);
                          },
                        ),
                        CustomTextFieldWidget(
                          label: "الرقم اشتراك المياه",
                          hintText: "ادخل الرقم اشتراك المياه",
                          isDigitsOnly: true,
                          keyboardType: TextInputType.number,
                          bottomMargin: 24,
                          onChanged: (value) {
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(waterAccountNumber: value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              CRPreviousNextButtons(
                  onPressed: () {
                    context.read<CRStep10AddetionalDataCubit>().save();
                  },
                  isBtnDisabled: false),
            ],
          ),
          if (state.status == BlocStatus.loading)
            const CustomCircularLoadingWidget(),
        ],
      );
    });
  }
}
