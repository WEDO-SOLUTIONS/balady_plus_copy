import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:balady_uikit/core/typography/text_theme_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:mapness/shared/providers/map/suggest.dart';

class FavouriteTextField extends ConsumerStatefulWidget {
  const FavouriteTextField({super.key, this.hintText});
  final String? hintText;

  @override
  ConsumerState<FavouriteTextField> createState() => _FavouriteTextFieldState();
}

class _FavouriteTextFieldState extends ConsumerState<FavouriteTextField> {
  late TextEditingController _controller;
  final _searchFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(suggestQueryProvider, (previous, next) {
      if (_controller.text != next) {
        _controller.text = next;
      }
    });

    return Directionality(
      textDirection: Directionality.of(context),
      child: Stack(
        fit: StackFit.passthrough,
        children: [
          SizedBox(
            height: 40,
            child: TextField(
              focusNode: _searchFocus,
              onChanged: (value) {
                if (value.isEmpty) {
                  ref.read(suggestQueryProvider.notifier).query = '';
                } else {
                  ref.read(suggestQueryProvider.notifier).query = value;
                }
                setState(() {});
              },
              controller: _controller,
              textAlignVertical: TextAlignVertical.center,
              decoration: InputDecoration(
                filled: true,
                // isDense: true,
                hintText: widget.hintText ?? context.l10n.search,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.only(
                  //   // horizontal: 8,
                  right: 8,
                  left: 38,
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
              style: Theme.of(context).extension<ThemeTextStyles>()!.text,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SvgPicture.asset(
                Assets.icons.svg.icDashboardSearch.keyName,
                semanticsLabel: context.l10n.search,
                colorFilter: ColorFilter.mode(
                  context.colors.accentOnContainer,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          if (_controller.text.isNotEmpty)
            GestureDetector(
              onTap: () {
                _controller.clear();
                _searchFocus.requestFocus();
                setState(() {});
              },
              child: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: SvgPicture.asset(
                    Assets.icons.svg.icSearchClear.keyName,
                    semanticsLabel: context.l10n.a11yClearSearch,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
