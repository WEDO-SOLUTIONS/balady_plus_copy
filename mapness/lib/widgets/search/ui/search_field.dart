import 'package:balady_plus/app/core/utils/utils_exports.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';

class SearchField extends StatefulWidget {
  const SearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final void Function(String value)? onChanged;
  final void Function(String value)? onSubmitted;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final ValueNotifier<bool> _clearVisible = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    widget.controller?.addListener(() {
      _clearVisible.value = widget.controller!.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    _clearVisible.value = widget.controller?.text.isNotEmpty ?? false;

    return Stack(
      fit: StackFit.passthrough,
      children: [
        SizedBox(
          height: 40,
          child: TextField(
            focusNode: widget.focusNode,
            onChanged: (value) {
              _clearVisible.value = value.isNotEmpty;
              widget.onChanged?.call(value);
            },
            onSubmitted: widget.onSubmitted,
            controller: widget.controller,
            maxLines: 1,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              hintText: context.l10n.search,
              fillColor: const Color(0xFF1E2A36).withOpacity(0.05),
              contentPadding: EdgeInsets.only(
                right: context.isRTL ? 8 : 38,
                left: context.isRTL ? 38 : 8,
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
            style: const TextStyle(
              color: Color(0xFF1E2A36),
              fontSize: 14,
              fontWeight: FontWeight.w400,
              height: 1.5,
              fontFamily: "Frutiger",
            ),
          ),
        ),
        Align(
          alignment:
              context.isRTL ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "assets/icons/svg/ic_dashboard_search.svg",
              width: 24,
              height: 24,
              package: PackageConfig.packageName,
              colorFilter: ColorFilter.mode(
                const Color(0xFFE2A3680).withOpacity(0.5),
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: _clearVisible,
          builder: (context, value, child) {
            if (value) {
              return GestureDetector(
                onTap: () {
                  _clearVisible.value = false;
                  widget.focusNode?.requestFocus();
                  widget.controller?.clear();
                  widget.onChanged?.call("");
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SvgPicture.asset(
                      "assets/icons/svg/ic_search_clear.svg",
                      package: PackageConfig.packageName,
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        )
      ],
    );
  }
}
