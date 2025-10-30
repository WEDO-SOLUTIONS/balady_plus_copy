import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../core/services/local/helpers.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../reply_retrieve_vehicles_bloc/retrieve_vehicles_bloc.dart';

class ReplySubmitBtn extends StatelessWidget {
  const ReplySubmitBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReplyRetrieveVehiclesBloc, ReplyRetrieveVehiclesState>(
        builder: (context, state) {
      bool isButtonDisabled = !state.isFormValid();
      return EnhancedCustomElevatedButtonWidget(
        btnPressed: isButtonDisabled
            ? () {}
            : () {
                context
                    .read<ReplyRetrieveVehiclesBloc>()
                    .add(SubmitIncidentEvent());
              },
        btnText: Helpers.translatingWord("vhr_apply"),
        btnRadius: 8,
        btnColor:
            isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
        btnTextColor: isButtonDisabled ? AppColor.black400 : AppColor.white,
      );
    });
  }
}
