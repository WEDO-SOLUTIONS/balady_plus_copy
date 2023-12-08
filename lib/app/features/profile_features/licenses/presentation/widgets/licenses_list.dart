import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../../core/utils/utils_exports.dart' show BlocRequestStatus;
import '../../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show MessageDialog, ShimmerEffectWidget;
import '../../licenses_exports.dart'
    show
        LicensesBloc,
        LicensesListItem,
        LicensesListShimmer,
        LicensesLoadMoreEvent,
        LicensesState;

class LicensesList extends StatefulWidget {
  const LicensesList({super.key});

  @override
  State<LicensesList> createState() => _LicensesListState();
}

class _LicensesListState extends State<LicensesList> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<LicensesBloc>().add(LicensesLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LicensesBloc, LicensesState>(
      listener: (_, state) async {
        switch (state.licensesStatus) {
          case BlocRequestStatus.submissionGetFailure:
            MessageDialog.showErrorNotification(msg: state.error);
            break;
          default:
            break;
        }
      },
      builder: (context, state) {
        if (state.licensesStatus == BlocRequestStatus.submissionGetLoading &&
            !state.paginationLoading) {
          return const LicensesListShimmer();
        } else if (state.licensesStatus ==
                BlocRequestStatus.submissionGetSuccess ||
            state.paginationLoading) {
          if (state.licenses.isEmpty && state.noMoreData) {
            return Center(
              child: EmptyListWidget(
                title: "no_data_shown".tr(),
              ),
            );
          }
          int length = state.licenses.length;
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
              return LicensesListItem(
                license: state.licenses[index],
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
