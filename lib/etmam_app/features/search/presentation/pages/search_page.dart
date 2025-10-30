import 'package:balady_plus/etmam_app/core/dependency_injection/dependency_injection_exports.dart'
    show sl;
import 'package:balady_plus/etmam_app/core/services/services_exports.dart'
    show AppEvents;
import 'package:balady_plus/etmam_app/core/utils/constants/app_config.dart';
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/presentation/widgets/custom_app_bar_widget.dart';
import 'package:balady_plus/app/core/utils/utils_exports.dart';

import 'package:balady_plus/etmam_app/core/utils/utils_exports.dart'
    show CommonFunctions;
import 'package:balady_plus/etmam_app/features/_shared_feature_/shared/shared_feature_exports.dart'
    show CustomLoadingWidget;
import 'package:balady_plus/etmam_app/features/search/search_exports.dart'
    show
        SearchBloc,
        SearchState,
        SearchTitleResult,
        SearchHeader,
        SearchResultList;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final ScrollController _scrollController = new ScrollController();
  final FocusNode _focusNode = new FocusNode();
  @override
  void initState() {
    super.initState();
    //CommonFunctions.sendEventToAnalytics(AppEvents.SearchPage);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchBloc>(
      create: (context) => SearchBloc(
          getSearchData: sl(),
          getSubService: sl(),
          getServicesProvidersByService: sl(),
          scrollController: _scrollController),
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          return Scaffold(
              appBar: CustomAppBar(
                title: trans('Search_SearchHeader'),
              ),
              body: GestureDetector(
                onTap: () => _focusNode.unfocus(),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SearchHeader(focusNode: _focusNode),
                        SearchTitleResult(),
                        SearchResultList(
                            scrollController: _scrollController,
                            focusNode: _focusNode),
                      ],
                    ),
                    if (state.status == BlocStatus.loading)
                      const CustomLoadingWidget(),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
