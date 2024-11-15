import 'package:flutter/material.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/shimmer_card%20copy.dart';
import 'package:smart_advisor/app/features/select_activity/presentation/blocs/main_flow_bloc/main_flow_bloc.dart';

import '../../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../home_page/presentation/pages/select_activity.dart';
import '/app/core/utils/utils_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Step2Page extends StatefulWidget {
  static String title = "Step2Page";

  const Step2Page({super.key});

  @override
  State<Step2Page> createState() => _Step2PageState();
}

class _Step2PageState extends State<Step2Page> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainFlowBloc, MainFlowState>(builder: (context, state) {
      List<LookUpItem>? items = state.sectors ?? [];
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
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 16,
                          ),
                          Text(
                            "أي من القطاعات التالية يصف عملك ؟",
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
                              });
                            },
                          ),
                          MediaQuery.removePadding(
                            removeTop: true,
                            context: context,
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 24),
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: OptionButton(
                                    isSelected: state.selectedSector?.id ==
                                        items![index].id,
                                    text: items[index].name ?? "",
                                    iconPath:
                                        "packages/smart_advisor/smart_advisor_assets/icons/svg/${items[index].id}.svg",
                                    onTap: () {
                                      context.read<MainFlowBloc>().add(
                                          ChangeValuesEvent(
                                              selectedSector: items![index]));

                                      setState(() {});
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (items.isEmpty &&
                    state.sectorStatus != BlocStatus.loading &&
                    state.sectorStatus != BlocStatus.failure) ...[
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
