// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import '/app/core/utils/constants/paths/icon_paths.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/language.dart';
import '/app/features/vd/widgets/header.dart';
import '/app/features/vd/widgets/library_card.dart';
import '/app/features/vd/widgets/vd_card_list.dart';
import '/app/features/vd/widgets/vd_model.dart';

List<VdModel> _list = [
  VdModel(
      icons: IconPath.arrowsButtonUpDouble,
      titleone: '300',
      subtitle: 'إجمالي البلاغات'),
  VdModel(
      icons: 'packages/smart_advisor/smart_advisor_assets/images/Arrowup.png',
      titleone: '%40',
      subtitle: ' بلاغات مغلقة'),
  VdModel(
      icons: 'packages/smart_advisor/smart_advisor_assets/images/Arrowup.png',
      titleone: '20',
      subtitle: 'يوم منذ آخر بلاغ '),
  VdModel(
      icons: 'packages/smart_advisor/smart_advisor_assets/images/Arrowup.png',
      titleone: '70',
      subtitle: 'بلاغ هذا الشهر '),
  VdModel(
      icons: 'packages/smart_advisor/smart_advisor_assets/images/Arrowup.png',
      titleone: '30',
      subtitle: 'مقدم بلاغ '),
  VdModel(
      icons: 'packages/smart_advisor/smart_advisor_assets/images/Arrowup.png',
      titleone: '46',
      subtitle: 'بلاغ تكرر اصلاحه '),
];

class VdPage extends StatelessWidget {
  const VdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE6E8EA),
      body: Column(
        children: [
          const Header(),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'visual_distortion_report'.tr(),
                      style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      height: 290,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                      ),
                      child: Column(
                        children: [
                          MediaQuery.removePadding(
                            removeTop: true,
                            removeBottom: true,
                            context: context,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 0,
                                childAspectRatio: 1,
                                crossAxisCount: 3,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _list.length,
                              itemBuilder: (context, index) {
                                return VdCardList(
                                  items: _list[index],
                                );
                              },
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Navigate to the destination page
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(builder: (context) => HomePage()),
                              // );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xfd9B8DB0),
                                    Color(0xff2B5E8E),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(11),
                              ),
                              height: 48,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 16, left: 16, top: 11, bottom: 11),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SvgPicture.asset(
                                            'packages/smart_advisor/smart_advisor_assets/images/ChartPieSlice.svg'),
                                        Text(
                                          ("full_report").tr(),
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.cairo(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                    SvgPicture.asset(IconPath.arrowRight),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      ("library_guide").tr(),
                      style: GoogleFonts.cairo(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // const LibraryGuide(),
                    ListView(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(0),
                      shrinkWrap: true,
                      children: [
                        const LibraryCard(
                            image:
                                'packages/smart_advisor/smart_advisor_assets/images/buldings.png',
                            title: 'البناء تحت الانشاء ',
                            subtitle:
                                'تعرف علي المخالفات وبنود التفتيش للمباني'),
                        const SizedBox(
                          height: 12,
                        ),
                        LibraryCard(
                            image:
                                'packages/smart_advisor/smart_advisor_assets/images/road.png',
                            title: 'الطرق والشوارع ',
                            subtitle:
                                'تعرف علي المخالفات وبنود التفتيش للمباني'),
                        const SizedBox(
                          height: 12,
                        ),
                        LibraryCard(
                            image:
                                'packages/smart_advisor/smart_advisor_assets/images/flower.png',
                            title: 'الفراغات والحدائق العامة ',
                            subtitle:
                                'تعرف علي المخالفات وبنود التفتيش للمباني')
                      ],
                    ),

                    //LibraryCard(image: image, title: title, subtitle: subtitle)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
