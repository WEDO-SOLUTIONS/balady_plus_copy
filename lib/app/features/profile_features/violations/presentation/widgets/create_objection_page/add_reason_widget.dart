import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../create_objection_bloc/create_objection_bloc.dart';

class AddReasonWidget extends StatelessWidget {
  const AddReasonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateObjectionBloc, CreateObjectionState>(
        builder: (context, state) {
      return CustomElevatedIconButtonWidget(
        text: ("add_reason").tr(),
        icon: const CustomSvgIconWidget(IconPath.add, iconSize: 18.0),
        btnColor: Colors.transparent,
        textStyle: AppStyle.elevatedButtonStyle.copyWith(
          color: AppColor.primary800Light,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
        btnAlignment: MainAxisAlignment.start,
        onPressed: () {
          context.read<CreateObjectionBloc>().add(AddNewReasonEvent());
        },
      );
    });
  }
}
