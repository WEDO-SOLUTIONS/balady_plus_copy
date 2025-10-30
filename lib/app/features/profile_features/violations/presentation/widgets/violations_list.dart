import 'package:balady_plus/app/core/utils/constants/route_names.dart';
import 'package:balady_plus/app/core/utils/routes_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';
import '../../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, ContextConversion;
import '../../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../../_shared_feature_/shared_feature_exports.dart'
    show MessageDialog, ShimmerEffectWidget;
import '../../violations_exports.dart'
    show
        GetViolationsEvent,
        ViolationListShimmer,
        ViolationsBloc,
        ViolationsListItem,
        ViolationsLoadMoreEvent,
        ViolationsState;

class ViolationList extends StatefulWidget {
  const ViolationList({super.key});

  @override
  State<ViolationList> createState() => _ViolationListState();
}

class _ViolationListState extends State<ViolationList> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<ViolationsBloc>().add(ViolationsLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ViolationsBloc, ViolationsState>(
      listenWhen: (previous, current) =>
          previous.violationsStatus != current.violationsStatus,
      listener: (_, state) async {
        if ((state.violationsStatus == BlocRequestStatus.submissionGetFailure &&
            state.page != 0)) {
          MessageDialog.showErrorNotification(msg: state.error);
        }
      },
      builder: (context, state) {
        if (state.violationsStatus == BlocRequestStatus.submissionGetFailure &&
            state.page == 0) {
          return Center(
            child: ReloadWidget(
              onTab: () {
                context.read<ViolationsBloc>().add(GetViolationsEvent());
              },
            ),
          );
        } else if (state.violationsStatus ==
                BlocRequestStatus.submissionGetLoading &&
            !state.paginationLoading) {
          return const ViolationListShimmer();
        } else {
          if (state.violations.isEmpty && state.noMoreData) {
            return Center(
              child: EmptyListWidget(
                title: "no_data_shown".tr(),
              ),
            );
          }
          int length = state.violations.length;
          if (state.paginationLoading) {
            length += 1;
          }
          return Stack(
            children: [
              ListView.builder(
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
                  return ViolationsListItem(
                    violations: state.violations[index],
                    onDetails: () {
                      context.pushNamedRoute(
                        RouteName.violationDetailsPage,
                        arguments: {
                          "hashingViolationNumber": state.violations[index].hashingViolationNumber ?? '',
                          "applicationId": state.violations[index].applicationId ?? "",
                          "violationDetails": state.violations[index]
                        },
                      );
                    },
                    onApply: () {},
                  );
                },
              ),
            ],
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
