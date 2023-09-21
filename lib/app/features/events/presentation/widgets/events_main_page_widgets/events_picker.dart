import 'package:balady_plus/app/features/_shared_feature_/presentation/components/bottom_sheets/draggable_sheet_component.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../_shared_feature_/presentation/widgets/drop_downs/drop_down_box_with_title.dart';
import '../../../../_shared_feature_/presentation/widgets/texts/filter_text_field.dart';
import '../../bloc/events_bloc.dart';
import '../../bloc/events_state.dart';

class EventsPickerWidget extends StatelessWidget {
  final EventsBloc requestsBloc;

  const EventsPickerWidget({
    super.key,
    required this.requestsBloc,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: requestsBloc,
      child: SizedBox(
        width: double.infinity,
        child: BlocBuilder<EventsBloc, EventsState>(builder: (context, state) {
          return Column(
            children: [
              FilterTextField(
                hintText: "search".tr(),
                initialValue: state.searchKeyword,
                onChanged: (value) {
                  context.read<InvoicesBloc>().add(
                        SearchWithInvoiceNumberEvent(
                          query: value,
                        ),
                      );
                },
              ),
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
              )
            ],
          );
        }),
      ),
    );
  }
}
