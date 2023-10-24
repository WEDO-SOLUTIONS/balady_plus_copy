import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/landing/dashboard.dart';
import 'package:mapness/features/landing/providers/dashboard_controls.dart';
import 'package:mapness/features/map/providers/search.dart';
import 'package:mapness/features/map/providers/suggests.dart';

class SearchBar extends ConsumerStatefulWidget {
  const SearchBar({
    required this.dashboardKey,
    super.key,
  });

  final GlobalKey<DashboardState> dashboardKey;

  @override
  ConsumerState<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends ConsumerState<SearchBar> {
  late TextEditingController _controller;
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _searchFocus.addListener(_focusListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _focusListener() {
    if (_searchFocus.hasFocus) {
      ref
          .read(dashboardControlsProvider.notifier)
          .update(DashboardControlsState.searching);
      widget.dashboardKey.currentState?.expand();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardControlsProvider);
    final stateNotifier = ref.watch(dashboardControlsProvider.notifier);

    if (dashboardState == DashboardControlsState.idle &&
        _controller.text.isNotEmpty) {
      _controller.clear();
    }

    return Row(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.passthrough,
            children: [
              SizedBox(
                height: 40,
                child: TextField(
                  focusNode: _searchFocus,
                  onChanged: (value) {
                    if (value.isEmpty) {
                      stateNotifier.update(DashboardControlsState.searching);
                    } else {
                      stateNotifier.update(DashboardControlsState.suggests);
                      ref.watch(suggestsProvider.notifier).fetch(value);
                    }
                    setState(() {});
                  },
                  onSubmitted: (value) {
                    stateNotifier.update(DashboardControlsState.results);
                    ref.watch(searchProvider.notifier).search(value);
                    widget.dashboardKey.currentState?.collapse(to: 0.7);
                  },
                  controller: _controller,
                  maxLines: 1,
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    // isDense: true,
                    hintText: "Search",
                    fillColor: dashboardState != DashboardControlsState.results
                        ? const Color(0xFFF1F4F8)
                        : Colors.white,
                    contentPadding: const EdgeInsets.only(
                      //   // horizontal: 8,
                      right: 8,
                      left: 38,
                      top: 0,
                      bottom: 0,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefix: const SizedBox(
                      width: 28,
                    ),
                  ),
                  cursorHeight: 22,
                  style: GoogleFonts.notoSansArabic(
                    textStyle: const TextStyle(
                      fontSize: 16,
                      // height: 22 / 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/icons/svg/ic_dashboard_search.svg",
                    semanticsLabel: 'MinApps Screen',
                    package: "mapness",
                    colorFilter: ColorFilter.mode(
                      dashboardState != DashboardControlsState.idle
                          ? const Color(0xFF4CA5B4)
                          : const Color(0xB21E2A36),
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              if (_controller.text.isNotEmpty)
                GestureDetector(
                  onTap: () {
                    _controller.clear();
                    stateNotifier.update(DashboardControlsState.searching);
                    _searchFocus.requestFocus();
                    setState(() {});
                  },
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SvgPicture.asset(
                        "assets/icons/svg/ic_search_clear.svg",
                        semanticsLabel: 'MinApps Screen',
                        package: "mapness",
                      ),
                    ),
                  ),
                )
            ],
          ),
        ),
        if (dashboardState != DashboardControlsState.idle)
          const SizedBox(
            width: 12,
          ),
        if (dashboardState != DashboardControlsState.idle)
          GestureDetector(
            onTap: () {
              _searchFocus.unfocus();
              ref
                  .read(dashboardControlsProvider.notifier)
                  .update(DashboardControlsState.idle);
              ref.watch(searchProvider.notifier).removeMarkers();
              widget.dashboardKey.currentState?.collapse();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(8),
                ),
                color: dashboardState != DashboardControlsState.results
                    ? const Color(0xFFF1F4F8)
                    : Colors.white,
              ),
              padding: const EdgeInsets.all(8.0),
              child: SvgPicture.asset(
                "assets/icons/svg/ic_search_close.svg",
                semanticsLabel: 'MinApps Screen',
                package: "mapness",
              ),
            ),
          ),
      ],
    );
  }
}
