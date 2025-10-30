import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/search_widget.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart'
    show
        CityBloc,
        CityState,
        GetCitiesEvent,
        GetMoreCitiesEvent,
        SearchForCityEvent;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import '../../../../core/utils/utils_exports.dart'
    show
        AppColor,
        AppFontWeight,
        BlocStatus,
        BorderType,
        CommonFunctions,
        CommonProperties,
        IconPath,
        trans;
import '../../../_shared_feature_/shared/shared_feature_exports.dart'
    show
        CityWidget,
        CustomLoadingWidget,
        CustomPrimaryButton,
        CustomSvgIconWidget,
        CustomTextFieldWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        ReloadWidget;

class ChangeCityDialog extends StatefulWidget {
  Function onSelect;
  ChangeCityDialog({Key? key, required this.onSelect}) : super(key: key);

  @override
  State<ChangeCityDialog> createState() => _ChangeCityDialogState();
}

class _ChangeCityDialogState extends State<ChangeCityDialog> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(
      bloc: sl(),
      builder: (context, state) {
        return CityList(
          onSelect: widget.onSelect,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    // sl<CityBloc>().add(SearchForCityEvent(text: ""));
  }
}

class CityList extends StatefulWidget {
  Function onSelect;

  CityList({Key? key, required this.onSelect}) : super(key: key);

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  String selectedId = CommonProperties.cityId;
  int selectedIndex = -1;
  final TextEditingController _controller = TextEditingController();

  ScrollController _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        sl<CityBloc>().add(const GetMoreCitiesEvent());
      }
    });
    print("Selected ID ${CommonProperties.cityId}");
    selectedId = CommonProperties.cityId;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(
        bloc: sl(),
        builder: (context, state) {
          return Column(
            children: [
              if (state.status == BlocStatus.success ||
                  state.status == BlocStatus.loadMore ||
                  state.status == BlocStatus.loadingShimmer) ...[
                SearchWidget(
                  hint: trans('search'),
                  onChange: /* () {},*/
                      (text) {
                    sl<CityBloc>().add(SearchForCityEvent(text: text));
                    setState(() {});
                  },
                ),
                const CustomVerticalSpace(height: 24),
                Expanded(
                  child: (state.searchedItems != null &&
                          (state.searchedItems?.length ?? 0) > 0)
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4, mainAxisExtent: 120),
                          itemCount: (state.searchedItems?.length ?? 0 + 1),
                          controller: _scrollController,
                          itemBuilder: (ctx, index) {
                            /* if (index >= (state.items?.length ?? 0)) {
                              if (state.status == BlocStatus.loadMore) {
                                return const SizedBox(
                                  height: 50,
                                  child: Center(child: CustomLoadingWidget()),
                                );
                              } else {
                                return Container(height: 50);
                              }
                            }*/

                            return CityWidget(
                                cityName:
                                    state.searchedItems?[index].name ?? "",
                                cityIcon:
                                    state.searchedItems?[index].imageUrl ?? "",
                                isSelected:
                                    (state.searchedItems?[index].id ?? "") ==
                                        selectedId,
                                btnPressed: () {
                                  selectedId =
                                      state.searchedItems?[index].id ?? "";
                                  selectedIndex = index;
                                  setState(() {});
                                });
                          })
                      : EmptySearchWidget(),
                ),
                if (state.status == BlocStatus.loadMore) CustomLoadingWidget(),
                const CustomVerticalSpace(height: 15),
                CustomPrimaryButton(
                    isBtnDisabled: selectedIndex < 0,
                    onPressed: () {
                      widget.onSelect(state.searchedItems?[selectedIndex]);
                      Navigator.of(context).pop();
                    },
                    btnText: trans('choose_city'))
              ],
              if (state.status == BlocStatus.loading) CustomLoadingWidget(),
              if (state.status == BlocStatus.failure)
                ReloadWidget(
                  widgetHeight: 100,
                  onTab: () {
                    sl<CityBloc>().add(GetCitiesEvent());
                  },
                ),
            ],
          );
        });
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
          sl<CityBloc>().add(SearchForCityEvent(text: controller.text));
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

class EmptySearchWidget extends StatelessWidget {
  const EmptySearchWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomTextWidget(
            trans('Search_NoResultTitle'),
            fontSize: 18.0,
            fontColor: AppColor.hunterGreen,
            fontWeight: AppFontWeight.w600,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
