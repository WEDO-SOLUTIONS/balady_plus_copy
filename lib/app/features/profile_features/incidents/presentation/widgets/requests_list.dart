import 'package:balady_plus/app/core/utils/enums/enums.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/need_login_widget.dart';
import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/reload_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show MessageDialog, RetryWidget, ShimmerEffectWidget;
import '../../requests_exports.dart'
    show
        GetCRMRequestEvent,
        IncidentsBloc,
        IncidentsState,
        RequestsListItem,
        RequestsListShimmer;
import 'crm_request_list_item.dart';

class RequestsList extends StatefulWidget {
  const RequestsList({super.key});

  @override
  State<RequestsList> createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      //  context.read<IncidentsBloc>().add(RequestsLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IncidentsBloc, IncidentsState>(
        listenWhen: (previous, current) =>
            previous.crmRequestsStatus != current.crmRequestsStatus,
        listener: (_, state) async {
          if (state.crmRequestsStatus ==
              BlocRequestStatus.submissionGetFailure) {
            MessageDialog.showErrorNotification(msg: state.error);
          }
        },
        builder: (context, state) {
          if (state.crmRequestsStatus ==
              BlocRequestStatus.submissionGetFailure) {
            return Center(
              child: ReloadWidget(
                onTab: () {
                  context.read<IncidentsBloc>().add(
                      GetCRMRequestEvent(crmRequestType: RequestsType.INC));
                },
              ),
            );
          } else if (state.crmRequestsStatus ==
              BlocRequestStatus.submissionGetLoading) {
            return const RequestsListShimmer();
          } else if ((state.crmRequestsList?.incidentRequestList?.isEmpty ??
              true &&
                  state.crmRequestsStatus ==
                      BlocRequestStatus.submissionGetSuccess)) {
            return EmptyListWidget(
              title: "no_requests_found".tr(),
            );
          }
          return ListView.builder(
              itemCount:
                  state.crmRequestsList?.incidentRequestList?.length ?? 0,
              shrinkWrap: true,
              itemBuilder: ((context, index) {
                return CRMRequestsListItem(
                  request: state.crmRequestsList!.incidentRequestList![index],
                );
              }));
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
