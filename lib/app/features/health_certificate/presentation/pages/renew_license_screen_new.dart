/*import 'package:flutter/material.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../core/services/view_models/main_health_license_view_model.dart';
import '../widgets/renew_certificate_widgets/renew_certificate_footer_widget.dart';

class RenewLicenseScreenNew extends StatefulWidget {
  const RenewLicenseScreenNew({Key? key}) : super(key: key);

  @override
  State<RenewLicenseScreenNew> createState() => _RenewLicenseScreenNewState();
}

class _RenewLicenseScreenNewState extends State<RenewLicenseScreenNew> {
  final model = locator<MainHealthLicenseViewModel>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white2,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // header
          ServiceCardHeaderWidget(
            title: Helpers.translatingWord("renew_health_license"),
            subTitle: Helpers.translatingWord("renewCertificateSubtitleWord"),
            rating: model.renewRatingResponse?.data?.result?.rating ?? "-",
            ratingCount:
                model.renewRatingResponse?.data?.result?.ratingCount ?? "-",
            numberOfDays: 4,
          ),
          // body
          const RenewCertificateBodyWidget(),
          // footer
          const RenewCertificateFooterWidget(),
        ],
      ),
    );
  }
}
*/
