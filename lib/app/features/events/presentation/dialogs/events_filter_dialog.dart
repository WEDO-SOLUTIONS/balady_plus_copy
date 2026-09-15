import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/constants/analytics_events.dart';
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
import '../widgets/filter_date_picker.dart';

class EventsFilterDialog extends StatefulWidget {
  final EventsBloc requestsBloc;
  final SearchEventsParams params;

  const EventsFilterDialog({super.key, required this.requestsBloc, required this.params});

  @override
  State<EventsFilterDialog> createState() => _EventsFilterDialogState();
}

class _EventsFilterDialogState extends State<EventsFilterDialog> {
  String? keyword;
  EventCategoryItem? selectedCity;
  EventCategoryItem? selectedSeason;
  EventCategoryItem? selectedAudince;
  EventCategoryItem? selectedCategory;
  EventCategoryItem? selectedFees;

  DateTime? dateFrom;
  DateTime? dateTo;
  //bool? isFree;
  String? sortBy;

  final TextEditingController? textEditingController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keyword = widget.params.keyword;
    selectedCity = widget.params.selectedCity;
    selectedSeason = widget.params.selectedSeason;
    selectedAudince = widget.params.selectedAudince;
    selectedCategory = widget.params.selectedCategory;
    selectedFees = widget.params.selectedFees;
    dateFrom = widget.params.dateFrom;
    dateTo = widget.params.dateTo;
    //   isFree = widget.params.isFree;
    sortBy = widget.params.sortBy;
    textEditingController?.text = widget.params.keyword ?? "";

    CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.eventsListClickFilterEvent);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.requestsBloc,
      child: SizedBox(
        width: double.infinity,
        child: BlocBuilder<EventsBloc, EventsState>(
          builder: (context, state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FilterTextField(
                  hintText: "search".tr(),
                  textEditingController: textEditingController,
                  textInputType: TextInputType.text,
                  onChanged: (value) {
                    keyword = value;
                  },
                ),
                DropDownWithTitle(
                  title: "events_filter_city".tr(),
                  selectedValue: selectedCity?.name,
                  status: state.cityStatus,
                  onRetry: () => context.read<EventsBloc>().add(GetCitiesEvent()),
                  onTap: () {
                    //MMDialog
                    BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                      context,
                      // dialogKeyName: DialogName.objectablePageProductsFilters,
                      // currentRouteName: RouteName.objectableTransactions,
                      child: GenericBottomSheetList<EventCategoryItem>(
                        title: "events_filter_city".tr(),
                        items: state.citiesList ?? [],
                        selectedValue: selectedCity,
                        onTap: (item) {
                          setState(() {
                            selectedCity = item;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
                DropDownWithTitle(
                  title: "events_filter_season".tr(),
                  selectedValue: selectedSeason?.name,
                  status: state.seasonStatus,
                  onRetry: () => context.read<EventsBloc>().add(GetSeasonsEvent()),
                  onTap: () {
                    //MMDialog
                    BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                      context,
                      // dialogKeyName: DialogName.objectablePageProductsFilters,
                      // currentRouteName: RouteName.objectableTransactions,
                      child: GenericBottomSheetList<EventCategoryItem>(
                        title: "events_filter_season".tr(),
                        items: state.seasonList ?? [],
                        selectedValue: selectedSeason,
                        onTap: (item) {
                          setState(() {
                            selectedSeason = item;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
                DropDownWithTitle(
                  title: "events_filter_audience".tr(),
                  selectedValue: selectedAudince?.name,
                  status: state.audinceStatus,
                  onRetry: () => context.read<EventsBloc>().add(GetAudienceEvent()),
                  onTap: () {
                    //MMDialog
                    BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                      context,
                      // dialogKeyName: DialogName.objectablePageProductsFilters,
                      // currentRouteName: RouteName.objectableTransactions,
                      child: GenericBottomSheetList<EventCategoryItem>(
                        title: "events_filter_audience".tr(),
                        items: state.audinceList ?? [],
                        selectedValue: selectedAudince,
                        onTap: (item) {
                          setState(() {
                            selectedAudince = item;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
                DropDownWithTitle(
                  title: "events_filter_category".tr(),
                  selectedValue: selectedCategory?.name,
                  status: state.categoryStatus,
                  onRetry: () => context.read<EventsBloc>().add(GetCategoriesEvent()),
                  onTap: () {
                    //MMDialog
                    BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                      context,
                      // dialogKeyName: DialogName.objectablePageProductsFilters,
                      // currentRouteName: RouteName.objectableTransactions,
                      child: GenericBottomSheetList<EventCategoryItem>(
                        title: "events_filter_category".tr(),
                        items: state.categoryList ?? [],
                        selectedValue: selectedCategory,
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
                DropDownWithTitle(
                  title: "events_filter_fess".tr(),
                  selectedValue: selectedFees?.name,
                  status: state.feesStatus,
                  onRetry: () => context.read<EventsBloc>().add(GetFeesEvent()),
                  onTap: () {
                    //MMDialog
                    BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                      context,
                      // dialogKeyName: DialogName.objectablePageProductsFilters,
                      // currentRouteName: RouteName.objectableTransactions,
                      child: GenericBottomSheetList<EventCategoryItem>(
                        title: "events_filter_fess".tr(),
                        items: state.feesList ?? [],
                        selectedValue: selectedFees,
                        onTap: (item) {
                          setState(() {
                            selectedFees = item;
                          });
                          Navigator.pop(context);
                        },
                      ),
                    );
                  },
                ),
                Row(
                  children: [
                    Expanded(
                      child: EventFilterDatePicker(
                        title: "events_filter_dateFrom".tr(),
                        initialDateForm: DateForm.gregorian,
                        initialDate: dateFrom,
                        onChange: (DateTime date, DateForm dateForm) {
                          setState(() {
                            dateFrom = date;
                          });
                        },
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: EventFilterDatePicker(
                        title: "events_filter_dateTo".tr(),
                        initialDateForm: DateForm.gregorian,
                        startDate: dateFrom,
                        initialDate: dateTo,
                        onChange: (DateTime date, DateForm dateForm) {
                          setState(() {
                            dateTo = date;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                /*   CustomTextWidget(
                "events_filter_fess".tr(),
                textStyle: AppStyle.dropDownTitleTextStyle,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      decoration: ShapeDecoration(
                        color: Color(0x66E6EFEF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: CustomRadioButtonEnd<bool>(
                        title: "events_filter_fess_free".tr(),
                        value: true,
                        currentSelected: isFree,
                        onChange: (var r) {
                          setState(() {
                            isFree = r;
                          });
                        },
                        endRadio: false,
                        unSelectedBackgroundColor: Colors.transparent,
                        textSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: ShapeDecoration(
                        color: Color(0x66E6EFEF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CustomRadioButtonEnd<bool>(
                        title: "events_filter_fess_not_free".tr(),
                        value: false,
                        currentSelected: isFree,
                        onChange: (var r) {
                          setState(() {
                            isFree = r;
                          });
                        },
                        endRadio: false,
                        unSelectedBackgroundColor: Colors.transparent,
                        textSize: 16,
                      ),
                    ),
                  )
                ],
              ),*/
                // SizedBox(
                //    height: 16,
                //  ),
                /* CustomTextWidget(
                "events_filter_fess_sort".tr(),
                textStyle: AppStyle.dropDownTitleTextStyle,
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: ShapeDecoration(
                        color: Color(0x66E6EFEF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CustomRadioButtonEnd<String>(
                        title: "events_filter_fess_sort_price".tr(),
                        value: "price",
                        currentSelected: sortBy,
                        onChange: (var r) {
                          setState(() {
                            sortBy = r;
                          });
                        },
                        endRadio: false,
                        unSelectedBackgroundColor: Colors.transparent,
                        textSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: ShapeDecoration(
                        color: Color(0x66E6EFEF),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: CustomRadioButtonEnd<String>(
                        title: "events_filter_fess_sort_date".tr(),
                        value: "date",
                        currentSelected: sortBy,
                        onChange: (var r) {
                          setState(() {
                            sortBy = r;
                          });
                        },
                        endRadio: false,
                        unSelectedBackgroundColor: Colors.transparent,
                        textSize: 16,
                      ),
                    ),
                  )
                ],
              ),*/
                SizedBox(height: 40),
                Column(
                  children: [
                    ElevatedButtonWidget.apply(
                      onPressed: () {
                        Navigator.pop(
                          context,
                          widget.params.copyWith(
                            keyword: Nullable(keyword),
                            selectedAudince: Nullable(selectedAudince),
                            selectedCategory: Nullable(selectedCategory),
                            selectedCity: Nullable(selectedCity),
                            selectedSeason: Nullable(selectedSeason),
                            sortBy: Nullable(sortBy),
                            dateFrom: Nullable(dateFrom),
                            dateTo: Nullable(dateTo),
                            selectedFees: Nullable(selectedFees),
                          ),
                        );

                        CommonFunctions.sendAnalyticsEvent(AnalyticsEvents.eventsListClickApplyFilterEvent);
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButtonWidget.deletaAll(
                      onPressed: () {
                        //   Navigator.pop(context, SearchEventsParams());
                        textEditingController?.text = "";
                        keyword = null;
                        selectedCity = null;
                        selectedSeason = null;
                        selectedAudince = null;
                        selectedCategory = null;
                        selectedFees = null;
                        dateFrom = null;
                        dateTo = null;
                        //   isFree = widget.params.isFree;
                        sortBy = null;
                        setState(() {});
                      },
                    ),
                  ],
                ),
                /*
              */
              ],
            );
          },
        ),
      ),
    );
  }
}
