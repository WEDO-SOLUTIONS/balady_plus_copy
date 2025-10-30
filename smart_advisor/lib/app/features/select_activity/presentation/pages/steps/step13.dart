import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

class Step13page extends StatefulWidget {
  const Step13page({super.key});

  @override
  State<Step13page> createState() => _Step13pageState();
}

class _Step13pageState extends State<Step13page> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'ما هو نوع التعاقد؟',
                    textAlign: TextAlign.center,
                    style: AppStyle.somarSemiBold
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'سيساعدنا هذا في تقديم إرشادات مصممة خصيصًا لك',
                    textAlign: TextAlign.center,
                    style: AppStyle.textRegularStyle
                        .copyWith(color: AppColor.textSecondaryColor),
                  ),
                  const SizedBox(height: 24),
                  OptionButton(
                    isSelected: state.atmOption == "ATTACH",
                    text: "تم دفع رسوم تأسيس الصراف الآلي",
                    onTap: () {
                      context
                          .read<MainFlowBloc>()
                          .add(ChangeValuesEvent(atmOption: "ATTACH"));
                    },
                  ),
                  const SizedBox(height: 16),
                  OptionButton(
                    isSelected: state.atmOption == "PAY",
                    text: "لم يتم دفع رسوم تأسيس الصراف الآلي",
                    onTap: () {
                      context
                          .read<MainFlowBloc>()
                          .add(ChangeValuesEvent(atmOption: "PAY"));
                    },
                  )
                ]),
          ),
        );
      },
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
              color: isSelected ? AppColor.primary : Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                fit: BoxFit.fill,
                child: Container(
                  height: 22,
                  width: 22,
                  child: SvgPicture.asset(
                    isSelected
                        ? 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radio.svg'
                        : 'packages/smart_advisor/smart_advisor_assets/icons/svg/Radionotselected.svg',
                    height: 22,
                    width: 22,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Text(
                text,
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
