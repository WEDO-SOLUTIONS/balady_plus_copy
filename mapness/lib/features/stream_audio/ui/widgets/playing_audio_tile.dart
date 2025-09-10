import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';

class PlayingAudioTile extends StatelessWidget {
  const PlayingAudioTile({super.key});

  @override
  Widget build(BuildContext context) => Row(
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Panorama FM',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Paused',
                        style: TextStyle(
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
