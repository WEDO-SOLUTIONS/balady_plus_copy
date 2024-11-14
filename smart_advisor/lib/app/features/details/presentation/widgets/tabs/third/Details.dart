import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/utils_exports.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import 'package:smart_advisor/app/features/details/presentation/violation_details_bloc/violation_details_event.dart';
import 'package:smart_advisor/app/features/details/presentation/violation_details_bloc/violation_details_state.dart';

import '../../../../../../core/services/local/navigation_services.dart';
import '../../../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '../../../../../details2/widgets/correction_period.dart';
import '../../../../../select_activity/domain/entities/activity_details_page_params.dart';
import '../../../violation_details_bloc/violation_details_bloc.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/constants/app_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../details2/widgets/can_be_objected_to_card.dart';
import '../../../../../details2/widgets/infringement_card.dart';
import '../../../../../details2/widgets/item_card.dart';
import '../../../../../details2/widgets/lead_time_card.dart';
import '../../../../../details2/widgets/responsible_for_the_violation_card.dart';
import '../../../../../details2/widgets/sanction_calc.dart';

class ViolationDetails extends StatefulWidget {
  final ActivityDetailsPageParams args;
  final String linkId;

  const ViolationDetails({super.key, required this.args, required this.linkId});

  @override
  State<ViolationDetails> createState() => _DetailsState();
}

class _DetailsState extends State<ViolationDetails> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ViolationDetailsBloc(args: widget.args, linkId: widget.linkId),
      child: BlocConsumer<ViolationDetailsBloc, ViolationDetailsState>(
        listener: (context, state) {},
        buildWhen: (previous, current) =>
            previous.violationDetailsStatus != current.violationDetailsStatus,
        builder: (context, state) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.70,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16),
              child: Column(
                children: [
                  if (state.violationDetailsStatus == BlocStatus.success ||
                      state.response != null)
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 4,
                              width: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(9),
                                color: AppColor.surfaceMidContrast,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "تفاصيل المخالفة",
                                  style: AppStyle.heading2BoldStyle.copyWith(
                                      color: AppColor.textPrimaryColor),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    NavigationService.navigatorKey.currentState!
                                        .pop();
                                  },
                                  child: SvgPicture.asset(
                                      "packages/smart_advisor/smart_advisor_assets/icons/svg/Button.svg"),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            InfringementCard(
                              title: "المخالفة",
                              details: state.response?.description ?? "",
                              isCritical: state.response?.isCritical == "true",
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            ItemNumberAndNotificationCard(
                              number: state.response?.linkId ?? "",
                              notification: "",
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            if (state.response?.isCorrectionNeeded == "true")
                              LeadTimeCard(
                                title:
                                    "المهلة التصحيحية قبل إيقاع المخالفة مرة اخرى",
                                details:
                                    "${state.response?.correctionPeriod} يوم",
                              ),
                            const SizedBox(
                              height: 6,
                            ),
                            CanBeObjectedToCard(
                              canObjected:
                                  state.response?.objectionApplicable == true
                                      ? "نعم"
                                      : "لا",
                              leadTime:
                                  "${state.response?.objectionPeriod} يوم",
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            ResponsibleForTheViolationCard(
                              title: "المسؤول عن المخالفة",
                              responsible: state.response?.violatorList
                                      ?.map((e) => e.violatorIdType ?? "")
                                      .toList() ??
                                  [],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                    "قيمة الغرامة",
                                    style: AppStyle.heading2BoldStyle.copyWith(
                                        color: AppColor.textPrimaryColor),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            SanctionCalc(
                              noOfOccurences: state.noOfOccurences,
                              correction: state.response?.isCorrectionNeeded,
                              isCritical: state.response?.isCritical == "true",
                              price: state.response?.totalFineAmount ?? "",
                              index: state.noOfOccurences - 1,
                              onChangeOccurence: (int noOfOccurences) {
                                context.read<ViolationDetailsBloc>().add(
                                    GetViolationDetailsEvent(
                                        noOfOccurences: noOfOccurences));
                              },
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            /* const SanctionCard(
                                title: "العقوبة",
                                details: "أغلاق المنشاة حتى إصدار ترخيص",
                              )*/
                          ],
                        ),
                      ),
                    ),
                  if (state.violationDetailsStatus == BlocStatus.loading &&
                      state.response == null)
                    Shimmer2VerticalList(
                      height: 100,
                    ),
                  if (state.violationDetailsStatus == BlocStatus.loading &&
                      state.response != null)
                    CircularProgressIndicator(
                      color: AppColor.statusAccentColor,
                    ),
                  if (state.violationDetailsStatus == BlocStatus.failure)
                    ReloadWidget(onTab: () {
                      context.read<ViolationDetailsBloc>().add(
                          GetViolationDetailsEvent(
                              noOfOccurences: state.noOfOccurences));
                    })
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
