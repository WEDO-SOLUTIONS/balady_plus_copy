import 'package:balady_plus/app/core/utils/constants/app_colors.dart';
import 'package:balady_plus/app/core/utils/enums/app_font_weights.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show AppStyle;
import '../../services_exports.dart' show ServiceEntity, ServiceIcon;

class ServicesList extends StatelessWidget {
  final String title;
  final List<ServiceEntity> services;
  final int crossAxisCount;

  const ServicesList({
    super.key,
    required this.title,
    required this.services,
    this.crossAxisCount = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 24),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
        borderRadius: BorderRadius.all(
          Radius.circular(16),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextWidget(
            title,
            fontSize: 16,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern800Light,
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 16,
            crossAxisSpacing: 4,
            childAspectRatio: 0.8,
            physics: const NeverScrollableScrollPhysics(),
            children: List.generate(
              services.length,
              (index) => ServiceIcon(
                service: services[index],
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
