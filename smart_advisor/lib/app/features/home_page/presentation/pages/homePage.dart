import '../../../../core/services/local/navigation_services.dart';
import '/app/core/utils/constants/app_colors.dart';
import '/app/core/utils/utils_exports.dart';
import '/app/features/_shared_feature_/presentation/models/grideViewModel.dart';
import '/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import '/app/features/_shared_feature_/presentation/widgets/shimmer_card.dart';
import '/app/features/home_page/presentation/bloc/home_bloc.dart';
import '/app/features/home_page/presentation/bloc/home_event.dart';
import '/app/features/home_page/presentation/bloc/home_state.dart';
import '/app/features/home_page/presentation/widgets/home_sector_card_item.dart';
import '/app/features/home_page/presentation/widgets/chat_bot_widget.dart';
import '/app/features/home_page/presentation/widgets/home_header.dart';
import '/app/features/home_page/presentation/widgets/home_recent_card.dart';
import '/app/features/select_activity/domain/entities/categories_page_params.dart';
import '/app/features/shared_features/widgets/custom_button.dart';
import '/app/core/utils/constants/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/app/features/map/presentation/pages/map_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => HomeBloc(),
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            return Stack(
              children: [
                Scaffold(
                  backgroundColor: AppColor.white,
                  body: Column(
                    children: [
                      const HomeHeader(),
                      const SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 210),
                                  child: Text(
                                    ("select_entity_type").tr(),
                                    style: GoogleFonts.cairo(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                if (state.sectorStatus ==
                                    BlocStatus.success) ...[
                                  MediaQuery.removePadding(
                                    removeTop: true,
                                    context: context,
                                    child: ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount:
                                          (state.sectors?.length ?? 0) >= 3
                                              ? 3
                                              : (state.sectors?.length ?? 0),
                                      itemBuilder: (context, index) {
                                        return HomeSectorCardItem(
                                          item: GrideViewModel(
                                              icon:
                                                  "packages/smart_advisor/smart_advisor_assets/icons/svg/${state.sectors?[index].id}.svg",
                                              sector:
                                                  state.sectors?[index].name ??
                                                      "",
                                              category: ""),
                                          onPress: () {
                                            NavigationService
                                                .navigatorKey.currentState!
                                                .pushNamed(
                                                    RouteName.categoriesPage,
                                                    arguments:
                                                        CategoriesPageParams(
                                                            sector:
                                                                state.sectors![
                                                                    index]));
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                  CustomButton(
                                      btnHeight: 48,
                                      btnColor: AppColor.statusAccentColor,
                                      onPress: () {
                                        NavigationService
                                            .navigatorKey.currentState!
                                            .pushNamed(RouteName.sectors);
                                      },
                                      text: "browse_all_sectors".tr()),
                                ],
                                if (state.sectorStatus == BlocStatus.failure)
                                  ReloadWidget(
                                    onTab: () {
                                      context
                                          .read<HomeBloc>()
                                          .add(GetSectorEvent());
                                    },
                                  ),

                                if (state.sectorStatus == BlocStatus.loading)
                                  const ShimmerVerticalList(),

                                // VdCard(),
                                const SizedBox(height: 16),
                                /* Text(
                                  ("recently").tr(),
                                  style: GoogleFonts.cairo(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                               Container(
                                  height: 92,
                                  child: ListView(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      children: [
                                        HomeRecentCard(
                                          onPress: () {
                                            /*  Navigator.push(context,
                                                MaterialPageRoute(builder: (ctx) {
                                              return const MapPage();
                                            }));*/
                                          },
                                        ),
                                        HomeRecentCard(
                                          onPress: () {
                                            /* Navigator.push(context,
                                                MaterialPageRoute(builder: (ctx) {
                                              return const MapPage();
                                            }));*/
                                          },
                                        ),
                                      ]),
                                ),*/
                                const SizedBox(height: 100),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const ChatBotWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}
