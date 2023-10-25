import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/happiness_map/data/happines_manager.dart';

class HappinessTextField extends ConsumerWidget {
  const HappinessTextField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final happinessManager = ref.watch(happinessManagerProvider.notifier);

    final border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );

    return TextField(
      enabled: false,
      textAlign: TextAlign.end,
      textInputAction: TextInputAction.done,
      // controller: model.searchController,
      onSubmitted: happinessManager.updateComment,
      onChanged: happinessManager.updateComment,
      // focusNode: model.searchFocusNode,
      decoration: InputDecoration(
        hintText: 'Share your feedback',
        enabledBorder: border,
        fillColor: const Color(0xfff4f4f5),
        filled: true,
        border: border,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        focusedBorder: border,
        isDense: true,
        hintStyle: GoogleFonts.inter(
          color: const Color(0x7F1E2A36),
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 0.09,
        ),
      ),
    );
  }
}
