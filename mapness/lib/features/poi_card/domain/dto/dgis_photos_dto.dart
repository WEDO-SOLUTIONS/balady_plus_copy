import 'package:json_annotation/json_annotation.dart';

part 'dgis_photos_dto.g.dart';

@JsonSerializable()
class DgisPhotosDto {
  List<Album> albums;
  List<Item> items;

  DgisPhotosDto({required this.albums, required this.items});

  factory DgisPhotosDto.fromJson(Map<String, dynamic> json) => _$DgisPhotosDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DgisPhotosDtoToJson(this);
}

@JsonSerializable()
class Item {
  String id;
  String url;
  String? realObjectType;
  int height;
  int width;
  @JsonKey(name: 'preview_urls')
  PreviewUrls? previewUrls;

  @JsonKey(defaultValue: false)
  bool isPinned;

  Item({
    required this.id,
    required this.url,
    required this.height,
    required this.width,
    required this.previewUrls,
    required this.isPinned,
    this.realObjectType,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class PreviewUrls {
  @JsonKey(name: '600x')
  final String? mediumByWidth;

  PreviewUrls({
    this.mediumByWidth,
  });

  factory PreviewUrls.fromJson(Map<String, dynamic> json) => _$PreviewUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$PreviewUrlsToJson(this);
}

@JsonSerializable()
class Owner {
  String id;
  String publicId;
  String name;
  String avatar;

  Owner({
    required this.id,
    required this.publicId,
    required this.name,
    required this.avatar,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);

  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}

@JsonSerializable()
class Album {
  String id;
  String name;
  int count;

  Album({required this.id, required this.name, required this.count});

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
