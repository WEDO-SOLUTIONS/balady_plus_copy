// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/shared_features/new_app_bar.dart';

class SelectActivity extends StatefulWidget {
  const SelectActivity({super.key});

  @override
  State<SelectActivity> createState() => _SelectActivityState();
}

class _SelectActivityState extends State<SelectActivity> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          NewAppBar(
            title: 'المنشآت والرخص التجارية',
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16, top: 87),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 150),
                  child: Text(
                    'مالذي تود معرفته عن المنشآت والرخص التجارية؟',
                    style: AppStyle.somarSemiBold
                        .copyWith(color: AppColor.textPrimaryColor),
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                OptionButton(
                  text: 'كيف أفتح منشأة جديدة ؟',
                  iconPath:
                      'packages/smart_advisor/smart_advisor_assets/icons/svg/55.svg',
                  isSelected: _selectedIndex == 0,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                ),
                SizedBox(height: 12),
                OptionButton(
                  text: 'كيف أدير رخصة أملكها ؟',
                  iconPath:
                      'packages/smart_advisor/smart_advisor_assets/icons/svg/55.svg',
                  isSelected: _selectedIndex == 1,
                  onTap: () {
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                ),
              ],
            ),
          )
        ],
      ),
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
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                // height: 77,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                // padding: const EdgeInsets.all(8),
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
