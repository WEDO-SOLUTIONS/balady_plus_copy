import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../create_objection_bloc/create_objection_bloc.dart';

class SubmitBtn extends StatelessWidget {
  const SubmitBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateObjectionBloc, CreateObjectionState>(
        builder: (context, state) {
      bool isButtonDisabled = !state.isFormValid();
      return EnhancedCustomElevatedButtonWidget(
        btnPressed: isButtonDisabled
            ? () {}
            : () {
                if (state.reasons?.first.notes?.isNotEmpty ?? false)
                  context
                      .read<CreateObjectionBloc>()
                      .add(SubmitIncidentEvent());
                else {
                  CommonFunctions.showError(
                          "must_enter_one_reason_for_objection".tr())
                      .tr();
                }
              },
        btnText: ("objection_apply").tr(),
        btnColor:
            isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
        btnTextColor: isButtonDisabled ? AppColor.black400 : AppColor.white,
      );
    });
  }
}
