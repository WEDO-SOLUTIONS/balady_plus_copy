import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mapness/_generated/assets/assets.gen.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

class RadioContextualButton extends ConsumerStatefulWidget {
  const RadioContextualButton({super.key});

  @override
  ConsumerState<RadioContextualButton> createState() => _RadioContextualButtonState();
}

class _RadioContextualButtonState extends ConsumerState<RadioContextualButton> {
  Future<void> _openAudioPlayer(BuildContext context) async {
    final provider = ref.read(streamAudioProvider.notifier);

    // Reset if needed before getting live programs
    if (provider.needsReinitialization) {
      await provider.reset();
    }

    // Ensure we have live programs data first
    await provider.getChannels();
    if (provider.filteredChannels.isNotEmpty == true) {
      await provider.selectChannel(provider.filteredChannels.first);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(streamAudioProvider);
    // final providerNotifier = ref.read(streamAudioProvider.notifier);

    if (provider.selectedChannel != null) {
      return const SizedBox.shrink();
    }
    return Row(
      children: [
        /// Open Audio Button
        GestureDetector(
          onTap: () {
            _openAudioPlayer(context);
            // providerNotifier.mockUserInTraffic();
          },
          child: _buildActionButton(context),
        ),

        /// Message Banner
        if (provider.isContextualMessageVisible)
          Stack(
            children: [
              SvgPicture.asset(Assets.icons.svg.audio.contextualBanner.keyName),
              Positioned(left: 26, top: 8, child: _buildMessageContent(context, provider))
            ],
          ),
      ],
    );
  }

  Widget _buildActionButton(BuildContext context) => Container(
        width: 48,
        height: 48,
        padding: const EdgeInsets.all(12),
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.50, -0.00),
            end: Alignment(0.50, 1.00),
            stops: [0.00, 0.0],
            colors: [Color(0xFF212222), Color(0xFF212222)],
          ),
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.white.withOpacity( 0.15)),
            borderRadius: BorderRadius.circular(40),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x7F212222),
              blurRadius: 16,
              offset: Offset(0, 8),
              spreadRadius: -8,
            )
          ],
        ),
        child: SvgPicture.asset(
          Assets.icons.svg.audio.audioStream.keyName,
        ),
      );

  Widget _buildMessageContent(BuildContext context, StreamAudioProvider provider) => SizedBox(
        width: 200,
        child: Row(
          children: [
            Column(children: [_buildHeader(provider), const SizedBox(height: 2,),  _buildSubTitle(provider)]),
            const Spacer(),
            ..._buildActions(),
          ],
        ),
      );

  Widget _buildHeader(StreamAudioProvider provider) => Text(
        provider.contextualMessageTitle ?? 'Catch the latest',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontFamily: 'Golos Text',
          fontWeight: FontWeight.w600,
          height: 1.14,
        ),
      );

  Widget _buildSubTitle(StreamAudioProvider provider) => Text(
        provider.contextualMessageSubtitle ?? 'Tune into live radio',
        style: TextStyle(
          color: Colors.white.withOpacity(0.70),
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
      )
    ];
  }
}
