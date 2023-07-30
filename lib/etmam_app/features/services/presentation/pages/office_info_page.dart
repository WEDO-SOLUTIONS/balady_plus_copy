import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show AboutOfficeWidget, CustomAppBar, CustomVerticalSpace;
import 'package:balady_plus/etmam_app/features/services/services_exports.dart'
    show Provider, ProviderNameAndLogoWidget;
import 'package:balady_plus/etmam_app/features/submit_request/submit_request_exports.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/utils_exports.dart' show CommonFunctions, trans;

class OfficeInfoPage extends StatefulWidget {
  Provider provider;

  OfficeInfoPage({Key? key, required this.provider}) : super(key: key);

  @override
  State<OfficeInfoPage> createState() => _OfficeInfoPageState();
}

class _OfficeInfoPageState extends State<OfficeInfoPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.OfficeInfoPage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: trans('office_info'),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                ProviderNameAndLogoWidget(
                  name: widget.provider.name ?? "",
                  logo: widget.provider.logoUrl ?? "",
                ),
                const CustomVerticalSpace(height: 20),
                WhiteCardWidget(
                  child: AboutOfficeWidget(
                    aboutOfficeDesc: widget.provider.description,
                    workingHours: widget.provider.wrokDays,
                    website: widget.provider.website,
                    mobile: widget.provider.mainBranchContact,
                    socialMedia: widget.provider.socialMediaAccounts,
                    showCallButton: true,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
