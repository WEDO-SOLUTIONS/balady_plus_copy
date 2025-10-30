import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/transaction_inquiry/presentation/core/bloc/msr_bloc/msr_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import 'package:provider/provider.dart';

import '../../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../../core/view_models/inquiry/new_inquiry_view_model.dart';
import '../../../core/view_models/msr/new_msr_details_view_model.dart';

class PreviousNextButtons extends StatelessWidget {
  const PreviousNextButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MSRBloc, MSRState>(
      builder: (context, state) {
        NewMSRDetailsViewModel model = Provider.of<NewMSRDetailsViewModel>(
          context,
          listen: true,
        );
        bool isButtonDisabled = !model.isFormValid;
        bool isLastPage = context.read<MSRBloc>().isLastPage();
        return model.isLoading
            ? const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            )
            : Container(
                color: Colors.transparent,
                padding: const EdgeInsets.only(
                  right: 16,
                  left: 16,
                  top: 5,
                  bottom: 30,
                ),
                child: EnhancedCustomElevatedButtonWidget(
                  btnColor: isButtonDisabled
                      ? AppColor.black200
                      : AppColor.primary900Light,
                  btnTextColor:
                      isButtonDisabled ? AppColor.black400 : AppColor.white,
                  btnPressed: isButtonDisabled
                      ? () {}
                      : () {
                          if (!isLastPage) {
                            context.read<MSRBloc>().add(GoToNextPageEvent());
                          } else {
                            model.hideKeyboard();
                            model.submit();
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
}
