import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:mapness/features/stream_audio/data/dto/channel_dto.dart';

class ChannelsDataSource {
  WebService webService = sl();

  Future<List<ChannelDTO>> getChannels() async {
    try {
      final isArabic = CommonFunctions.isAppAR;
      webService.dio.options.headers['Accept-Language'] = isArabic ? 'ar' : 'en';

      final response = await webService.dio.get('/v1/mbc-services/channels');

      if (response.statusCode != 200) {
        throw Exception('Failed to load channels');
      }

      final Map<String, dynamic> data = (response.data as Map<String, dynamic>)['data'];
      final List<dynamic> result = data['result'];
      final List<ChannelDTO> channels = [];

      for (final channel in result) {
        channels.add(ChannelDTO.fromJson(channel));
      }

      return channels;
    } catch (e) {
      throw Exception('Error fetching channels: $e');
    }
  }
}
