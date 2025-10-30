import 'package:smart_advisor/app/features/_shared_feature_/presentation/widgets/shimmer_card%20copy.dart';
import 'package:smart_advisor/app/features/shared_features/widgets/custom_text_component.dart';

import '../../../_shared_feature_/domain/entities/lookUp_response.dart';
import '../../../_shared_feature_/presentation/widgets/custom_background_header.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/presentation/widgets/shimmer_card.dart';
import '../../../home_page/presentation/widgets/sector_header.dart';
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
                backgroundColor: const Color(0xFFF4F6FB),
                body: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    SectorHeader(),
                    Expanded(
                      child: Stack(
                        children: [
                          if (state.sectorStatus == BlocStatus.failure)
                            ReloadWidget(
                              onTab: () {
                                context
                                    .read<SectorBloc>()
                                    .add(const GetSectorEvent());
                              },
                            ),
                          if (state.sectorStatus == BlocStatus.loading)
                            const Shimmer2VerticalList(),
                          if (state.sectorStatus == BlocStatus.success)
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                    ),
                                    Text(
                                      "اختر نوع المحل",
                                      style: AppStyle.heading2BoldStyle,
                                    ),
                                    const SizedBox(
                                      height: 0,
                                    ),
                                    MediaQuery.removePadding(
                                      removeTop: true,
                                      context: context,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: const EdgeInsets.only(top: 10),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: items.length,
                                        itemBuilder: (context, index) {
                                          return HomeSectorCardItem(
                                            animation: 0,
                                            item: GrideViewModel(
                                                icon:
                                                    "packages/smart_advisor/smart_advisor_assets/icons/svg/${items?[index].id}.svg",
                                                sector:
                                                    items?[index].name ?? "",
                                                category: ""),
                                            onPress: () {
                                              NavigationService
                                                  .navigatorKey.currentState!
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
                          if (items.isEmpty &&
                              state.sectorStatus != BlocStatus.loading) ...[
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
