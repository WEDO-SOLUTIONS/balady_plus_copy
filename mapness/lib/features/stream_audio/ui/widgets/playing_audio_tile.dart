import 'package:flutter/material.dart';

import '../../../../_generated/assets/assets.gen.dart';

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
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
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
          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(
                  Icons.fast_rewind,
                  color: Colors.white,
                  size: 30,
                ),
                Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 36,
                ),
                Icon(
                  Icons.fast_forward,
                  color: Colors.white,
                  size: 30,
                ),
              ],
            ),
          ),
        ],
      );
}
