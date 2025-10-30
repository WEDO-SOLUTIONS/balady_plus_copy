import 'package:balady_plus/etmam_app/core/utils/common_properties.dart';

import 'package:balady_plus/app/core/utils/utils_exports.dart' show BlocStatus;

import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_loading_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_shimmer_widget.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/reload_widget.dart';
import 'package:balady_plus/etmam_app/features/home/presentation/widgets/sub_services_page/etmam_sub_service_card_widget.dart';
import 'package:balady_plus/etmam_app/features/services/services_exports.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show
        GetProvidersEvent,
        SearchBloc,
        GetSearchDataEvent,
        SearchParams,
        SearchState,
        SearchNoResult,
        SearchResultItem;

class SearchResultList extends StatefulWidget {
  final ScrollController scrollController;
  final FocusNode focusNode;

  SearchResultList(
      {Key? key, required this.scrollController, required this.focusNode})
      : super(key: key);

  @override
  State<SearchResultList> createState() => _SearchResultListState();
}

class _SearchResultListState extends State<SearchResultList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state.status == BlocStatus.failure) {
          //  CommonFunctions.showError(state.errorMessage ?? "");
        }
      },
      builder: (context, state) {
        if (state.status == BlocStatus.loadingShimmer)
          return Expanded(
            child: CustomShimmerListWidget(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              height: 67,
              itemCount: 10,
            ),
          );

        if ((state.items?.isEmpty ?? true) &&
            state.status == BlocStatus.failure) return const SearchNoResult();

        if (state.status == BlocStatus.retry)
          return ReloadWidget(onTab: () {
            context.read<SearchBloc>().add(GetSearchDataEvent(
                params: SearchParams(pageIndex: "1", text: state.text ?? "")));
          });

        if (state.status == BlocStatus.success ||
            state.status == BlocStatus.loading ||
            state.status == BlocStatus.loadMore)
          return Expanded(
            child: Container(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: MediaQuery.removePadding(
                context: context,
                removeTop: true,
                child: ListView.builder(
                    itemCount: (state.items?.length ?? 0) + 1,
                    controller: widget.scrollController,
                    itemBuilder: (ctx, index) {
                      if (index >= (state.items?.length ?? 0)) {
                        if (state.status == BlocStatus.loadMore) {
                          return const SizedBox(
                            height: 50,
                            child: Center(child: CustomLoadingWidget()),
                          );
                        } else {
                          return Container(height: 50);
                        }
                      }

                      return state.items != null
                          ? EtmamSubServicePageCardWidget(
                              subServiceName: state.items?[index].name ?? "",
                              subServiceIcon:
                                  state.items?[index].logoImageUrl ?? "",
                              btnPressed: () {
                                context.read<SearchBloc>().add(
                                    GetProvidersEvent(
                                        params: ServiceParams(
                                            cityId: CommonProperties.cityId,
                                            pageIndex: "1",
                                            subServiceId:
                                                state.items?[index].id ?? "",
                                            subServiceName:
                                                state.items?[index].name ??
                                                    "")));
                                widget.focusNode.unfocus();
                              },
                            )
                          : Container();
                    }),
              ),
            ),
          );
        return Container();
      },
    );
  }
}
