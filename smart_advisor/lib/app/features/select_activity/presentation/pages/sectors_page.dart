import '../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/core/services/services_exports.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/models/grideViewModel.dart';
import '/app/features/home_page/presentation/widgets/home_sector_card_item.dart';
import '/app/features/select_activity/domain/entities/addetional_activites_page_params.dart';
import '/app/features/select_activity/domain/entities/categories_page_params.dart';
import '/app/features/select_activity/presentation/blocs/sector_bloc/sector_bloc.dart';
import '/app/features/select_activity/presentation/dialogs/rubric_dialog.dart';
import '/app/features/select_activity/presentation/pages/categories_page.dart';
import '/app/features/shared_features/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/app/core/utils/constants/language.dart';
import '/app/features/_shared_feature_/presentation/widgets/custom_widgets/customTextField.dart';

class SectorsPage extends StatefulWidget {
  const SectorsPage({super.key});

  @override
  State<SectorsPage> createState() => _SectorsPageState();
}

class _SectorsPageState extends State<SectorsPage> {
  String query = "";
  @override
  Widget build(BuildContext context) {
    return BlocProvider<SectorBloc>(
      create: (context) => SectorBloc(),
      child: BlocBuilder<SectorBloc, SectorState>(
          buildWhen: (previous, current) =>
              previous.sectorStatus != current.sectorStatus,
          builder: (context, state) {
            List<LookUpItem>? items = state.sectors ?? [];
            items = items
                .map((e) {
                  if (e.name.contains(query)) return e;
                })
                .nonNulls
                .toList();

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                backgroundColor: AppColor.white,
                appBar: CustomAppBar(
                  title: "entities".tr(),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Textfield(
                          onChanged: (String? str) {
                            setState(() {
                              query = str ?? "";
                            });
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        if (state.sectorStatus == BlocStatus.failure)
                          ReloadWidget(
                            onTab: () {
                              context
                                  .read<SectorBloc>()
                                  .add(const GetSectorEvent());
                            },
                          ),
                        if (state.sectorStatus == BlocStatus.loading)
                          const ShimmerVerticalList(),
                        MediaQuery.removePadding(
                          removeTop: true,
                          context: context,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: items.length ?? 0,
                            itemBuilder: (context, index) {
                              return HomeSectorCardItem(
                                item: GrideViewModel(
                                    icon:
                                        "packages/smart_advisor/smart_advisor_assets/icons/svg/${items?[index].id}.svg",
                                    sector: items?[index].name ?? "",
                                    category: ""),
                                onPress: () {
                                  NavigationService.navigatorKey.currentState!
                                      .pushNamed(
                                    RouteName.categoriesPage,
                                    arguments: CategoriesPageParams(
                                        sector: items![index]),
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
              ),
            );
          }),
    );
  }
}
