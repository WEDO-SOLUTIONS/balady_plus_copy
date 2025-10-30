import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_advisor/app/core/utils/constants/app_colors.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/manage_license_flow/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/widgets/activity_item_card.dart';

import '../../../../../_shared_feature_/presentation/models/lookUp_response_model.dart';
import '../../../../../select_activity/data/models/new_activites_model.dart';

class SelectActivities extends StatefulWidget {
  static String title = "SelectActivities";

  const SelectActivities({super.key});

  @override
  State<SelectActivities> createState() => _SelectActivitiesState();
}

class _SelectActivitiesState extends State<SelectActivities> {
  LookUpItemModel? selected;
  List<LookUpItemModel> activities = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final uniqueActivityIds = <int>{};

    activities = allRegulationsData
        .where((regulation) => uniqueActivityIds.add(
            regulation.dActivitiesId)) // Ensures uniqueness of dActivitiesId
        .map((regulation) => LookUpItemModel(
              id: regulation.dActivitiesId,
              name: regulation.dActivitiesName,
              count: regulation.activitiesSum,
            ))
        .toList();
  }

  String query = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ManageMainFlowBloc, ManageMainFlowState>(
        builder: (context, state) {
      return SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ما النشاط الذي تريد التغيير له ؟",
                          style: AppStyle.somarSemiBold
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          "إختر النشاط المناسب من قائمة الانشطة التفصيلية",
                          style: AppStyle.textRegularStyle
                              .copyWith(color: AppColor.textSecondaryColor),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: activities.length,
                            itemBuilder: (context, index) {
                              return ActivityItemCard(
                                isSelected:
                                    activities[index].id == selected?.id,
                                id: activities[index].id.toString(),
                                name: activities[index].name,
                                index: index,
                                onPress: () {
                                  selected = activities[index];
                                  setState(() {});
                                  context.read<ManageMainFlowBloc>().add(
                                      ChangeValueEvent(
                                          currentPagesNumber: 3,
                                          editSelection: 0,
                                          isLastEditPage: true,
                                          selectedActivity: selected));
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (activities.isEmpty) ...[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          "packages/smart_advisor/smart_advisor_assets/images/searchimg.png",
                          height: 122,
                          width: 150,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "لا يوجد",
                          textAlign: TextAlign.center,
                          style: AppStyle.textRegularRomanStyle
                              .copyWith(color: const Color(0xFF566069)),
                        ),
                      ],
                    ),
                  )
                ],
              ],
            )
          ],
        ),
      );
    });
  }
}
