import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/favourites/providers/favourite_search.dart';
import 'package:mapness/features/favourites/widgets/screen/search_screen.dart';

class FavouritesSearch extends ConsumerWidget {
  const FavouritesSearch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResult = ref.watch(favouritesSearchProvider);

    return SearchScreen(
      onNext: () {
        context.pop();
      },
      itemBuilder: (_, index) {
        final item = searchResult[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.distance,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: const Color(0xff1E2A36),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    item.address,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    item.workingHours,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: item.workingHoursColor,
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
