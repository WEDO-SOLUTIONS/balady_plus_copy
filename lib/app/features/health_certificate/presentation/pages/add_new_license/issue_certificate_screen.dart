/*import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show AppColors, Helpers, ServiceCardHeaderWidget, locator, AppEvents;
import 'package:balady_new_app/app/features/license_management/license_management_exports.dart'
    show
        IssueCertificateBodyWidget,
        IssueCertificateFooterWidget,
        MainHealthLicenseViewModel;
import 'package:flutter/material.dart';

class IssueCertificateScreen extends StatefulWidget {
  const IssueCertificateScreen({Key? key}) : super(key: key);

  @override
  State<IssueCertificateScreen> createState() => _IssueCertificateScreenState();
}

class _IssueCertificateScreenState extends State<IssueCertificateScreen> {
  final model = locator<MainHealthLicenseViewModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Helpers.sendEventToAnalytics(AppEvents.HealthCertificate_Apply_ServiceCard);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white2,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // header
          ServiceCardHeaderWidget(
            title: Helpers.translatingWord("issueCertificateTitleWord"),
            subTitle: Helpers.translatingWord("issueCertificateSubtitleWord"),
            rating: model.newRatingResponse?.data?.result?.rating ?? "-",
            ratingCount:
                model.newRatingResponse?.data?.result?.ratingCount ?? "-",
            numberOfDays: 4,
          ),
          // body
          const IssueCertificateBodyWidget(),
          // // footer
          const IssueCertificateFooterWidget(),
        ],
      ),
    );
  }
}
*/
