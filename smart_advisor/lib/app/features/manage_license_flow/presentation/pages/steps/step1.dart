// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/paths/icon_paths.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

class Step1 extends StatefulWidget {
  const Step1({super.key});

  @override
  State<Step1> createState() => _Step1State();
}

class _Step1State extends State<Step1> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColor.backgroundColor,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  right: 16.0,
                  left: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'ما الإجراء الذي تريد إنجازه لرخصتك؟',
                      style: AppStyle.somarSemiBold
                          .copyWith(color: AppColor.textPrimaryColor),
                    ),
                    Text(
                      'اختر أحد الخيارات لنساعدك في تقديم الإرشادات.',
                      style: AppStyle.textlargeRegularStyle
                          .copyWith(color: AppColor.textSecondaryColor),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    OptionButton(
                      text: 'أريد التجديد',
                      iconPath: IconPath.time,
                      isSelected: state.actionNumber == 1,
                      onTap: () {
                        context
                            .read<ManageMainFlowBloc>()
                            .add(ChangeValueEvent(actionNumber: 1));
                      },
                    ),
                    SizedBox(height: 12),
                    OptionButton(
                      text: 'أريد التعديل',
                      iconPath: IconPath.penEdit,
                      isSelected: state.actionNumber == 2,
                      onTap: () {
                        context
                            .read<ManageMainFlowBloc>()
                            .add(ChangeValueEvent(actionNumber: 2));
                      },
                    ),
                    SizedBox(height: 12),
                    OptionButton(
                      text: 'أريد الإلغاء',
                      iconPath: IconPath.fileCancel,
                      isSelected: state.actionNumber == 3,
                      onTap: () {
                        context
                            .read<ManageMainFlowBloc>()
                            .add(ChangeValueEvent(actionNumber: 3));
                      },
                    ),
                    SizedBox(height: 12),
                    OptionButton(
                      text: 'أريد نقل الملكية',
                      iconPath: IconPath.handShake,
                      isSelected: state.actionNumber == 4,
                      onTap: () {
                        context
                            .read<ManageMainFlowBloc>()
                            .add(ChangeValueEvent(actionNumber: 4));
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.text,
    required this.iconPath,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          border: Border.all(
              color: isSelected ? AppColor.primary : Colors.transparent),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Container(
                  height: 45,
                  width: 45,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Color(0xFFF3F9F5)),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: SvgPicture.asset(
                      iconPath,
                      width: 20,
                      height: 20,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Flexible(
                child: Text(
                  text,
                  style: AppStyle.textRegularRomanStyle
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
