import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/search/models/search_scope.dart';
import 'package:mapness/features/search/providers/search.dart';
import 'package:mapness/shared/extensions/build_context_ext.dart';
import 'package:provider/provider.dart';

class SearchHistoryEmpty extends ConsumerWidget {
  const SearchHistoryEmpty({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scope = context.read<SearchScope>();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 38,
          vertical: 20,
        ),
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: "Look for useful places, cafes, malls for example: ",
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  letterSpacing: 0.18,
                  color: const Color(0xFF1E2A36),
                ),
              ),
              TextSpan(
                text: context.l10n.mallNearby,
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                  letterSpacing: 0.18,
                  color: const Color(0xFF4CA5B4),
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    ref
                        .read(searchQueryProvider(scope.value).notifier)
                        .update(context.l10n.mallNearby);
                  },
              )
            ],
          ),
        ),
      ),
    );
  }
}
