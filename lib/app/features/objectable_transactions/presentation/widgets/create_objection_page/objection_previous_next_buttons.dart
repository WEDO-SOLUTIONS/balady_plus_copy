import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/common_functions.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
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
          child: (state.status == BlocStatus.loading)
              ? const CustomCircularLoadingWidget()
              : EnhancedCustomElevatedButtonWidget(
                  btnColor: isButtonDisabled
                      ? AppColor.black200
                      : AppColor.primary900Light,
                  btnTextColor:
                      isButtonDisabled ? AppColor.black400 : AppColor.white,
                  btnPressed: isButtonDisabled
                      ? () {}
                      : () {
                          if (!isLastPage) {
                            if (state.currentPageValue == 2) {


                            if(validateForm(state)== true) {
                              context
                                  .read<CreateObjectionBloc>()
                                  .add(GoToNextPageEvent());
                            }


                            } else
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
                  btnText: isLastPage ? ("submit_order").tr() : ("next").tr(),
                  btnTextSize: 16,
                  btnTextWeight: AppFontWeight.bold,
                  btnHeight: 56,
                ),
        );
      },
    );
  }

  bool validateForm(CreateObjectionState state)
  {
    if(state.reasons != null) {
      for (int index = 0; index < state.reasons!.length; index++) {

        if (state.reasons?[index].notes
            ?.isNotEmpty ?? false) {
          if (state.reasons?[index].file == null) {
            CommonFunctions.showError("municipalAdvisorAttachmentsRequired".tr());
            return false;
          }
        }
        else {

          CommonFunctions.showError(
              "objection_create_reason_required".tr());
          return false;

        }
      }

    }
    else
    {
      CommonFunctions.showError(
          "must_enter_one_reason_for_objection".tr());
      return false;
    }

    return true;
  }


}
