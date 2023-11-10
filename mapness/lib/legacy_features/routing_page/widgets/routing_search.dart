part of '../routing_overlay.dart';

class _RoutingSearch extends StatefulWidget {
  const _RoutingSearch({
    super.key,
    required this.controller,
    required this.startObjectId,
    required this.finishObjectId,
    required this.pointsChanged,
  });

  final DgisMapController controller;
  final ValueNotifier<ObjectInfoState?> startObjectId;
  final ValueNotifier<ObjectInfoState?> finishObjectId;
  final void Function() pointsChanged;

  @override
  State<_RoutingSearch> createState() => _SearchSheetState();
}

class _SearchSheetState extends State<_RoutingSearch> {
  late RoutingSearchViewModel startSearch;
  late RoutingSearchViewModel finishSearch;

  @override
  void initState() {
    super.initState();

    startSearch = RoutingSearchViewModel(
      widget.controller,
      widget.startObjectId,
      onItemSelected: (item) {
        print("item selected");
        widget.startObjectId.value = item;
        widget.pointsChanged();
      },
    )..init();
    finishSearch = RoutingSearchViewModel(
      widget.controller,
      widget.finishObjectId,
      onItemSelected: (item) {
        print("item selected");
        widget.finishObjectId.value = item;
        widget.pointsChanged();
      },
    )..init();

    startSearch.cancelControlState.addListener(() {
      if (startSearch.cancelControlState.value) {
        finishSearch.onCancelTap();
      }
    });
    finishSearch.cancelControlState.addListener(() {
      if (finishSearch.cancelControlState.value) {
        startSearch.onCancelTap();
      }
    });
  }

  @override
  void dispose() {
    startSearch.dispose();
    finishSearch.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<RoutingViewModel>();

    return Column(
      children: [
        ColoredBox(
          color: Colors.white,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 14.0,
                  bottom: 18.0,
                  right: 20.0,
                ),
                child: Row(
                  children: [
                    FloatingActionButton.small(
                      onPressed: () async {
                        model.swapStartFinish();

                        await finishSearch.valueChanged();
                        await startSearch.valueChanged();

                        model.setRouteParams();
                      },
                      elevation: 0,
                      backgroundColor: const Color(0xFFF2F2F2),
                      child: SizedBox(
                        height: 40,
                        width: 40,
                        child: SvgPicture.asset(
                          'assets/icons/svg/routing/ic_arrow_switch.svg',
                          color: const Color(0xFF808080),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 14.0),
                            child: Provider.value(
                              value: startSearch,
                              builder: (context, child) => WillPopScope(
                                onWillPop: startSearch.onWillPop,
                                child: const NavSearchField(
                                  'A',
                                  placeholder: 'My location',
                                ),
                              ),
                            ),
                          ),
                          const Divider(
                            thickness: 1.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Provider.value(
                              value: finishSearch,
                              builder: (context, child) => WillPopScope(
                                onWillPop: finishSearch.onWillPop,
                                child: const NavSearchField(
                                  'B',
                                  placeholder: 'To',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Provider<SearchViewModel>.value(
          value: startSearch,
          builder: (context, child) => WillPopScope(
            onWillPop: startSearch.onWillPop,
            child: const _SearchContent(),
          ),
        ),
        Provider<SearchViewModel>.value(
          value: finishSearch,
          builder: (context, child) => WillPopScope(
            onWillPop: finishSearch.onWillPop,
            child: const _SearchContent(),
          ),
        ),
      ],
    );
  }
}

class _SearchContent extends StatelessWidget {
  const _SearchContent({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<SearchViewModel>();

    return ValueListenableBuilder<bool>(
        valueListenable: model.cancelControlState,
        builder: (context, visible, __) {
          if (!visible) {
            return const SizedBox.shrink();
          }

          return ValueListenableBuilder<double>(
              valueListenable: model.heightState,
              builder: (context, height, __) {
                return ValueListenableBuilder<SearchState>(
                    valueListenable: model.searchState,
                    builder: (context, state, _) {
                      return Container(
                        height: height,
                        color: Colors.white,
                        child: Column(
                          children: [
                            Expanded(
                              child: CustomScrollView(
                                  physics: const ClampingScrollPhysics(),
                                  controller: model.paginationController,
                                  slivers: [
                                    if (state.isLoading)
                                      const SliverToBoxAdapter(
                                        child: SizedBox(
                                          height: 2,
                                          child: LinearProgressIndicator(
                                            minHeight: 2,
                                            color: Color(0xffE6F4E1),
                                            backgroundColor: Color(0xff9aa994),
                                          ),
                                        ),
                                      ),
                                    if (state.isEmpty)
                                      SliverToBoxAdapter(
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const SizedBox(height: 64),
                                              SvgPicture.asset(
                                                  "assets/svg/img_search_empty.svg"),
                                              const SizedBox(height: 8),
                                              Text(
                                                "You search - ${model.searchController.text} - did not match any results.",
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xFF8E8E8E),
                                                  fontSize: 15,
                                                  height: 1.33,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    if (state.hasSuggests)
                                      SuggestList(
                                        items: state.suggests!,
                                        onItemTap: model.onSuggestTap,
                                      ),
                                    if (state.hasData)
                                      SearchResultList(
                                        items: state.data!,
                                        onItemTap: model.onItemTap,
                                      ),
                                  ]),
                            ),
                          ],
                        ),
                      );
                    });
              });
        });
  }
}
