/*import 'package:flutter/material.dart';

import '../../../../core/base/base_view_model.dart';
import '../../../../core/services/local/helpers.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../core/services/view_models/main_health_license_view_model.dart';
import '../widgets/cancel_certificate_widgets/cancel_certificate_body_widgets.dart';
import '../widgets/cancel_certificate_widgets/cancel_certificate_footer_widget.dart';

class CancelLicenseScreenNew extends StatefulWidget {
  final Function? onCancel;

  const CancelLicenseScreenNew({Key? key, this.onCancel}) : super(key: key);

  @override
  State<CancelLicenseScreenNew> createState() => _CancelLicenseScreenNewState();
}

class _CancelLicenseScreenNewState extends State<CancelLicenseScreenNew> {
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
            title: Helpers.translatingWord("cancel_health_license"),
            subTitle: Helpers.translatingWord("cancelCertificateSubtitleWord"),
            rating: model.cancelRatingResponse?.data?.result?.rating ?? "-",
            ratingCount:
                model.cancelRatingResponse?.data?.result?.ratingCount ?? "-",
          ),
          // body
          const CancelCertificateBodyWidget(),
          // footer
          CancelCertificateFooterWidget(
            onCancel: widget.onCancel,
          ),
        ],
      ),
    );
  }
}
*/
