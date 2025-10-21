import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
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

    return FadeTransition(
      opacity: _fadeAnimation,
      child: widget.isLandscape ? _buildLandscapeLayout(provider) : _buildPortraitLayout(provider),
    );
  }

  Widget _buildPortraitLayout(StreamAudioProvider provider) => Column(
        children: [
          // Simplified audio player row
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                // Album art with subtle animation
                _buildAlbumArt(provider, 48),
                const SizedBox(width: 16),
                // Title and subtitle
                Expanded(child: _buildTitleSubtitle(provider, CrossAxisAlignment.start)),
                // Play/Pause button with animation
                const SizedBox(width: 12),
                _buildControls(provider, isVertical: false),
              ],
            ),
          ),
        ],
      );

  Widget _buildLandscapeLayout(StreamAudioProvider provider) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Album art (larger in landscape)
            _buildAlbumArt(provider, 120),
            const SizedBox(height: 20),
            // Title and subtitle (center aligned)
            _buildTitleSubtitle(provider, CrossAxisAlignment.center),
            const SizedBox(height: 24),
            // Play/Pause and Seek buttons (vertically stacked)
            _buildControls(provider, isVertical: true),
          ],
        ),
      );

  Widget _buildAlbumArt(StreamAudioProvider provider, double size) {
    final channel = provider.selectedChannel;
    final String url = channel?.maximizedLogo ?? 'https://assets.mbcmood.com/channels/1708604937logombc.png';

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[300],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity( 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: !url.contains('svg')
          ? Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.network(
                url,
                fit: BoxFit.fitWidth,
              ),
            )
          : Padding(padding: const EdgeInsets.all(8.0), child: SvgPicture.network(url)),
    );
  }

  Widget _buildTitleSubtitle(StreamAudioProvider provider, CrossAxisAlignment alignment) => Column(
        crossAxisAlignment: alignment,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            provider.selectedChannel?.currentPlayedProgram?.name ?? 'On Air',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.white,
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
              color: Colors.white.withOpacity( 0.5),
              letterSpacing: -0.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: alignment == CrossAxisAlignment.center ? TextAlign.center : TextAlign.start,
          ),
        ],
      );

  Widget _buildControls(StreamAudioProvider provider, {required bool isVertical}) {
    final backwardButton = AnimatedOpacity(
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
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
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
            child: _buildPlayPauseIcon(provider),
          ),
        ),
      ),
    );

    final forwardButton = AnimatedOpacity(
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
            colorFilter: const ColorFilter.mode(
              Colors.white,
              BlendMode.srcIn,
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

  Widget _buildPlayPauseIcon(StreamAudioProvider provider) {
    // Remove keys entirely to avoid conflicts - AnimatedSwitcher can work without them
    // The widget type difference (SizedBox vs SvgPicture) is enough for Flutter to distinguish them

    if (provider.isLoading) {
      return SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white.withOpacity(0.8),
          ),
        ),
      );
    }

    return SvgPicture.asset(
      provider.isPlaying ? Assets.icons.svg.audio.pause.keyName : Assets.icons.svg.audio.resume.keyName,
      width: 20,
      height: 20,
      colorFilter: const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      ),
    );
  }
}
