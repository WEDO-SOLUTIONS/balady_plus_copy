import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart'
    show AppColor, AppStyle;
import '../../../../../_shared_feature_/shared_feature_exports.dart'
    show CustomTextFieldWidget, CustomTextWidget, ElevatedButtonWidget;
import '../../../municipal_advisor_exports.dart'
    show
        MunicipalAdvisorBloc,
        MunicipalAdvisorSelectAreaEvent,
        MunicipalAdvisorState;

class AreaSelector extends StatefulWidget {
  const AreaSelector({super.key});

  @override
  State<AreaSelector> createState() => _AreaSelectorState();
}

class _AreaSelectorState extends State<AreaSelector> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            CustomTextWidget(
              'municipalAdvisorAreaHint'.tr(),
              textStyle: AppStyle.subMessageTextStle,
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              borderColor: AppColor.primary900Light16,
              controller: _controller,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onValidate: (value) {
                if (value!.isEmpty ||
                    double.parse(value) < state.activityDetails!.minimumArea ||
                    double.parse(value) > state.activityDetails!.maximumArea) {
                  final min =
                      state.activityDetails!.minimumArea.toStringAsFixed(0);
                  String max = '';
                  if (state.activityDetails!.maximumArea != double.infinity) {
                    max =
                        '${'to'.tr()} ${state.activityDetails!.maximumArea.toStringAsFixed(0)}';
                  }
                  return '${'municipalAdvisorAreaError'.tr()} $min $max ${'m2'.tr()}';
                }

                return null;
              },
              suffixIcon: CustomTextWidget(
                'm2'.tr(),
                textAlign: TextAlign.right,
                textStyle: AppStyle.textFieldSuffixTextStyle,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.choose(
              onPressed: () {
                FocusScope.of(context).unfocus();
                //postframe
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final area = num.tryParse(_controller.text);
                  if (area != null) {
                    context.read<MunicipalAdvisorBloc>().add(
                          MunicipalAdvisorSelectAreaEvent(area: area),
                        );
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }
}
