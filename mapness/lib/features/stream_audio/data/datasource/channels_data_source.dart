import 'package:balady_plus/app/core/dependency_injection/injection_container.dart';
import 'package:balady_plus/app/core/services/global/web_service.dart';
import 'package:balady_plus/app/core/utils/common_functions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:mapness/features/stream_audio/data/dto/channel_dto.dart';

class ChannelsDataSource {
  WebService webService = sl();

  Future<List<ChannelDTO>> getChannels() async {
    try {
      final isArabic = CommonFunctions.isAppAR;
      webService.dio.options.headers['Accept-Language'] = isArabic ? 'ar' : 'en';

      debugPrint('ChannelsDataSource: Requesting channels from API...');
      final response = await webService.dio.get(
        '/v1/mbc-services/channels',
        options: Options(
          sendTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
        ),
      );

      debugPrint('ChannelsDataSource: Received response with status: ${response.statusCode}');

      if (response.statusCode != 200) {
        throw Exception('Failed to load channels - Status: ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Received null response data');
      }

      final responseData = response.data as Map<String, dynamic>;
      if (!responseData.containsKey('data')) {
        throw Exception('Response missing data field');
      }

      final Map<String, dynamic> data = responseData['data'];
      if (!data.containsKey('result')) {
        throw Exception('Response data missing result field');
      }

      final List<dynamic> result = data['result'];
      final List<ChannelDTO> channels = [];

      debugPrint('ChannelsDataSource: Processing ${result.length} channels...');

      for (final channel in result) {
        try {
          channels.add(ChannelDTO.fromJson(channel));
        } catch (e) {
          debugPrint('ChannelsDataSource: Error parsing channel: $e');
          // Continue with other channels instead of failing completely
        }
      }

      debugPrint('ChannelsDataSource: Successfully parsed ${channels.length} channels');
      return channels;
    } catch (e) {
      debugPrint('ChannelsDataSource: Error fetching channels: $e');
      throw Exception('Error fetching channels: $e');
    }
  }
}
