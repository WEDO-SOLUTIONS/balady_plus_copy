import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/services/local/helpers.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/constants.dart';
import '../../../../../core/utils/enums/enums.dart';
import '../../../../_shared_feature_/presentation/widgets/buttons/custom_buttons_widgets.dart';
import '../../blocs/ekram_book_cemetry/ekram_book_cemetry_bloc.dart';

class CemetryreviousNextButtons extends StatelessWidget {
  const CemetryreviousNextButtons({
    Key? key,
    required this.isBtnDisabled,
    this.onPressed,
  }) : super(key: key);

  final bool isBtnDisabled;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EkramBookCemetryBloc, EkramBookCemetryState>(
      builder: (context, state) {
        bool isLastPage = context.read<EkramBookCemetryBloc>().isLastPage();
        return Container(
          color: Colors.transparent,
          padding:
              const EdgeInsets.only(right: 16, left: 16, top: 5, bottom: 30),
          child: EnhancedCustomElevatedButtonWidget(
            btnColor:
                isBtnDisabled ? AppColor.black200 : AppColor.primary900Light,
            btnTextColor: isBtnDisabled ? AppColor.black400 : AppColor.white,
            btnPressed: isBtnDisabled ? () {} : onPressed ?? () {},
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
