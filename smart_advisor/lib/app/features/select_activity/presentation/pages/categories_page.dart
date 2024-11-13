import 'package:smart_advisor/app/core/utils/constants/app_style.dart';
import 'package:smart_advisor/app/core/utils/constants/language.dart';
import 'package:smart_advisor/app/features/home_page/presentation/widgets/chat_bot_widget.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/route_names.dart';
import '../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../_shared_feature_/presentation/widgets/custom_background_header.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_card copy.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/categories_page_params.dart';
import '/app/features/select_activity/domain/entities/rubrics_page_params.dart';
import '/app/features/select_activity/presentation/blocs/categories_bloc/categories_bloc.dart';
import '/app/features/select_activity/presentation/dialogs/rubric_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/activity_item_card.dart';

class CategoriesPage extends StatefulWidget {
  final CategoriesPageParams args;
  const CategoriesPage({super.key, required this.args});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String query = "";

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CategoriesBloc>(
      create: (context) => CategoriesBloc(args: widget.args),
      child: BlocBuilder<CategoriesBloc, CategoriesState>(
          buildWhen: (previous, current) =>
              previous.categoriesStatus != current.categoriesStatus,
          builder: (context, state) {
            List<LookUpItem>? items = state.categories ?? [];
            items = items
                .map((e) {
                  if (e.name.contains(query)) return e;
                })
                .nonNulls
                .toList();

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: const Color(0xFFF4F6FB),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomImageAppBar(
                      title: "الفئة",
                      onSearch: (String? t) {
                        setState(() {
                          query = t ?? "";
                        });
                      },
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          if (state.categoriesStatus == BlocStatus.failure)
                            ReloadWidget(
                              onTab: () {
                                context
                                    .read<CategoriesBloc>()
                                    .add(const GetCategoriesEvent());
                              },
                            ),
                          if (state.categoriesStatus == BlocStatus.loading)
                            const Shimmer2VerticalList(),
                          if (state.categoriesStatus == BlocStatus.success)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: SingleChildScrollView(
                                padding: EdgeInsets.only(top: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "اختر نوع الفئة",
                                      style: AppStyle.heading2BoldStyle,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: items.length ?? 0,
                                        itemBuilder: (context, index) {
                                          return ActivityItemCard(
                                            isSelected: false,
                                            id: items?[index].id.toString() ??
                                                "",
                                            name: items?[index].name ?? "",
                                            index: index,
                                            onPress: () {
                                              showModalBottomSheet(
                                                backgroundColor:
                                                    const Color(0xff000000),
                                                isScrollControlled: true,
                                                context: context,
                                                builder:
                                                    (BuildContext context) =>
                                                        RubricDialog(
                                                  args: RubricsPageParams(
                                                      sector:
                                                          widget.args.sector,
                                                      category: items![index]),
                                                ),
                                              );
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
                                    'نتائج البحث',
                                    style: AppStyle.calloutBoldStyle.copyWith(
                                        color: AppColor.textPrimaryColor),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    "لا يوجد",
                                    textAlign: TextAlign.center,
                                    style: AppStyle.textRegularRomanStyle
                                        .copyWith(
                                            color: const Color(0xFF566069)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
