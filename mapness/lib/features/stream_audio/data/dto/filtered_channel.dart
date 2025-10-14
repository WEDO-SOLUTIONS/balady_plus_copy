
import 'package:mapness/features/stream_audio/data/dto/channel_dto.dart';

class FilteredChannel extends ChannelDTO {

  FilteredChannel({
    super.id,
    super.name,
    super.logo,
    super.webLogo,
    super.maximizedLogo,
    super.minimizedLogo,
    super.circledLogo,
    super.audioUrl,
    super.channelBanners,
    super.channelOrder,
    super.programs,
  });

    factory FilteredChannel.fromDTO(ChannelDTO dto) => FilteredChannel(
      id: dto.id,
      name: dto.name,
      logo: dto.logo,
      webLogo: dto.webLogo,
      maximizedLogo: dto.maximizedLogo,
      minimizedLogo: dto.minimizedLogo,
      circledLogo: dto.circledLogo,
      audioUrl: dto.audioUrl,
      channelBanners: dto.channelBanners,
      channelOrder: dto.channelOrder,
      programs: dto.programs,
    );

  Program? get currentPlayedProgram {
    final now = DateTime.now();
    for(final Program program in programs ?? []){
      // Example date format: "10:00AM - 11:00AM"
      final rangeDate = _parseTimeRange(program.date ?? '');
      final startTime = rangeDate.$1;
      final endTime = rangeDate.$2;

      if(startTime != null && endTime != null){
        if((now == startTime || now == endTime) || now.isAfter(startTime) && now.isBefore(endTime)){
          return program;
        }
      }
    }
    return null;
  }

  (DateTime?, DateTime?) _parseTimeRange(String timeRange) {
    // Split the string by " - "
    final parts = timeRange.split(' - ');

    if (parts.length != 2) {
      // 'Invalid time range format. Expected "HH:MMAM - HH:MMAM"'
      return (null, null);
    }

    final startTime = parts[0].trim();
    final endTime = parts[1].trim();

    // Get current date
    final now = DateTime.now();

    // Parse start and end times
    final startDate = _parseTime(startTime, now);
    final endDate = _parseTime(endTime, now);

    return (startDate,endDate);
  }

  DateTime? _parseTime(String time, DateTime baseDate) {
    // Extract AM/PM
    final isPM = time.toUpperCase().endsWith('PM');
    final isAM = time.toUpperCase().endsWith('AM');

    if (!isPM && !isAM) {
      // 'Time must end with AM or PM'
      return null;
    }

    // Remove AM/PM and split by ":"
    final timeWithoutPeriod = time.substring(0, time.length - 2);
    final timeParts = timeWithoutPeriod.split(':');

    if (timeParts.length != 2) {
      // Invalid time format. Expected HH:MM'
      return null;
    }

    int hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);

    // Convert to 24-hour format
    if (isPM && hour != 12) {
      hour += 12;
    } else if (isAM && hour == 12) {
      hour = 0;
    }

    return DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      hour,
      minute,
    );
  }



}