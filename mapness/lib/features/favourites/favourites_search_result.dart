import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/features/favourites/providers/favourite_search.dart';
import 'package:mapness/features/favourites/widgets/screen/search_screen.dart';

class FavouritesSearchResult extends ConsumerWidget {
  const FavouritesSearchResult({Key? key}) : super(key: key);

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
              Expanded(
                child: Column(
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
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    // return Scaffold(
    //   backgroundColor: const Color(0xfff4f4f5),
    //   body: Column(
    //     children: [
    //       Container(
    //         color: const Color(0xfff2f7f8),
    //         padding: EdgeInsets.only(
    //           left: 16,
    //           right: 16,
    //           top: MediaQuery.of(context).padding.top + 8,
    //         ),
    //         child: Row(
    //           mainAxisSize: MainAxisSize.max,
    //           children: [
    //             const Expanded(
    //               child: FavouriteTextField(),
    //             ),
    //             const SizedBox(width: 8),
    //             Container(
    //               height: 40,
    //               width: 40,
    //               decoration: BoxDecoration(
    //                 color: Colors.white,
    //                 borderRadius: BorderRadius.circular(8),
    //               ),
    //               child: const Icon(CupertinoIcons.forward),
    //             )
    //           ],
    //         ),
    //       ),
    //       Expanded(
    //         child: Padding(
    //           padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    //           child: ListView.separated(
    //             itemCount: searchResult.length,
    //             separatorBuilder: (_, __) => const Divider(),
    //             itemBuilder: ,
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
