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
                'programImage':
                    'https://assets.mbcmood.com/programs_thumbnails/1714173058هدى-وهن-00.jpg',
                'streamUrl': 'https://securestreams2.autopo.st:1241/live',
              },
              {
                'title': 'MBC FM',
                'sub': 'Sweet talk',
                'channelImage': 'assets/images/audio_placeholders/mbc_fm.png',
                'programImage':
                    'https://assets.mbcmood.com/programs_thumbnails/1745311050%D8%AD%D9%84%D9%88%20%D8%A7%D9%84%D9%83%D9%84%D8%A7%D9%85%20%D8%A7%D8%AE%D9%8A%D8%B1%20.jpg',
                'streamUrl': 'https://radiouno.stream24.net/live.mp3',
              },
              {
                'title': 'MBC Loud',
                'sub': 'Non-Stop Hits with Jay R',
                'channelImage': 'assets/images/audio_placeholders/mbc_loud.png',
                'programImage': 'assets/images/audio_placeholders/non.png',
                'streamUrl':
                    'https://azuralive.streams.ovh/radio/8160/radio.mp3',
              },
              {
                'title': 'Al Arabiya FM',
                'sub': 'Noon program',
                'channelImage':
                    'assets/images/audio_placeholders/arabiya_fm.png',
                'programImage': 'assets/images/audio_placeholders/arabiya.png',
                'streamUrl': 'https://a2.asurahosting.com:6460/radio.mp3',
              }
            ],
          }));
}
