/*import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/enums/health_certificate.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class LicenseDetailsHeaderSection extends StatefulWidget {
  final LICENSE_MANAGEMENT_STATUS licenseManagementStatus;
  final String licensetStatusName;

  final String title;
  final String licenseId;

  const LicenseDetailsHeaderSection({
    Key? key,
    required this.licenseManagementStatus,
    required this.licensetStatusName,
    required this.title,
    required this.licenseId,
  }) : super(key: key);

  @override
  _LicenseDetailsHeaderSectionState createState() =>
      _LicenseDetailsHeaderSectionState();
}

class _LicenseDetailsHeaderSectionState
    extends State<LicenseDetailsHeaderSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.topStart,
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          top: 25,
          start: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LicenseStatusWidget(
              licenseStatus: widget.licenseManagementStatus,
              licenseStatusName: widget.licensetStatusName,
            ),
            Constants.verticalSpaceSmall,
            CustomTextWidget(
              widget.title,
              fontColor: AppColor.black,
              fontSize: 22.0,
              textAlign: TextAlign.start,
              height: 1.2,
              maxLines: 1,
              textScaleFactor: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            Constants.verticalSpaceSmall,
            CustomTextWidget(
              widget.licenseId,
              fontColor: AppColor.black500,
            ),
          ],
        ),
      ),
    );
  }
}
*/
