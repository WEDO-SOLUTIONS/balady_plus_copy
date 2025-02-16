import 'package:balady_plus/app/features/ekram/ekram_exports.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/app_font_weights.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';

class EkramPreviousNextButtons extends StatelessWidget {
  VoidCallback? btnPressed;
   EkramPreviousNextButtons({Key? key,required this.btnPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramRequestTransportationBloc,
        EkramRequestTransportationState>(
      builder: (context, state) {
        bool isBtnDisabled = !state.isNextButtonEnabled();

        bool isLastPage =
            context.read<EkramRequestTransportationBloc>().isLastPage();
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
                : btnPressed,
            btnRadius: 8,
            btnText: isLastPage ? "ekramSubmitOrder".tr() : ("next").tr(),
            btnTextSize: 16,
            btnTextWeight: AppFontWeight.bold,
            btnHeight: 56,
          ),
        );
      },
    );
  }
}
