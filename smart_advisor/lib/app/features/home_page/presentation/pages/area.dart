import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/area_widget.dart';
import 'package:smart_advisor/app/features/shared_features/new_app_bar.dart';

class Area extends StatefulWidget {
  const Area({super.key});

  @override
  State<Area> createState() => _AreaState();
}

class _AreaState extends State<Area> {
  int? selectedOption;

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
                title: 'فتح منشأة جديدة',
              ),

              const SizedBox(height: 77),

              Text(
                'ما هي المساحة التقديرية للمنشأة الخاصة بك؟',
                textAlign: TextAlign.center,
                style: AppStyle.somarSemiBold
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              // const SizedBox(height: 4),
              Text(
                'المساحات المتاحة لك حسب نشاطك',
                textAlign: TextAlign.center,
                style: AppStyle.textRegularStyle
                    .copyWith(color: AppColor.textSecondaryColor),
              ),
              const SizedBox(height: 24),

              SizedBox(
                height: 10,
              ),
              // buildContainer(
              //   'من 501 الى 1000م2',
              //   'مساحة كبيرة، مثالية لمحلات السوبرماركت الكبيرة، متاجر الأجهزة الكهربائية',
              //   isSelected: false,
              //   isActive: true,
              // ),
              // SizedBox(height: 16),
              // Third container (Not Active)
              // buildContainer(
              //   'أكبر من 3000م2',
              //   'مساحة ضخمة، مثالية للمراكز التجارية، محلات السوبرماركت العملاقة، أو المعارض الكبرى',
              //   isSelected: false,
              //   isActive: false,
              // ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(
                      0xFFF9F5F4), // Light background color similar to the image
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color:
                        Color(0xFFE7DAD9), // Border color similar to the image
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                            'packages/smart_advisor/smart_advisor_assets/icons/svg/warning.svg'),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'تنبيه',
                          style: AppStyle.textRegularRomanStyle
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      'يشترط نشاط "كوفي شوب داخل التموينات في مراكز الخدمة..." '
                      'الذي قمت باختياره أن لا تقل مساحة المحل عن 24 وان لا تزيد عن 1000',
                      style: AppStyle.footNoteRomanStyle
                          .copyWith(color: AppColor.textSecondaryColor),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ]),
      ),
    );
  }
}
