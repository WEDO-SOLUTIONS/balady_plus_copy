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
    super.channelBanners,
    super.channelOrder,
    super.programs,
    super.streamUrl,
  });

  factory FilteredChannel.fromDTO(ChannelDTO dto) => FilteredChannel(
    id: dto.id,
    name: dto.name,
    logo: dto.logo,
    webLogo: dto.webLogo,
    maximizedLogo: dto.maximizedLogo,
    minimizedLogo: dto.minimizedLogo,
    circledLogo: dto.circledLogo,
    channelBanners: dto.channelBanners,
    channelOrder: dto.channelOrder,
    programs: dto.programs,
    streamUrl: dto.streamUrl,
  );

  Program? get currentPlayedProgram {
    final now = DateTime.now();
    for (final Program program in programs ?? []) {
      // Use separate start_time and end_time fields
      final rangeDate = _parseTimeRange(program.startTime ?? '', program.endTime ?? '');
      final startTime = rangeDate.$1;
      final endTime = rangeDate.$2;

      if (startTime != null && endTime != null) {
        if ((now == startTime || now == endTime) || now.isAfter(startTime) && now.isBefore(endTime)) {
          return program;
        }
      }
    }
    return null;
  }

  /// Parses separate start and end time strings into DateTime objects.
  ///
  /// Accepts time formats like:
  /// - "6:00 AM" or "6:00AM"
  /// - "10:00 PM" or "10:00PM"
  ///
  /// Returns a tuple of (startDateTime, endDateTime) or (null, null) if parsing fails.
  (DateTime?, DateTime?) _parseTimeRange(String startTime, String endTime) {
    // Get current date
    final now = DateTime.now();

    // Parse start and end times
    final startDate = _parseTime(startTime.trim(), now);
    final endDate = _parseTime(endTime.trim(), now);

    return (startDate, endDate);
  }

  /// Parses a single time string into a DateTime object.
  ///
  /// Handles both "6:00 AM" and "6:00AM" formats automatically.
  /// Converts 12-hour format to 24-hour format for DateTime creation.
  DateTime? _parseTime(String time, DateTime baseDate) {
    // Normalize the time string by handling space variations
    String normalizedTime = time.trim();

    // Handle cases where there's no space between time and AM/PM
    // Convert "6:00AM" to "6:00 AM" and "6:00PM" to "6:00 PM"
    if (normalizedTime.toUpperCase().endsWith('AM') && !normalizedTime.toUpperCase().endsWith(' AM')) {
      normalizedTime = '${normalizedTime.substring(0, normalizedTime.length - 2)} AM';
    } else if (normalizedTime.toUpperCase().endsWith('PM') && !normalizedTime.toUpperCase().endsWith(' PM')) {
      normalizedTime = '${normalizedTime.substring(0, normalizedTime.length - 2)} PM';
    }

    final isPM = normalizedTime.toUpperCase().endsWith('PM');
    final isAM = normalizedTime.toUpperCase().endsWith('AM');

    if (!isPM && !isAM) {
      // 'Time must end with AM or PM'
      return null;
    }

    // Remove AM/PM and split by ":"
    final timeWithoutPeriod = normalizedTime.substring(0, normalizedTime.length - 3).trim();
    final timeParts = timeWithoutPeriod.split(':');

    if (timeParts.length != 2) {
      // Invalid time format. Expected HH:MM'
      return null;
    }

    try {
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
    } catch (e) {
      // Handle parsing errors
      return null;
    }
  }
}
