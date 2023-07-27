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
  final bool partOfLicenseCost;
  const AreaSelector({
    super.key,
    this.partOfLicenseCost = false,
  });

  @override
  State<AreaSelector> createState() => _AreaSelectorState();
}

class _AreaSelectorState extends State<AreaSelector> {
  final _controller = TextEditingController();

  @override
  initState() {
    super.initState();
    _controller.text = context
            .read<MunicipalAdvisorBloc>()
            .state
            .selectedArea
            ?.toStringAsFixed(2) ??
        '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MunicipalAdvisorBloc, MunicipalAdvisorState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: widget.partOfLicenseCost ? 16 : 4),
            if (widget.partOfLicenseCost)
              CustomTextWidget(
                'area'.tr(),
                textStyle: AppStyle.dropDownTitleTextStyle,
              )
            else
              CustomTextWidget(
                'municipalAdvisorAreaHint'.tr(),
                textStyle: AppStyle.subMessageTextStle,
              ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              borderColor: AppColor.primary900Light16,
              controller: _controller,
              // initialValue: state.selectedArea?.toStringAsFixed(2),
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
            if (!widget.partOfLicenseCost)
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
