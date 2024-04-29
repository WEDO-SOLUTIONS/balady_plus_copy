import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/health_certificate/presentation/blocs/new_health_certificate_bloc/new_health_certificate_bloc.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class PreviousNextButtons extends StatelessWidget {
  bool isFormValid;
  Function onConfirm;
  PreviousNextButtons(
      {Key? key, required this.isFormValid, required this.onConfirm})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewHealthCertificateBloc, NewHealthCertificateState>(
      builder: (context, state) {
        bool isButtonDisabled = !isFormValid;
        bool isLastPage = context.read<NewHealthCertificateBloc>().isLastPage();
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
                 onConfirm();
                  },
            btnRadius: 8,
            btnText: isLastPage ? ("confirm").tr() : ("next").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.bold,
            btnHeight: 56,
          ),
        );
      },
    );
  }
}
