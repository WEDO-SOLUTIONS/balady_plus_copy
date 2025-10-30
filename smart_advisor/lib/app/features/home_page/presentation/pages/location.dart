import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/shared_features/new_app_bar.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {
  String? selectedOption; // To track which option is selected

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(
          right: 16.0,
          left: 16,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const NewAppBar(
                title: 'المنشآت والرخص التجارية',
              ),

              const SizedBox(height: 77),

              Text(
                'هل تعرف موقع عملك؟',
                textAlign: TextAlign.center,
                style: AppStyle.somarSemiBold
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              // const SizedBox(height: 4),
              Text(
                'الموقع الذي ستقوم بمزاولة النشاط فيه',
                textAlign: TextAlign.center,
                style: AppStyle.textRegularStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
              const SizedBox(height: 24),

              // Option buttons
              Row(
                children: [
                  Expanded(
                    child: OptionButton(
                      text: 'نعم',
                      description: 'أعرف أين سأقوم بممارسة النشاط',
                      isSelected: selectedOption == 'yes',
                      onTap: () {
                        setState(() {
                          selectedOption = 'yes';
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: OptionButton(
                      text: 'لا',
                      description: 'لم أقم بتحديد الموقع بعد',
                      isSelected: selectedOption == 'no',
                      onTap: () {
                        setState(() {
                          selectedOption = 'no';
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'الموقع',
                style: AppStyle.textRegularRomanStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              SizedBox(
                height: 8,
              ),

              // Location button
              Container(
                height: 56,
                padding: const EdgeInsets.only(top: 16, bottom: 16, right: 13),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'حدد الموقع من الخريطة',
                      style: TextStyle(fontSize: 16),
                    ),
                    SvgPicture.asset(
                        'packages/smart_advisor/smart_advisor_assets/icons/svg/grayarrow.svg'),
                  ],
                ),
              ),
              const Spacer(),
            ]),
      ),
    );
  }
}

class OptionButton extends StatelessWidget {
  final String text;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionButton({
    Key? key,
    required this.text,
    required this.description,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 108,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColor.primary : Colors.white,
            width: 2,
          ),
          color: isSelected ? Colors.white : Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: AppStyle.textRegularRomanStyle
                  .copyWith(color: AppColor.textPrimaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: AppStyle.footNoteMediumStyle
                  .copyWith(color: AppColor.textSecondaryColor),
            ),
          ],
        ),
      ),
    );
  }
}
