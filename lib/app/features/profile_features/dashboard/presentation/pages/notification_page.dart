import 'package:balady_plus/app/core/utils/constants/constants.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/services/services_exports.dart';
import '../../../../../core/utils/utils_exports.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBarWidget(
        title: "notification".tr(),
      ),
      body: NotificationCard(
        date: sharedPrefs.getFirstDateTime() != null
            ? DateTime.parse(sharedPrefs.getFirstDateTime()!)
            : DateTime.now(),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  const NotificationCard({
    super.key,
    required this.date,
  });

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: Constants.boxShadow,
        color: AppColor.white,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomSvgIconWidget(IconPath.magicStar),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextWidget(
                "notifications_text".tr(),
                fontColor: AppColor.blackModern600Light,
                fontSize: 14,
                fontWeight: AppFontWeight.bold,
              ),
              const SizedBox(height: 8),
              CustomTextWidget(
                DateFormat("yyyy-MM-dd ").format(date),
                fontColor: AppColor.blackModern400Light,
                fontSize: 10,
                fontWeight: AppFontWeight.bold,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class EmptyNotificationWidget extends StatelessWidget {
  const EmptyNotificationWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 275,
      width: MediaQuery.sizeOf(context).width,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: Constants.boxShadow,
        color: AppColor.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CustomSvgIconWidget(
            IconPath.notificationIc,
            iconSize: 52,
            iconColor: AppColor.primary200Light,
          ),
          const SizedBox(height: 6),
          CustomTextWidget(
            "notFoundNotification".tr(),
            fontSize: 18,
            fontWeight: AppFontWeight.bold,
            fontColor: AppColor.blackModern600Light,
          ),
        ],
      ),
    );
  }
}
