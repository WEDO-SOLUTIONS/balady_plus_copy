import 'package:flutter/services.dart';

import '../../../smart_advisor.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/start_page/widgets/internet_dialog.dart';
import 'package:flutter/material.dart';
import '/app/features/_shared_feature_/presentation/models/startpagemodel.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/start_page_item_card.dart';
import 'package:flutter_svg/svg.dart';

class Startpage extends StatefulWidget {
  Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  final List<Startpagemodel> _list = [
    Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startpageC1.png",
        title: "فتح محل تجاري ",
        subtitle: "تعرف على اشتراطات ومخالفات الرخص التجارية",
        isDisabled: false),
    Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startpageC2.png",
        title: "بناء بيت",
        subtitle: "تعرف على اشتراطات الرخص الانشائية",
        isDisabled: true),
    Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startpageC4.png",
        title: "الحفريات",
        subtitle: "تعرف على أنواع التشوه البصري وطريقة معالجته",
        isDisabled: true),
    /*  Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startpageC3.png",
        title: "دليل التشوه البصري",
        subtitle: "تعرف على أنواع التشوه البصري وطريقة معالجته"),
    Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startpageC4.png",
        title: "الحفريات",
        subtitle: "تعرف على أنواع التشوه البصري وطريقة معالجته"),
    Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startpageC5.png",
        title: "الفرص الاستثماريه",
        subtitle: "تعرف على كل الفرص الاستثماريه"),*/
  ];

  int currentIndex = -1;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topCenter,
              colors: [
                Color(0xFFD4F1F4), // Light gradient color
                Color(0xFFF4F9F9), // Light grayish color
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(SmartAdvisor.ctx);
                      },
                      icon: SvgPicture.asset(
                        IconPath.backIcon,
                        width: 12,
                        color: AppColor.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
                Text(
                  "كيف نساعدك ؟",
                  style: AppStyle.heading1BoldStyle
                      .copyWith(color: AppColor.textPrimaryColor),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 50, left: 50, top: 4),
                  child: Text(
                    "اخبرنا عن اهتماماتك لنسهل عليك معرفة كافة المتطلبات",
                    style: AppStyle.textRegularStyle
                        .copyWith(color: AppColor.textSecondaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _list.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () {
                        setState(() {
                          currentIndex = index;
                        });

                        if (currentIndex == 0) {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: const Color(0xff000000),
                            isScrollControlled: true,
                            builder: (ctx) {
                              return const InternetDialog();
                            },
                          );
                        } else if (currentIndex == 1) {
                          CommonFunctions.openWebView(
                              context: context,
                              title: 'اشتراطات إنشاء المباني السكنية',
                              URL:
                                  'https://apps.balady.gov.sa/BALADYCDN/Content/Construction/ashtratatanshaalmbanyalsknytmalqrar3.pdf');
                        }
                      },
                      child: StartPageItemCard(
                        item: _list[index],
                        isSelected: index == currentIndex,
                      ),
                    ),
                  ),
                ),
                /* CustomButton(
                    isDisabled: currentIndex == -1,
                    btnMargin: const EdgeInsets.all(16),
                    onPress: () {
                      switch (currentIndex) {
                        case 0:
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                          break;

                        case 1:
                          /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const BuildingViolationsPage()),
                          );*/
                          break;

                        case 2:
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Details()),
                          );
                          break;
                      }
                    },
                    text: ("continue").tr()),*/

                /*  InkWell(
                    onTap: () async {
                      showModalBottomSheet(
                        backgroundColor: const Color(0xff000000),
                        isScrollControlled: true,
                        context: context,
                        builder: (BuildContext context) => InternetDialog(),
                      );
                    },
                    child: SvgPicture.asset(IconPath.archiveBox)),
                const SizedBox(
                  height: 32,
                ),*/
              ],
            ),
          ),
        ),
      ),
    );
  }
}
