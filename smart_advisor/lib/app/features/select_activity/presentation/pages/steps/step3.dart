import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/chat_bot_widget.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';

import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '../../../data/models/activity_item_model.dart';
import '../../widgets/activity_item_card.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/rubrics_page_params.dart';
import '/app/features/select_activity/presentation/dialogs/rubric_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step3Page extends StatefulWidget {
  static String title = "Step3Page";

  const Step3Page({super.key});

  @override
  State<Step3Page> createState() => _Step3PageState();
}

class _Step3PageState extends State<Step3Page> {
  String query = "";
  int visibleItemCount = 25; // Initial count of items to display

  void loadMoreItems() {
    setState(() {
      visibleItemCount += 25; // Increase the count by 25
    });
  }

  List<LookUpItem> sortOriginalByCount(String query,
      List<LookUpItem> originalList, List<ActivityCount> countList) {
    // Create a map of id to count for quick lookup
    final countMap = {for (var item in countList) item.id: item.count};

    // Sort the original list based on the count in countMap
    return originalList
        .where((item) => item.name.contains(query)) // Filter by query
        .toList()
      ..sort((a, b) {
        final countA = countMap[a.id] ?? 0; // Default to 0 if id is not found
        final countB = countMap[b.id] ?? 0;
        return countB.compareTo(countA); // Sort in descending order by count
      });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(builder: (context, state) {
      List<LookUpItem>? items = state.categories ?? [];
      items = sortOriginalByCount(query, items, state.categoryCount ?? []);

      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              children: [
                if (state.categoriesStatus == BlocStatus.failure)
                  ReloadWidget(
                    onTab: () {
                      context
                          .read<MainFlowBloc>()
                          .add(const GetCategoriesEvent());
                    },
                  ),
                if (state.categoriesStatus == BlocStatus.loading)
                  const Shimmer2VerticalList(),
                if (state.categoriesStatus == BlocStatus.success)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "أي من المجالات التالية يصف عملك ؟",
                            style: AppStyle.somarSemiBold
                                .copyWith(color: AppColor.textPrimaryColor),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            'سيساعدنا هذا في تقديم إرشادات مصممة خصيصًا لك',
                            style: AppStyle.textRegularStyle
                                .copyWith(color: AppColor.textSecondaryColor),
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Textfield(
                            onChanged: (String? t) {
                              setState(() {
                                query = t ?? "";
                                visibleItemCount =
                                    25; // Reset item count on new query
                              });
                            },
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: (items.length < visibleItemCount
                                  ? items.length
                                  : visibleItemCount),
                              itemBuilder: (context, index) {
                                return ActivityItemCard(
                                  isSelected: items?[index].id ==
                                      state.selectedCategory?.id,
                                  id: items![index].id.toString(),
                                  name: items[index].name,
                                  index: index,
                                  onPress: () {
                                    context.read<MainFlowBloc>().add(
                                        ChangeValuesEvent(
                                            selectedCategory: items?[index]));
                                  },
                                );
                              },
                            ),
                          ),
                          if (visibleItemCount < items.length)
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: CustomButton(
                                    onPress: loadMoreItems,
                                    text: "تحميل المزيد")),
                        ],
                      ),
                    ),
                  ),
                if (items.isEmpty &&
                    state.categoriesStatus == BlocStatus.success) ...[
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
            ),
          )
        ],
      );
    });
  }
}
