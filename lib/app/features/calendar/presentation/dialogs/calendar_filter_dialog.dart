import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/draggable_sheet_component.dart';
import 'package:balady_plus/app/features/calendar/presentation/bloc/calendar_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/common_functions.dart';
import '../../../../core/utils/constants/app_style.dart';
import '../../../../core/utils/constants/ux_cam_events.dart';
import '../../../../core/utils/enums/date_form.dart';
import '../../../../core/utils/nullable.dart';
import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/components/bottom_sheets/generic_bottom_sheet_list.dart';
import '../../../_shared_feature_/presentation/dialogs/bottom_sheet_dialogs.dart';
import '../../../_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../_shared_feature_/presentation/widgets/radio_buttons/custom_radio_button_widget copy.dart';
import '../../../_shared_feature_/presentation/widgets/texts/custom_text_widget.dart';
import '../../../_shared_feature_/presentation/widgets/texts/filter_text_field.dart';

import '../../../events/domain/entities/events_category/events_category_item.dart';
import '../../../events/presentation/widgets/filter_date_picker.dart';
import '../../domain/entities/search_calendar/search_calendar_params.dart';
import '../bloc/calendar_bloc.dart';
import '../bloc/calendar_state.dart';

class CalendarFilterDialog extends StatefulWidget {
  final CalendarBloc requestsBloc;
  final SearchCalendarParams params;

  const CalendarFilterDialog({
    super.key,
    required this.requestsBloc,
    required this.params,
  });

  @override
  State<CalendarFilterDialog> createState() => _CalendarFilterDialogState();
}

class _CalendarFilterDialogState extends State<CalendarFilterDialog> {
  String? keyword;
  EventCategoryItem? selectedSeason;

  DateTime? dateFrom;
  DateTime? dateTo;
  String? sortBy;
  final TextEditingController? textEditingController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keyword = widget.params.keyword;
    selectedSeason = widget.params.selectedSeason;
    dateFrom = widget.params.dateFrom;
    dateTo = widget.params.dateTo;
    textEditingController?.text = widget.params.keyword ?? "";

    CommonFunctions.sendUXCamEvent(
        UXCamEvents.KingdomCalendar_List_Click_Filter_Event);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.requestsBloc,
      child: SizedBox(
        width: double.infinity,
        child:
            BlocBuilder<CalendarBloc, CalendarState>(builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FilterTextField(
                hintText: "search".tr(),
                textEditingController: textEditingController,
                textInputType: TextInputType.text,
                onChanged: (value) {
                  print(value);
                  keyword = value;
                },
              ),
              DropDownWithTitle(
                title: "saudi_calendar_type".tr(),
                selectedValue: selectedSeason?.name,
                status: state.seasonStatus,
                onRetry: () => context.read<CalendarBloc>().add(
                      GetSeasonsEvent(),
                    ),
                onTap: () {
                  //MMDialog
                  BottomSheetDialog.showDraggableSheet<EventCategoryItem>(
                    context,
                    // dialogKeyName: DialogName.objectablePageProductsFilters,
                    // currentRouteName: RouteName.objectableTransactions,
                    child: GenericBottomSheetList<EventCategoryItem>(
                      title: "saudi_calendar_type".tr(),
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
              Row(
                children: [
                  Expanded(
                    child: EventFilterDatePicker(
                      title: "events_filter_dateFrom".tr(),
                      initialDateForm: DateForm.gregorian,
                      initialDate: dateFrom,
                      onChange: (DateTime date, DateForm dateForm) {
                        setState(() {
                          this.dateFrom = date;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: EventFilterDatePicker(
                      title: "events_filter_dateTo".tr(),
                      initialDateForm: DateForm.gregorian,
                      initialDate: dateTo,
                      onChange: (DateTime date, DateForm dateForm) {
                        setState(() {
                          this.dateTo = date;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              SizedBox(
                height: 16,
              ),
              Column(
                children: [
                  ElevatedButtonWidget.apply(
                    onPressed: () {
                      CommonFunctions.sendUXCamEvent(UXCamEvents
                          .KingdomCalendar_List_Click_Apply_Filter_Event);

                      Navigator.pop(
                          context,
                          widget.params.copyWith(
                            page: 1,
                            size: 10,
                            keyword: Nullable(keyword),
                            selectedSeason: Nullable(selectedSeason),
                            dateFrom: Nullable(dateFrom),
                            dateTo: Nullable(dateTo),
                          ));
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButtonWidget.deletaAll(
                    onPressed: () {
                      keyword = null;
                      selectedSeason = null;
                      dateFrom = null;
                      dateTo = null;
                      textEditingController?.text = "";
                      setState(() {});
                      //  Navigator.pop(
                      //      context, SearchCalendarParams(page: 1, size: 10));
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
