// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/features/_shared_feature_/presentation/models/violations_model.dart';

class ViolationsList extends StatelessWidget {
  final List<ViolationsModel> items = [
    ViolationsModel(
      image: 'packages/smart_advisor/smart_advisor_assets/images/.png',
      title: 'عن ',
      subtitle: ' ة.  ',
    ),
  ];
  ViolationsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
              //     Text(
              //       'مخافات عامه',
              //       style: TextStyle(
              //           fontSize: 18,
              //           color: Color(0xff191925),
              //           fontWeight: FontWeight.bold),
              //     )
              //   ],
              // ),
              Container(
                height: 87,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF)),
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              'packages/smart_advisor/smart_advisor_assets/images/Flag.svg'),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'عدم توفير حواجز او مسافات',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'تبدا من',
                                style: GoogleFonts.cairo(
                                    fontSize: 14, color: Color(0xff455A64)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '2000',
                                style: GoogleFonts.cairo(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2E7998)),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'ريال',
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: Color(0xff455A64)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 87,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF)),
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              'packages/smart_advisor/smart_advisor_assets/images/Flag.svg'),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'الشروع في الترميم او الهدم',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'تبدا من',
                                style: GoogleFonts.cairo(
                                    fontSize: 14, color: Color(0xff455A64)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '345',
                                style: GoogleFonts.cairo(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2E7998)),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'ريال',
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: Color(0xff455A64)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'مخالفات خاصة بالنشاط',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff191925),
                    ),
                  ),
                  // IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
                  SvgPicture.asset(IconPath.arrowGray)
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 87,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF)),
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              'packages/smart_advisor/smart_advisor_assets/images/bulding.svg'),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'عدم توفير حواجز او مسافات',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'تبدا من',
                                style: GoogleFonts.cairo(
                                    fontSize: 14, color: Color(0xff455A64)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '2000',
                                style: GoogleFonts.cairo(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2E7998)),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                'ريال',
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: Color(0xff455A64)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 87,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF)),
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              'packages/smart_advisor/smart_advisor_assets/images/bulding.svg'),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'الشروع في الترميم او الهدم',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'تبدا من',
                                style: GoogleFonts.cairo(
                                    fontSize: 14, color: Color(0xff455A64)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '345',
                                style: GoogleFonts.cairo(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2E7998)),
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                'ريال',
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: Color(0xff455A64)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                height: 87,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF)),
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              'packages/smart_advisor/smart_advisor_assets/images/bulding.svg'),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'عدم توفير حواجز او مسافات',
                            style: GoogleFonts.cairo(
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'تبدا من',
                                style: GoogleFonts.cairo(
                                    fontSize: 14, color: Color(0xff455A64)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '345',
                                style: GoogleFonts.cairo(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2E7998)),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'ريال',
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: Color(0xff455A64)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 87,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Color(0xffFFFFFF)),
                child: Padding(
                  padding: const EdgeInsets.all(17.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SvgPicture.asset(
                              'packages/smart_advisor/smart_advisor_assets/images/bulding.svg'),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'عدم توفير حواجز او مسافات',
                            style: GoogleFonts.cairo(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                'تبدا من',
                                style: GoogleFonts.cairo(
                                    fontSize: 14, color: Color(0xff455A64)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                '2000',
                                style: GoogleFonts.cairo(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xff2E7998)),
                              ),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                'ريال',
                                style: GoogleFonts.cairo(
                                    fontSize: 12, color: Color(0xff455A64)),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
