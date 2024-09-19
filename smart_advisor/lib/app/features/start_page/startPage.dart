import '../../../smart_advisor.dart';
import '../../core/services/local/navigation_services.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/start_page/widgets/internet_dialog.dart';
import 'package:flutter/material.dart';
import '/app/features/_shared_feature_/presentation/models/startpagemodel.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/start_page_item_card.dart';
import 'package:flutter_svg/svg.dart';

import '../home_page/presentation/pages/homePage.dart';

class Startpage extends StatefulWidget {
  Startpage({super.key});

  @override
  State<Startpage> createState() => _StartpageState();
}

class _StartpageState extends State<Startpage> {
  final List<Startpagemodel> _list = [
    Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startPageCardOne.png",
        title: "فتح محل تجاري ",
        subtitle: "تعرف على اشتراطات ومخالفات الرخص التجارية"),
    Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startPageCardTow.png",
        title: "بناء بيت",
        subtitle: "تعرف على اشتراطات الرخص الانشائية"),
    /*  Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startPageCardThree.png",
        title: "دليل التشوه البصري",
        subtitle: "تعرف على أنواع التشوه البصري وطريقة معالجته"),
    Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startPageCardFour.png",
        title: "الحفريات",
        subtitle: "تعرف على أنواع التشوه البصري وطريقة معالجته"),
    Startpagemodel(
        image:
            "packages/smart_advisor/smart_advisor_assets/images/startPageCardFive.png",
        title: "الفرص الاستثماريه",
        subtitle: "تعرف على أنواع التشوه البصري وطريقة معالجته"),*/
  ];

  int currentIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 40,
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
              const SizedBox(
                height: 50,
              ),
              Text(
                "كيف نساعدك ؟",
                style: AppStyle.accentBoldStyle
                    .copyWith(color: AppColor.textPrimaryColor),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 40, left: 40),
                child: Text(
                  "اخبرنا عن اهتماماتك لنساعدك ونوجه التطبيق حسب اهتماماتك واحتياجاتك",
                  style: AppStyle.textRegularRomanStyle
                      .copyWith(color: AppColor.textSecondaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
              ListView.builder(
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
                            return InternetDialog();
                          });
                    }
                  },
                  child: StartPageItemCard(
                    item: _list[index],
                    isSelected: index == currentIndex,
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
              const SizedBox(
                height: 12,
              ),
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
    );
  }
}
