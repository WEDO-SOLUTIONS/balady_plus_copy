import 'dart:ui';

import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/stream_audio_colors.dart';

class AudioPlayerBanner extends ConsumerWidget {
  const AudioPlayerBanner({
    required this.onTap,
    required this.onClose,
    super.key,
  });

  final VoidCallback onTap;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(streamAudioProvider);
    final selectedChannel = provider.selectedChannel;
    final theme = context.streamAudioColors;

    if (selectedChannel == null) {
      return const SizedBox.shrink();
    }

    return Container(
      height: 56,
      decoration: BoxDecoration(color: theme.playerBackground),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                _buildProgramImage(provider, theme),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedChannel.currentPlayedProgram?.name ??
                            (Directionality.of(context) == TextDirection.rtl ? 'على الهواء' : 'On Air'),
                        style: TextStyle(
                          color: theme.playerText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        selectedChannel.name ?? 'MBC Mood',
                        style: TextStyle(
                          color: theme.playerMutedText,
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          height: 1.2,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Play/Pause button
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () async {
                        await ref.read(streamAudioProvider).togglePlayPause();
                      },
                      child: Container(
                        width: 48,
                        height: 56,
                        // color: Colors.transparent,
                        alignment: Alignment.center,
                        child: provider.isLoading
                            ? SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(theme.playerText),
                                ),
                              )
                            : SvgPicture.asset(
                                provider.isPlaying
                                    ? Assets.icons.svg.audio.pause.keyName
                                    : Assets.icons.svg.audio.resume.keyName,
                                width: 16,
                                height: 16,
                                colorFilter: ColorFilter.mode(theme.playerText, BlendMode.srcIn),
                              ),
                      ),
                    ),
                    // Forward button
                    Transform.flip(
                      flipX: Directionality.of(context) == TextDirection.rtl,
                      child: AnimatedOpacity(
                        opacity: provider.canGoToNextChannel ? 1.0 : 0.4,
                        duration: const Duration(milliseconds: 200),
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: !provider.canGoToNextChannel
                              ? null
                              : () => ref.read(streamAudioProvider).goToNextChannel(),
                          child: Container(
                            width: 48,
                            height: 56,
                            // color: Colors.transparent,
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              Assets.icons.svg.audio.seekForward.keyName,
                              width: 14,
                              height: 14,
                              colorFilter: ColorFilter.mode(theme.playerText, BlendMode.srcIn),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Close button
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: onClose,
                      child: Container(
                        width: 48,
                        height: 56,
                        // color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.close,
                          color: theme.playerMutedText,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgramImage(StreamAudioProvider provider, StreamAudioColors theme) {
    final channel = provider.selectedChannel;
    final hasProgram = channel?.currentPlayedProgram != null;
    final programLogo = channel?.currentPlayedProgram?.image;
    final bool hasProgramLogo = programLogo != null && programLogo.isNotEmpty;
    final url = hasProgramLogo ? programLogo : (channel?.logo ?? 'https://www.mbcmood.com/images/Logo.png');

    return Stack(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: !url.contains('svg')
              ? Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      url,
                      fit: BoxFit.fitWidth,
                      errorBuilder: (_, __, ___) => Padding(
                        padding: const EdgeInsets.all(4),
                        child: Assets.icons.svg.icMbcMood.svg(
                          colorFilter: ColorFilter.mode(theme.placeholderIcon, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                )
              : SvgPicture.network(
                  url,
                  placeholderBuilder: (_) => Padding(
                    padding: const EdgeInsets.all(4),
                    child: Assets.icons.svg.icMbcMood.svg(
                      colorFilter: ColorFilter.mode(theme.placeholderIcon, BlendMode.srcIn),
                    ),
                  ),
                ),
        ),
        if (!hasProgram)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 1.4, sigmaY: 1.4),
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.black.withValues(alpha: 0.2),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: theme.playerBorder),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
