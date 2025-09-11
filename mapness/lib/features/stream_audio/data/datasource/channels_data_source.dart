import 'package:mapness/features/stream_audio/data/dto/LiveNowDto.dart';

class ChannelsDataSource {
  Future<LiveNowDto> getLiveNow() async => Future.delayed(
      const Duration(seconds: 1),
      () => LiveNowDto.fromJson({
            'docs': [
              {
                'title': 'Panorama FM',
                'sub': 'Hoda and Han',
                'channelImage': 'assets/images/audio_placeholders/panorama.png',
                'programImage': 'assets/images/audio_placeholders/hoda.png',
              },
              {
                'title': 'MBC FM',
                'sub': 'Sweet talk',
                'channelImage': 'assets/images/audio_placeholders/mbc_fm.png',
                'programImage': 'assets/images/audio_placeholders/sweet.png',
              },
              {
                'title': 'MBC Loud',
                'sub': 'Non-Stop Hits with Jay R',
                'channelImage': 'assets/images/audio_placeholders/mbc_loud.png',
                'programImage': 'assets/images/audio_placeholders/non.png',
              },
              {
                'title': 'Al Arabiya FM',
                'sub': 'Noon program',
                'channelImage':
                    'assets/images/audio_placeholders/arabiya_fm.png',
                'programImage': 'assets/images/audio_placeholders/arabiya.png',
              }
            ],
          }));
}
