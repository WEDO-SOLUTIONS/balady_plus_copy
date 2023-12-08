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
        MunicipalAdvisorSelectUnitCountEvent,
        MunicipalAdvisorState;

class UnitCountSelector extends StatefulWidget {
  const UnitCountSelector({super.key});

  @override
  State<UnitCountSelector> createState() => _UnitCountSelectorState();
}

class _UnitCountSelectorState extends State<UnitCountSelector> {
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
              'municipalAdvisorUnitCountHint'.tr(),
              textStyle: AppStyle.subMessageTextStle,
            ),
            const SizedBox(height: 16),
            CustomTextFieldWidget(
              borderColor: AppColor.primary900Light16,
              controller: _controller,
              keyboardType: const TextInputType.numberWithOptions(
                signed: true,
                decimal: true,
              ),
              textInputAction: TextInputAction.done,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButtonWidget.choose(
              onPressed: () {
                FocusScope.of(context).unfocus();
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  final unitCount = int.tryParse(_controller.text);
                  if (unitCount != null) {
                    context.read<MunicipalAdvisorBloc>().add(
                          MunicipalAdvisorSelectUnitCountEvent(
                            unitCount: unitCount,
                          ),
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
