import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/stream_audio_colors.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class PlayingAudioTile extends ConsumerStatefulWidget {
  final bool isLandscape;
  final String? instanceId;

  const PlayingAudioTile({this.isLandscape = false, this.instanceId, super.key});

  @override
  ConsumerState<PlayingAudioTile> createState() => _PlayingAudioTileState();
}

class _PlayingAudioTileState extends ConsumerState<PlayingAudioTile> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    final theme = context.streamAudioColors;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.isLandscape ? _buildLandscapeLayout(provider, theme) : _buildPortraitLayout(provider, theme),
    );
  }

  Widget _buildPortraitLayout(StreamAudioProvider provider, StreamAudioColors theme) => Column(
        children: [
          // Simplified audio player row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                // Album art with subtle animation
                _buildAlbumArt(provider, 48, theme),
                const SizedBox(width: 16),
                // Title and subtitle
                Expanded(child: _buildTitleSubtitle(provider, CrossAxisAlignment.start, theme)),
                // Play/Pause button with animation
                const SizedBox(width: 12),
                _buildControls(provider, theme, isVertical: false),
              ],
            ),
          ),
        ],
      );

  Widget _buildLandscapeLayout(StreamAudioProvider provider, StreamAudioColors theme) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album art (larger in landscape)
            _buildAlbumArt(provider, 120, theme),
            const SizedBox(height: 20),
            // Title and subtitle (center aligned)
            _buildTitleSubtitle(provider, CrossAxisAlignment.center, theme),
            const SizedBox(height: 24),
            // Play/Pause and Seek buttons (vertically stacked)
            _buildControls(provider, theme, isVertical: true),
          ],
        ),
      );

  Widget _buildAlbumArt(StreamAudioProvider provider, double size, StreamAudioColors theme) {
    final channel = provider.selectedChannel;

    final programLogo = channel?.currentPlayedProgram?.image;
    final bool hasProgramLogo = programLogo != null && programLogo.isNotEmpty;
    final programUrl =
        hasProgramLogo ? programLogo : (channel?.logo ?? 'https://assets.mbcmood.com/channels/1708604937logombc.png');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: const Color(0xFF161B26),
        boxShadow: [
          BoxShadow(
            color: theme.playerShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: !programUrl.contains('svg')
          ? Padding(
              padding: const EdgeInsets.all(2),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  programUrl,
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
              programUrl,
              placeholderBuilder: (_) => Padding(
                padding: const EdgeInsets.all(4),
                child: Assets.icons.svg.icMbcMood.svg(
                  colorFilter: ColorFilter.mode(theme.placeholderIcon, BlendMode.srcIn),
                ),
              ),
            ),
    );
  }

  Widget _buildTitleSubtitle(
    StreamAudioProvider provider,
    CrossAxisAlignment alignment,
    StreamAudioColors theme,
  ) => Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            provider.selectedChannel?.currentPlayedProgram?.name ?? (Directionality.of(context) == TextDirection.rtl ? 'على الهواء' : 'On Air'),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: theme.playerText,
              letterSpacing: -0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: alignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.start,
          ),
          const SizedBox(height: 4),
          Text(
            provider.selectedChannel?.name ?? '-',
            style: TextStyle(
              fontSize: 13,
              color: theme.playerMutedText,
              letterSpacing: -0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: alignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.start,
          ),
        ],
      );

  Widget _buildControls(StreamAudioProvider provider, StreamAudioColors theme, {required bool isVertical}) {
    final backwardButton = Transform.flip(
      flipX: Directionality.of(context) == TextDirection.rtl,
      child: AnimatedOpacity(
        opacity: provider.canGoToPreviousChannel ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: !provider.canGoToPreviousChannel ? null : () => ref.read(streamAudioProvider).goToPreviousChannel(),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              Assets.icons.svg.audio.seekBackward.keyName,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(theme.playerText, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );

    final playPauseButton = GestureDetector(
      onTap: () async {
        await ref.read(streamAudioProvider).togglePlayPause();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 44,
        height: 44,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: _buildPlayPauseIcon(provider, theme),
          ),
        ),
      ),
    );

    final forwardButton = Transform.flip(
      flipX: Directionality.of(context) == TextDirection.rtl,
      child: AnimatedOpacity(
        opacity: provider.canGoToNextChannel ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 200),
        child: GestureDetector(
          onTap: !provider.canGoToNextChannel ? null : () => ref.read(streamAudioProvider).goToNextChannel(),
          child: Container(
            width: 44,
            height: 44,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              Assets.icons.svg.audio.seekForward.keyName,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(theme.playerText, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );

    if (isVertical) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          backwardButton,
          const SizedBox(height: 8),
          playPauseButton,
          const SizedBox(height: 8),
          forwardButton,
        ],
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          backwardButton,
          const SizedBox(width: 8),
          playPauseButton,
          const SizedBox(width: 8),
          forwardButton,
        ],
      );
    }
  }

  Widget _buildPlayPauseIcon(StreamAudioProvider provider, StreamAudioColors theme) {
    // Ensure UI reflects actual audio state, not just the playing flag
    // This handles cases where audio is interrupted by phone calls, etc.

    if (provider.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(theme.playerText.withValues(alpha: 0.8)),
        ),
      );
    }

    // Show play icon if not playing OR if there's an error
    // This ensures the UI correctly reflects when audio is paused by external factors
    final shouldShowPlayIcon = !provider.isPlaying || provider.hasError;

    return SvgPicture.asset(
      shouldShowPlayIcon ? Assets.icons.svg.audio.resume.keyName : Assets.icons.svg.audio.pause.keyName,
      width: 20,
      height: 20,
      colorFilter: ColorFilter.mode(theme.playerText, BlendMode.srcIn),
    );
  }
}
