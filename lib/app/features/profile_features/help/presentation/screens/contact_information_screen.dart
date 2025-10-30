import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:flutter/material.dart';
import '../../../../../core/utils/utils_exports.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart';

class ContactInformationScreen extends StatelessWidget {
  const ContactInformationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(title: "معلومات التواصل"),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        margin: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AppColor.white,
          boxShadow: Constants.boxShadow,
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextWidget(
              "نسعد بتواصلكم مع فريق بلدي، من خلال قنوات التواصل التالية:",
              fontColor: AppColor.blackModern600Light,
              fontWeight: AppFontWeight.bold,
              fontSize: 14,
              height: 1.5,
              maxLines: null,
            ),
            SizedBox(height: 12),
            ContactInfoCard(
              title: "حساب تويتر",
              value: "@Balady_CS",
            ),
            SizedBox(height: 8),
            ContactInfoCard(
              title: "رقم التواصل",
              value: "199040",
            ),
            SizedBox(height: 8),
            ContactInfoCard(
              title: "البريد الالكتروني",
              value: "infoCS@balady.gov.sa",
            ),
          ],
        ),
      ),
    );
  }
}

class ContactInfoCard extends StatelessWidget {
  const ContactInfoCard({
    super.key,
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AppColor.primary50Light.withOpacity(0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextWidget(
            title,
            fontColor: AppColor.primary700Light,
            fontWeight: AppFontWeight.bold,
            fontSize: 12,
          ),
          const SizedBox(height: 6),
          CustomTextWidget(
            value,
            fontColor: AppColor.blackModern600Light,
            fontWeight: AppFontWeight.bold,
            fontSize: 16,
            maxLines: null,
          ),
        ],
      ),
    );
  }
}
