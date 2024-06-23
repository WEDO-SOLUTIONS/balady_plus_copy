import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../create_objection_bloc/create_objection_bloc.dart';

class AddReasonWidget extends StatelessWidget {
  const AddReasonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateObjectionBloc, CreateObjectionState>(
        builder: (context, state) {
      bool enableAddButton = state.reasons?.last.notes?.isNotEmpty ?? false;
      return CustomElevatedIconButtonWidget(
        text: ("add_reason").tr(),
        icon: CustomSvgIconWidget(
          IconPath.add,
          iconSize: 18.0,
          iconColor: enableAddButton ? null : AppColor.blackModern500Light,
        ),
        btnColor: Colors.transparent,
        textStyle: AppStyle.elevatedButtonStyle.copyWith(
          color: enableAddButton
              ? AppColor.primary800Light
              : AppColor.blackModern500Light,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        btnAlignment: MainAxisAlignment.start,
        onPressed: () {
          if (enableAddButton)
            context.read<CreateObjectionBloc>().add(AddNewReasonEvent());
        },
      );
    });
  }
}
