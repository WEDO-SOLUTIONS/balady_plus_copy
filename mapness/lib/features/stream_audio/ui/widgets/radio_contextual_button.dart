import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/stream_audio_colors.dart';
import 'package:mapness/shared/ui/buttons/map_button.dart';

class RadioContextualButton extends ConsumerStatefulWidget {
  const RadioContextualButton({super.key});

  @override
  ConsumerState<RadioContextualButton> createState() => _RadioContextualButtonState();
}

class _RadioContextualButtonState extends ConsumerState<RadioContextualButton> {
  Future<void> _openAudioPlayer(BuildContext context) async {
    final provider = ref.read(streamAudioProvider.notifier);

    if (provider.needsReinitialization) {
      await provider.reset();
    }

    await provider.getChannels();
    if (provider.filteredChannels.isNotEmpty == true) {
      await provider.selectChannel(provider.filteredChannels.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    final theme = context.streamAudioColors;

    if (provider.selectedChannel != null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        _buildActionButton(theme),
        if (provider.isContextualMessageVisible)
          Stack(
            children: [
              SvgPicture.asset(Assets.icons.svg.audio.contextualBanner.keyName),
              Positioned(left: 26, top: 8, child: _buildMessageContent(theme, provider)),
            ],
          ),
      ],
    );
  }

  Widget _buildActionButton(StreamAudioColors theme) => MapButton(
        onTap: () => _openAudioPlayer(context),
        borderRadius: BorderRadius.circular(MapButton.defaultSize / 2),
        child: SvgPicture.asset(
          Assets.icons.svg.audio.audioStream.keyName,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(theme.accent, BlendMode.srcIn),
        ),
      );

  Widget _buildMessageContent(StreamAudioColors theme, StreamAudioProvider provider) => SizedBox(
        width: 200,
        child: Row(
          children: [
            Column(
              children: [
                _buildHeader(theme, provider),
                const SizedBox(height: 2),
                _buildSubTitle(theme, provider),
              ],
            ),
            const Spacer(),
            ..._buildActions(),
          ],
        ),
      );

  Widget _buildHeader(StreamAudioColors theme, StreamAudioProvider provider) => Text(
        provider.contextualMessageTitle ?? 'Catch the latest',
        style: TextStyle(
          color: theme.playerText,
          fontSize: 14,
          fontFamily: 'Golos Text',
          fontWeight: FontWeight.w600,
          height: 1.14,
        ),
      );

  Widget _buildSubTitle(StreamAudioColors theme, StreamAudioProvider provider) => Text(
        provider.contextualMessageSubtitle ?? 'Tune into live radio',
        style: TextStyle(
          color: theme.playerMutedText,
          fontSize: 12,
          fontFamily: 'Golos Text',
          fontWeight: FontWeight.w400,
          height: 1.33,
        ),
      );

  List<Widget> _buildActions() {
    final providerNotifier = ref.read(streamAudioProvider.notifier);

    return [
      const SizedBox(width: 14),
      GestureDetector(
        onTap: () {
          setState(() => providerNotifier.hideContextualMessage());
          _openAudioPlayer(context);
        },
        child: SvgPicture.asset(Assets.icons.svg.audio.check.keyName),
      ),
      const SizedBox(width: 14),
      GestureDetector(
        onTap: () => setState(() => providerNotifier.hideContextualMessage()),
        child: SvgPicture.asset(Assets.icons.svg.audio.close.keyName),
      ),
    ];
  }
}
