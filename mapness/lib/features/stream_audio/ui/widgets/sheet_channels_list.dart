import 'package:balady_uikit/core/extensions/build_context_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/data/dto/filtered_channel.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';
import 'package:mapness/features/stream_audio/ui/stream_audio_colors.dart';
import 'package:mapness/features/stream_audio/ui/widgets/channel_item.dart';

class MediaCatalogList extends ConsumerWidget {
  final VoidCallback? needReset;
  final bool isLandscape;

  const MediaCatalogList({
    Key? key,
    this.needReset,
    this.isLandscape = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(streamAudioProvider);
    final theme = context.streamAudioColors;
    final channels = provider.filteredChannels;

    if (channels.isEmpty) {
      return Container(
        height: isLandscape ? null : 136,
        alignment: Alignment.center,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(theme.accent),
        ),
      );
    }

    if (isLandscape) {
      return _buildLandscapeList(channels, provider, ref);
    } else {
      return _buildPortraitList(channels, provider, ref);
    }
  }

  Widget _buildPortraitList(List<FilteredChannel> channels, StreamAudioProvider provider, WidgetRef ref) => Container(
    height: 180,
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: channels.length,
      itemBuilder: (context, index) {
        final channel = channels[index];
        final isSelected = provider.selectedChannel?.id == channel.id;

        return GestureDetector(
          onTap: () {
            if (!isSelected) {
              ref.read(streamAudioProvider).selectChannel(channel);
              needReset?.call();
            } else {
              print('Current Program Image:');
              print(channel.currentPlayedProgram?.image);
              print('Channel Logo:');
              print(channel.logo);
            }
          },
          child: MediaCatalogItem(channel: channel, isSelected: isSelected),
        );
      },
    ),
  );

  Widget _buildLandscapeList(List<FilteredChannel> channels, StreamAudioProvider provider, WidgetRef ref) =>
      ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: channels.length,
        itemBuilder: (context, index) {
          final channel = channels[index];
          final isSelected = provider.selectedChannel?.id == channel.id;

          return GestureDetector(
            onTap: () {
              if (!isSelected) {
                ref.read(streamAudioProvider).selectChannel(channel);
                needReset?.call();
              }
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: MediaCatalogItem(channel: channel, isSelected: isSelected),
            ),
          );
        },
      );
}
