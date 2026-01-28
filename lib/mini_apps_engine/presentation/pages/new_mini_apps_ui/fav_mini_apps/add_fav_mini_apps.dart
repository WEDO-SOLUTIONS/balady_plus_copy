import 'package:balady_plus/app/core/utils/constants/paths/icon_paths.dart';
import 'package:balady_plus/app/core/utils/extensions/context_conversion.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';
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
        return BlocListener<NewMiniAppLogicCubit, NewMiniAppLogicState>(
          listenWhen: (prev, curr) =>
              prev.reachLimitNumber != curr.reachLimitNumber,
          listener: (context, state) {
            CommonFunctions.showError("max_fav_apps_limit".tr());
          },
          child: Scaffold(
            //   backgroundColor: Colors.white,
            body: SafeArea(
              child: Container(
                height: context.screenHeight,
                width: context.screenWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: context.screenWidth * 0.04,
                ),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        StaggeredAppear(
                          children: [
                            if (!_isSearching)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomSubHeadingText(
                                        width: context.w(144),
                                        height: context.h(28),
                                        text: 'my_favorite_apps'.tr(),
                                        //  fontColor: const Color(0XFF242424),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18,
                                      ),
                                      CustomSubHeadingText(
                                        maxLines: 2,
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
                                      SizedBox(
                                        width: context.w(49),
                                        height: context.h(49),
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            // color: Theme.of(context).colorScheme.surface,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                              color: const Color(0xFFEDEDED),
                                              width: 1,
                                            ),
                                          ),
                                          child: Center(
                                            child: IconButton(
                                              onPressed: () =>
                                                  _startSearch(context),
                                              icon: SvgPicture.asset(
                                                Theme.of(context).brightness ==
                                                        Brightness.dark
                                                    ? IconPath.searchSVG2
                                                    : IconPath.searchSVG,
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
                                            //  color: const Color(0XFFFFFFFF),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            border: Border.all(
                                              color: const Color(0xFFEDEDED),
                                              width: 1,
                                            ),
                                          ),
                                          child: IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: Icon(
                                              Icons.close,
                                              color: Theme.of(context)
                                                  .iconTheme
                                                  .color,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            else
                              Row(
                                children: [
                                  SizedBox(
                                    width: context.w(49),
                                    height: context.h(49),
                                    child: DecoratedBox(
                                      decoration: BoxDecoration(
                                        color: const Color(0XFFFFFFFF),
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        border: Border.all(
                                          color: const Color(0xFFEDEDED),
                                          width: 1,
                                        ),
                                      ),
                                      child: IconButton(
                                        onPressed: () {
                                          if (_searchController
                                              .text.isNotEmpty) {
                                            // _searchController.clear();
                                            // context
                                            //     .read<NewMiniAppLogicCubit>()
                                            //     .searchMiniApp('');
                                            _stopSearch(context);
                                          } else {
                                            _stopSearch(context);
                                          }
                                        },
                                        icon: Icon(
                                          Icons.close,
                                          color:
                                              Theme.of(context).iconTheme.color,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: context.w(10)),
                                  Expanded(
                                    child: ValueListenableBuilder<
                                        TextEditingValue>(
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
                                              ? SvgPicture.asset(
                                                  Theme.of(context)
                                                              .brightness ==
                                                          Brightness.dark
                                                      ? IconPath.searchSVG2
                                                      : IconPath.searchSVG)
                                              : IconButton(
                                                  onPressed: () {
                                                    _searchController.clear();
                                                    context
                                                        .read<
                                                            NewMiniAppLogicCubit>()
                                                        .searchMiniApp('');
                                                  },
                                                  icon: Icon(
                                                    Icons.close_rounded,
                                                    color: Theme.of(context)
                                                        .iconTheme
                                                        .color,
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
                        if (_isSearching)
                          const Expanded(
                            child: SearchMiniAppsResultsList(),
                          )
                        else
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ! Fav apps
                                  state.favoriteApps.isNotEmpty
                                      ? const StaggeredAppear(
                                          children: [GetAllFavMiniAppsWidget()])
                                      : const SizedBox(),

                                  const SizedBox(height: 12),

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
                                              //  fontColor: const Color(0XFF242424),
                                              fontWeight: FontWeight.w700,
                                              fontSize: 18,
                                            ),
                                          ],
                                        )
                                      : const SizedBox(),

                                  const SizedBox(height: 12),

                                  const StaggeredAppear(
                                      children: [GetAllUnFavMiniAppsWidget()]),
                                  SizedBox(height: context.screenHeight * 0.08)
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: context.screenHeight * 0.08,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors:
                                Theme.of(context).brightness == Brightness.dark
                                    ? [
                                        Colors.black.withOpacity(0.0),
                                        Colors.black.withOpacity(0.6),
                                        Colors.black,
                                      ]
                                    : [
                                        Colors.white.withOpacity(0.0),
                                        Colors.white.withOpacity(0.6),
                                        Colors.white,
                                      ],
                            stops: const [0.0, 0.45, 1.0],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
