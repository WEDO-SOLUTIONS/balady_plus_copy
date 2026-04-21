import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mapness/features/stream_audio/ui/providers/stream_audio_prov.dart';

/// Debug widget to show channel loading status
/// This can be used temporarily to verify that channels are loading automatically
class ChannelsDebugWidget extends ConsumerWidget {
  const ChannelsDebugWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.watch(streamAudioProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Channels Debug Info:',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('Loading: ${provider.isLoadingChannels}'),
          Text('Has Channels: ${provider.hasChannels}'),
          Text('Channels Count: ${provider.filteredChannels.length}'),
          Text('Selected Channel: ${provider.selectedChannel?.name ?? 'None'}'),
          Text('Provider Initialized: ${provider.isInitialized}'),
          const SizedBox(height: 8),
          if (provider.isLoadingChannels)
            const Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 8),
                Text('Loading channels...'),
              ],
            )
          else if (provider.hasChannels)
            Text(
              'Channels loaded successfully!',
              style: TextStyle(color: Colors.green.shade700),
            )
          else
            Text(
              'No channels available',
              style: TextStyle(color: Colors.red.shade700),
            ),
          if (provider.hasChannels) ...[
            const SizedBox(height: 8),
            const Text('Available Channels:', style: TextStyle(fontWeight: FontWeight.w600)),
            ...provider.filteredChannels.take(3).map(
                  (channel) => Padding(
                    padding: const EdgeInsets.only(left: 16, top: 4),
                    child: Text('• ${channel.name}'),
                  ),
                ),
            if (provider.filteredChannels.length > 3)
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 4),
                child: Text('... and ${provider.filteredChannels.length - 3} more'),
              ),
          ],
        ],
      ),
    );
  }
}
