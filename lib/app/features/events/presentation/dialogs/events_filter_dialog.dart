import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/draggable_sheet_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../_shared_feature_/presentation/buttons/elevated_button_widgets.dart';
import '../../../_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../_shared_feature_/presentation/widgets/texts/filter_text_field.dart';
import '../../domain/entities/search_events/search_events_params.dart';
import '../bloc/events_bloc.dart';
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
              DropDownWithTitle(
                title: "product".tr(),
                selectedValue: state.selectedRequestType?.name,
                status: state.requestTypesStatus,
                onRetry: () => context.read<ObjectableTransactionBloc>().add(
                      GetRequestTypesEvent(),
                    ),
                onTap: () {
                  final List<String> items =
                      state.requestTypes.map((e) => e.name ?? "").toList();
                  BottomSheetDialog.showDraggableSheet(
                    context,
                    dialogKeyName: DialogName.objectablePageProductsFilters,
                    currentRouteName: RouteName.objectableTransactions,
                    child: BottomSheetList(
                      title: "product".tr(),
                      items: items,
                      selectedValue: state.selectedRequestType?.name,
                      onTap: (item) {
                        final requestType = state.requestTypes
                            .where((e) => e.name == item)
                            .first;
                        context.read<ObjectableTransactionBloc>().add(
                              RequestTypeSelectedEvent(
                                requestType: requestType,
                              ),
                            );
                        Navigator.pop(context);
                      },
                    ),
                  );
                },
              )*/
            ],
          );
        }),
      ),
    );
  }
}
