import 'package:balady_plus/app/features/classification_certificate/persentation/classification_certificate_verify/widgets/search_normal_options_widget.dart';
import 'package:flutter/material.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/presentation/widgets/default_appbar_widget.dart';
import '../widgets/search_type_widget.dart';

class ClassificationCertificateVerifyScreen extends StatelessWidget {
  const ClassificationCertificateVerifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.scaffoldBackground,
      resizeToAvoidBottomInset: true,
      appBar: DefaultAppBarWidget(
        title: "back".tr(),
        showBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "search_method".tr(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: SearchTypeWidget(
                      title: 'search_name',
                      onTap: () {},
                      isSelected: true,
                    ),
                  ),
                  Expanded(
                    child: SearchTypeWidget(
                      title: 'advanced_search',
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SearchNormalOptionsWidget(
              title: 'Test Title.',
              description: 'Test Description.',
              onTap: () {},
              value: 1,
              groupValue: 4,
            ),
            const SizedBox(height: 16),


            ElevatedButton(
              onPressed: () {},
              child: Text(
                "search".tr(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
