import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/app/features/_shared_feature_/shared_feature_exports.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class ClassificationCertificateDetailsScreen extends StatefulWidget {
  const ClassificationCertificateDetailsScreen({super.key});

  @override
  State<ClassificationCertificateDetailsScreen> createState() =>
      _ClassificationCertificateDetailsScreenState();
}

class _ClassificationCertificateDetailsScreenState
    extends State<ClassificationCertificateDetailsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: DefaultAppBarWidget(
        titleWidget: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: 'query'.tr(), style: AppStyle.complianceTitleStyle),
              const WidgetSpan(
                child: SizedBox(
                  width: 10,
                ),
              ),
              TextSpan(
                text: "licenseNumber",
                style: AppStyle.listTitleTextStyle,
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(

        ),
      ),
    );
  }
}
