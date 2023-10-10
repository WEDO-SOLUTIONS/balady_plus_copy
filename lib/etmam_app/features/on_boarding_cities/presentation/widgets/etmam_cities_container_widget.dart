import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart'
    show
        CityBloc,
        CityState,
        GetCitiesEvent,
        GetMoreCitiesEvent,
        SearchForCityEvent,
        SelectCityEvent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/utils_exports.dart'
    show AppColor, AppFontWeight, BorderType, IconPath, trans;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CityWidget,
        CustomPrimaryButton,
        CustomSvgIconWidget,
        CustomTextFieldWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        ReloadWidget,
        CustomLoadingWidget;
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../home/presentation/dialogs/change_city_dialog.dart';

class EtmamCitiesContainerWidget extends StatefulWidget {
  const EtmamCitiesContainerWidget({Key? key}) : super(key: key);

  @override
  State<EtmamCitiesContainerWidget> createState() =>
      _CityContainerWidgetState();
}

class _CityContainerWidgetState extends State<EtmamCitiesContainerWidget> {
  int selectedIndex = -1;
  final TextEditingController _controller = TextEditingController();
  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print("max");
        context.read<CityBloc>().add(GetMoreCitiesEvent());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String? args = ModalRoute.of(context)!.settings.arguments as String?;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          topLeft: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 22),
      child: SafeArea(
        top: false,
        child: BlocBuilder<CityBloc, CityState>(
          bloc: sl(),
          builder: (context, state) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (state.status == BlocStatus.success) ...[
                  const CustomVerticalSpace(height: 24),
                  CustomTextFieldWidget(
                    label: "",
                    hintText: trans('city_search_hint'),
                    controller: _controller,
                    maxLines: 1,
                    borderType: BorderType.outline,
                    borderRadius: 12,
                    contentVerticalPadding: 10,
                    spacerSize: 0,
                    suffixIcon: SearchIcon(
                      controller: _controller,
                    ),
                    suffixSize: 29,
                    onChanged: (String text) {
                      sl<CityBloc>().add(SearchForCityEvent(text: text));
                      setState(() {});
                    },
                    validator: (_) {},
                  ),
                  Expanded(
                    child: (state.searchedItems != null &&
                            (state.searchedItems?.length ?? 0) > 0)
                        ? NotificationListener<ScrollNotification>(
                            onNotification: (scrollNotification) {
                              if (scrollNotification.metrics.pixels ==
                                  scrollNotification.metrics.maxScrollExtent) {
                                context
                                    .read<CityBloc>()
                                    .add(GetMoreCitiesEvent());
                              }
                              return true;
                            },
                            child: GridView.builder(
                                shrinkWrap: true,
                                controller: _scrollController,
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 5),
                                //   physics: const BouncingScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 5, mainAxisExtent: 120),
                                itemCount:
                                    (state.searchedItems?.length ?? 0) + 1,
                                itemBuilder: (ctx, index) {
                                  if (index >= (state.items?.length ?? 0)) {
                                    if (state.status == BlocStatus.loadMore) {
                                      return const SizedBox(
                                        height: 50,
                                        child: Center(
                                            child: CustomLoadingWidget()),
                                      );
                                    } else {
                                      return Container(height: 50);
                                    }
                                  }

                                  return CityWidget(
                                      cityName:
                                          state.searchedItems?[index].name ??
                                              "",
                                      cityIcon: state
                                              .searchedItems?[index].imageUrl ??
                                          "",
                                      isSelected: index == selectedIndex,
                                      btnPressed: () {
                                        selectedIndex = index;
                                        setState(() {});
                                      });
                                }),
                          )
                        : EmptySearchWidget(),
                  ),
                  const CustomVerticalSpace(height: 15),
                  CustomPrimaryButton(
                    onPressed: () {
                      //   sharedPrefs.setIsFirstLaunch(false);
                      sl<CityBloc>().add(SelectCityEvent(
                          item: state.searchedItems?[selectedIndex],
                          subServiceid: args));
                      //    Navigator.of(context).pushReplacementNamed(
                      //        EtmamRoutesNames.bottomNavigation);
                    },
                    btnText: trans('choose_city'),
                    isBtnDisabled: selectedIndex < 0,
                  )
                ],
                if (state.status == BlocStatus.failure)
                  ReloadWidget(
                    widgetHeight: 100,
                    onTab: () {
                      sl<CityBloc>().add(GetCitiesEvent());
                    },
                  ),
                if (state.status == BlocStatus.loading ||
                    state.providersStatus == BlocStatus.loading)
                  const CustomLoadingWidget()
              ],
            );
          },
        ),
      ),
    );
  }
}

class SearchIcon extends StatelessWidget {
  TextEditingController controller;

  SearchIcon({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showSearch = controller.text.isEmpty;
    return GestureDetector(
      onTap: () {
        if (!showSearch) {
          controller.clear();
          sl<CityBloc>().add(SearchForCityEvent(text: ""));
        }
      },
      child: Container(
          padding: const EdgeInsetsDirectional.only(end: 12),
          child: showSearch
              ? CustomSvgIconWidget(
                  IconPath.search,
                  iconSize: 17,
                )
              : CustomSvgIconWidget(
                  IconPath.searchCancel,
                  iconSize: 17,
                )),
    );
  }
}
