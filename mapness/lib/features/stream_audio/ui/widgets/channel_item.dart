import 'dart:ui';

import 'package:balady_uikit/balady_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/data/dto/filtered_channel.dart';

class MediaCatalogItem extends StatelessWidget {
  const MediaCatalogItem({
    required this.channel,
    required this.isSelected,
    super.key,
  });

  final FilteredChannel channel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final title = channel.currentPlayedProgram?.name ?? (Directionality.of(context) == TextDirection.rtl ? 'على الهواء' : 'On Air');
    final subTitle = channel.name ?? '-';
    final hasProgram = channel.currentPlayedProgram != null;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: RadiusBorder.xs),
      child: Stack(
        children: [
          SizedBox(
            width: 104,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    buildProgramImage(),

                    /// Channel selected and has current program
                    /// -> normal gradient
                    if (isSelected && hasProgram)
                      Container(
                        width: 96,
                        height: 96,
                        decoration: ShapeDecoration(
                          gradient: LinearGradient(
                            begin: const Alignment(0.50, -0.00),
                            end: const Alignment(0.50, 1.00),
                            colors: [Colors.black.withOpacity(0.60), Colors.black.withOpacity(0.90)],
                          ),
                          shape: RoundedRectangleBorder(
                            side: BorderSide(color: Colors.white.withOpacity(0.10)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),

                    /// channel hasn't program
                    /// -> blur effect with gradient
                    if (!hasProgram)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                          child: Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: const [0.00, 1.00],
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.black.withOpacity(isSelected ? 0.9 : 0.2)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(),
                            ),
                          ),
                        ),
                      ),

                    /// Wave Icon above selected channel with or without program
                    if (isSelected)
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: 0,
                        left: 0,
                        child: Center(
                          child: SvgPicture.asset(
                            Assets.icons.svg.audio.waves.keyName,
                            width: 32,
                            height: 32,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: Spacing.$2x),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subTitle,
                      style: const TextStyle(fontSize: 12, color: Colors.white60),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: 54,
            right: 0,
            child: CircleImage(url: channel.circledLogo ?? channel.logo ?? ''),
          ),
        ],
      ),
    );
  }

  Widget buildProgramImage() {
    final programLogo = channel.currentPlayedProgram?.image;
    final bool hasProgramLogo = programLogo != null && programLogo.isNotEmpty;
    final url = hasProgramLogo ? programLogo : (channel.maximizedLogo ?? 'https://www.mbcmood.com/images/Logo.png');

    return ProgramImage(url: url);
  }
}

class CircleImage extends StatelessWidget {
  const CircleImage({
    required this.url,
    super.key,
  });

  final String url;

  @override
  Widget build(BuildContext context) => Container(
        height: 45,
        width: 45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(RadiusBorder.full),
          border: Border.all(
            color: Colors.black.withOpacity(0.10),
          ),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(color: Colors.black26, blurRadius: 12, offset: Offset(0, 10)),
            BoxShadow(color: Colors.black26, blurRadius: 36, offset: Offset(0, 12))
          ],
        ),
        child: !url.contains('svg')
            ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: Image.network(
                  url,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, __, ___) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Assets.icons.svg.icMbcMood.svg(
                      colorFilter: const ColorFilter.mode(Color(0xffF24A38), BlendMode.srcIn),
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.network(
                  url,
                  placeholderBuilder: (context) => Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Assets.icons.svg.icMbcMood.svg(
                      colorFilter: const ColorFilter.mode(Color(0xffF24A38), BlendMode.srcIn),
                    ),
                  ),
                ),
              ),
      );
}

class ProgramImage extends StatelessWidget {
  const ProgramImage({required this.url, this.withBoarder = false, super.key});

  final String url;
  final bool withBoarder;

  @override
  Widget build(BuildContext context) => Container(
        width: 96,
        height: 96,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: withBoarder ? Border.all(color: Colors.black.withOpacity(0.1)) : null,
          color: Colors.white,
        ),
        child: url.contains('svg')
            ? SvgPicture.network(
                url,
                placeholderBuilder: (context) => Assets.icons.svg.icMbcMood.svg(
                  colorFilter: const ColorFilter.mode(Color(0xffF24A38), BlendMode.srcIn),
                ),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url,
                  fit: BoxFit.fitWidth,
                  errorBuilder: (_, __, ___) => Assets.icons.svg.icMbcMood.svg(
                    colorFilter: const ColorFilter.mode(Color(0xffF24A38), BlendMode.srcIn),
                  ),
                ),
              ),
      );
}
