import '../../../../core/utils/constants/app_colors.dart';
import '../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '/app/core/utils/enums/bloc_status.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/select_activity/domain/entities/categories_page_params.dart';
import '/app/features/select_activity/domain/entities/rubrics_page_params.dart';
import '/app/features/select_activity/presentation/blocs/categories_bloc/categories_bloc.dart';
import '/app/features/select_activity/presentation/dialogs/rubric_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';
import '../../../shared_features/widgets/app_bar.dart';
import '../widgets/activity_item_card.dart';
import '../widgets/title_subtitle_widget.dart';

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
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider<CategoriesBloc>(
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
            return Scaffold(
              backgroundColor: AppColor.white,
              appBar: CustomAppBar(
                title: widget.args.sector.name,
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleSubTitleWidget(
                          title: "اختر من ${widget.args.sector.name}",
                          subTitle: ""),
                      const SizedBox(
                        height: 16,
                      ),
                      Textfield(
                        onChanged: (String? str) {
                          query = str ?? "";
                          setState(() {});
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      if (state.categoriesStatus == BlocStatus.success)
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: items.length ?? 0,
                            itemBuilder: (context, index) {
                              return ActivityItemCard(
                                id: items?[index].id.toString() ?? "",
                                name: items?[index].name ?? "",
                                index: index,
                                onPress: () {
                                  showModalBottomSheet(
                                    backgroundColor: const Color(0xff000000),
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (BuildContext context) =>
                                        RubricDialog(
                                      args: RubricsPageParams(
                                          category: items![index]),
                                    ),
                                  );

                                  // Navigator.pushNamed(context, RouteName.isicsPage,
                                  //     arguments: IsicsPageParams());
                                },
                              );
                            },
                          ),
                        ),
                      if (state.categoriesStatus == BlocStatus.failure)
                        ReloadWidget(
                          onTab: () {
                            context
                                .read<CategoriesBloc>()
                                .add(const GetCategoriesEvent());
                          },
                        ),
                      if (state.categoriesStatus == BlocStatus.loading)
                        const ShimmerVerticalList(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
