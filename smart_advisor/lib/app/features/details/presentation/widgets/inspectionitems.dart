// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/shimmer_card%20copy.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_bloc.dart';
import 'package:smart_advisor/app/features/details/presentation/bloc/details_state.dart';

import '../../../../core/utils/enums/bloc_status.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/constants/paths/icon_paths.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/material.dart';

class InspectionItemList extends StatefulWidget {
  const InspectionItemList({super.key});

  @override
  State<InspectionItemList> createState() => _InspectionItemListState();
}

class _InspectionItemListState extends State<InspectionItemList> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailsBloc, DetailsState>(
      builder: (context, state) {
        List<String> clauses = state.getSubClauses();
        return Column(
          children: [
            Column(
              children: [
                Container(
                  color: Colors.transparent,
                  // width: MediaQuery.of(context).size.width,

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: clauses.length,
                            itemBuilder: (ctx, index) {
                              return Container(
                                padding: const EdgeInsets.all(16.0),
                                margin: EdgeInsets.only(bottom: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: AppColor.surfaceTertairyColor),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'بند ${index + 1}',
                                          style: AppStyle.calloutBoldStyle
                                              .copyWith(
                                                  color: AppColor
                                                      .statusAccentColor),
                                        ),
                                        /* InkWell(
                                          onTap: () async {
                                            showModalBottomSheet(
                                              backgroundColor:
                                                  Color(0xff000000),
                                              isScrollControlled: true,
                                              context: context,
                                              builder: (BuildContext context) =>
                                                  InspecD(),
                                            );
                                          },
                                          child: SvgPicture.asset(
                                              IconPath.arrowOut),
                                        ),*/
                                      ],
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      clauses[index],
                                      style: AppStyle.textRegularStyle.copyWith(
                                          color: AppColor.textSecondaryColor),
                                    ),
                                    SizedBox(height: 20),
                                  ],
                                ),
                              );
                            }),
                      ),
                      if (state.vdViolationStatus == BlocStatus.loading)
                        Shimmer2VerticalList()
                      /*  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Image.asset(
                                  'packages/smart_advisor/smart_advisor_assets/images/image1.png'),
                              Positioned(
                                top: 138,
                                left: 73,
                                child: Container(
                                  width: 80,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(13.27),
                                    color: Color(0xffE94B3E),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.close,
                                        color: Color(0xffFFFFFF),
                                        size: 18,
                                      ),
                                      Text(
                                        ("non_compliant").tr(),
                                        style: GoogleFonts.cairo(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Stack(
                            children: [
                              Image.asset(
                                  'packages/smart_advisor/smart_advisor_assets/images/image2.png'),
                              Positioned(
                                top: 138,
                                left: 73,
                                child: Container(
                                  width: 80,
                                  height: 22,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(13.27),
                                    color: Color(0xff67A86A),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Color(0xffFFFFFF),
                                        size: 18,
                                      ),
                                      Text(
                                        ("compliant").tr(),
                                        style: GoogleFonts.cairo(
                                          color: Color(0xffFFFFFF),
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                                  
                                  
                                  
                                  */
                    ],
                  ),
                ),
                //   SizedBox(height: 10),
                /*   Container(
                  height: 270,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: AppColor.surfaceSecondaryColor,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'بند ٢',
                              style: AppStyle.calloutBoldStyle
                                  .copyWith(color: AppColor.statusAccentColor),
                            ),
                            SvgPicture.asset(IconPath.arrowOut),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          'القاء مخالفات البناء خارج حدود السور المؤقت او الحاويه',
                          style: AppStyle.footNoteRomanStyle
                              .copyWith(color: AppColor.textSecondaryColor),
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Stack(
                              children: [
                                Image.asset(
                                    'packages/smart_advisor/smart_advisor_assets/images/image3.png'),
                                Positioned(
                                  top: 138,
                                  left: 73,
                                  child: Container(
                                    width: 80,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(13.27),
                                      color: Color(0xffE94B3E),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.close,
                                          color: Color(0xffFFFFFF),
                                          size: 18,
                                        ),
                                        Text(
                                          ("non_compliant").tr(),
                                          style: GoogleFonts.cairo(
                                            color: Color(0xffFFFFFF),
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Stack(
                              children: [
                                Image.asset(
                                    'packages/smart_advisor/smart_advisor_assets/images/image4.png'),
                                Positioned(
                                  top: 138,
                                  left: 73,
                                  child: Container(
                                    width: 80,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(13.27),
                                      color: Color(0xff67A86A),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.check,
                                          color: Color(0xffFFFFFF),
                                          size: 18,
                                        ),
                                        Text(
                                          ("compliant").tr(),
                                          style: GoogleFonts.cairo(
                                              color: Color(0xffFFFFFF),
                                              fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        
        
        */
              ],
            ),
          ],
        );
      },
    );
  }
}
