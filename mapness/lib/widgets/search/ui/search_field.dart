import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/shared/config/package_config.dart';
import 'package:mapness/shared/config/package_fonts.dart';

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
              hintText: "Search",
              fillColor: const Color(0xFFF1F4F8),
              contentPadding: const EdgeInsets.only(
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
            style: PackageFonts.frutigerArabic(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SvgPicture.asset(
              "assets/icons/svg/ic_dashboard_search.svg",
              package: PackageConfig.packageName,
              colorFilter: const ColorFilter.mode(
                Color(0xFF4CA5B4),
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
