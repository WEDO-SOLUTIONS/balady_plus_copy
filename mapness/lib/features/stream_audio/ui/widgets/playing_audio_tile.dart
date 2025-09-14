import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class PlayingAudioTile extends ConsumerStatefulWidget {
  const PlayingAudioTile({super.key});

  @override
  ConsumerState<PlayingAudioTile> createState() => _PlayingAudioTileState();
}

class _PlayingAudioTileState extends ConsumerState<PlayingAudioTile> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    return Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.symmetric(horizontal: RadiusBorder.l),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(RadiusBorder.baseSharp),
                    image: DecorationImage(
                      image:
                          Assets.images.audioPlaceholders.panorama.provider(),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        provider.selectedProgram?.title ?? '-',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        provider.selectedProgram?.sub ?? '-',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white60,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
            Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SvgPicture.asset(Assets.icons.svg.audio.seekBackward.keyName),
                SvgPicture.asset(Assets.icons.svg.audio.resume.keyName),
                SvgPicture.asset(Assets.icons.svg.audio.seekForward.keyName),
              ],
            ),
          ),
        ],
      );
  }
}
