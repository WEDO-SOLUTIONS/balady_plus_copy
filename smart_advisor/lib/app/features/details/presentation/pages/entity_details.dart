import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';

import '../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '../widgets/detaIils_app_bar.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/details/presentation/bloc/details_bloc.dart';
import '/app/features/details/presentation/bloc/details_event.dart';
import '/app/features/details/presentation/bloc/details_state.dart';
import '/app/features/details/presentation/widgets/tabs/first/general_info_page.dart';
import '/app/features/details/presentation/widgets/tabs/second/condition_view.dart';
import '/app/features/details/presentation/widgets/tabs/third/violations_view.dart';
import '/app/features/select_activity/domain/entities/activity_details_page_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/inspectionitems.dart';
import '../widgets/violation_view.dart';
import 'complaince/complaince_page.dart';

class EntityDetails extends StatefulWidget {
  final ActivityDetailsPageParams args;
  const EntityDetails({Key? key, required this.args}) : super(key: key);

  @override
  State<EntityDetails> createState() => _EntityDetailsState();
}

class _EntityDetailsState extends State<EntityDetails> {
  int _selectedIndexDetail = 0;
  int _selectedIndexBasic = 0;

  void _onSegmentDetail(int index) {
    setState(() {
      _selectedIndexDetail = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailsBloc(args: widget.args),
      child: BlocListener<DetailsBloc, DetailsState>(
        listenWhen: (previous, current) =>
            previous.regulationStatus != current.regulationStatus,
        listener: (context, state) {
          if (state.regulationStatus == BlocStatus.failure) {
            //     CommonFunctions.showError(state.regulationErrorMsg ?? "");
          }
        },
        child: BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            return Scaffold(
              backgroundColor: const Color(0xFFF6F8FB),
              body: Column(
                children: [
                  DetailsAppBar(
                    onSegmentBasic: (int index) {
                      setState(() {
                        _selectedIndexBasic = index;
                      });
                    },
                  ),
                  if (state.entityActivityDetailsStatus == BlocStatus.loading)
                    const Shimmer2VerticalList(),
                  if (state.entityActivityDetailsStatus == BlocStatus.failure)
                    ReloadWidget(onTab: () {
                      context
                          .read<DetailsBloc>()
                          .add(GetEntityActivityDetailsEvent());
                    }),
                  if (state.entityActivityDetailsStatus ==
                      BlocStatus.success) ...[
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(top: 20),
                        child: Column(
                          children: [
                            //add visibility

                            Visibility(
                                visible: _selectedIndexBasic == 0,
                                child: GeneralInfoPage()),

                            Visibility(
                                visible: _selectedIndexBasic == 1,
                                child: const ConditionView()),
                            /*  Visibility(
                                  visible: _selectedIndexBasic == 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  ("checklist").tr(),
                                                  style: AppStyle.heading2BoldStyle
                                                      .copyWith(
                                                          color: AppColor
                                                              .textPrimaryColor),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            //here
                                            const SelfEvaluation(),
                                          ]),
                                    ),
                                  )),*/

                            Visibility(
                                visible: _selectedIndexBasic == 2,
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: SingleChildScrollView(
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              // Text(
                                              //   ("general_violations").tr(),
                                              //   style: GoogleFonts.cairo(
                                              //       fontWeight: FontWeight.bold,
                                              //       fontSize: 18),
                                              // ),
                                              // SvgPicture.asset(IconPath.arrowGray)
                                            ],
                                          ),
                                          //here
                                          ViolationsView(),
                                        ]),
                                  ),
                                )),

                            Visibility(
                              visible: _selectedIndexBasic == 3,
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Column(
                                    children: [
                                      /* Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            // IconButton(
                                            //     onPressed: () {
                                            //       setState(() {
                                            //         isViewDetail = !isViewDetail;
                                            //       });
                                            //     },
                                            //     icon: isViewDetail
                                            //         ? Icon(Icons.keyboard_arrow_up_sharp)
                                            //         : Icon(
                                            //             Icons.keyboard_arrow_down_sharp)),
                                            RichText(
                                              text: TextSpan(
                                                text: ("visual_distortion").tr(),
                                                style: AppStyle.heading2BoldStyle
                                                    .copyWith(
                                                        color:
                                                            AppColor.textPrimaryColor),
                                                children: <TextSpan>[
                                                  TextSpan(
                                                    text: 'حي العليا',
                                                    style: AppStyle.heading2BoldStyle
                                                        .copyWith(
                                                            color: AppColor
                                                                .statusAccentColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            SvgPicture.asset(IconPath.arraowDawn),
                                          ],
                                        ),
                                        const SizedBox(height: 10.0),*/
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          //add page here
                                          //   const VisualView(),

                                          Container(
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: AppColor
                                                  .surfaceSecondaryColor,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 5,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _onSegmentDetail(0),
                                                      child: Container(
                                                        height: 40,
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5,
                                                                horizontal: 8),
                                                        decoration: BoxDecoration(
                                                            color: _selectedIndexDetail ==
                                                                    0
                                                                ? AppColor
                                                                    .statusAccentColor
                                                                : AppColor
                                                                    .white,
                                                            borderRadius: const BorderRadius
                                                                .only(
                                                                topRight: Radius
                                                                    .circular(
                                                                        10),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        10))),
                                                        child: Text(
                                                          ("inspection_items")
                                                              .tr(),
                                                          maxLines: 1,
                                                          // overflow:
                                                          //     TextOverflow.ellipsis,
                                                          style: AppStyle
                                                              .footNoteRomanStyle
                                                              .copyWith(
                                                                  color: _selectedIndexDetail ==
                                                                          0
                                                                      ? Colors
                                                                          .white
                                                                      : AppColor
                                                                          .textSecondaryColor),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () =>
                                                          _onSegmentDetail(1),
                                                      child: Container(
                                                        height: 40,
                                                        alignment:
                                                            Alignment.center,
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                vertical: 5,
                                                                horizontal: 8),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: _selectedIndexDetail ==
                                                                  1
                                                              ? AppColor
                                                                  .statusAccentColor
                                                              : AppColor.white,
                                                          borderRadius:
                                                              const BorderRadius
                                                                  .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          10),
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          10)),
                                                        ),
                                                        child: Text(
                                                          ('violations').tr(),
                                                          //style: AppStyle.heading2BoldStyle .copyWith(color: AppColor.textPrimaryColor),
                                                          style: AppStyle
                                                              .footNoteRomanStyle
                                                              .copyWith(
                                                            color: _selectedIndexDetail ==
                                                                    1
                                                                ? Colors.white
                                                                : AppColor
                                                                    .textSecondaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 20),
                                          //

                                          Visibility(
                                            visible: _selectedIndexDetail == 0,
                                            child: const Column(
                                              children: [
                                                InspectionItemList(),
                                              ],
                                            ),
                                          ),
                                          Visibility(
                                            visible: _selectedIndexDetail == 1,
                                            child: const ViolatonView(),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            Visibility(
                                visible: _selectedIndexBasic == 4,
                                child: const CompliancePage()),

                            /*  Visibility(
                                  visible: _selectedIndexBasic == 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: SingleChildScrollView(
                                      child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ("opportunitiesـcity").tr(),
                                              style: GoogleFonts.cairo(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const InvesmentCard(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const InvesmentCard(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const InvesmentCard(),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const InvesmentCard(),
                                          ]),
                                    ),
                                  )),*/
                          ],
                        ),
                      ),
                    ),
                  ]
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
