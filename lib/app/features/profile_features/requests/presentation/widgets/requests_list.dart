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
        GetRequestsEvent,
        RequestsBloc,
        RequestsListItem,
        RequestsListShimmer,
        RequestsLoadMoreEvent,
        RequestsState;
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
      context.read<RequestsBloc>().add(RequestsLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestsBloc, RequestsState>(
        listenWhen: (previous, current) =>
            previous.requestsStatus != current.requestsStatus,
        listener: (_, state) async {
          if (state.requestsStatus == BlocRequestStatus.submissionGetFailure &&
              state.page != 0) {
            MessageDialog.showErrorNotification(msg: state.error);
          }
        },
        builder: (context, state) {
          if (state.crmRequestType == RequestsType.MUN) {
            if (state.requestsStatus ==
                    BlocRequestStatus.submissionGetFailure &&
                state.page == 0) {
              return Center(
                child: ReloadWidget(
                  onTab: () {
                    context.read<RequestsBloc>().add(GetRequestsEvent());
                  },
                ),
              );
            } else if (state.requestsStatus ==
                    BlocRequestStatus.submissionGetLoading &&
                !state.paginationLoading) {
              return const RequestsListShimmer();
            } else {
              if (state.requests.isEmpty &&
                  state.noMoreData &&
                  (state.requestNumberQuery?.isEmpty ?? true)) {
                return EmptyListWidget(
                  title: "no_requests_found".tr(),
                );
              } else if (state.requests.isEmpty && state.noMoreData) {
                return EmptyListWidget(
                  title: "no_requests_with_entered_number".tr(),
                );
              }
              int length = state.requests.length;
              if (state.paginationLoading) {
                length += 1;
              }
              return ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                itemCount: length,
                itemBuilder: (context, index) {
                  if (index == length - 1 && state.paginationLoading) {
                    return Container(
                      height: 200,
                      margin: const EdgeInsets.only(top: 16),
                      child: const ShimmerEffectWidget(),
                    );
                  }
                  return RequestsListItem(
                    request: state.requests[index],
                  );
                },
              );
            }
          }
          if (state.crmRequestType != RequestsType.MUN) {
            if (state.crmRequestsStatus ==
                BlocRequestStatus.submissionGetFailure) {
              return Center(
                child: ReloadWidget(
                  onTab: () {
                    context.read<RequestsBloc>().add(GetCRMRequestEvent(
                        crmRequestType: state.crmRequestType));
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
          }
          return Container();
        });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
