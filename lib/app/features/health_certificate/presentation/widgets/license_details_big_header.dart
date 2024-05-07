/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/enums/health_certificate.dart';
import '../../../_shared_feature_/presentation/widgets/custom_svg_icon_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';

class LicenseSilverAppBar extends StatefulWidget {
  final String title;
  final String licenseId;
  final LICENSE_MANAGEMENT_STATUS licenseManagementStatus;
  final String licenseStatusName;
  final Function onShareClicked;
  final bool hideShare;

  const LicenseSilverAppBar({
    Key? key,
    required this.title,
    required this.licenseId,
    required this.licenseManagementStatus,
    required this.licenseStatusName,
    required this.onShareClicked,
    this.hideShare = true,
  }) : super(key: key);

  @override
  _LicenseSilverAppBarState createState() => _LicenseSilverAppBarState();
}

class _LicenseSilverAppBarState extends State<LicenseSilverAppBar> {
  var top = 0.0;
  bool silverCollapsed = false;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 160,
      floating: false,
      leading: GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Container(
          margin: const EdgeInsets.only(right: 10),
          child: Image.asset(
            Constants.backImg,
            height: 20.0,
            width: 20.0,
            color: Colors.black,
          ),
        ),
      ),
      leadingWidth: 35,
      actions: [
        if (!widget.hideShare)
          IconButton(
            iconSize: 20,
            onPressed: () {
              widget.onShareClicked();
            },
            icon: const CustomSvgIconWidget(
              Constants.shareIcon,
              iconHeight: 20,
              iconWidth: 20,
            ),
          )
      ],
      systemOverlayStyle: SystemUiOverlayStyle.light.copyWith(
        statusBarBrightness: Brightness.light,
      ),
      flexibleSpace: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        top = constraints.biggest.height;
        double smallAppBarHeight =
            AppBar().preferredSize.height + MediaQuery.of(context).padding.top;
        if (top == smallAppBarHeight) {
          silverCollapsed = true;
        } else {
          silverCollapsed = false;
        }
        return LicenseDetailsBigHeader(
          licenseManagementStatus: widget.licenseManagementStatus,
          licensetStatusName: widget.licenseStatusName,
          title: widget.title,
          licenseId: widget.licenseId,
          isScrolled: silverCollapsed,
        );
      }),
    );
  }
}

class LicenseDetailsBigHeader extends StatefulWidget {
  final LICENSE_MANAGEMENT_STATUS licenseManagementStatus;
  final String licensetStatusName;

  final String title;
  final bool isScrolled;
  final String licenseId;

  const LicenseDetailsBigHeader({
    Key? key,
    required this.licenseManagementStatus,
    required this.licensetStatusName,
    required this.title,
    required this.isScrolled,
    required this.licenseId,
  }) : super(key: key);

  @override
  _LicenseDetailsBigHeaderState createState() =>
      _LicenseDetailsBigHeaderState();
}

class _LicenseDetailsBigHeaderState extends State<LicenseDetailsBigHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: Constants.appBarBoxShadow,
      ),
      alignment: AlignmentDirectional.topStart,
      child: FlexibleSpaceBar(
        centerTitle: true,
        title: widget.isScrolled
            ? SizedBox(
                width: MediaQuery.of(context).size.width - 60,
                child: CustomTextWidget(
                  widget.title,
                  fontColor: AppColor.black,
                  fontSize: 17,
                  maxLines: 1,
                  textScaleFactor: 1,
                  textOverflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              )
            : Container(),
        background: widget.isScrolled
            ? const Center()
            : Padding(
                padding: EdgeInsetsDirectional.only(
                  top: MediaQuery.of(context).padding.top + 60,
                  start: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //MM
                    /*
                    LicenseStatusWidget(
                      licenseStatus: widget.licenseManagementStatus,
                      licenseStatusName: widget.licensetStatusName,
                    ),*/
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
      ),
    );
  }
}
*/
