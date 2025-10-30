import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions, trans;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomAppBar, CustomVerticalSpace;
import 'package:balady_plus/etmam_app/features/profile/profile_exports.dart'
    show ContactInfoSection, PersonalMainInfoSection;
import 'package:flutter/material.dart';

class PersonalInfoPage extends StatefulWidget {
  const PersonalInfoPage({Key? key}) : super(key: key);

  @override
  _PersonalInfoPage createState() => _PersonalInfoPage();
}

class _PersonalInfoPage extends State<PersonalInfoPage> {
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.PersonalInfo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: trans('personal_info'),
        ),
        body: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(top: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PersonalMainInfoSection(),
                const CustomVerticalSpace(height: 21),
                ContactInfoSection(),
                const CustomVerticalSpace(height: 30),
              ],
            ),
          ),
        ));
  }
}
