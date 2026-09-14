import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:balady_plus/mini_apps_engine/helper/responsive_extension.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/animations/staggered_appear.dart';
import 'package:balady_plus/mini_apps_engine/new_mini_apps_logic/presentation/cubit/new_mini_app_logic_cubit.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/page_bar_section_widgets/custom_text_field.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/mini_apps_list_pages/widgets/general_widgets/custom_sub_heading_text.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/_shared/widgets/custom_mini_app_icon_button_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/get_all_fav_mini_apps_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/get_all_unfav_mini_apps_widget.dart';
import 'package:balady_plus/mini_apps_engine/presentation/pages/new_mini_apps_ui/fav_mini_apps/widgets/search_mini_apps_results_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<NewMiniAppLogicCubit, NewMiniAppLogicState>(
      listenWhen: (prev, curr) => prev.reachLimitNumber != curr.reachLimitNumber,
      listener: (context, state) {
        CommonFunctions.showError("max_fav_apps_limit".tr());
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "${'favorite_services_title'.tr()}\n",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                        fontFamily: GeneralKey.appFontType,
                      ),
                    ),

                    TextSpan(
                      text: 'favorite_services_subtitle'.tr(),
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withAlpha(120)
                            : Colors.black.withAlpha(120),
                        fontFamily: GeneralKey.appFontType,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          leading: Padding(
            padding: context.isRTL
                ? EdgeInsets.only(right: context.screenWidth * 0.02, bottom: 10)
                : EdgeInsets.only(left: context.screenWidth * 0.02, bottom: 10),
            child: const CustomMiniAppsIconButton(),
          ),
        ),
        body: SafeArea(
          child: Container(
            height: context.screenHeight,
            width: context.screenWidth,
            padding: EdgeInsets.symmetric(horizontal: context.screenWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: context.screenHeight * 0.02),
                  child: StaggeredAppear(
                    children: [
                      ValueListenableBuilder<TextEditingValue>(
                        valueListenable: _searchController,
                        builder: (context, value, child) {
                          return MiniAppsCustomTextField(
                            horizontalPadding: context.screenWidth * 0.01,
                            controller: _searchController,
                            onTap: () {},
                            keyboardType: TextInputType.text,
                            isReadOnly: false,
                            suffixIcon: value.text.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _isSearching = false;
                                      });
                                      context.read<NewMiniAppLogicCubit>().searchMiniApp('');
                                    },
                                    icon: Icon(Icons.close_rounded, color: Theme.of(context).colorScheme.onSurface),
                                  )
                                : null,
                            onChanged: (query) {
                              if (query.isNotEmpty && !_isSearching) {
                                setState(() {
                                  _isSearching = true;
                                });
                              } else if (query.isEmpty && _isSearching) {
                                setState(() {
                                  _isSearching = false;
                                });
                              }
                              context.read<NewMiniAppLogicCubit>().searchMiniApp(query);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),

                if (_isSearching)
                  Expanded(child: SearchMiniAppsResultsList(isSearching: _isSearching))
                else
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                            buildWhen: (previous, current) =>
                                previous.favoriteApps != current.favoriteApps ||
                                previous.isFavLoading != current.isFavLoading ||
                                previous.favError != current.favError,
                            builder: (context, state) {
                              if (state.favoriteApps.isEmpty && !state.isFavLoading && state.favError == null) {
                                return const SizedBox();
                              }

                              return const StaggeredAppear(children: [GetAllFavMiniAppsWidget()]);
                            },
                          ),
                          const SizedBox(height: 12),
                          BlocBuilder<NewMiniAppLogicCubit, NewMiniAppLogicState>(
                            buildWhen: (previous, current) => previous.unFavoriteApps != current.unFavoriteApps,
                            builder: (context, state) {
                              if (state.unFavoriteApps.isEmpty) {
                                return const SizedBox();
                              }

                              return StaggeredAppear(
                                initialDelay: const Duration(milliseconds: 220),
                                itemDuration: const Duration(milliseconds: 120),
                                itemDelay: const Duration(milliseconds: 100),
                                children: [
                                  CustomSubHeadingText(
                                    width: context.w(144),
                                    height: context.h(28),
                                    text: 'all_apps'.tr(),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          const GetAllUnFavMiniAppsWidget(),
                          SizedBox(height: context.screenHeight * 0.08),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
