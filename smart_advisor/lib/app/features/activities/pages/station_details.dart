// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/services/local/navigation_services.dart';
import '/app/features/activities/bloc/activite_bolc.dart';
import '/app/features/activities/bloc/activite_state.dart';
import '../../shared_features/widgets/text_item_component.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import '/app/core/utils/constants/language.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/custom_textfield_2.dart';

import '../../home_page/presentation/pages/homePage.dart';

class StationDetails extends StatelessWidget {
  const StationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => ActiviteBolc(),
        child: BlocBuilder<ActiviteBolc, ActiviteState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF8F8FB),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomAppBar(title: 'محطات'),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 18.0, right: 16, left: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('اختر نوع المنشأة ',
                              style: GoogleFonts.cairo(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 14,
                          ),
                          Text(
                            'قم باختيار نوع المنشأة الذي ترغب في الاستعلام عنه من القائمة.',
                            style: GoogleFonts.cairo(
                                fontSize: 16, color: const Color(0xFF566069)),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              const Expanded(child: const CustomTextfield2()),
                              const SizedBox(
                                width: 10,
                              ),
                              Container(
                                height: 56,
                                width: 56,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFF2E7998)),
                                child: Container(
                                  height: 26,
                                  width: 26,
                                  child: SvgPicture.asset(
                                    'packages/smart_advisor/smart_advisor_assets/images/SearchWhite.svg',
                                    height: 26,
                                    width: 26,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text(("most_common").tr(),
                              style: GoogleFonts.cairo(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 15,
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            removeBottom: true,
                            context: context,
                            child: ListView.builder(
                              itemCount: state.popularList.length,
                              itemBuilder: (context, index) {
                                return TextItemComponent(
                                  description:
                                      state.popularList[index].name ?? "",
                                );
                              },
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // children: [
                              //   const TextItemComponent(
                              //       descreption:
                              //           ' البيع بالتجزئة لوقود السيارات والدراجات النارية محطات الوقود  '),
                              //   const SizedBox(
                              //     height: 14,
                              //   ),
                              //   const TextItemComponent(
                              //       descreption:
                              //           'محطات الوقود ومراكز الخدمة فئة أ 1'),
                              //   const SizedBox(
                              //     height: 14,
                              //   ),
                              //   const TextItemComponent(
                              //       descreption:
                              //           'محطات الوقود ومراكز الخدمة فئة أ 2 '),
                              //   const SizedBox(
                              //     height: 14,
                              //   ),
                              //   const TextItemComponent(
                              //       descreption:
                              //           'محطات الوقود ومراكز الخدمة فئة ج المدمجة'),
                              // ],
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(('all_sections').tr(),
                              style: GoogleFonts.cairo(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const SizedBox(
                            height: 10,
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            removeBottom: true,
                            context: context,
                            child: ListView.builder(
                              itemCount: state.normalList.length,
                              itemBuilder: (context, index) {
                                return TextItemComponent(
                                    description:
                                        state.normalList[index].name ?? "");
                              },
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              // children: [
                              //   const TextItemComponent(
                              //       descreption:
                              //           ' محطة وقود داخل المدينة فئة د  '),
                              //   const SizedBox(
                              //     height: 14,
                              //   ),
                              //   const TextItemComponent(
                              //       descreption: ' محطة وقود صغيرة ج'),
                              //   const SizedBox(
                              //     height: 14,
                              //   ),
                              //   const TextItemComponent(
                              //       descreption: ' محطة وقود كبيرة أ '),
                              //   const SizedBox(
                              //     height: 14,
                              //   ),
                              //   const TextItemComponent(
                              //       descreption: 'محطة وقود متوسطة ب'),
                              //   const SizedBox(
                              //     height: 14,
                              //   ),
                              //   const TextItemComponent(
                              //       descreption:
                              //           'محطات الوقود ومراكز الخدمة فئة أ 1'),
                              //   const SizedBox(
                              //     height: 14,
                              //   ),
                              //   const TextItemComponent(
                              //       descreption:
                              //           'محطات الوقود ومراكز الخدمة فئة أ 2 '),
                              //   const SizedBox(
                              //     height: 14,
                              //   ),
                              //   const TextItemComponent(
                              //       descreption:
                              //           'محطات الوقود ومراكز الخدمة فئة ج المدمجة')
                              // ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(22),
                      child: CustomButton(
                          onPress: () {
                            NavigationService.navigatorKey.currentState!
                                .push(MaterialPageRoute(builder: (ctx) {
                              return HomePage();
                            }));
                          },
                          text: ("next").tr()),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
