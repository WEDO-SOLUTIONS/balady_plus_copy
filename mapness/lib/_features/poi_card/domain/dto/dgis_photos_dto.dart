import 'package:json_annotation/json_annotation.dart';

part 'dgis_photos_dto.g.dart';

@JsonSerializable()
class DgisPhotosDto {
  DgisPhotosDto({required this.albums, required this.items});

  factory DgisPhotosDto.fromJson(Map<String, dynamic> json) => _$DgisPhotosDtoFromJson(json);
  List<Album> albums;
  List<Item> items;

  Map<String, dynamic> toJson() => _$DgisPhotosDtoToJson(this);
}

@JsonSerializable()
class Item {
  Item({
    required this.id,
    required this.url,
    required this.height,
    required this.width,
    required this.previewUrls,
    required this.isPinned,
    this.realObjectType,
    // this.creationTime,
    // this.modificationTime,
    // this.copyright,
    // this.owner,
  });

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
  String id;
  String url;
  String? realObjectType;
  int height;
  int width;
  PreviewUrls? previewUrls;
  // Copyright? copyright;
  // Owner? owner;
  // String? creationTime;
  // String? modificationTime;
  @JsonKey(defaultValue: false)
  bool isPinned;

  Map<String, dynamic> toJson() => _$ItemToJson(this);
}

@JsonSerializable()
class PreviewUrls {
  @JsonKey(name: '100x100')
  final String? small;

  @JsonKey(name: '100x')
  final String? smallByWidth;

  @JsonKey(name: 'x100')
  final String? smallByHeight;

  PreviewUrls({
    this.small,
    this.smallByWidth,
    this.smallByHeight,
  });

  factory PreviewUrls.fromJson(Map<String, dynamic> json) => _$PreviewUrlsFromJson(json);

  Map<String, dynamic> toJson() => _$PreviewUrlsToJson(this);
}

@JsonSerializable()
class Copyright {
  Copyright({
    required this.type,
    required this.value,
    required this.code,
    required this.icon,
    required this.title,
    this.url,
    this.providerIcon,
  });

  factory Copyright.fromJson(Map<String, dynamic> json) => _$CopyrightFromJson(json);
  String type;
  String value;
  String? url;
  String? providerIcon;
  String code;
  String icon;
  String title;

  Map<String, dynamic> toJson() => _$CopyrightToJson(this);
}

@JsonSerializable()
class Owner {
  Owner({
    required this.id,
    required this.publicId,
    required this.name,
    required this.avatar,
  });

  factory Owner.fromJson(Map<String, dynamic> json) => _$OwnerFromJson(json);
  String id;
  String publicId;
  String name;
  String avatar;

  Map<String, dynamic> toJson() => _$OwnerToJson(this);
}

@JsonSerializable()
class Album {
  Album({required this.id, required this.name, required this.count});

  factory Album.fromJson(Map<String, dynamic> json) => _$AlbumFromJson(json);
  String id;
  String name;
  int count;

  Map<String, dynamic> toJson() => _$AlbumToJson(this);
}
