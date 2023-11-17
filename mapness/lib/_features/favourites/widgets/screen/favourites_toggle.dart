import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mapness/_features/favourites/providers/favourite_markers.dart';

class FavouritesToggle extends ConsumerWidget {
  final bool isEditing;

  const FavouritesToggle({required this.isEditing, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(favouriteMarkersProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: ShapeDecoration(
        color: const Color(0x238DBABD),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Show favorites on map',
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              color: const Color(0xFF001022),
              fontSize: 18,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.18,
            ),
          ),
          const Spacer(),
          CupertinoSwitch(
            value: state,
            activeColor: const Color(0xFF42909B),
            onChanged: isEditing
                ? null
                : (_) => ref.read(favouriteMarkersProvider.notifier).toggle(),
          ),
        ],
      ),
    );
  }
}
