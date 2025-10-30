import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../../municipal_advisor_exports.dart';

class PermitCheckBox extends StatelessWidget {
  final LicensePermitEntity permit;

  const PermitCheckBox({
    super.key,
    required this.permit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        final selected = state.selectedPermits.indexWhere(
                (element) => element.permitTypeId == permit.permitTypeId) !=
            -1;
        return Container(
          padding: const EdgeInsetsDirectional.only(start: 12),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: AppColor.primary50Light50,
          ),
          child: Column(
            children: [
              InkWell(
                onTap: () {
                  context.read<MunicipalAdvisorBloc>().add(
                        MunicipalAdvisorSelectPermitEvent(
                          permit: permit,
                        ),
                      );
                },
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 200,
                      child: CustomTextWidget(
                        permit.name,
                        textStyle: AppStyle.listTitleTextStyle,
                        maxLines: 2,
                      ),
                    ),
                    const Spacer(),
                    Checkbox(
                      value: selected,
                      activeColor: AppColor.primary700Light,
                      onChanged: (_) {
                        context.read<MunicipalAdvisorBloc>().add(
                              MunicipalAdvisorSelectPermitEvent(
                                permit: permit,
                              ),
                            );
                      },
                    )
                  ],
                ),
              ),
              if (selected && permit.permitTypeId == 1013)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              'Length'.tr(),
                              textStyle: AppStyle.textFieldTitleTextStyle,
                            ),
                            const SizedBox(height: 8),
                            CustomTextFieldWidget(
                              borderColor: AppColor.primary900Light16,
                              initialValue:
                                  state.sideWalkParams.length.toString(),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onSubmitted: (value) {
                                context.read<MunicipalAdvisorBloc>().add(
                                      MunicipalAdvisorUpdateSideWalkEvent(
                                        length: num.parse(value),
                                      ),
                                    );
                              },
                              suffixIcon: CustomTextWidget(
                                'm'.tr(),
                                textAlign: TextAlign.right,
                                textStyle: AppStyle.textFieldSuffixTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              'Width'.tr(),
                              textStyle: AppStyle.textFieldTitleTextStyle,
                            ),
                            const SizedBox(height: 8),
                            CustomTextFieldWidget(
                              borderColor: AppColor.primary900Light16,
                              initialValue:
                                  state.sideWalkParams.width.toString(),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onSubmitted: (value) {
                                context.read<MunicipalAdvisorBloc>().add(
                                      MunicipalAdvisorUpdateSideWalkEvent(
                                        width: num.parse(value),
                                      ),
                                    );
                              },
                              suffixIcon: CustomTextWidget(
                                'm'.tr(),
                                textAlign: TextAlign.right,
                                textStyle: AppStyle.textFieldSuffixTextStyle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              'Days'.tr(),
                              textStyle: AppStyle.textFieldTitleTextStyle,
                            ),
                            const SizedBox(height: 8),
                            CustomTextFieldWidget(
                              borderColor: AppColor.primary900Light16,
                              initialValue:
                                  state.sideWalkParams.days.toString(),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onSubmitted: (value) {
                                context.read<MunicipalAdvisorBloc>().add(
                                      MunicipalAdvisorUpdateSideWalkEvent(
                                        days: int.parse(value),
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              else if (selected && permit.permitTypeId == 1037)
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextWidget(
                              'NumberOfCarts'.tr(),
                              textStyle: AppStyle.textFieldTitleTextStyle,
                            ),
                            const SizedBox(height: 8),
                            CustomTextFieldWidget(
                              borderColor: AppColor.primary900Light16,
                              initialValue:
                                  state.nonFoodVehicleCount.toString(),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: true,
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onSubmitted: (value) {
                                context.read<MunicipalAdvisorBloc>().add(
                                      MunicipalAdvisorUpdateNonFoodVehicleCountEvent(
                                        count: int.parse(value),
                                      ),
                                    );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Expanded(
                      flex: 2,
                      child: SizedBox.shrink(),
                    )
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}
