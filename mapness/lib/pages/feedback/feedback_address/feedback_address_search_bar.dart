import 'package:auto_route/auto_route.dart';
import 'package:balady_uikit/balady_uikit.dart';
import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

class FeedbackAddressSearchBar extends ConsumerStatefulWidget {
  const FeedbackAddressSearchBar({
    super.key,
  });

  @override
  ConsumerState<FeedbackAddressSearchBar> createState() => _FeedbackAddressSearchBarState();
}

class _FeedbackAddressSearchBarState extends ConsumerState<FeedbackAddressSearchBar> {
  late FocusNode _focusNode;
  late TextEditingController _controller;
  final ValueNotifier<bool> _focused = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode()
      ..addListener(() {
        if (_focusNode.hasFocus) {
          _focused.value = true;
        }
      });
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scope = context.watch<SearchScope>();
    ref.listen(searchProvider(scope.value), (previous, next) {
      if (next.searchText != _controller.text) {
        _controller
          ..text = next.searchText
          ..selection = TextSelection.collapsed(offset: _controller.text.length);
      }
    });
    return BaladySearchWithBackButtonV2(
      searchInput: BaladyTextInput.search(
        controller: _controller,
        config: BaladyInputConfig(
          focusNode: _focusNode,
          onChanged: (query) => ref.read(searchProvider(scope.value).notifier).searchAddress(query),
          onSubmitted: (query) => ref.read(searchProvider(scope.value).notifier).searchAddress(query),
          hintText: context.l10n.search,
          fillColor: context.colors.neutralContainerDefault,
          hintColor: context.colors.foregroundSoft,
          textStyle: context.textStyles.bodySmallRegular,
        ),
      ),
      option: SearchTextBackOption(
        text: context.l10n.cancel,
        onPressed: () {
          FocusScope.of(context).unfocus();
          context.router.pop();
        },
      ),
    );
  }
}
