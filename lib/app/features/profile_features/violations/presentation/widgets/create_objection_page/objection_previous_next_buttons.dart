import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../core/utils/utils_exports.dart';
import '../../../../../_shared_feature_/shared_feature_exports.dart';
import '../../create_objection_bloc/create_objection_bloc.dart';

class ObjectionsNextButtons extends StatelessWidget {
  const ObjectionsNextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateObjectionBloc, CreateObjectionState>(
      builder: (context, state) {
        bool isButtonDisabled = false;
        bool isLastPage = context.read<CreateObjectionBloc>().isLastPage();
        return Container(
          color: Colors.transparent,
          padding: EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: EnhancedCustomElevatedButtonWidget(
            btnColor:
                isButtonDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isButtonDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isButtonDisabled
                ? () {}
                : () {
                    if (!isLastPage) {
                      context
                          .read<CreateObjectionBloc>()
                          .add(GoToNextPageEvent());
                    } else {
                      context
                          .read<CreateObjectionBloc>()
                          .add(SubmitIncidentEvent());
                    }
                  },
            btnRadius: 8,
            btnText: isLastPage ? ("vd_submit_incident").tr() : ("next").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.bold,
            btnHeight: 56,
          ),
        );
      },
    );
  }
}
