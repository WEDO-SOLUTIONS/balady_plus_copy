import 'package:flutter/material.dart';
import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_button.dart';
import '../../../../../../core/utils/constants/app_colors.dart';
import '../../../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '../../../../data/models/activity_item_model.dart';
import '../../../widgets/activity_item_card.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewStep1Page extends StatefulWidget {
  static String title = "NewStep1Page";

  const NewStep1Page({super.key});

  @override
  State<NewStep1Page> createState() => _NewStep1PageState();
}

class _NewStep1PageState extends State<NewStep1Page> {
  String query = "";
  int visibleItemCount = 25; // Initial count of items to display

  void loadMoreItems() {
    setState(() {
      visibleItemCount += 25; // Increase the count by 25
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(builder: (context, state) {
      List<LookUpItem>? items = state.sectors ?? [];
      items = items.where((item) => item.name.contains(query)).toList()
        ..sort((a, b) => (b.count ?? 0).compareTo(a.count ?? 0));
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              children: [
                if (state.sectorStatus == BlocStatus.failure)
                  ReloadWidget(
                    onTab: () {
                      context.read<MainFlowBloc>().add(const GetSectorEvent());
                    },
                  ),
                if (state.sectorStatus == BlocStatus.loading)
                  const Shimmer2VerticalList(),
                if (state.sectorStatus == BlocStatus.success)
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
                                      state.selectedSector?.id,
                                  id: items![index].id.toString(),
                                  name: items[index].name,
                                  index: index,
                                  onPress: () {
                                    context.read<MainFlowBloc>().add(
                                        ChangeValuesEvent(
                                            selectedSector: items?[index]));
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
                    state.sectorStatus == BlocStatus.success) ...[
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
