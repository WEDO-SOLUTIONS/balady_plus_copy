import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/draggable_sheet_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../_shared_feature_/presentation/widgets/texts/filter_text_field.dart';
import '../../domain/entities/events_category/events_category_item.dart';
import '../../domain/entities/search_events/search_events_params.dart';
import '../bloc/events_bloc.dart';
import '../bloc/events_event.dart';
import '../bloc/events_state.dart';

class EventsFilterDialog extends StatefulWidget {
  final EventsBloc requestsBloc;
  final SearchEventsParams params;

  const EventsFilterDialog({
    super.key,
    required this.requestsBloc,
    required this.params,
  });

  @override
  State<EventsFilterDialog> createState() => _EventsFilterDialogState();
}

class _EventsFilterDialogState extends State<EventsFilterDialog> {
  String? keyword;
  EventCategoryItem? selectedCity;
  EventCategoryItem? selectedSeason;
  EventCategoryItem? selectedAudince;
  EventCategoryItem? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.requestsBloc,
      child: SizedBox(
        width: double.infinity,
        child: BlocBuilder<EventsBloc, EventsState>(builder: (context, state) {
          return Column(
            children: [
              FilterTextField(
                hintText: "search".tr(),
                textInputType: TextInputType.text,
                initialValue: widget.params.keyword,
                onChanged: (value) {
                  print(value);
                  keyword = value;
                },
              ),
              DropDownWithTitle(
                title: "product".tr(),
                selectedValue: state.selectedCity?.name,
                status: state.cityStatus,
                onRetry: () => context.read<EventsBloc>().add(
                      GetCitiesEvent(),
                    ),
                onTap: () {
                  //MMDialog
                  BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                    context,
                    // dialogKeyName: DialogName.objectablePageProductsFilters,
                    // currentRouteName: RouteName.objectableTransactions,
                    child: GenericBottomSheetList<EventCategoryItem>(
                      title: "product".tr(),
                      items: state.citiesList ?? [],
                      selectedValue: state.selectedCity,
                      onTap: (item) {
                        selectedCity = item;
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              DropDownWithTitle(
                title: "product".tr(),
                selectedValue: state.selectedSeason?.name,
                status: state.seasonStatus,
                onRetry: () => context.read<EventsBloc>().add(
                      GetSeasonsEvent(),
                    ),
                onTap: () {
                  //MMDialog
                  BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                    context,
                    // dialogKeyName: DialogName.objectablePageProductsFilters,
                    // currentRouteName: RouteName.objectableTransactions,
                    child: GenericBottomSheetList<EventCategoryItem>(
                      title: "product".tr(),
                      items: state.seasonList ?? [],
                      selectedValue: state.selectedSeason,
                      onTap: (item) {
                        selectedSeason = item;
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              DropDownWithTitle(
                title: "product".tr(),
                selectedValue: state.selectedAudince?.name,
                status: state.audinceStatus,
                onRetry: () => context.read<EventsBloc>().add(
                      GetAudienceEvent(),
                    ),
                onTap: () {
                  //MMDialog
                  BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                    context,
                    // dialogKeyName: DialogName.objectablePageProductsFilters,
                    // currentRouteName: RouteName.objectableTransactions,
                    child: GenericBottomSheetList<EventCategoryItem>(
                      title: "product".tr(),
                      items: state.audinceList ?? [],
                      selectedValue: state.selectedAudince,
                      onTap: (item) {
                        selectedAudince = item;
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              DropDownWithTitle(
                title: "product".tr(),
                selectedValue: state.selectedCategory?.name,
                status: state.categoryStatus,
                onRetry: () => context.read<EventsBloc>().add(
                      GetCategoriesEvent(),
                    ),
                onTap: () {
                  //MMDialog
                  BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                    context,
                    // dialogKeyName: DialogName.objectablePageProductsFilters,
                    // currentRouteName: RouteName.objectableTransactions,
                    child: GenericBottomSheetList<EventCategoryItem>(
                      title: "product".tr(),
                      items: state.categoryList ?? [],
                      selectedValue: state.selectedCategory,
                      onTap: (item) {
                        setState(() {
                          selectedCategory = item;
                        });
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              ),
              Column(
                children: [
                  ElevatedButtonWidget.apply(
                    onPressed: () {
                      print("key word ${keyword}");
                      print(
                          "key word ${widget.params.copyWith(keyword: keyword).keyword}");

                      Navigator.pop(
                          context, widget.params.copyWith(keyword: keyword));
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButtonWidget.deletaAll(
                    onPressed: () {
                      /* context.read<ViolationsBloc>().add(
                      ClearViolationsFiltersEvent(),
                    );*/
                      Navigator.pop(context, true);
                    },
                  ),
                ],
              )
              /*
              */
            ],
          );
        }),
      ),
    );
  }
}
