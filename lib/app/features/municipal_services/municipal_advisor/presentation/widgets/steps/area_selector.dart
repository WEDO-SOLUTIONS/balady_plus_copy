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
import '../../municipal_advisor_bloc/municipal_advisor_bloc.dart';
import '../addetional_activity_item_widget.dart';

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

  bool isTextValide = false;
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
                  'municipalAdvisorAreaHint'.tr(),
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
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onValidate: (value) {

                return onValidate(value,state);
                // if (value!.isEmpty ||
                //     double.parse(value) < state.activityDetails!.minimumArea ||
                //     double.parse(value) > state.activityDetails!.maximumArea) {
                //   final min =
                //       state.activityDetails!.minimumArea.toStringAsFixed(0);
                //   String max = '';
                //   if (state.activityDetails!.maximumArea != double.infinity) {
                //     max =
                //         '${'to'.tr()} ${state.activityDetails!.maximumArea.toStringAsFixed(0)}';
                //   }
                //   isTextValide = false;
                //   return '${'municipalAdvisorAreaError'.tr()} $min $max ${'m2'.tr()}';
                // }
                // isTextValide = true;
                // return null;
              },
              onChanged: (String value) async {

                if (widget.partOfLicenseCost && value.isNotEmpty)
                  {
                    if (onValidate(value,state) == null&&isTextValide == true) {
                      await Future.delayed(const Duration(seconds: 2));
                      final area = num.tryParse(_controller.text);
                      if (area != null ) {
                        context.read<MunicipalAdvisorBloc>().add(
                          MunicipalAdvisorSelectAreaEvent(
                              area: area, isCostingFrees: true),
                        );
                        context.read<MunicipalAdvisorBloc>().add(
                          MunicipalAdvisorCalculateLicenseEvent(),);
                      }
                    }


                  }
              },
              suffixIcon: CustomTextWidget(
                'm2'.tr(),
                textAlign: TextAlign.right,
                textStyle: AppStyle.textFieldSuffixTextStyle,
              ),
            ),
            const SizedBox(height: 16),

            if (widget.partOfLicenseCost)
            if (state.selectedAdditionalActivities.isNotEmpty) ...[
              ...state.selectedAdditionalActivities
                  .map((e) => AddetionalActivityItemWidget(
                item: e,
                onChangedArea: (String? value) {
                  context.read<MunicipalAdvisorBloc>().add(
                      ChangeAreaInAddetionalActivityEvent(
                          activityDetails: e, area: value ?? ""));
                  context.read<MunicipalAdvisorBloc>().add(
                    MunicipalAdvisorCalculateLicenseEvent(),);

                },
                onDelete: () {
                  context.read<MunicipalAdvisorBloc>().add(
                      DeleteAddetionalActivityEvent(
                          activityDetails: e));
                  context.read<MunicipalAdvisorBloc>().add(
                    MunicipalAdvisorCalculateLicenseEvent(),);
                },
              ))
                  .toList()
            ],

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

  String? onValidate(String? value,MunicipalAdvisorState state)
  {


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
        isTextValide = false;
        return '${'municipalAdvisorAreaError'.tr()} $min $max ${'m2'.tr()}';
      }
      isTextValide = true;
      return null;
    }



}
