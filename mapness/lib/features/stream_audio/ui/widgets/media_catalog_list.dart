import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/widgets/media_catalog_item.dart';

class MediaCatalogList extends ConsumerWidget {
  final VoidCallback? needReset;

  const MediaCatalogList({
    Key? key,
    this.needReset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(streamAudioProvider);
    final programs = provider.liveNow?.programs ?? [];

    if (programs.isEmpty) {
      return Container(
        height: 136,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white.withOpacity(0.5),
          ),
        ),
      );
    }

    return Container(
      height: 180,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: programs.length,
        itemBuilder: (context, index) {
          final program = programs[index];
          final isSelected = provider.selectedProgram?.title == program.title;

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                ref.read(streamAudioProvider).selectProgram(program);
                needReset?.call();
              }
            },
            child: MediaCatalogItem(
              subTitle: program.title,
              title: program.sub,
              image: program.programImage.provider(),
              radioImage: program.channelImage.provider(),
            ),
          );

          // return GestureDetector(
          //   onTap: () {
          //     if (!isSelected) {
          //       ref.read(streamAudioProvider).selectProgram(program);
          //       needReset?.call();
          //     }
          //   },
          //   child: Container(
          //     width: 80,
          //     margin: const EdgeInsets.symmetric(horizontal: 4),
          //     child: Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         // Channel image
          //         AnimatedContainer(
          //           duration: const Duration(milliseconds: 200),
          //           width: isSelected ? 60 : 56,
          //           height: isSelected ? 60 : 56,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(isSelected ? 16 : 12),
          //             border: isSelected ? Border.all(color: Colors.white, width: 2) : null,
          //             boxShadow: isSelected
          //                 ? [
          //                     BoxShadow(
          //                       color: Colors.white.withOpacity(0.3),
          //                       blurRadius: 12,
          //                       spreadRadius: 1,
          //                     ),
          //                   ]
          //                 : null,
          //           ),
          //           child: ClipRRect(
          //             borderRadius: BorderRadius.circular(isSelected ? 14 : 12),
          //             child: Image.asset(
          //               program.channelImage.keyName,
          //               fit: BoxFit.cover,
          //               errorBuilder: (context, error, stackTrace) => Container(
          //                 color: Colors.grey[800],
          //                 child: Icon(
          //                   Icons.radio,
          //                   color: Colors.white.withOpacity(0.5),
          //                   size: 24,
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ),
          //
          //         const SizedBox(height: 4),
          //
          //         // Channel name
          //         Text(
          //           program.title,
          //           style: TextStyle(
          //             fontSize: 11,
          //             color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
          //             fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          //           ),
          //           maxLines: 1,
          //           overflow: TextOverflow.ellipsis,
          //           textAlign: TextAlign.center,
          //         ),
          //
          //         // Playing indicator
          //         if (isSelected && provider.isPlaying)
          //           Container(
          //             margin: const EdgeInsets.only(top: 2),
          //             child: Row(
          //               mainAxisAlignment: MainAxisAlignment.center,
          //               children: List.generate(
          //                 3,
          //                 (i) => AnimatedContainer(
          //                   duration: Duration(milliseconds: 300 + (i * 100)),
          //                   width: 2,
          //                   height: provider.isPlaying ? (4 + (i * 2)).toDouble() : 2,
          //                   margin: const EdgeInsets.symmetric(horizontal: 1),
          //                   decoration: BoxDecoration(
          //                     color: Colors.white,
          //                     borderRadius: BorderRadius.circular(1),
          //                   ),
          //                 ),
          //               ),
          //             ),
          //           ),
          //       ],
          //     ),
          //   ),
          // );
        },
      ),
    );
  }
}
