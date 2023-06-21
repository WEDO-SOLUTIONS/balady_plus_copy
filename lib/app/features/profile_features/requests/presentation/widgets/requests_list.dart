import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show MessageDialog, ShimmerEffectWidget;
import '../../requests_exports.dart'
    show
        RequestsBloc,
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
      context.read<RequestsBloc>().add(RequestsLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RequestsBloc, RequestsState>(
      listener: (_, state) async {
        switch (state.requestsStatus) {
          case BlocRequestStatus.submissionGetFailure:
            MessageDialog.showErrorNotification(msg: state.error);
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        if (state.requestsStatus == BlocRequestStatus.submissionGetLoading &&
            !state.paginationLoading) {
          return const RequestsListShimmer();
        } else if (state.requestsStatus ==
                BlocRequestStatus.submissionGetSuccess ||
            state.paginationLoading) {
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

        return const SizedBox.shrink();
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
