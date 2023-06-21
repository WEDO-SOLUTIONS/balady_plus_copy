import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        DefaultAppBarWidget,
        DraggableSheetComponent,
        FilterIcon;
import '../../requests_exports.dart'
    show
        AppBarSeachBar,
        GetRequestsEvent,
        RequestsBloc,
        RequestsList,
        RequestsLoadLookupsEvent,
        SearchRequestsEvent;
import '../widgets/requests_filters_bottom_sheet.dart';

class RequestsPage extends StatelessWidget {
  const RequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RequestsBloc>(
      create: (context) => sl<RequestsBloc>()..add(GetRequestsEvent()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'requests'.tr(),
            bottom: AppBarSeachBar(
              onChanged: (value) {
                context.read<RequestsBloc>().add(
                      SearchRequestsEvent(query: value),
                    );
              },
            ),
            actions: [
              FilterIcon(
                onTap: () {
                  context.read<RequestsBloc>().add(RequestsLoadLookupsEvent());
                  BottomSheetDialog.showDraggableSheet(
                    context,
                    child: DraggableSheetComponent(
                      title: "filters".tr(),
                      height: 0.9,
                      body: RequestsFilterBottomSheet(
                        requestsBloc: context.read<RequestsBloc>(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
          body: const Padding(
            padding: EdgeInsets.all(16),
            child: RequestsList(),
          ),
        );
      }),
    );
  }
}
