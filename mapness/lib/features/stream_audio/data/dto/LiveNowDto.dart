import 'package:mapness/_generated/assets/assets.gen.dart';

class LiveNowDto {
  const LiveNowDto({
    required this.programs,
  });

  final List<ProgramDto> programs;

  /// [BookingsModel.fromJson] a factory constructor to convert json
  /// into LiveNowDto
  factory LiveNowDto.fromJson(Map<String, dynamic> json) {
    final programImages = [
      Assets.images.audioPlaceholders.hoda,
      Assets.images.audioPlaceholders.sweet,
      Assets.images.audioPlaceholders.non,
      Assets.images.audioPlaceholders.arabiya,
    ];
    final channelImage = [
      Assets.images.audioPlaceholders.panorama,
      Assets.images.audioPlaceholders.mbcFm,
      Assets.images.audioPlaceholders.mbcLoud,
      Assets.images.audioPlaceholders.arabiyaFm,
    ];
    final docs = (json['docs'] as List<dynamic>?)
            ?.whereType<Map<String, dynamic>>()
            .toList() ??
        [];

    final programs = List<ProgramDto>.generate(docs.length, (i) {
      final v = docs[i];
      final programImg = programImages[i % programImages.length];
      final channelImg = channelImage[i % channelImage.length];
      return ProgramDto.fromJson(v, programImg, channelImg);
    });
    return LiveNowDto(programs: programs);
  }

  /// [LiveNowDto.empty] Empty constructor
  factory LiveNowDto.empty() => const LiveNowDto(programs: []);
}

class ProgramDto {
  const ProgramDto({
    required this.title,
    required this.sub,
    required this.channelImage,
    required this.programImage,
  });

  final String title;
  final String sub;
  final AssetGenImage channelImage;
  final AssetGenImage programImage;

  /// [Program.fromJson] a factory constructor to convert json
  /// into object
  factory ProgramDto.fromJson(Map<String, dynamic> json,
      AssetGenImage programImage, AssetGenImage channelImage) {
    final title = json['title'] is String ? json['title'] as String : '';
    final sub = json['sub'] is String ? json['sub'] as String : '';
    // final channelImage =
    // json['channelImage'] is String ? json['channelImage'] as String : '';
    // final programImage =
    // json['programImage'] is String ? json['programImage'] as String : '';

    return ProgramDto(
      title: title,
      sub: sub,
      channelImage: channelImage,
      programImage: programImage,
    );
  }

  /// [Program.empty] Empty constructor
  factory ProgramDto.empty() => const ProgramDto(
        title: '',
        sub: '',
        channelImage: AssetGenImage(''),
        programImage: AssetGenImage(''),
      );
}
