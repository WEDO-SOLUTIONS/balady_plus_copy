import 'package:flutter/material.dart';
import '../../../core/services/local/navigation_services.dart';
import '../../home_page/presentation/pages/new_home_page.dart';
import '/app/core/utils/constants/language.dart';

import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/features/evaluation/widget/resulte_wedgit.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import '/app/features/shared_features/widgets/custom_button.dart';

class Result extends StatelessWidget {
  const Result({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          backgroundColor: const Color(0xFFF8F7FB),
          appBar: CustomAppBar(
            title: ("Result").tr(),
          ),
          body: Padding(
            padding: const EdgeInsets.only(right: 16, left: 16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const ResultWidget(),
              const SizedBox(
                height: 35,
              ),
              Text(
                'حتى ترفع نسبه إمتثالك يجب عليك',
                style: GoogleFonts.cairo(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                height: 64,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 15, left: 15),
                  child: Text(
                    'يرجى الالتزام بتجديد الرخصة قبل انتهائها أو إلغائها في حالة عدم الرغبة في تجديدها وذلك لتجنب رسوم غرامة ',
                    style: GoogleFonts.cairo(fontSize: 12, height: 1.8),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 64,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, right: 15, left: 15),
                  child: Text(
                    'يرجى الالتزام بتجديد الرخصة قبل انتهائها أو إلغائها في حالة عدم الرغبة ',
                    style: GoogleFonts.cairo(fontSize: 12, height: 1.8),
                  ),
                ),
              ),
              const SizedBox(
                height: 70,
              ),
              InkWell(
                onTap: () {
                  // Navigate to the destination page
                  // Navigator.push(
                  //  context,
                  // MaterialPageRoute(builder: (context) => HomePage()),
                  //);
                },
                child: Container(
                  height: 51,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F7FB),
                    border:
                        Border.all(color: const Color(0xFF155F75), width: 2),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(IconPath.archiveBox),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          ("download_result").tr(),
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: const Color(0xFF155F75)),
                        ),
                      ]),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              CustomButton(
                onPress: () {
                  NavigationService.navigatorKey.currentState!
                      .push(MaterialPageRoute(builder: (ctx) {
                    return NewHomePage();
                  }));
                },
                text: ("back_main").tr(),
              ),
            ]),
          )),
    );
  }
}
