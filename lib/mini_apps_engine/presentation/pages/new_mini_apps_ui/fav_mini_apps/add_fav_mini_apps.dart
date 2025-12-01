import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/get_all_fav_mini_apps_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/get_all_unFav_mini_apps_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/search_mini_apps_results_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class AddFavMiniApps extends StatefulWidget {
  const AddFavMiniApps({super.key});

  @override
  State<AddFavMiniApps> createState() => _AddFavMiniAppsState();
}

class _AddFavMiniAppsState extends State<AddFavMiniApps> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch(BuildContext context) {
    setState(() {
      _isSearching = true;
    });
    _searchController.clear();
    context.read<NewMiniAppLogicCubit>().searchMiniApp('');
  }

  void _stopSearch(BuildContext context) {
    setState(() {
      _isSearching = false;
    });
    _searchController.clear();
    context.read<NewMiniAppLogicCubit>().searchMiniApp('');
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.screenWidth * 0.04,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //! Page bar (يتغيّر حسب وضع البحث)
                  StaggeredAppear(
                    children: [
                      if (!_isSearching)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CustomSubHeadingText(
                                  width: context.w(144),
                                  height: context.h(28),
                                  text: 'my_favorite_apps'.tr(),
                                  fontColor: const Color(0XFF242424),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18,
                                ),
                                CustomSubHeadingText(
                                  width: context.w(235),
                                  height: context.h(50),
                                  text:
                                      'you_can_add_your_favorite_apps_for_easy_access'
                                          .tr(),
                                  fontColor: const Color(0XFFA1A1A1),
                                  fontWeight: FontWeight.w300,
                                  fontSize: 13,
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                // Search icon → يدخل وضع البحث
                                SizedBox(
                                  width: context.w(49),
                                  height: context.h(49),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFFFFFFF),
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: const Color(0xFFEDEDED),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: IconButton(
                                        onPressed: () => _startSearch(context),
                                        icon: SvgPicture.asset(
                                          IconPath.searchSVG,
                                          width: context.w(20),
                                          height: context.h(20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: context.w(10)),
                                SizedBox(
                                  width: context.w(49),
                                  height: context.h(49),
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      color: const Color(0XFFFFFFFF),
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                        color: const Color(0xFFEDEDED),
                                        width: 1,
                                      ),
                                    ),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.close),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      else
                        //! وضع البحث: back + search field
                        Row(
                          children: [
                            SizedBox(
                              width: context.w(49),
                              height: context.h(49),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: const Color(0XFFFFFFFF),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(
                                    color: const Color(0xFFEDEDED),
                                    width: 1,
                                  ),
                                ),
                                child: IconButton(
                                  onPressed: () {
                                    if (_searchController.text.isNotEmpty) {
                                      // _searchController.clear();
                                      // context
                                      //     .read<NewMiniAppLogicCubit>()
                                      //     .searchMiniApp('');
                                      _stopSearch(context);
                                    } else {
                                      _stopSearch(context);
                                    }
                                  },
                                  icon: const Icon(Icons.close),
                                ),
                              ),
                            ),
                            SizedBox(width: context.w(10)),
                            Expanded(
                              child: ValueListenableBuilder<TextEditingValue>(
                                valueListenable: _searchController,
                                builder: (context, value, child) {
                                  final hasText = value.text.isNotEmpty;

                                  return MiniAppsCustomTextField(
                                    width: context.screenWidth * 0.75,
                                    height: context.h(49),
                                    suffixPadding: hasText
                                        ? const EdgeInsets.symmetric(
                                            horizontal: 8,
                                          ) // when user typed
                                        : const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                    autoFocus: true,
                                    autofocus: true,
                                    controller: _searchController,
                                    onTap: () {},
                                    keyboardType: TextInputType.text,
                                    isReadOnly: false,
                                    suffixString: value.text.isEmpty
                                        ? Text(
                                            "search2".tr(),
                                            style: const TextStyle(
                                              color: Colors.black,
                                            ),
                                          )
                                        : const SizedBox(),
                                    suffixIcon: value.text.isEmpty
                                        ? SvgPicture.asset(IconPath.searchSVG)
                                        : IconButton(
                                            onPressed: () {
                                              _searchController.clear();
                                              context
                                                  .read<NewMiniAppLogicCubit>()
                                                  .searchMiniApp('');
                                            },
                                            icon: const Icon(
                                              Icons.close_rounded,
                                              color: Color(0XFFB2B2B2),
                                            ),
                                          ),
                                    onChanged: (query) {
                                      context
                                          .read<NewMiniAppLogicCubit>()
                                          .searchMiniApp(query);
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),

                  SizedBox(height: context.screenHeight * 0.02),

                  //! باقي الصفحة حسب وضع البحث
                  if (_isSearching)
                    // ===== وضع البحث: نعرض نتائج البحث فقط =====
                    const Expanded(
                      child: SearchMiniAppsResultsList(),
                    )
                  else
                    // ===== الوضع العادي: المفضلة + كل التطبيقات =====
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //! Fav apps
                            state.favoriteApps.isNotEmpty
                                ? StaggeredAppear(
                                    children: [
                                      GetAllFavMiniAppsWidget(
                                        height: state.unFavoriteApps.isNotEmpty
                                            ? context.screenHeight * 0.40
                                            : context.screenHeight * 0.73,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),

                            SizedBox(height: context.screenHeight * 0.02),

                            //! All apps (unFavorite)
                            state.unFavoriteApps.isNotEmpty
                                ? StaggeredAppear(
                                    initialDelay:
                                        const Duration(milliseconds: 220),
                                    itemDuration:
                                        const Duration(milliseconds: 120),
                                    itemDelay:
                                        const Duration(milliseconds: 100),
                                    children: [
                                      CustomSubHeadingText(
                                        width: context.w(144),
                                        height: context.h(28),
                                        text: 'all_apps'.tr(),
                                        fontColor: const Color(0XFF242424),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                            SizedBox(height: context.screenHeight * 0.01),
                            state.unFavoriteApps.isNotEmpty
                                ? StaggeredAppear(
                                    initialDelay:
                                        const Duration(milliseconds: 320),
                                    itemDuration:
                                        const Duration(milliseconds: 220),
                                    itemDelay:
                                        const Duration(milliseconds: 130),
                                    children: [
                                      GetAllUnFavMiniAppsWidget(
                                        height: state.favoriteApps.isNotEmpty
                                            ? context.screenHeight * 0.30
                                            : context.screenHeight * 0.70,
                                      ),
                                    ],
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class FavSearchSectionShimmerLoadingWidget extends StatelessWidget {
  const FavSearchSectionShimmerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    const Color placeholderColor = Color(0xFFE0E0E0);

    // Height mimics the target item height: context.h(64)
    final double itemHeight = context.h(64);

    // Padding mimics the target horizontal padding
    final double horizontalPadding = context.screenWidth * 0.02;
    // In a real app, use: Shimmer.fromColors(baseColor: Colors.grey[300]!, highlightColor: Colors.grey[100]!, child: child)
    // For this example, we just return the child structure wrapped in a color.
    return ListView.separated(
        // We use the same separator logic as the original list
        separatorBuilder: (context, index) =>
            SizedBox(height: context.screenHeight * 0.02),
        scrollDirection: Axis.vertical,
        // Fixed count ensures the loading screen is consistent
        itemCount: 10,
        itemBuilder: (context, index) {
          return SizedBox(
            width: context.screenWidth,
            height: itemHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white, // Background color of the container
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: const Color(0XFFEFEEEE),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // 1. Icon Placeholder (Mimics 48x48 icon)
                        Container(
                          width: context.w(48),
                          height: context.h(48),
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        SizedBox(width: context.screenWidth * 0.02),

                        // 2. Text Placeholder (Mimics miniApp.name, 192 wide)
                        Container(
                          width: context.w(192),
                          height:
                              context.h(15), // Placeholder height for text line
                          decoration: BoxDecoration(
                            color: placeholderColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),

                    // 3. Switch Placeholder (Small indicator on the right)
                    Container(
                      width: context.w(40),
                      height: context.h(25),
                      decoration: BoxDecoration(
                        color: placeholderColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
