import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../_shared_feature_/shared_feature_exports.dart'
    show MessageDialog, RetryWidget, ShimmerEffectWidget;
import '../../objections_exports.dart'
    show
        GetRequestsEvent,
        ObjectionsBloc,
        RequestsListItem,
        RequestsListShimmer,
        RequestsLoadMoreEvent,
        RequestsState;

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
      context.read<ObjectionsBloc>().add(RequestsLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ObjectionsBloc, RequestsState>(
      listenWhen: (previous, current) =>
          previous.requestsStatus != current.requestsStatus,
      listener: (_, state) async {
        if (state.requestsStatus == BlocRequestStatus.submissionGetFailure &&
            state.page != 0) {
          MessageDialog.showErrorNotification(msg: state.error);
        }
      },
      builder: (context, state) {
        if (state.requestsStatus == BlocRequestStatus.submissionGetFailure &&
            state.page == 0) {
          return Center(
            child: RetryWidget(
              onRetry: () {
                context.read<ObjectionsBloc>().add(GetRequestsEvent());
              },
            ),
          );
        } else if (state.requestsStatus ==
                BlocRequestStatus.submissionGetLoading &&
            !state.paginationLoading) {
          return const RequestsListShimmer();
        } else {
          if (state.requests.isEmpty && state.noMoreData) {
            return Center(
              child: Text("no_data".tr()),
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
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
