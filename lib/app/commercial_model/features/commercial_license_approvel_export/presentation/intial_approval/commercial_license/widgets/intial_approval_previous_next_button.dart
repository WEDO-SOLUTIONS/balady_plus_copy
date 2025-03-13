import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/commercial_model/features/commercial_license/commercial_license_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../../../features/_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../blocs/commercial_license_initial_Approval_bloc.dart';

class IntialApprovalPreviousNextButtons extends StatelessWidget {
  const IntialApprovalPreviousNextButtons({
    Key? key,
    required this.isBtnDisabled,
    this.onPressed,
  }) : super(key: key);

  final bool isBtnDisabled;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommercialLicenseInitialAprrovalBloc, CommercialLicenseInitialApprovalState>(
      builder: (context, state) {
        bool isLastPage = context.read<CommercialLicenseInitialAprrovalBloc>().isLastPage();
        return Container(
          color: Colors.transparent,
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: EnhancedCustomElevatedButtonWidget(
            btnColor:
                isBtnDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isBtnDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isBtnDisabled
                ? () {}
                : onPressed ??
                    () {
                      if (!isLastPage) {
                        context
                            .read<CommercialLicenseInitialAprrovalBloc>()
                            .add(const NextPageEvent());
                      } else {

                        // context.read<CommercialLicenseBloc>().add(SubmitIncidentEvent());
                      }
                    },
            btnRadius: 8,
            btnText: isLastPage ? "submit_order".tr() : ("next").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.bold,
            btnHeight: 56,
          ),
        );
      },
    );
  }
}
