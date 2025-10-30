import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

import '../../../../../core/services/local/navigation_services.dart';
import '../../../../../core/utils/constants/app_colors.dart';
import '../../../../../core/utils/constants/app_style.dart';
import '../../../../../core/utils/enums/bloc_status.dart';
import '../../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '../../blocs/rubrics_bloc/rubrics_bloc.dart';
import '../../dialogs/rubric_item.dart';
import '../../widgets/activity_item_card.dart';

class Step4Page extends StatefulWidget {
  static String title = "Step4Page";

  const Step4Page({super.key});

  @override
  State<Step4Page> createState() => _Step4PageState();
}

class _Step4PageState extends State<Step4Page> {
  String query = "";
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(
        //  buildWhen: (previous, current) =>
        //      previous.rubricsStatus != current.rubricsStatus,
        builder: (context, state) {
      List<LookUpItem>? items = state.rubrics ?? [];
      items = items
          .map((e) {
            if (e.name.contains(query)) return e;
          })
          .nonNulls
          .toList();

      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Stack(
              children: [
                if (state.rubricsStatus == BlocStatus.failure)
                  ReloadWidget(
                    onTab: () {
                      context
                          .read<MainFlowBloc>()
                          .add(const GetCategoriesEvent());
                    },
                  ),
                if (state.rubricsStatus == BlocStatus.loading)
                  const Shimmer2VerticalList(),
                if (state.rubricsStatus == BlocStatus.success)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "أي من التخصصات التالية يصف عملك ؟",
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
                            height: 24,
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: items.length ?? 0,
                              itemBuilder: (context, index) {
                                return ActivityItemCard(
                                  isSelected: items?[index].id ==
                                      state.selectedRubric?.id,
                                  id: items?[index].id.toString() ?? "",
                                  name: items?[index].name ?? "",
                                  index: index,
                                  onPress: () {
                                    context.read<MainFlowBloc>().add(
                                        ChangeValuesEvent(
                                            selectedRubric: items![index]));
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (items.isEmpty &&
                    state.rubricsStatus == BlocStatus.success) ...[
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
                        /* Text(
                          'نتائج البحث',
                          style: AppStyle.calloutBoldStyle
                              .copyWith(color: AppColor.textPrimaryColor),
                        ),
                        const SizedBox(height: 10),*/
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
