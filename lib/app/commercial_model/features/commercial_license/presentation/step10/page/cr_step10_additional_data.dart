import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
import '../../../../../../features/_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../../../../features/_shared_feature_/shared_feature_exports.dart';
import '../../../commercial_license_exports.dart';
import '../bloc/cr_step10_addetional_data_cubit.dart';

class CRStep10AdditionalData extends StatefulWidget {
  const CRStep10AdditionalData({Key? key}) : super(key: key);

  @override
  State<CRStep10AdditionalData> createState() => _CRStep10AdditionalDataState();
}

class _CRStep10AdditionalDataState extends State<CRStep10AdditionalData> {
  final TextEditingController _controller = TextEditingController();
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
                        CRHeaderDesc(
                          header: "extra_facility_data".tr(),
                          desc: "",
                        ),
                        CustomTextWidget(
                          "chooseDesc".tr(),
                          fontWeight: AppFontWeight.bold,
                          fontSize: 16,
                          fontColor: AppColor.blackModern700Light,
                        ),
                        const SizedBox(height: 16),
                        CheckBoxWithTitle(
                          title: "step10check1".tr(),
                          onChanged: (value) {
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(
                                    thereIsOuterInvestablePlace: value);
                          },
                        ),
                        const SizedBox(height: 12),
                        CheckBoxWithTitle(
                          title: "step10check2".tr(),
                          onChanged: (value) {
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(serveDisabledPersons: value);
                          },
                        ),
                        const SizedBox(height: 12),
                        CheckBoxWithTitle(
                          title: "step10check3".tr(),
                          onChanged: (value) {
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateHasParking(hasParking: value);
                          },
                        ),
                        if (state.hasParking == true) ...[
                          const SizedBox(height: 16),
                          CustomTextFieldWidget(
                            label: "step10label1".tr(),
                            hintText: "step10label1".tr(),
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
                          title: "exists_after_sale_service".tr(),
                          onChanged: (value) {
                            String v = value == true ? "YES" : "NO";
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(hasElectronicSale: v);
                          },
                        ),
                        const SizedBox(height: 12),
                        CheckBoxWithTitle(
                          title: "step10check5".tr(),
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
                                  title: "same_facility".tr(),
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
                                  title: "external_entity".tr(),
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
                            label: "cr_entity_name".tr(),
                            hintText: "cr_entity_name".tr(),
                            controller: _controller,
                            keyboardType: TextInputType.text,
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
                          title: "step10check6".tr(),
                          onChanged: (value) {
                            String v = value == true ? "YES" : "NO";
                            context
                                .read<CRStep10AddetionalDataCubit>()
                                .updateFields(hasVehicleParking: v);
                          },
                        ),
                        const SizedBox(height: 16),
                        CustomTextFieldWidget(
                          label: "step10label2".tr(),
                          hintText: "step10hint2".tr(),
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
                          label: "step10label3".tr(),
                          hintText: "step10hint3".tr(),
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
              (state.status.isSubmissionLoading)
                  ? const Center(child: CustomCircularLoadingWidget())
                  : CRPreviousNextButtons(
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
