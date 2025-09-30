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
            Colors.white.withValues(alpha: 0.5),
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
              isSelected: isSelected,
            ),
          );
        },
      ),
    );
  }
}
