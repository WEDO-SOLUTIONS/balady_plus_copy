import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show DialogHeader;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/search_widget.dart';
import 'package:flutter/material.dart';
import 'package:balady_plus/etmam_app/features/on_boarding_cities/on_boarding_cities_exports.dart'
    show CityBloc, CityState, GetCitiesEvent, SearchForCityEvent;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:flutter_bloc/flutter_bloc.dart';
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
        CustomPrimaryButton,
        CustomSvgIconWidget,
        CustomTextFieldWidget,
        CustomTextWidget,
        CustomVerticalSpace,
        ReloadWidget;

class ChangeCityDialog extends StatefulWidget {
  final Function onSelect;

  ChangeCityDialog({Key? key, required this.onSelect}) : super(key: key);

  @override
  State<ChangeCityDialog> createState() => _ChangeCityDialogState();
}

class _ChangeCityDialogState extends State<ChangeCityDialog> {
  String selectedId = CommonProperties.cityId;
  int selectedIndex = -1;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.ChangeCity);
    print("GGGG");
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CityBloc, CityState>(
      bloc: sl(),
      builder: (context, state) {
        return Container(
          padding:
              const EdgeInsets.only(right: 20, left: 20, top: 26, bottom: 10),
          child: Column(
            children: [
              // header
              DialogHeader(
                title: trans('choose_city'),
              ),
              const CustomVerticalSpace(height: 20),
              // search
              SearchWidget(
                hint: trans('search'),
                onChange: /* () {},*/
                    (text) {
                  sl<CityBloc>().add(SearchForCityEvent(text: text));
                  setState(() {});
                },
              ),
              const CustomVerticalSpace(height: 20),
              // incident type list

              if (state.status == BlocStatus.success ||
                  state.status == BlocStatus.loadMore ||
                  state.status == BlocStatus.success) ...[
                Expanded(
                  child: (state.searchedItems != null &&
                          (state.searchedItems?.length ?? 0) > 0)
                      ? GridView.builder(
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5, mainAxisExtent: 120),
                          itemCount: state.searchedItems?.length ?? 0,
                          itemBuilder: (ctx, index) {
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
                const CustomVerticalSpace(height: 15),
                CustomPrimaryButton(
                    isBtnDisabled: selectedIndex < 0,
                    onPressed: () {
                      widget.onSelect(state.searchedItems?[selectedIndex]);
                      Navigator.of(context).pop();
                    },
                    btnText: trans('choose_city'))
              ],
              if (state.status == BlocStatus.failure)
                ReloadWidget(
                  widgetHeight: 100,
                  onTab: () {
                    sl<CityBloc>().add(GetCitiesEvent());
                  },
                ),
            ],
          ),
        );
      },
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
