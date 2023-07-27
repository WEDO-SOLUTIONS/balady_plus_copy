import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show
        BottomSheetDialog,
        BottomSheetWithActions,
        DefaultAppBarWidget,
        FilterIcon;
import '../../requests_exports.dart'
    show
        AppBarSeachBar,
        GetCRMRequestEvent,
        IncidentsBloc,
        IncidentsState,
        RequestsList,
        SearchCRMIncidentsEvent;

class INCRequestsPage extends StatelessWidget {
  const INCRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<IncidentsBloc>(
      create: (context) => IncidentsBloc()
        ..add(GetCRMRequestEvent(crmRequestType: RequestsType.INC)),
      child:
          BlocBuilder<IncidentsBloc, IncidentsState>(builder: (context, state) {
        return Scaffold(
          appBar: DefaultAppBarWidget(
            title: 'reports'.tr(),
            bottom: AppBarSeachBar(
              crmRequestType: RequestsType.INC,
              onChanged: (value) {
                context.read<IncidentsBloc>().add(
                      SearchCRMIncidentsEvent(query: value),
                    );
              },
            ),
            actions: [],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(child: const RequestsList()),
              ],
            ),
          ),
        );
      }),
    );
  }
}
