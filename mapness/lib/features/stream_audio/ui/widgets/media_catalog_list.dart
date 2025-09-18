import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/widgets/media_catalog_item.dart';

import '../providers/stream_audio_prov.dart';

class MediaCatalogList extends ConsumerStatefulWidget {
  const MediaCatalogList({required this.needReset, super.key});

  final Function() needReset;

  @override
  ConsumerState<MediaCatalogList> createState() => _MediaCatalogListState();
}

class _MediaCatalogListState extends ConsumerState<MediaCatalogList> {
  @override
  Widget build(BuildContext context) => Builder(builder: (context) {
        final liveNow = ref.watch(streamAudioProvider).liveNow;
        if (liveNow == null) {
          return const Padding(padding: EdgeInsets.all(16.0), child: Center(child: CircularProgressIndicator()));
        }

        final programs = liveNow.programs;
        if (programs.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'No live programs right now',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          );
        }
        return SizedBox(
          height: 136,
          child: ListView.builder(
            itemCount: programs.length,
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: RadiusBorder.l),
            itemBuilder: (_, index) {
              final program = programs[index];
              return GestureDetector(
                onTap: () {
                  widget.needReset.call();
                  ref.read(streamAudioProvider).selectProgram(program);
                },
                child: MediaCatalogItem(
                  subTitle: program.title,
                  title: program.sub,
                  image: program.programImage.provider(),
                  radioImage: program.channelImage.provider(),
                ),
              );
            },
          ),
        );
      });
}
