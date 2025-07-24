import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/_shared_feature_/domain/entities/lookUp_response.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../domain/entities/activity_details_page_params.dart';
import '../../blocs/main_flow_bloc/main_flow_bloc.dart';

class Step1Page extends StatefulWidget {
  static String title = "Step1Page";

  const Step1Page({super.key});

  @override
  State<Step1Page> createState() => _Step1PageState();
}

class _Step1PageState extends State<Step1Page> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'ما الذي تود معرفته عن الرخص التجارية للمحلات/المنشاَت؟',
                    style: AppStyle.somarSemiBold
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  OptionButton(
                    text: 'كيف أفتح منشأة جديدة ؟',
                    iconPath:
                        'packages/smart_advisor/smart_advisor_assets/icons/svg/option_1.svg',
                    isSelected: state.step1Selection == 0,
                    onTap: () {
                      context
                          .read<MainFlowBloc>()
                          .add(const ChangeValuesEvent(step1Selection: 0));
                    },
                  ),
                  const SizedBox(height: 12),
                  OptionButton(
                    text: "أرغب في تقييم درجة امتثال منشأتي",
                    iconPath:
                        'packages/smart_advisor/smart_advisor_assets/icons/svg/option_2.svg',
                    isSelected: state.step1Selection == 1,
                    onTap: () {
                      context
                          .read<MainFlowBloc>()
                          .add(const ChangeValuesEvent(step1Selection: 1));
                    },
                  ),
                  const SizedBox(height: 12),
                  OptionButton(
                    text: "كيف أدير رخصة أملكها ؟",
                    iconPath:
                        'packages/smart_advisor/smart_advisor_assets/icons/svg/option_3.svg',
                    isSelected: state.step1Selection == 2,
                    onTap: () {
                      context
                          .read<MainFlowBloc>()
                          .add(const ChangeValuesEvent(step1Selection: 2));
                    },
                  ),
                ],
              ),
            )
          ],
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
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // height: 77,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                // padding: const EdgeInsets.all(8),
                child: SvgPicture.asset(
                  iconPath,
                  // width: 45,
                  // height: 45,
                ),
              ),
              const SizedBox(
                width: 8,
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
