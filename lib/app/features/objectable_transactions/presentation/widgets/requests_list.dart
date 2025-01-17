import 'package:balady_plus/app/core/utils/constants/remote_config.dart';
import 'package:balady_plus/app/features/objectable_transactions/domain/entities/transaction_details_params.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import '../../../../core/services/local/navigation_services.dart';
import '../../../../core/utils/utils_exports.dart'
    show BlocRequestStatus, CommonFunctions, RouteName;
import '../../../_shared_feature_/presentation/widgets/custom_circular_loading_widget.dart';
import '../../../_shared_feature_/presentation/widgets/need_login_widget.dart';
import '../../../_shared_feature_/presentation/widgets/reload_widget.dart';
import '../../../_shared_feature_/shared_feature_exports.dart'
    show MessageDialog, RetryWidget, ShimmerEffectWidget;
import '../../domain/entities/create_objection_page_params.dart';
import '../../objections_exports.dart'
    show
        GetRequestsEvent,
        GetTransactionDetailsEvent,
        ObjectableTransactionBloc,
        ObjectableTransactionState,
        ObjectableTransactionsEntity,
        RequestsListItem,
        RequestsListShimmer,
        RequestsLoadMoreEvent,
        ValidateObjectionTransactions;

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
      context.read<ObjectableTransactionBloc>().add(RequestsLoadMoreEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ObjectableTransactionBloc, ObjectableTransactionState>(
      listenWhen: (previous, current) =>
          previous.requestsStatus != current.requestsStatus ||
          previous.detailsStatus != current.detailsStatus,
      listener: (_, state) async {
        if ((state.requestsStatus == BlocRequestStatus.submissionGetFailure &&
                state.page != 0) ||
            state.detailsStatus == BlocRequestStatus.submissionGetFailure) {
          MessageDialog.showErrorNotification(msg: state.error);
        }
      },
      builder: (context, state) {
        if (state.requestsStatus == BlocRequestStatus.submissionGetFailure &&
            state.page == 0) {
          return Center(
            child: ReloadWidget(
              onTab: () {
                context
                    .read<ObjectableTransactionBloc>()
                    .add(GetRequestsEvent());
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
              child: EmptyListWidget(
                title: "no_data_shown".tr(),
              ),
            );
          }
          int length = state.requests.length;
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
                  return RequestsListItem(
                    request: state.requests[index],
                    onDetails: () {
                      openObjectableDetails(context, state.requests[index]);
                    },
                    onApply: () {
                      context.read<ObjectableTransactionBloc>().add(
                          ValidateObjectionTransactions(
                              params: state.requests[index]));

                      //Objection Before Validation
                      /* NavigationService.navigatorKey.currentState!
                          .pushNamed(RouteName.createObjectionDetails,
                              arguments: CreateObjectionPageParams(
                                item: state.requests[index],
                              ));*/

                      // Old Behavoiur
                      /*  context.read<ObjectableTransactionBloc>().add(
                          GetTransactionDetailsEvent(
                              apply: true,
                              params: TransactionDetailsParams(
                                  applicationId:
                                      state.requests[index].applicationId ??
                                          "13",
                                  id: state.requests[index].transactionNumber ??
                                      "")));
                 
                 */
                    },
                  );
                },
              ),
              if (state.detailsStatus == BlocRequestStatus.submissionGetLoading)
                const CustomCircularLoadingWidget(),
            ],
          );
        }
      },
    );
  }

  void openObjectableDetails(
      BuildContext context, ObjectableTransactionsEntity item) {
    String? serviceTypeId = item.serviceTypeId;
    String? contentTypeId = item.contentTypeId;
    if (serviceTypeId == "3" || serviceTypeId == "4") {
      context.read<ObjectableTransactionBloc>().add(GetTransactionDetailsEvent(
          apply: false,
          params: TransactionDetailsParams(
              item: item,
              applicationId: item.applicationId ?? "13",
              id: item.transactionNumber ?? "")));
    } else if (item.applicationId == "1003") {
      if (serviceTypeId == "1") {
        if (contentTypeId == "permit") {
          CommonFunctions.openBaladyWebView(
              "${RemoteConfig.baladyCommercialUrl}/Permits/PermitsDetails/Index/${item.hashingTransactionNumber}/${item.hashingOriginalServiceId}",
              isObjections: true);
        } else {
          CommonFunctions.openBaladyWebView(
              "${RemoteConfig.baladyBaseUrl}/dashboardclient/requests/details/${item.hashingTransactionNumber}",
              isObjections: true);
        }
      } else if (serviceTypeId == "2") {
        CommonFunctions.openBaladyWebView(
            "${RemoteConfig.baladyBaseUrl}/dashboardclient/licenses/details/${item.hashingTransactionNumber}",
            isObjections: true);
      }
    } else if (item.applicationId == "1200") {
      var typeName = serviceTypeId == "1" ? 'requests' : "licenses";
      CommonFunctions.openBaladyWebView(RemoteConfig.baladyBaseUrl +
          "/dashboardclient/" +
          typeName +
          '/construction-details/' +
          (item.hashingTransactionNumber ?? "") +
          '/requestType/' +
          "1200");
    } else if (item.applicationId == "1100") {
      var typeName = serviceTypeId == "1" ? 'requests' : "licenses";
      CommonFunctions.openBaladyWebView(RemoteConfig.baladyBaseUrl +
          "/dashboardclient/" +
          typeName +
          '/construction-details/' +
          (item.hashingTransactionNumber ?? "") +
          '/requestType/' +
          "1100");
    } 
    else if (item.applicationId == "1300") {
      var typeName = serviceTypeId == "1" ? 'requests' : "licenses";
      CommonFunctions.openBaladyWebView(item.redirectUrl);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
