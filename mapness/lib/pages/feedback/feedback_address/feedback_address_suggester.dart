import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/features/search/ui/search_scope.dart';
import 'package:mapness/pages/feedback/feedback_address/feedback_address_content.dart';
import 'package:mapness/pages/feedback/feedback_address/feedback_address_search_bar.dart';

@RoutePage()
class FeedbackAddressSuggester extends ConsumerStatefulWidget {
  const FeedbackAddressSuggester({
    super.key,
  });

  @override
  ConsumerState<FeedbackAddressSuggester> createState() => _FeedbackAddressSuggesterState();
}

class _FeedbackAddressSuggesterState extends ConsumerState<FeedbackAddressSuggester> {
  late final StatelessBottomSheetController _dgisSheetController;
  final kbVisibilityController = KeyboardVisibilityController();
  late final StreamSubscription<bool> _keyboardVisible;

  bool visible = true;
  bool isFirstLaunch = false;

  @override
  void initState() {
    super.initState();
    _dgisSheetController = StatelessBottomSheetController(
        heightModel: BottomSheetHeightModel.aspect(
          .98,
        ),
        onClose: (_) {
          ref.read(appRouterProvider).back();
        });

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
        child: LayoutBuilder(
          builder: (context, constraints) => NotificationListener<ScrollNotification>(
            onNotification: _onNotification,
            child: SafeArea(
              child: StatelessBottomSheet(
                key: const ValueKey('FEEDBACK SEARCH SHEET'),
                physics: const BouncingScrollPhysics(),
                scrollController: _dgisSheetController,
                backgroundColor: context.colorsV3.backgroundSurface4,
                safeAreaColor: context.colorsV3.backgroundSurface4,
                header: ColoredBox(
                  color: context.colorsV3.backgroundSurface1,
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
                sliverBeforeContent: FeedbackAddressContent(
                  showMyLocation: false,
                  scrollController: _dgisSheetController,
                ),
              ),
            ),
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
