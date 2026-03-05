import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/_features/common/widgets/dragger.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/features/search/providers/search_history.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/feedback/feedback_address/feedback_address_content.dart';
import 'package:mapness/pages/feedback/feedback_address/feedback_address_search_bar.dart';
import 'package:mapness/pages/map_search/ui/map_search_content_v2.dart';
import 'package:mapness/shared/providers/analytic/bss_service.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class FeedbackAddressSuggester extends ConsumerStatefulWidget {
  const FeedbackAddressSuggester({super.key});

  @override
  ConsumerState<FeedbackAddressSuggester> createState() => _FeedbackAddressSuggesterState();
}

class _FeedbackAddressSuggesterState extends ConsumerState<FeedbackAddressSuggester> {
  late final ToggleSheetController _dgisSheetController;
  final kbVisibilityController = KeyboardVisibilityController();
  late final StreamSubscription<bool> _keyboardVisible;

  bool visible = true;
  bool isFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    _dgisSheetController = ToggleSheetController(
      heightModel: ToggleSheetHeightModel.offset(Spacing.$6x),
      onClose: (_) {
        ref.read(appRouterProvider).back();
      },
    );

    _keyboardVisible = kbVisibilityController.onChange.listen(_onKeyboardToggle);
  }

  @override
  void dispose() {
    _dgisSheetController.dispose();
    _keyboardVisible.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SearchScope(
    named: SearchScopeEnum.feedback,
    child: NotificationListener<ScrollNotification>(
      onNotification: _onNotification,
      child: ToggleSheet(
        key: const ValueKey('FEEDBACK SEARCH SHEET'),
        physics: const BouncingScrollPhysics(),
        scrollController: _dgisSheetController,
        barrierColorDelegate: ToggleSheetDelegate.value(context.colors.screenOverlayDimming40),
        backgroundColor: context.colors.backgroundSurface4,
        safeAreaColor: context.colors.backgroundSurface4,
        dragger: SheetDragger(backgroundColor: context.colors.backgroundSurface1),
        header: ColoredBox(
          color: context.colors.backgroundSurface1,
          child: const Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.$4x),
                child: FeedbackAddressSearchBar(),
              ),
              SizedBox(height: Spacing.$4x),
            ],
          ),
        ),
        sliver: FeedbackAddressContent(showMyLocation: false, scrollController: _dgisSheetController),
      ),
    ),
  );

  void _unFocusOnScroll() {
    if (kbVisibilityController.isVisible) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  bool _onNotification(ScrollNotification notification) {
    if (notification is ScrollStartNotification) {
      // BSA-1103
      // We need to check if the user is dragging the sheet
      // If not we don't need to unfocus the search field
      //
      // This check is necessary because the [ScrollStartNotification] is called even on the scroll of the TextField
      // when the user is typing a long text and the TextField is scrolling to show it
      if (notification.dragDetails != null) {
        _unFocusOnScroll();
        MapSearchContent.scrollSendEvent(
          searchState: ref.read(searchProvider(SearchScopeEnum.feedback.value)),
          historyListSize: ref.read(searchHistoryProvider(SearchScopeEnum.feedback.value)).length,
          sendEvent: BssService.instance.sendEvent,
        );
      }
    }
    return true;
  }

  void _onKeyboardToggle(bool kbState) {
    if (!kbState) {
      return;
    }
  }
}
