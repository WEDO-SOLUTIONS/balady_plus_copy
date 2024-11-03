import 'package:flutter/material.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

import '../../../../core/utils/constants/app_colors.dart';

class CustomBottomButtons extends StatelessWidget {
  final Function onNext;
  final Function onPrev;
  final bool isNextOnly;
  final bool isNextDisabled;

  const CustomBottomButtons(
      {super.key,
      required this.onNext,
      required this.onPrev,
      this.isNextDisabled = false,
      this.isNextOnly = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 122,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          if (isNextOnly == false)
            Expanded(
                child: CustomButton(
              onPress: onPrev,
              text: "السابق",
              btnBorderColor: const Color(0x941E2A36),
              btnColor: Colors.transparent,
              textColor: const Color(0x941E2A36),
            )),
          const SizedBox(
            width: 16,
          ),
          Expanded(
              flex: 2,
              child: CustomButton(
                  isDisabled: isNextDisabled, onPress: onNext, text: "التالي"))
        ],
      ),
    );
  }
}
