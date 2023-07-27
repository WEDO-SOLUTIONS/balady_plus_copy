import 'package:balady_plus/app/features/_shared_feature_/presentation/widgets/need_login_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show MessageDialog, ShimmerEffectWidget;
import '../../invoices_exports.dart'
    show
        GetInvoicesEvent,
        InvoicesBloc,
        InvoicesListItem,
        InvoicesListShimmer,
        InvoicesLoadMoreEvent,
        InvoicesState;

class InvoicesList extends StatefulWidget {
  const InvoicesList({super.key});

  @override
  State<InvoicesList> createState() => _InvoicesListState();
}

class _InvoicesListState extends State<InvoicesList> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<InvoicesBloc>().add(InvoicesLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InvoicesBloc, InvoicesState>(
      listenWhen: (previous, current) =>
          previous.invoicesStatus != current.invoicesStatus,
      listener: (_, state) async {
        switch (state.invoicesStatus) {
          case BlocRequestStatus.submissionGetFailure:
            MessageDialog.showErrorNotification(msg: state.error);
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        if (state.invoicesStatus == BlocRequestStatus.submissionGetFailure &&
            state.page == 0) {
          return Center(
            child: ReloadWidget(
              onTab: () {
                context.read<InvoicesBloc>().add(GetInvoicesEvent());
              },
            ),
          );
        } else if (state.invoicesStatus ==
                BlocRequestStatus.submissionGetLoading &&
            !state.paginationLoading) {
          return const InvoicesListShimmer();
        } else {
          if (state.invoices.isEmpty && state.noMoreData) {
            return Center(
              child: EmptyListWidget(
                title: "no_data_shown".tr(),
              ),
            );
          }
          int length = state.invoices.length;
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
              return InvoicesListItem(
                invoice: state.invoices[index],
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
