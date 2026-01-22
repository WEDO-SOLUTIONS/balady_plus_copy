// This is a generated file - do not edit.
//
// Generated from protocol.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'protocol.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'protocol.pbenum.dart';

class Timestamp extends $pb.GeneratedMessage {
  factory Timestamp({
    $fixnum.Int64? value,
  }) {
    final result = create();
    if (value != null) result.value = value;
    return result;
  }

  Timestamp._();

  factory Timestamp.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Timestamp.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Timestamp',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Timestamp clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Timestamp copyWith(void Function(Timestamp) updates) =>
      super.copyWith((message) => updates(message as Timestamp)) as Timestamp;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Timestamp create() => Timestamp._();
  @$core.override
  Timestamp createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Timestamp getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Timestamp>(create);
  static Timestamp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get value => $_getI64(0);
  @$pb.TagNumber(1)
  set value($fixnum.Int64 value) => $_setInt64(0, value);
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => $_clearField(1);
}

class Image extends $pb.GeneratedMessage {
  factory Image({
    $core.String? url,
  }) {
    final result = create();
    if (url != null) result.url = url;
    return result;
  }

  Image._();

  factory Image.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Image.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Image',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Image clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Image copyWith(void Function(Image) updates) =>
      super.copyWith((message) => updates(message as Image)) as Image;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Image create() => Image._();
  @$core.override
  Image createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Image getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Image>(create);
  static Image? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);
}

class Point extends $pb.GeneratedMessage {
  factory Point({
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final result = create();
    if (latitude != null) result.latitude = latitude;
    if (longitude != null) result.longitude = longitude;
    return result;
  }

  Point._();

  factory Point.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Point.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Point',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aD(1, _omitFieldNames ? '' : 'latitude')
    ..aD(2, _omitFieldNames ? '' : 'longitude')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Point clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Point copyWith(void Function(Point) updates) =>
      super.copyWith((message) => updates(message as Point)) as Point;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point create() => Point._();
  @$core.override
  Point createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Point getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Point>(create);
  static Point? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double value) => $_setDouble(0, value);
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double value) => $_setDouble(1, value);
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => $_clearField(2);
}

class Color extends $pb.GeneratedMessage {
  factory Color({
    $core.String? hex,
  }) {
    final result = create();
    if (hex != null) result.hex = hex;
    return result;
  }

  Color._();

  factory Color.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Color.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Color',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'hex')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Color clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Color copyWith(void Function(Color) updates) =>
      super.copyWith((message) => updates(message as Color)) as Color;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Color create() => Color._();
  @$core.override
  Color createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Color getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Color>(create);
  static Color? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get hex => $_getSZ(0);
  @$pb.TagNumber(1)
  set hex($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasHex() => $_has(0);
  @$pb.TagNumber(1)
  void clearHex() => $_clearField(1);
}

class TextStyle extends $pb.GeneratedMessage {
  factory TextStyle({
    Color? color,
  }) {
    final result = create();
    if (color != null) result.color = color;
    return result;
  }

  TextStyle._();

  factory TextStyle.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TextStyle.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TextStyle',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Color>(1, _omitFieldNames ? '' : 'color', subBuilder: Color.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextStyle clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TextStyle copyWith(void Function(TextStyle) updates) =>
      super.copyWith((message) => updates(message as TextStyle)) as TextStyle;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TextStyle create() => TextStyle._();
  @$core.override
  TextStyle createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TextStyle getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<TextStyle>(create);
  static TextStyle? _defaultInstance;

  @$pb.TagNumber(1)
  Color get color => $_getN(0);
  @$pb.TagNumber(1)
  set color(Color value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearColor() => $_clearField(1);
  @$pb.TagNumber(1)
  Color ensureColor() => $_ensure(0);
}

class ErrorResponse_ErrorMessage extends $pb.GeneratedMessage {
  factory ErrorResponse_ErrorMessage({
    Error? type,
    $core.int? intCode,
    $core.String? message,
    $core.String? systemMessage,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (intCode != null) result.intCode = intCode;
    if (message != null) result.message = message;
    if (systemMessage != null) result.systemMessage = systemMessage;
    return result;
  }

  ErrorResponse_ErrorMessage._();

  factory ErrorResponse_ErrorMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ErrorResponse_ErrorMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorResponse.ErrorMessage',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aE<Error>(1, _omitFieldNames ? '' : 'type', enumValues: Error.values)
    ..aI(2, _omitFieldNames ? '' : 'intCode')
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aOS(4, _omitFieldNames ? '' : 'systemMessage')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResponse_ErrorMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResponse_ErrorMessage copyWith(
          void Function(ErrorResponse_ErrorMessage) updates) =>
      super.copyWith(
              (message) => updates(message as ErrorResponse_ErrorMessage))
          as ErrorResponse_ErrorMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorResponse_ErrorMessage create() => ErrorResponse_ErrorMessage._();
  @$core.override
  ErrorResponse_ErrorMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ErrorResponse_ErrorMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorResponse_ErrorMessage>(create);
  static ErrorResponse_ErrorMessage? _defaultInstance;

  @$pb.TagNumber(1)
  Error get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(Error value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get intCode => $_getIZ(1);
  @$pb.TagNumber(2)
  set intCode($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIntCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntCode() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get systemMessage => $_getSZ(3);
  @$pb.TagNumber(4)
  set systemMessage($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSystemMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearSystemMessage() => $_clearField(4);
}

/// Base requests & responses
class ErrorResponse extends $pb.GeneratedMessage {
  factory ErrorResponse({
    ErrorResponse_ErrorMessage? error,
  }) {
    final result = create();
    if (error != null) result.error = error;
    return result;
  }

  ErrorResponse._();

  factory ErrorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ErrorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ErrorResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<ErrorResponse_ErrorMessage>(2, _omitFieldNames ? '' : 'error',
        subBuilder: ErrorResponse_ErrorMessage.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ErrorResponse copyWith(void Function(ErrorResponse) updates) =>
      super.copyWith((message) => updates(message as ErrorResponse))
          as ErrorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorResponse create() => ErrorResponse._();
  @$core.override
  ErrorResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ErrorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ErrorResponse>(create);
  static ErrorResponse? _defaultInstance;

  @$pb.TagNumber(2)
  ErrorResponse_ErrorMessage get error => $_getN(0);
  @$pb.TagNumber(2)
  set error(ErrorResponse_ErrorMessage value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(2)
  void clearError() => $_clearField(2);
  @$pb.TagNumber(2)
  ErrorResponse_ErrorMessage ensureError() => $_ensure(0);
}

class OkResponse extends $pb.GeneratedMessage {
  factory OkResponse({
    $core.int? code,
  }) {
    final result = create();
    if (code != null) result.code = code;
    return result;
  }

  OkResponse._();

  factory OkResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory OkResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'OkResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aI(2, _omitFieldNames ? '' : 'code')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OkResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  OkResponse copyWith(void Function(OkResponse) updates) =>
      super.copyWith((message) => updates(message as OkResponse)) as OkResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OkResponse create() => OkResponse._();
  @$core.override
  OkResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static OkResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<OkResponse>(create);
  static OkResponse? _defaultInstance;

  @$pb.TagNumber(2)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(2)
  set code($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(2)
  void clearCode() => $_clearField(2);
}

class Story_Preview extends $pb.GeneratedMessage {
  factory Story_Preview({
    Image? image,
    $core.String? title,
  }) {
    final result = create();
    if (image != null) result.image = image;
    if (title != null) result.title = title;
    return result;
  }

  Story_Preview._();

  factory Story_Preview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Story_Preview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Story.Preview',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Image>(1, _omitFieldNames ? '' : 'image', subBuilder: Image.create)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Preview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Preview copyWith(void Function(Story_Preview) updates) =>
      super.copyWith((message) => updates(message as Story_Preview))
          as Story_Preview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Preview create() => Story_Preview._();
  @$core.override
  Story_Preview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Story_Preview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Story_Preview>(create);
  static Story_Preview? _defaultInstance;

  @$pb.TagNumber(1)
  Image get image => $_getN(0);
  @$pb.TagNumber(1)
  set image(Image value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage() => $_clearField(1);
  @$pb.TagNumber(1)
  Image ensureImage() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);
}

class Story_Video extends $pb.GeneratedMessage {
  factory Story_Video({
    $core.String? url,
    $core.String? resolution,
  }) {
    final result = create();
    if (url != null) result.url = url;
    if (resolution != null) result.resolution = resolution;
    return result;
  }

  Story_Video._();

  factory Story_Video.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Story_Video.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Story.Video',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..aOS(2, _omitFieldNames ? '' : 'resolution')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Video clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Video copyWith(void Function(Story_Video) updates) =>
      super.copyWith((message) => updates(message as Story_Video))
          as Story_Video;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Video create() => Story_Video._();
  @$core.override
  Story_Video createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Story_Video getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Story_Video>(create);
  static Story_Video? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get resolution => $_getSZ(1);
  @$pb.TagNumber(2)
  set resolution($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasResolution() => $_has(1);
  @$pb.TagNumber(2)
  void clearResolution() => $_clearField(2);
}

class Story_Frame_Content extends $pb.GeneratedMessage {
  factory Story_Frame_Content({
    $core.Iterable<Image>? images,
  }) {
    final result = create();
    if (images != null) result.images.addAll(images);
    return result;
  }

  Story_Frame_Content._();

  factory Story_Frame_Content.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Story_Frame_Content.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Story.Frame.Content',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..pPM<Image>(1, _omitFieldNames ? '' : 'images', subBuilder: Image.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_Content clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_Content copyWith(void Function(Story_Frame_Content) updates) =>
      super.copyWith((message) => updates(message as Story_Frame_Content))
          as Story_Frame_Content;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_Content create() => Story_Frame_Content._();
  @$core.override
  Story_Frame_Content createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_Content getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Story_Frame_Content>(create);
  static Story_Frame_Content? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Image> get images => $_getList(0);
}

class Story_Frame_Style extends $pb.GeneratedMessage {
  factory Story_Frame_Style({
    TextStyle? title,
    TextStyle? description,
    TextStyle? backgroundColor,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (backgroundColor != null) result.backgroundColor = backgroundColor;
    return result;
  }

  Story_Frame_Style._();

  factory Story_Frame_Style.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Story_Frame_Style.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Story.Frame.Style',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<TextStyle>(1, _omitFieldNames ? '' : 'title',
        subBuilder: TextStyle.create)
    ..aOM<TextStyle>(2, _omitFieldNames ? '' : 'description',
        subBuilder: TextStyle.create)
    ..aOM<TextStyle>(3, _omitFieldNames ? '' : 'backgroundColor',
        subBuilder: TextStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_Style clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_Style copyWith(void Function(Story_Frame_Style) updates) =>
      super.copyWith((message) => updates(message as Story_Frame_Style))
          as Story_Frame_Style;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_Style create() => Story_Frame_Style._();
  @$core.override
  Story_Frame_Style createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_Style getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Story_Frame_Style>(create);
  static Story_Frame_Style? _defaultInstance;

  @$pb.TagNumber(1)
  TextStyle get title => $_getN(0);
  @$pb.TagNumber(1)
  set title(TextStyle value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);
  @$pb.TagNumber(1)
  TextStyle ensureTitle() => $_ensure(0);

  @$pb.TagNumber(2)
  TextStyle get description => $_getN(1);
  @$pb.TagNumber(2)
  set description(TextStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasDescription() => $_has(1);
  @$pb.TagNumber(2)
  void clearDescription() => $_clearField(2);
  @$pb.TagNumber(2)
  TextStyle ensureDescription() => $_ensure(1);

  @$pb.TagNumber(3)
  TextStyle get backgroundColor => $_getN(2);
  @$pb.TagNumber(3)
  set backgroundColor(TextStyle value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasBackgroundColor() => $_has(2);
  @$pb.TagNumber(3)
  void clearBackgroundColor() => $_clearField(3);
  @$pb.TagNumber(3)
  TextStyle ensureBackgroundColor() => $_ensure(2);
}

class Story_Frame_ActionButton_Link extends $pb.GeneratedMessage {
  factory Story_Frame_ActionButton_Link({
    $core.String? url,
  }) {
    final result = create();
    if (url != null) result.url = url;
    return result;
  }

  Story_Frame_ActionButton_Link._();

  factory Story_Frame_ActionButton_Link.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Story_Frame_ActionButton_Link.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Story.Frame.ActionButton.Link',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_ActionButton_Link clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_ActionButton_Link copyWith(
          void Function(Story_Frame_ActionButton_Link) updates) =>
      super.copyWith(
              (message) => updates(message as Story_Frame_ActionButton_Link))
          as Story_Frame_ActionButton_Link;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_Link create() =>
      Story_Frame_ActionButton_Link._();
  @$core.override
  Story_Frame_ActionButton_Link createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_Link getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Story_Frame_ActionButton_Link>(create);
  static Story_Frame_ActionButton_Link? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => $_clearField(1);
}

class Story_Frame_ActionButton_Style extends $pb.GeneratedMessage {
  factory Story_Frame_ActionButton_Style({
    Color? backgroundColor,
    TextStyle? textStyle,
  }) {
    final result = create();
    if (backgroundColor != null) result.backgroundColor = backgroundColor;
    if (textStyle != null) result.textStyle = textStyle;
    return result;
  }

  Story_Frame_ActionButton_Style._();

  factory Story_Frame_ActionButton_Style.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Story_Frame_ActionButton_Style.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Story.Frame.ActionButton.Style',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Color>(1, _omitFieldNames ? '' : 'backgroundColor',
        subBuilder: Color.create)
    ..aOM<TextStyle>(2, _omitFieldNames ? '' : 'textStyle',
        subBuilder: TextStyle.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_ActionButton_Style clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_ActionButton_Style copyWith(
          void Function(Story_Frame_ActionButton_Style) updates) =>
      super.copyWith(
              (message) => updates(message as Story_Frame_ActionButton_Style))
          as Story_Frame_ActionButton_Style;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_Style create() =>
      Story_Frame_ActionButton_Style._();
  @$core.override
  Story_Frame_ActionButton_Style createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_Style getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Story_Frame_ActionButton_Style>(create);
  static Story_Frame_ActionButton_Style? _defaultInstance;

  @$pb.TagNumber(1)
  Color get backgroundColor => $_getN(0);
  @$pb.TagNumber(1)
  set backgroundColor(Color value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBackgroundColor() => $_has(0);
  @$pb.TagNumber(1)
  void clearBackgroundColor() => $_clearField(1);
  @$pb.TagNumber(1)
  Color ensureBackgroundColor() => $_ensure(0);

  @$pb.TagNumber(2)
  TextStyle get textStyle => $_getN(1);
  @$pb.TagNumber(2)
  set textStyle(TextStyle value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasTextStyle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTextStyle() => $_clearField(2);
  @$pb.TagNumber(2)
  TextStyle ensureTextStyle() => $_ensure(1);
}

class Story_Frame_ActionButton extends $pb.GeneratedMessage {
  factory Story_Frame_ActionButton({
    $core.String? title,
    Story_Frame_ActionButton_Link? link,
    Story_Frame_ActionButton_Style? style,
    $core.bool? isEnabled,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (link != null) result.link = link;
    if (style != null) result.style = style;
    if (isEnabled != null) result.isEnabled = isEnabled;
    return result;
  }

  Story_Frame_ActionButton._();

  factory Story_Frame_ActionButton.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Story_Frame_ActionButton.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Story.Frame.ActionButton',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOM<Story_Frame_ActionButton_Link>(2, _omitFieldNames ? '' : 'link',
        subBuilder: Story_Frame_ActionButton_Link.create)
    ..aOM<Story_Frame_ActionButton_Style>(3, _omitFieldNames ? '' : 'style',
        subBuilder: Story_Frame_ActionButton_Style.create)
    ..aOB(4, _omitFieldNames ? '' : 'isEnabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_ActionButton clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame_ActionButton copyWith(
          void Function(Story_Frame_ActionButton) updates) =>
      super.copyWith((message) => updates(message as Story_Frame_ActionButton))
          as Story_Frame_ActionButton;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton create() => Story_Frame_ActionButton._();
  @$core.override
  Story_Frame_ActionButton createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Story_Frame_ActionButton>(create);
  static Story_Frame_ActionButton? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  Story_Frame_ActionButton_Link get link => $_getN(1);
  @$pb.TagNumber(2)
  set link(Story_Frame_ActionButton_Link value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasLink() => $_has(1);
  @$pb.TagNumber(2)
  void clearLink() => $_clearField(2);
  @$pb.TagNumber(2)
  Story_Frame_ActionButton_Link ensureLink() => $_ensure(1);

  @$pb.TagNumber(3)
  Story_Frame_ActionButton_Style get style => $_getN(2);
  @$pb.TagNumber(3)
  set style(Story_Frame_ActionButton_Style value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasStyle() => $_has(2);
  @$pb.TagNumber(3)
  void clearStyle() => $_clearField(3);
  @$pb.TagNumber(3)
  Story_Frame_ActionButton_Style ensureStyle() => $_ensure(2);

  @$pb.TagNumber(4)
  $core.bool get isEnabled => $_getBF(3);
  @$pb.TagNumber(4)
  set isEnabled($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsEnabled() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsEnabled() => $_clearField(4);
}

class Story_Frame extends $pb.GeneratedMessage {
  factory Story_Frame({
    Image? background,
    $core.String? title,
    $core.String? description,
    Story_Frame_ActionButton? actionButton,
    $core.bool? isViewed,
    $core.int? duration,
    Story_Frame_Style? style,
    Story_Frame_Content? content,
  }) {
    final result = create();
    if (background != null) result.background = background;
    if (title != null) result.title = title;
    if (description != null) result.description = description;
    if (actionButton != null) result.actionButton = actionButton;
    if (isViewed != null) result.isViewed = isViewed;
    if (duration != null) result.duration = duration;
    if (style != null) result.style = style;
    if (content != null) result.content = content;
    return result;
  }

  Story_Frame._();

  factory Story_Frame.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Story_Frame.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Story.Frame',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Image>(1, _omitFieldNames ? '' : 'background',
        subBuilder: Image.create)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOM<Story_Frame_ActionButton>(4, _omitFieldNames ? '' : 'actionButton',
        subBuilder: Story_Frame_ActionButton.create)
    ..aOB(5, _omitFieldNames ? '' : 'isViewed')
    ..aI(6, _omitFieldNames ? '' : 'duration')
    ..aOM<Story_Frame_Style>(7, _omitFieldNames ? '' : 'style',
        subBuilder: Story_Frame_Style.create)
    ..aOM<Story_Frame_Content>(8, _omitFieldNames ? '' : 'content',
        subBuilder: Story_Frame_Content.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story_Frame copyWith(void Function(Story_Frame) updates) =>
      super.copyWith((message) => updates(message as Story_Frame))
          as Story_Frame;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame create() => Story_Frame._();
  @$core.override
  Story_Frame createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Story_Frame getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Story_Frame>(create);
  static Story_Frame? _defaultInstance;

  @$pb.TagNumber(1)
  Image get background => $_getN(0);
  @$pb.TagNumber(1)
  set background(Image value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasBackground() => $_has(0);
  @$pb.TagNumber(1)
  void clearBackground() => $_clearField(1);
  @$pb.TagNumber(1)
  Image ensureBackground() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => $_clearField(3);

  @$pb.TagNumber(4)
  Story_Frame_ActionButton get actionButton => $_getN(3);
  @$pb.TagNumber(4)
  set actionButton(Story_Frame_ActionButton value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasActionButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearActionButton() => $_clearField(4);
  @$pb.TagNumber(4)
  Story_Frame_ActionButton ensureActionButton() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get isViewed => $_getBF(4);
  @$pb.TagNumber(5)
  set isViewed($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasIsViewed() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsViewed() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.int get duration => $_getIZ(5);
  @$pb.TagNumber(6)
  set duration($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDuration() => $_has(5);
  @$pb.TagNumber(6)
  void clearDuration() => $_clearField(6);

  @$pb.TagNumber(7)
  Story_Frame_Style get style => $_getN(6);
  @$pb.TagNumber(7)
  set style(Story_Frame_Style value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasStyle() => $_has(6);
  @$pb.TagNumber(7)
  void clearStyle() => $_clearField(7);
  @$pb.TagNumber(7)
  Story_Frame_Style ensureStyle() => $_ensure(6);

  @$pb.TagNumber(8)
  Story_Frame_Content get content => $_getN(7);
  @$pb.TagNumber(8)
  set content(Story_Frame_Content value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasContent() => $_has(7);
  @$pb.TagNumber(8)
  void clearContent() => $_clearField(8);
  @$pb.TagNumber(8)
  Story_Frame_Content ensureContent() => $_ensure(7);
}

class Story extends $pb.GeneratedMessage {
  factory Story({
    $core.String? id,
    Story_Preview? preview,
    $core.Iterable<Story_Frame>? frames,
    $core.bool? isViewed,
    $core.int? activateEveryNLaunches,
    $core.Iterable<Story_Video>? videos,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (preview != null) result.preview = preview;
    if (frames != null) result.frames.addAll(frames);
    if (isViewed != null) result.isViewed = isViewed;
    if (activateEveryNLaunches != null)
      result.activateEveryNLaunches = activateEveryNLaunches;
    if (videos != null) result.videos.addAll(videos);
    return result;
  }

  Story._();

  factory Story.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Story.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Story',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Story_Preview>(2, _omitFieldNames ? '' : 'preview',
        subBuilder: Story_Preview.create)
    ..pPM<Story_Frame>(3, _omitFieldNames ? '' : 'frames',
        subBuilder: Story_Frame.create)
    ..aOB(4, _omitFieldNames ? '' : 'isViewed')
    ..aI(5, _omitFieldNames ? '' : 'activateEveryNLaunches')
    ..pPM<Story_Video>(6, _omitFieldNames ? '' : 'videos',
        subBuilder: Story_Video.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Story copyWith(void Function(Story) updates) =>
      super.copyWith((message) => updates(message as Story)) as Story;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story create() => Story._();
  @$core.override
  Story createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Story getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Story>(create);
  static Story? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  Story_Preview get preview => $_getN(1);
  @$pb.TagNumber(2)
  set preview(Story_Preview value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPreview() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreview() => $_clearField(2);
  @$pb.TagNumber(2)
  Story_Preview ensurePreview() => $_ensure(1);

  @$pb.TagNumber(3)
  $pb.PbList<Story_Frame> get frames => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get isViewed => $_getBF(3);
  @$pb.TagNumber(4)
  set isViewed($core.bool value) => $_setBool(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIsViewed() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsViewed() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.int get activateEveryNLaunches => $_getIZ(4);
  @$pb.TagNumber(5)
  set activateEveryNLaunches($core.int value) => $_setSignedInt32(4, value);
  @$pb.TagNumber(5)
  $core.bool hasActivateEveryNLaunches() => $_has(4);
  @$pb.TagNumber(5)
  void clearActivateEveryNLaunches() => $_clearField(5);

  @$pb.TagNumber(6)
  $pb.PbList<Story_Video> get videos => $_getList(5);
}

class StoriesResponse extends $pb.GeneratedMessage {
  factory StoriesResponse({
    $core.Iterable<Story>? stories,
  }) {
    final result = create();
    if (stories != null) result.stories.addAll(stories);
    return result;
  }

  StoriesResponse._();

  factory StoriesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StoriesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StoriesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..pPM<Story>(2, _omitFieldNames ? '' : 'stories', subBuilder: Story.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoriesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StoriesResponse copyWith(void Function(StoriesResponse) updates) =>
      super.copyWith((message) => updates(message as StoriesResponse))
          as StoriesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StoriesResponse create() => StoriesResponse._();
  @$core.override
  StoriesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StoriesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StoriesResponse>(create);
  static StoriesResponse? _defaultInstance;

  @$pb.TagNumber(2)
  $pb.PbList<Story> get stories => $_getList(0);
}

class HappinessRequest_Tag extends $pb.GeneratedMessage {
  factory HappinessRequest_Tag({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  HappinessRequest_Tag._();

  factory HappinessRequest_Tag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HappinessRequest_Tag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HappinessRequest.Tag',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HappinessRequest_Tag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HappinessRequest_Tag copyWith(void Function(HappinessRequest_Tag) updates) =>
      super.copyWith((message) => updates(message as HappinessRequest_Tag))
          as HappinessRequest_Tag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HappinessRequest_Tag create() => HappinessRequest_Tag._();
  @$core.override
  HappinessRequest_Tag createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HappinessRequest_Tag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HappinessRequest_Tag>(create);
  static HappinessRequest_Tag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class HappinessRequest extends $pb.GeneratedMessage {
  factory HappinessRequest({
    Point? point,
    $core.bool? isPositive,
    $core.Iterable<HappinessRequest_Tag>? tags,
    $core.String? text,
  }) {
    final result = create();
    if (point != null) result.point = point;
    if (isPositive != null) result.isPositive = isPositive;
    if (tags != null) result.tags.addAll(tags);
    if (text != null) result.text = text;
    return result;
  }

  HappinessRequest._();

  factory HappinessRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory HappinessRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'HappinessRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Point>(1, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..aOB(2, _omitFieldNames ? '' : 'isPositive')
    ..pPM<HappinessRequest_Tag>(3, _omitFieldNames ? '' : 'tags',
        subBuilder: HappinessRequest_Tag.create)
    ..aOS(4, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HappinessRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  HappinessRequest copyWith(void Function(HappinessRequest) updates) =>
      super.copyWith((message) => updates(message as HappinessRequest))
          as HappinessRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HappinessRequest create() => HappinessRequest._();
  @$core.override
  HappinessRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static HappinessRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<HappinessRequest>(create);
  static HappinessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Point get point => $_getN(0);
  @$pb.TagNumber(1)
  set point(Point value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoint() => $_clearField(1);
  @$pb.TagNumber(1)
  Point ensurePoint() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.bool get isPositive => $_getBF(1);
  @$pb.TagNumber(2)
  set isPositive($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsPositive() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsPositive() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<HappinessRequest_Tag> get tags => $_getList(2);

  @$pb.TagNumber(4)
  $core.String get text => $_getSZ(3);
  @$pb.TagNumber(4)
  set text($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasText() => $_has(3);
  @$pb.TagNumber(4)
  void clearText() => $_clearField(4);
}

class FavouriteItemPlace_Location extends $pb.GeneratedMessage {
  factory FavouriteItemPlace_Location({
    Point? point,
  }) {
    final result = create();
    if (point != null) result.point = point;
    return result;
  }

  FavouriteItemPlace_Location._();

  factory FavouriteItemPlace_Location.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavouriteItemPlace_Location.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavouriteItemPlace.Location',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Point>(1, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouriteItemPlace_Location clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouriteItemPlace_Location copyWith(
          void Function(FavouriteItemPlace_Location) updates) =>
      super.copyWith(
              (message) => updates(message as FavouriteItemPlace_Location))
          as FavouriteItemPlace_Location;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavouriteItemPlace_Location create() =>
      FavouriteItemPlace_Location._();
  @$core.override
  FavouriteItemPlace_Location createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FavouriteItemPlace_Location getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavouriteItemPlace_Location>(create);
  static FavouriteItemPlace_Location? _defaultInstance;

  @$pb.TagNumber(1)
  Point get point => $_getN(0);
  @$pb.TagNumber(1)
  set point(Point value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoint() => $_clearField(1);
  @$pb.TagNumber(1)
  Point ensurePoint() => $_ensure(0);
}

class FavouriteItemPlace_Entity extends $pb.GeneratedMessage {
  factory FavouriteItemPlace_Entity({
    EntitySourceType? sourceType,
    $core.String? id,
  }) {
    final result = create();
    if (sourceType != null) result.sourceType = sourceType;
    if (id != null) result.id = id;
    return result;
  }

  FavouriteItemPlace_Entity._();

  factory FavouriteItemPlace_Entity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavouriteItemPlace_Entity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavouriteItemPlace.Entity',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aE<EntitySourceType>(1, _omitFieldNames ? '' : 'sourceType',
        enumValues: EntitySourceType.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouriteItemPlace_Entity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouriteItemPlace_Entity copyWith(
          void Function(FavouriteItemPlace_Entity) updates) =>
      super.copyWith((message) => updates(message as FavouriteItemPlace_Entity))
          as FavouriteItemPlace_Entity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavouriteItemPlace_Entity create() => FavouriteItemPlace_Entity._();
  @$core.override
  FavouriteItemPlace_Entity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FavouriteItemPlace_Entity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavouriteItemPlace_Entity>(create);
  static FavouriteItemPlace_Entity? _defaultInstance;

  @$pb.TagNumber(1)
  EntitySourceType get sourceType => $_getN(0);
  @$pb.TagNumber(1)
  set sourceType(EntitySourceType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

class FavouriteItemPlace extends $pb.GeneratedMessage {
  factory FavouriteItemPlace({
    FavouriteItemPlace_Location? location,
    FavouriteItemPlace_Entity? entity,
    $core.String? title,
    $core.String? subtitle,
  }) {
    final result = create();
    if (location != null) result.location = location;
    if (entity != null) result.entity = entity;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    return result;
  }

  FavouriteItemPlace._();

  factory FavouriteItemPlace.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavouriteItemPlace.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavouriteItemPlace',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<FavouriteItemPlace_Location>(1, _omitFieldNames ? '' : 'location',
        subBuilder: FavouriteItemPlace_Location.create)
    ..aOM<FavouriteItemPlace_Entity>(2, _omitFieldNames ? '' : 'entity',
        subBuilder: FavouriteItemPlace_Entity.create)
    ..aOS(3, _omitFieldNames ? '' : 'title')
    ..aOS(4, _omitFieldNames ? '' : 'subtitle')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouriteItemPlace clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouriteItemPlace copyWith(void Function(FavouriteItemPlace) updates) =>
      super.copyWith((message) => updates(message as FavouriteItemPlace))
          as FavouriteItemPlace;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavouriteItemPlace create() => FavouriteItemPlace._();
  @$core.override
  FavouriteItemPlace createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FavouriteItemPlace getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavouriteItemPlace>(create);
  static FavouriteItemPlace? _defaultInstance;

  @$pb.TagNumber(1)
  FavouriteItemPlace_Location get location => $_getN(0);
  @$pb.TagNumber(1)
  set location(FavouriteItemPlace_Location value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasLocation() => $_has(0);
  @$pb.TagNumber(1)
  void clearLocation() => $_clearField(1);
  @$pb.TagNumber(1)
  FavouriteItemPlace_Location ensureLocation() => $_ensure(0);

  @$pb.TagNumber(2)
  FavouriteItemPlace_Entity get entity => $_getN(1);
  @$pb.TagNumber(2)
  set entity(FavouriteItemPlace_Entity value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasEntity() => $_has(1);
  @$pb.TagNumber(2)
  void clearEntity() => $_clearField(2);
  @$pb.TagNumber(2)
  FavouriteItemPlace_Entity ensureEntity() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.String get title => $_getSZ(2);
  @$pb.TagNumber(3)
  set title($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitle() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitle() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get subtitle => $_getSZ(3);
  @$pb.TagNumber(4)
  set subtitle($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSubtitle() => $_has(3);
  @$pb.TagNumber(4)
  void clearSubtitle() => $_clearField(4);
}

class FavouriteItem extends $pb.GeneratedMessage {
  factory FavouriteItem({
    $core.String? id,
    FavouriteItemPlace? place,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (place != null) result.place = place;
    return result;
  }

  FavouriteItem._();

  factory FavouriteItem.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavouriteItem.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavouriteItem',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<FavouriteItemPlace>(2, _omitFieldNames ? '' : 'place',
        subBuilder: FavouriteItemPlace.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouriteItem clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouriteItem copyWith(void Function(FavouriteItem) updates) =>
      super.copyWith((message) => updates(message as FavouriteItem))
          as FavouriteItem;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavouriteItem create() => FavouriteItem._();
  @$core.override
  FavouriteItem createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FavouriteItem getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavouriteItem>(create);
  static FavouriteItem? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  FavouriteItemPlace get place => $_getN(1);
  @$pb.TagNumber(2)
  set place(FavouriteItemPlace value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPlace() => $_has(1);
  @$pb.TagNumber(2)
  void clearPlace() => $_clearField(2);
  @$pb.TagNumber(2)
  FavouriteItemPlace ensurePlace() => $_ensure(1);
}

class FavouritesResponse_Places extends $pb.GeneratedMessage {
  factory FavouritesResponse_Places({
    FavouriteItemPlace? home,
    FavouriteItemPlace? work,
  }) {
    final result = create();
    if (home != null) result.home = home;
    if (work != null) result.work = work;
    return result;
  }

  FavouritesResponse_Places._();

  factory FavouritesResponse_Places.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavouritesResponse_Places.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavouritesResponse.Places',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<FavouriteItemPlace>(1, _omitFieldNames ? '' : 'home',
        subBuilder: FavouriteItemPlace.create)
    ..aOM<FavouriteItemPlace>(2, _omitFieldNames ? '' : 'work',
        subBuilder: FavouriteItemPlace.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouritesResponse_Places clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouritesResponse_Places copyWith(
          void Function(FavouritesResponse_Places) updates) =>
      super.copyWith((message) => updates(message as FavouritesResponse_Places))
          as FavouritesResponse_Places;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavouritesResponse_Places create() => FavouritesResponse_Places._();
  @$core.override
  FavouritesResponse_Places createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FavouritesResponse_Places getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavouritesResponse_Places>(create);
  static FavouritesResponse_Places? _defaultInstance;

  @$pb.TagNumber(1)
  FavouriteItemPlace get home => $_getN(0);
  @$pb.TagNumber(1)
  set home(FavouriteItemPlace value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasHome() => $_has(0);
  @$pb.TagNumber(1)
  void clearHome() => $_clearField(1);
  @$pb.TagNumber(1)
  FavouriteItemPlace ensureHome() => $_ensure(0);

  @$pb.TagNumber(2)
  FavouriteItemPlace get work => $_getN(1);
  @$pb.TagNumber(2)
  set work(FavouriteItemPlace value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasWork() => $_has(1);
  @$pb.TagNumber(2)
  void clearWork() => $_clearField(2);
  @$pb.TagNumber(2)
  FavouriteItemPlace ensureWork() => $_ensure(1);
}

class FavouritesResponse extends $pb.GeneratedMessage {
  factory FavouritesResponse({
    FavouritesResponse_Places? places,
    $core.Iterable<FavouriteItem>? items,
  }) {
    final result = create();
    if (places != null) result.places = places;
    if (items != null) result.items.addAll(items);
    return result;
  }

  FavouritesResponse._();

  factory FavouritesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory FavouritesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'FavouritesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<FavouritesResponse_Places>(1, _omitFieldNames ? '' : 'places',
        subBuilder: FavouritesResponse_Places.create)
    ..pPM<FavouriteItem>(2, _omitFieldNames ? '' : 'items',
        subBuilder: FavouriteItem.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouritesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  FavouritesResponse copyWith(void Function(FavouritesResponse) updates) =>
      super.copyWith((message) => updates(message as FavouritesResponse))
          as FavouritesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static FavouritesResponse create() => FavouritesResponse._();
  @$core.override
  FavouritesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static FavouritesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<FavouritesResponse>(create);
  static FavouritesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  FavouritesResponse_Places get places => $_getN(0);
  @$pb.TagNumber(1)
  set places(FavouritesResponse_Places value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPlaces() => $_has(0);
  @$pb.TagNumber(1)
  void clearPlaces() => $_clearField(1);
  @$pb.TagNumber(1)
  FavouritesResponse_Places ensurePlaces() => $_ensure(0);

  @$pb.TagNumber(2)
  $pb.PbList<FavouriteItem> get items => $_getList(1);
}

class AddFavouriteItemsRequest_Item_Entity extends $pb.GeneratedMessage {
  factory AddFavouriteItemsRequest_Item_Entity({
    EntitySourceType? sourceType,
    $core.String? id,
  }) {
    final result = create();
    if (sourceType != null) result.sourceType = sourceType;
    if (id != null) result.id = id;
    return result;
  }

  AddFavouriteItemsRequest_Item_Entity._();

  factory AddFavouriteItemsRequest_Item_Entity.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddFavouriteItemsRequest_Item_Entity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddFavouriteItemsRequest.Item.Entity',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aE<EntitySourceType>(1, _omitFieldNames ? '' : 'sourceType',
        enumValues: EntitySourceType.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFavouriteItemsRequest_Item_Entity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFavouriteItemsRequest_Item_Entity copyWith(
          void Function(AddFavouriteItemsRequest_Item_Entity) updates) =>
      super.copyWith((message) =>
              updates(message as AddFavouriteItemsRequest_Item_Entity))
          as AddFavouriteItemsRequest_Item_Entity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFavouriteItemsRequest_Item_Entity create() =>
      AddFavouriteItemsRequest_Item_Entity._();
  @$core.override
  AddFavouriteItemsRequest_Item_Entity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddFavouriteItemsRequest_Item_Entity getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          AddFavouriteItemsRequest_Item_Entity>(create);
  static AddFavouriteItemsRequest_Item_Entity? _defaultInstance;

  @$pb.TagNumber(1)
  EntitySourceType get sourceType => $_getN(0);
  @$pb.TagNumber(1)
  set sourceType(EntitySourceType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

class AddFavouriteItemsRequest_Item extends $pb.GeneratedMessage {
  factory AddFavouriteItemsRequest_Item({
    FavouriteItemType? type,
    Point? point,
    AddFavouriteItemsRequest_Item_Entity? entity,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (point != null) result.point = point;
    if (entity != null) result.entity = entity;
    return result;
  }

  AddFavouriteItemsRequest_Item._();

  factory AddFavouriteItemsRequest_Item.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddFavouriteItemsRequest_Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddFavouriteItemsRequest.Item',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aE<FavouriteItemType>(1, _omitFieldNames ? '' : 'type',
        enumValues: FavouriteItemType.values)
    ..aOM<Point>(2, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..aOM<AddFavouriteItemsRequest_Item_Entity>(
        3, _omitFieldNames ? '' : 'entity',
        subBuilder: AddFavouriteItemsRequest_Item_Entity.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFavouriteItemsRequest_Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFavouriteItemsRequest_Item copyWith(
          void Function(AddFavouriteItemsRequest_Item) updates) =>
      super.copyWith(
              (message) => updates(message as AddFavouriteItemsRequest_Item))
          as AddFavouriteItemsRequest_Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFavouriteItemsRequest_Item create() =>
      AddFavouriteItemsRequest_Item._();
  @$core.override
  AddFavouriteItemsRequest_Item createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddFavouriteItemsRequest_Item getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddFavouriteItemsRequest_Item>(create);
  static AddFavouriteItemsRequest_Item? _defaultInstance;

  @$pb.TagNumber(1)
  FavouriteItemType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(FavouriteItemType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  Point get point => $_getN(1);
  @$pb.TagNumber(2)
  set point(Point value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearPoint() => $_clearField(2);
  @$pb.TagNumber(2)
  Point ensurePoint() => $_ensure(1);

  @$pb.TagNumber(3)
  AddFavouriteItemsRequest_Item_Entity get entity => $_getN(2);
  @$pb.TagNumber(3)
  set entity(AddFavouriteItemsRequest_Item_Entity value) =>
      $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasEntity() => $_has(2);
  @$pb.TagNumber(3)
  void clearEntity() => $_clearField(3);
  @$pb.TagNumber(3)
  AddFavouriteItemsRequest_Item_Entity ensureEntity() => $_ensure(2);
}

class AddFavouriteItemsRequest extends $pb.GeneratedMessage {
  factory AddFavouriteItemsRequest({
    $core.Iterable<AddFavouriteItemsRequest_Item>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  AddFavouriteItemsRequest._();

  factory AddFavouriteItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory AddFavouriteItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'AddFavouriteItemsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..pPM<AddFavouriteItemsRequest_Item>(1, _omitFieldNames ? '' : 'items',
        subBuilder: AddFavouriteItemsRequest_Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFavouriteItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  AddFavouriteItemsRequest copyWith(
          void Function(AddFavouriteItemsRequest) updates) =>
      super.copyWith((message) => updates(message as AddFavouriteItemsRequest))
          as AddFavouriteItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static AddFavouriteItemsRequest create() => AddFavouriteItemsRequest._();
  @$core.override
  AddFavouriteItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static AddFavouriteItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<AddFavouriteItemsRequest>(create);
  static AddFavouriteItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<AddFavouriteItemsRequest_Item> get items => $_getList(0);
}

class DeleteFavouriteItemsRequest_Item extends $pb.GeneratedMessage {
  factory DeleteFavouriteItemsRequest_Item({
    FavouriteItemType? type,
    $core.String? id,
  }) {
    final result = create();
    if (type != null) result.type = type;
    if (id != null) result.id = id;
    return result;
  }

  DeleteFavouriteItemsRequest_Item._();

  factory DeleteFavouriteItemsRequest_Item.fromBuffer(
          $core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteFavouriteItemsRequest_Item.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteFavouriteItemsRequest.Item',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aE<FavouriteItemType>(1, _omitFieldNames ? '' : 'type',
        enumValues: FavouriteItemType.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFavouriteItemsRequest_Item clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFavouriteItemsRequest_Item copyWith(
          void Function(DeleteFavouriteItemsRequest_Item) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteFavouriteItemsRequest_Item))
          as DeleteFavouriteItemsRequest_Item;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteFavouriteItemsRequest_Item create() =>
      DeleteFavouriteItemsRequest_Item._();
  @$core.override
  DeleteFavouriteItemsRequest_Item createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteFavouriteItemsRequest_Item getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteFavouriteItemsRequest_Item>(
          create);
  static DeleteFavouriteItemsRequest_Item? _defaultInstance;

  @$pb.TagNumber(1)
  FavouriteItemType get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(FavouriteItemType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

class DeleteFavouriteItemsRequest extends $pb.GeneratedMessage {
  factory DeleteFavouriteItemsRequest({
    $core.Iterable<DeleteFavouriteItemsRequest_Item>? items,
  }) {
    final result = create();
    if (items != null) result.items.addAll(items);
    return result;
  }

  DeleteFavouriteItemsRequest._();

  factory DeleteFavouriteItemsRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory DeleteFavouriteItemsRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DeleteFavouriteItemsRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..pPM<DeleteFavouriteItemsRequest_Item>(1, _omitFieldNames ? '' : 'items',
        subBuilder: DeleteFavouriteItemsRequest_Item.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFavouriteItemsRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DeleteFavouriteItemsRequest copyWith(
          void Function(DeleteFavouriteItemsRequest) updates) =>
      super.copyWith(
              (message) => updates(message as DeleteFavouriteItemsRequest))
          as DeleteFavouriteItemsRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DeleteFavouriteItemsRequest create() =>
      DeleteFavouriteItemsRequest._();
  @$core.override
  DeleteFavouriteItemsRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static DeleteFavouriteItemsRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DeleteFavouriteItemsRequest>(create);
  static DeleteFavouriteItemsRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<DeleteFavouriteItemsRequest_Item> get items => $_getList(0);
}

/// iWish
class Category extends $pb.GeneratedMessage {
  factory Category({
    $core.int? id,
    $core.String? nameEn,
    $core.String? nameAr,
    $core.String? iconUrl,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (nameEn != null) result.nameEn = nameEn;
    if (nameAr != null) result.nameAr = nameAr;
    if (iconUrl != null) result.iconUrl = iconUrl;
    return result;
  }

  Category._();

  factory Category.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Category.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Category',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'nameEn')
    ..aOS(3, _omitFieldNames ? '' : 'nameAr')
    ..aOS(4, _omitFieldNames ? '' : 'iconUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Category clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Category copyWith(void Function(Category) updates) =>
      super.copyWith((message) => updates(message as Category)) as Category;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Category create() => Category._();
  @$core.override
  Category createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Category getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Category>(create);
  static Category? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get nameEn => $_getSZ(1);
  @$pb.TagNumber(2)
  set nameEn($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNameEn() => $_has(1);
  @$pb.TagNumber(2)
  void clearNameEn() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get nameAr => $_getSZ(2);
  @$pb.TagNumber(3)
  set nameAr($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNameAr() => $_has(2);
  @$pb.TagNumber(3)
  void clearNameAr() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get iconUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set iconUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIconUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearIconUrl() => $_clearField(4);
}

class IWishObjectMarker_Location extends $pb.GeneratedMessage {
  factory IWishObjectMarker_Location({
    Point? point,
  }) {
    final result = create();
    if (point != null) result.point = point;
    return result;
  }

  IWishObjectMarker_Location._();

  factory IWishObjectMarker_Location.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObjectMarker_Location.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObjectMarker.Location',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Point>(1, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObjectMarker_Location clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObjectMarker_Location copyWith(
          void Function(IWishObjectMarker_Location) updates) =>
      super.copyWith(
              (message) => updates(message as IWishObjectMarker_Location))
          as IWishObjectMarker_Location;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObjectMarker_Location create() => IWishObjectMarker_Location._();
  @$core.override
  IWishObjectMarker_Location createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObjectMarker_Location getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObjectMarker_Location>(create);
  static IWishObjectMarker_Location? _defaultInstance;

  @$pb.TagNumber(1)
  Point get point => $_getN(0);
  @$pb.TagNumber(1)
  set point(Point value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoint() => $_clearField(1);
  @$pb.TagNumber(1)
  Point ensurePoint() => $_ensure(0);
}

class IWishObjectMarker extends $pb.GeneratedMessage {
  factory IWishObjectMarker({
    $core.String? id,
    @$core.Deprecated('This field is deprecated.') IWishCategory? category,
    IWishObjectMarker_Location? location,
    IWishState? state,
    Category? iwishCategory,
    $core.String? address,
    $core.String? photo,
    $core.String? name,
    $core.double? distance,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (category != null) result.category = category;
    if (location != null) result.location = location;
    if (state != null) result.state = state;
    if (iwishCategory != null) result.iwishCategory = iwishCategory;
    if (address != null) result.address = address;
    if (photo != null) result.photo = photo;
    if (name != null) result.name = name;
    if (distance != null) result.distance = distance;
    return result;
  }

  IWishObjectMarker._();

  factory IWishObjectMarker.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObjectMarker.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObjectMarker',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<IWishCategory>(2, _omitFieldNames ? '' : 'category',
        enumValues: IWishCategory.values)
    ..aOM<IWishObjectMarker_Location>(3, _omitFieldNames ? '' : 'location',
        subBuilder: IWishObjectMarker_Location.create)
    ..aE<IWishState>(4, _omitFieldNames ? '' : 'state',
        enumValues: IWishState.values)
    ..aOM<Category>(5, _omitFieldNames ? '' : 'iwishCategory',
        subBuilder: Category.create)
    ..aOS(6, _omitFieldNames ? '' : 'address')
    ..aOS(7, _omitFieldNames ? '' : 'photo')
    ..aOS(8, _omitFieldNames ? '' : 'name')
    ..aD(9, _omitFieldNames ? '' : 'distance')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObjectMarker clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObjectMarker copyWith(void Function(IWishObjectMarker) updates) =>
      super.copyWith((message) => updates(message as IWishObjectMarker))
          as IWishObjectMarker;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObjectMarker create() => IWishObjectMarker._();
  @$core.override
  IWishObjectMarker createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObjectMarker getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObjectMarker>(create);
  static IWishObjectMarker? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(2)
  IWishCategory get category => $_getN(1);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(2)
  set category(IWishCategory value) => $_setField(2, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);

  @$pb.TagNumber(3)
  IWishObjectMarker_Location get location => $_getN(2);
  @$pb.TagNumber(3)
  set location(IWishObjectMarker_Location value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => $_clearField(3);
  @$pb.TagNumber(3)
  IWishObjectMarker_Location ensureLocation() => $_ensure(2);

  @$pb.TagNumber(4)
  IWishState get state => $_getN(3);
  @$pb.TagNumber(4)
  set state(IWishState value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasState() => $_has(3);
  @$pb.TagNumber(4)
  void clearState() => $_clearField(4);

  @$pb.TagNumber(5)
  Category get iwishCategory => $_getN(4);
  @$pb.TagNumber(5)
  set iwishCategory(Category value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasIwishCategory() => $_has(4);
  @$pb.TagNumber(5)
  void clearIwishCategory() => $_clearField(5);
  @$pb.TagNumber(5)
  Category ensureIwishCategory() => $_ensure(4);

  @$pb.TagNumber(6)
  $core.String get address => $_getSZ(5);
  @$pb.TagNumber(6)
  set address($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasAddress() => $_has(5);
  @$pb.TagNumber(6)
  void clearAddress() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.String get photo => $_getSZ(6);
  @$pb.TagNumber(7)
  set photo($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPhoto() => $_has(6);
  @$pb.TagNumber(7)
  void clearPhoto() => $_clearField(7);

  @$pb.TagNumber(8)
  $core.String get name => $_getSZ(7);
  @$pb.TagNumber(8)
  set name($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasName() => $_has(7);
  @$pb.TagNumber(8)
  void clearName() => $_clearField(8);

  @$pb.TagNumber(9)
  $core.double get distance => $_getN(8);
  @$pb.TagNumber(9)
  set distance($core.double value) => $_setDouble(8, value);
  @$pb.TagNumber(9)
  $core.bool hasDistance() => $_has(8);
  @$pb.TagNumber(9)
  void clearDistance() => $_clearField(9);
}

class Location extends $pb.GeneratedMessage {
  factory Location({
    Point? point,
  }) {
    final result = create();
    if (point != null) result.point = point;
    return result;
  }

  Location._();

  factory Location.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Location.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Location',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Point>(1, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Location clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Location copyWith(void Function(Location) updates) =>
      super.copyWith((message) => updates(message as Location)) as Location;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Location create() => Location._();
  @$core.override
  Location createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Location getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Location>(create);
  static Location? _defaultInstance;

  @$pb.TagNumber(1)
  Point get point => $_getN(0);
  @$pb.TagNumber(1)
  set point(Point value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoint() => $_clearField(1);
  @$pb.TagNumber(1)
  Point ensurePoint() => $_ensure(0);
}

class IWishObjectMarkerV2 extends $pb.GeneratedMessage {
  factory IWishObjectMarkerV2({
    $core.String? id,
    $core.String? name,
    Location? location,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (name != null) result.name = name;
    if (location != null) result.location = location;
    return result;
  }

  IWishObjectMarkerV2._();

  factory IWishObjectMarkerV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObjectMarkerV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObjectMarkerV2',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'name')
    ..aOM<Location>(3, _omitFieldNames ? '' : 'location',
        subBuilder: Location.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObjectMarkerV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObjectMarkerV2 copyWith(void Function(IWishObjectMarkerV2) updates) =>
      super.copyWith((message) => updates(message as IWishObjectMarkerV2))
          as IWishObjectMarkerV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObjectMarkerV2 create() => IWishObjectMarkerV2._();
  @$core.override
  IWishObjectMarkerV2 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObjectMarkerV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObjectMarkerV2>(create);
  static IWishObjectMarkerV2? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get name => $_getSZ(1);
  @$pb.TagNumber(2)
  set name($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasName() => $_has(1);
  @$pb.TagNumber(2)
  void clearName() => $_clearField(2);

  @$pb.TagNumber(3)
  Location get location => $_getN(2);
  @$pb.TagNumber(3)
  set location(Location value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => $_clearField(3);
  @$pb.TagNumber(3)
  Location ensureLocation() => $_ensure(2);
}

class IWishObject_Location extends $pb.GeneratedMessage {
  factory IWishObject_Location({
    Point? point,
  }) {
    final result = create();
    if (point != null) result.point = point;
    return result;
  }

  IWishObject_Location._();

  factory IWishObject_Location.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObject_Location.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObject.Location',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Point>(1, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Location clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Location copyWith(void Function(IWishObject_Location) updates) =>
      super.copyWith((message) => updates(message as IWishObject_Location))
          as IWishObject_Location;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObject_Location create() => IWishObject_Location._();
  @$core.override
  IWishObject_Location createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObject_Location getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObject_Location>(create);
  static IWishObject_Location? _defaultInstance;

  @$pb.TagNumber(1)
  Point get point => $_getN(0);
  @$pb.TagNumber(1)
  set point(Point value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoint() => $_clearField(1);
  @$pb.TagNumber(1)
  Point ensurePoint() => $_ensure(0);
}

class IWishObject_Variant_Preview extends $pb.GeneratedMessage {
  factory IWishObject_Variant_Preview({
    Image? image,
  }) {
    final result = create();
    if (image != null) result.image = image;
    return result;
  }

  IWishObject_Variant_Preview._();

  factory IWishObject_Variant_Preview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObject_Variant_Preview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObject.Variant.Preview',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Image>(1, _omitFieldNames ? '' : 'image', subBuilder: Image.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Variant_Preview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Variant_Preview copyWith(
          void Function(IWishObject_Variant_Preview) updates) =>
      super.copyWith(
              (message) => updates(message as IWishObject_Variant_Preview))
          as IWishObject_Variant_Preview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObject_Variant_Preview create() =>
      IWishObject_Variant_Preview._();
  @$core.override
  IWishObject_Variant_Preview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObject_Variant_Preview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObject_Variant_Preview>(create);
  static IWishObject_Variant_Preview? _defaultInstance;

  @$pb.TagNumber(1)
  Image get image => $_getN(0);
  @$pb.TagNumber(1)
  set image(Image value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage() => $_clearField(1);
  @$pb.TagNumber(1)
  Image ensureImage() => $_ensure(0);
}

class IWishObject_Variant extends $pb.GeneratedMessage {
  factory IWishObject_Variant({
    $core.int? id,
    $core.String? title,
    IWishObject_Variant_Preview? preview,
    $core.Iterable<IWishObject_Photo>? photos,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (title != null) result.title = title;
    if (preview != null) result.preview = preview;
    if (photos != null) result.photos.addAll(photos);
    return result;
  }

  IWishObject_Variant._();

  factory IWishObject_Variant.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObject_Variant.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObject.Variant',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOM<IWishObject_Variant_Preview>(3, _omitFieldNames ? '' : 'preview',
        subBuilder: IWishObject_Variant_Preview.create)
    ..pPM<IWishObject_Photo>(4, _omitFieldNames ? '' : 'photos',
        subBuilder: IWishObject_Photo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Variant clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Variant copyWith(void Function(IWishObject_Variant) updates) =>
      super.copyWith((message) => updates(message as IWishObject_Variant))
          as IWishObject_Variant;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObject_Variant create() => IWishObject_Variant._();
  @$core.override
  IWishObject_Variant createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObject_Variant getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObject_Variant>(create);
  static IWishObject_Variant? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => $_clearField(2);

  @$pb.TagNumber(3)
  IWishObject_Variant_Preview get preview => $_getN(2);
  @$pb.TagNumber(3)
  set preview(IWishObject_Variant_Preview value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasPreview() => $_has(2);
  @$pb.TagNumber(3)
  void clearPreview() => $_clearField(3);
  @$pb.TagNumber(3)
  IWishObject_Variant_Preview ensurePreview() => $_ensure(2);

  @$pb.TagNumber(4)
  $pb.PbList<IWishObject_Photo> get photos => $_getList(3);
}

class IWishObject_Voted extends $pb.GeneratedMessage {
  factory IWishObject_Voted({
    $core.int? variantIndex,
    $core.bool? isFeedbackSent,
  }) {
    final result = create();
    if (variantIndex != null) result.variantIndex = variantIndex;
    if (isFeedbackSent != null) result.isFeedbackSent = isFeedbackSent;
    return result;
  }

  IWishObject_Voted._();

  factory IWishObject_Voted.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObject_Voted.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObject.Voted',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'variantIndex')
    ..aOB(2, _omitFieldNames ? '' : 'isFeedbackSent')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Voted clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Voted copyWith(void Function(IWishObject_Voted) updates) =>
      super.copyWith((message) => updates(message as IWishObject_Voted))
          as IWishObject_Voted;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObject_Voted create() => IWishObject_Voted._();
  @$core.override
  IWishObject_Voted createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObject_Voted getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObject_Voted>(create);
  static IWishObject_Voted? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get variantIndex => $_getIZ(0);
  @$pb.TagNumber(1)
  set variantIndex($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVariantIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearVariantIndex() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.bool get isFeedbackSent => $_getBF(1);
  @$pb.TagNumber(2)
  set isFeedbackSent($core.bool value) => $_setBool(1, value);
  @$pb.TagNumber(2)
  $core.bool hasIsFeedbackSent() => $_has(1);
  @$pb.TagNumber(2)
  void clearIsFeedbackSent() => $_clearField(2);
}

class IWishObject_Photo extends $pb.GeneratedMessage {
  factory IWishObject_Photo({
    Image? image,
  }) {
    final result = create();
    if (image != null) result.image = image;
    return result;
  }

  IWishObject_Photo._();

  factory IWishObject_Photo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObject_Photo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObject.Photo',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Image>(1, _omitFieldNames ? '' : 'image', subBuilder: Image.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Photo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Photo copyWith(void Function(IWishObject_Photo) updates) =>
      super.copyWith((message) => updates(message as IWishObject_Photo))
          as IWishObject_Photo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObject_Photo create() => IWishObject_Photo._();
  @$core.override
  IWishObject_Photo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObject_Photo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObject_Photo>(create);
  static IWishObject_Photo? _defaultInstance;

  @$pb.TagNumber(1)
  Image get image => $_getN(0);
  @$pb.TagNumber(1)
  set image(Image value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage() => $_clearField(1);
  @$pb.TagNumber(1)
  Image ensureImage() => $_ensure(0);
}

class IWishObject_Metadata extends $pb.GeneratedMessage {
  factory IWishObject_Metadata({
    $core.String? areaName,
    $core.String? typeName,
    $core.int? areaSize,
    Timestamp? openingDate,
  }) {
    final result = create();
    if (areaName != null) result.areaName = areaName;
    if (typeName != null) result.typeName = typeName;
    if (areaSize != null) result.areaSize = areaSize;
    if (openingDate != null) result.openingDate = openingDate;
    return result;
  }

  IWishObject_Metadata._();

  factory IWishObject_Metadata.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObject_Metadata.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObject.Metadata',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'areaName')
    ..aOS(2, _omitFieldNames ? '' : 'typeName')
    ..aI(3, _omitFieldNames ? '' : 'areaSize')
    ..aOM<Timestamp>(4, _omitFieldNames ? '' : 'openingDate',
        subBuilder: Timestamp.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Metadata clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject_Metadata copyWith(void Function(IWishObject_Metadata) updates) =>
      super.copyWith((message) => updates(message as IWishObject_Metadata))
          as IWishObject_Metadata;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObject_Metadata create() => IWishObject_Metadata._();
  @$core.override
  IWishObject_Metadata createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObject_Metadata getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObject_Metadata>(create);
  static IWishObject_Metadata? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get areaName => $_getSZ(0);
  @$pb.TagNumber(1)
  set areaName($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAreaName() => $_has(0);
  @$pb.TagNumber(1)
  void clearAreaName() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get typeName => $_getSZ(1);
  @$pb.TagNumber(2)
  set typeName($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTypeName() => $_has(1);
  @$pb.TagNumber(2)
  void clearTypeName() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get areaSize => $_getIZ(2);
  @$pb.TagNumber(3)
  set areaSize($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasAreaSize() => $_has(2);
  @$pb.TagNumber(3)
  void clearAreaSize() => $_clearField(3);

  @$pb.TagNumber(4)
  Timestamp get openingDate => $_getN(3);
  @$pb.TagNumber(4)
  set openingDate(Timestamp value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasOpeningDate() => $_has(3);
  @$pb.TagNumber(4)
  void clearOpeningDate() => $_clearField(4);
  @$pb.TagNumber(4)
  Timestamp ensureOpeningDate() => $_ensure(3);
}

class IWishObject extends $pb.GeneratedMessage {
  factory IWishObject({
    $core.String? id,
    @$core.Deprecated('This field is deprecated.') IWishCategory? category,
    IWishState? state,
    IWishObject_Location? location,
    $core.String? title,
    $core.String? subtitle,
    $core.Iterable<IWishObject_Photo>? photos,
    $core.Iterable<IWishObject_Variant>? variants,
    $core.int? selectedVariantId,
    $core.bool? feedbackSent,
    IWishObject_Metadata? metadata,
    IWishSize? size,
    Category? iwishCategory,
    $core.Iterable<IWishTag>? iwishTags,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (category != null) result.category = category;
    if (state != null) result.state = state;
    if (location != null) result.location = location;
    if (title != null) result.title = title;
    if (subtitle != null) result.subtitle = subtitle;
    if (photos != null) result.photos.addAll(photos);
    if (variants != null) result.variants.addAll(variants);
    if (selectedVariantId != null) result.selectedVariantId = selectedVariantId;
    if (feedbackSent != null) result.feedbackSent = feedbackSent;
    if (metadata != null) result.metadata = metadata;
    if (size != null) result.size = size;
    if (iwishCategory != null) result.iwishCategory = iwishCategory;
    if (iwishTags != null) result.iwishTags.addAll(iwishTags);
    return result;
  }

  IWishObject._();

  factory IWishObject.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishObject.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishObject',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aE<IWishCategory>(2, _omitFieldNames ? '' : 'category',
        enumValues: IWishCategory.values)
    ..aE<IWishState>(3, _omitFieldNames ? '' : 'state',
        enumValues: IWishState.values)
    ..aOM<IWishObject_Location>(4, _omitFieldNames ? '' : 'location',
        subBuilder: IWishObject_Location.create)
    ..aOS(5, _omitFieldNames ? '' : 'title')
    ..aOS(6, _omitFieldNames ? '' : 'subtitle')
    ..pPM<IWishObject_Photo>(7, _omitFieldNames ? '' : 'photos',
        subBuilder: IWishObject_Photo.create)
    ..pPM<IWishObject_Variant>(8, _omitFieldNames ? '' : 'variants',
        subBuilder: IWishObject_Variant.create)
    ..aI(9, _omitFieldNames ? '' : 'selectedVariantId')
    ..aOB(10, _omitFieldNames ? '' : 'feedbackSent')
    ..aOM<IWishObject_Metadata>(11, _omitFieldNames ? '' : 'metadata',
        subBuilder: IWishObject_Metadata.create)
    ..aE<IWishSize>(12, _omitFieldNames ? '' : 'size',
        enumValues: IWishSize.values)
    ..aOM<Category>(13, _omitFieldNames ? '' : 'iwishCategory',
        subBuilder: Category.create)
    ..pPM<IWishTag>(14, _omitFieldNames ? '' : 'iwishTags',
        subBuilder: IWishTag.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishObject copyWith(void Function(IWishObject) updates) =>
      super.copyWith((message) => updates(message as IWishObject))
          as IWishObject;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishObject create() => IWishObject._();
  @$core.override
  IWishObject createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishObject getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishObject>(create);
  static IWishObject? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(2)
  IWishCategory get category => $_getN(1);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(2)
  set category(IWishCategory value) => $_setField(2, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(2)
  $core.bool hasCategory() => $_has(1);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(2)
  void clearCategory() => $_clearField(2);

  @$pb.TagNumber(3)
  IWishState get state => $_getN(2);
  @$pb.TagNumber(3)
  set state(IWishState value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasState() => $_has(2);
  @$pb.TagNumber(3)
  void clearState() => $_clearField(3);

  @$pb.TagNumber(4)
  IWishObject_Location get location => $_getN(3);
  @$pb.TagNumber(4)
  set location(IWishObject_Location value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasLocation() => $_has(3);
  @$pb.TagNumber(4)
  void clearLocation() => $_clearField(4);
  @$pb.TagNumber(4)
  IWishObject_Location ensureLocation() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.String get title => $_getSZ(4);
  @$pb.TagNumber(5)
  set title($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasTitle() => $_has(4);
  @$pb.TagNumber(5)
  void clearTitle() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get subtitle => $_getSZ(5);
  @$pb.TagNumber(6)
  set subtitle($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasSubtitle() => $_has(5);
  @$pb.TagNumber(6)
  void clearSubtitle() => $_clearField(6);

  @$pb.TagNumber(7)
  $pb.PbList<IWishObject_Photo> get photos => $_getList(6);

  @$pb.TagNumber(8)
  $pb.PbList<IWishObject_Variant> get variants => $_getList(7);

  @$pb.TagNumber(9)
  $core.int get selectedVariantId => $_getIZ(8);
  @$pb.TagNumber(9)
  set selectedVariantId($core.int value) => $_setSignedInt32(8, value);
  @$pb.TagNumber(9)
  $core.bool hasSelectedVariantId() => $_has(8);
  @$pb.TagNumber(9)
  void clearSelectedVariantId() => $_clearField(9);

  @$pb.TagNumber(10)
  $core.bool get feedbackSent => $_getBF(9);
  @$pb.TagNumber(10)
  set feedbackSent($core.bool value) => $_setBool(9, value);
  @$pb.TagNumber(10)
  $core.bool hasFeedbackSent() => $_has(9);
  @$pb.TagNumber(10)
  void clearFeedbackSent() => $_clearField(10);

  @$pb.TagNumber(11)
  IWishObject_Metadata get metadata => $_getN(10);
  @$pb.TagNumber(11)
  set metadata(IWishObject_Metadata value) => $_setField(11, value);
  @$pb.TagNumber(11)
  $core.bool hasMetadata() => $_has(10);
  @$pb.TagNumber(11)
  void clearMetadata() => $_clearField(11);
  @$pb.TagNumber(11)
  IWishObject_Metadata ensureMetadata() => $_ensure(10);

  @$pb.TagNumber(12)
  IWishSize get size => $_getN(11);
  @$pb.TagNumber(12)
  set size(IWishSize value) => $_setField(12, value);
  @$pb.TagNumber(12)
  $core.bool hasSize() => $_has(11);
  @$pb.TagNumber(12)
  void clearSize() => $_clearField(12);

  @$pb.TagNumber(13)
  Category get iwishCategory => $_getN(12);
  @$pb.TagNumber(13)
  set iwishCategory(Category value) => $_setField(13, value);
  @$pb.TagNumber(13)
  $core.bool hasIwishCategory() => $_has(12);
  @$pb.TagNumber(13)
  void clearIwishCategory() => $_clearField(13);
  @$pb.TagNumber(13)
  Category ensureIwishCategory() => $_ensure(12);

  @$pb.TagNumber(14)
  $pb.PbList<IWishTag> get iwishTags => $_getList(13);
}

class IWishTag extends $pb.GeneratedMessage {
  factory IWishTag({
    $core.int? id,
    $core.String? titleEn,
    $core.String? titleAr,
    $core.String? iconUrl,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (titleEn != null) result.titleEn = titleEn;
    if (titleAr != null) result.titleAr = titleAr;
    if (iconUrl != null) result.iconUrl = iconUrl;
    return result;
  }

  IWishTag._();

  factory IWishTag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishTag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishTag',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'id')
    ..aOS(2, _omitFieldNames ? '' : 'titleEn')
    ..aOS(3, _omitFieldNames ? '' : 'titleAr')
    ..aOS(4, _omitFieldNames ? '' : 'iconUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishTag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishTag copyWith(void Function(IWishTag) updates) =>
      super.copyWith((message) => updates(message as IWishTag)) as IWishTag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishTag create() => IWishTag._();
  @$core.override
  IWishTag createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishTag getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<IWishTag>(create);
  static IWishTag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get id => $_getIZ(0);
  @$pb.TagNumber(1)
  set id($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get titleEn => $_getSZ(1);
  @$pb.TagNumber(2)
  set titleEn($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasTitleEn() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitleEn() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get titleAr => $_getSZ(2);
  @$pb.TagNumber(3)
  set titleAr($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasTitleAr() => $_has(2);
  @$pb.TagNumber(3)
  void clearTitleAr() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get iconUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set iconUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasIconUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearIconUrl() => $_clearField(4);
}

class IWishMarkersResponse extends $pb.GeneratedMessage {
  factory IWishMarkersResponse({
    $core.Iterable<IWishObjectMarker>? markers,
  }) {
    final result = create();
    if (markers != null) result.markers.addAll(markers);
    return result;
  }

  IWishMarkersResponse._();

  factory IWishMarkersResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishMarkersResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishMarkersResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..pPM<IWishObjectMarker>(1, _omitFieldNames ? '' : 'markers',
        subBuilder: IWishObjectMarker.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishMarkersResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishMarkersResponse copyWith(void Function(IWishMarkersResponse) updates) =>
      super.copyWith((message) => updates(message as IWishMarkersResponse))
          as IWishMarkersResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishMarkersResponse create() => IWishMarkersResponse._();
  @$core.override
  IWishMarkersResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishMarkersResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishMarkersResponse>(create);
  static IWishMarkersResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<IWishObjectMarker> get markers => $_getList(0);
}

class IWishMarkersResponseV2 extends $pb.GeneratedMessage {
  factory IWishMarkersResponseV2({
    $core.Iterable<IWishObjectMarkerV2>? markers,
  }) {
    final result = create();
    if (markers != null) result.markers.addAll(markers);
    return result;
  }

  IWishMarkersResponseV2._();

  factory IWishMarkersResponseV2.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishMarkersResponseV2.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishMarkersResponseV2',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..pPM<IWishObjectMarkerV2>(1, _omitFieldNames ? '' : 'markers',
        subBuilder: IWishObjectMarkerV2.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishMarkersResponseV2 clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishMarkersResponseV2 copyWith(
          void Function(IWishMarkersResponseV2) updates) =>
      super.copyWith((message) => updates(message as IWishMarkersResponseV2))
          as IWishMarkersResponseV2;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishMarkersResponseV2 create() => IWishMarkersResponseV2._();
  @$core.override
  IWishMarkersResponseV2 createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishMarkersResponseV2 getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishMarkersResponseV2>(create);
  static IWishMarkersResponseV2? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<IWishObjectMarkerV2> get markers => $_getList(0);
}

class IWishItemResponse extends $pb.GeneratedMessage {
  factory IWishItemResponse({
    IWishObject? object,
  }) {
    final result = create();
    if (object != null) result.object = object;
    return result;
  }

  IWishItemResponse._();

  factory IWishItemResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishItemResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishItemResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<IWishObject>(1, _omitFieldNames ? '' : 'object',
        subBuilder: IWishObject.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishItemResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishItemResponse copyWith(void Function(IWishItemResponse) updates) =>
      super.copyWith((message) => updates(message as IWishItemResponse))
          as IWishItemResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishItemResponse create() => IWishItemResponse._();
  @$core.override
  IWishItemResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishItemResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishItemResponse>(create);
  static IWishItemResponse? _defaultInstance;

  @$pb.TagNumber(1)
  IWishObject get object => $_getN(0);
  @$pb.TagNumber(1)
  set object(IWishObject value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasObject() => $_has(0);
  @$pb.TagNumber(1)
  void clearObject() => $_clearField(1);
  @$pb.TagNumber(1)
  IWishObject ensureObject() => $_ensure(0);
}

class IWishVoteRequest extends $pb.GeneratedMessage {
  factory IWishVoteRequest({
    $core.int? variantId,
  }) {
    final result = create();
    if (variantId != null) result.variantId = variantId;
    return result;
  }

  IWishVoteRequest._();

  factory IWishVoteRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishVoteRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishVoteRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aI(1, _omitFieldNames ? '' : 'variantId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishVoteRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishVoteRequest copyWith(void Function(IWishVoteRequest) updates) =>
      super.copyWith((message) => updates(message as IWishVoteRequest))
          as IWishVoteRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishVoteRequest create() => IWishVoteRequest._();
  @$core.override
  IWishVoteRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishVoteRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishVoteRequest>(create);
  static IWishVoteRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get variantId => $_getIZ(0);
  @$pb.TagNumber(1)
  set variantId($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasVariantId() => $_has(0);
  @$pb.TagNumber(1)
  void clearVariantId() => $_clearField(1);
}

class IWishFeedbackRequest_Tag extends $pb.GeneratedMessage {
  factory IWishFeedbackRequest_Tag({
    $core.String? name,
  }) {
    final result = create();
    if (name != null) result.name = name;
    return result;
  }

  IWishFeedbackRequest_Tag._();

  factory IWishFeedbackRequest_Tag.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishFeedbackRequest_Tag.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishFeedbackRequest.Tag',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishFeedbackRequest_Tag clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishFeedbackRequest_Tag copyWith(
          void Function(IWishFeedbackRequest_Tag) updates) =>
      super.copyWith((message) => updates(message as IWishFeedbackRequest_Tag))
          as IWishFeedbackRequest_Tag;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishFeedbackRequest_Tag create() => IWishFeedbackRequest_Tag._();
  @$core.override
  IWishFeedbackRequest_Tag createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishFeedbackRequest_Tag getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishFeedbackRequest_Tag>(create);
  static IWishFeedbackRequest_Tag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);
}

class IWishFeedbackRequest extends $pb.GeneratedMessage {
  factory IWishFeedbackRequest({
    IWishFeedbackRating? rating,
    $core.Iterable<IWishFeedbackRequest_Tag>? tags,
    $core.String? text,
  }) {
    final result = create();
    if (rating != null) result.rating = rating;
    if (tags != null) result.tags.addAll(tags);
    if (text != null) result.text = text;
    return result;
  }

  IWishFeedbackRequest._();

  factory IWishFeedbackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishFeedbackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishFeedbackRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aE<IWishFeedbackRating>(1, _omitFieldNames ? '' : 'rating',
        enumValues: IWishFeedbackRating.values)
    ..pPM<IWishFeedbackRequest_Tag>(2, _omitFieldNames ? '' : 'tags',
        subBuilder: IWishFeedbackRequest_Tag.create)
    ..aOS(3, _omitFieldNames ? '' : 'text')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishFeedbackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishFeedbackRequest copyWith(void Function(IWishFeedbackRequest) updates) =>
      super.copyWith((message) => updates(message as IWishFeedbackRequest))
          as IWishFeedbackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishFeedbackRequest create() => IWishFeedbackRequest._();
  @$core.override
  IWishFeedbackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishFeedbackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishFeedbackRequest>(create);
  static IWishFeedbackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  IWishFeedbackRating get rating => $_getN(0);
  @$pb.TagNumber(1)
  set rating(IWishFeedbackRating value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasRating() => $_has(0);
  @$pb.TagNumber(1)
  void clearRating() => $_clearField(1);

  @$pb.TagNumber(2)
  $pb.PbList<IWishFeedbackRequest_Tag> get tags => $_getList(1);

  @$pb.TagNumber(3)
  $core.String get text => $_getSZ(2);
  @$pb.TagNumber(3)
  set text($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasText() => $_has(2);
  @$pb.TagNumber(3)
  void clearText() => $_clearField(3);
}

class IWishDeleteAllFeedbacksRequest extends $pb.GeneratedMessage {
  factory IWishDeleteAllFeedbacksRequest({
    $core.Iterable<$core.String>? userIds,
  }) {
    final result = create();
    if (userIds != null) result.userIds.addAll(userIds);
    return result;
  }

  IWishDeleteAllFeedbacksRequest._();

  factory IWishDeleteAllFeedbacksRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory IWishDeleteAllFeedbacksRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'IWishDeleteAllFeedbacksRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'userIds')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishDeleteAllFeedbacksRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  IWishDeleteAllFeedbacksRequest copyWith(
          void Function(IWishDeleteAllFeedbacksRequest) updates) =>
      super.copyWith(
              (message) => updates(message as IWishDeleteAllFeedbacksRequest))
          as IWishDeleteAllFeedbacksRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static IWishDeleteAllFeedbacksRequest create() =>
      IWishDeleteAllFeedbacksRequest._();
  @$core.override
  IWishDeleteAllFeedbacksRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static IWishDeleteAllFeedbacksRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<IWishDeleteAllFeedbacksRequest>(create);
  static IWishDeleteAllFeedbacksRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get userIds => $_getList(0);
}

class InterestingPlace_Preview extends $pb.GeneratedMessage {
  factory InterestingPlace_Preview({
    $core.String? title,
    Image? image,
  }) {
    final result = create();
    if (title != null) result.title = title;
    if (image != null) result.image = image;
    return result;
  }

  InterestingPlace_Preview._();

  factory InterestingPlace_Preview.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InterestingPlace_Preview.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InterestingPlace.Preview',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOM<Image>(2, _omitFieldNames ? '' : 'image', subBuilder: Image.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlace_Preview clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlace_Preview copyWith(
          void Function(InterestingPlace_Preview) updates) =>
      super.copyWith((message) => updates(message as InterestingPlace_Preview))
          as InterestingPlace_Preview;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InterestingPlace_Preview create() => InterestingPlace_Preview._();
  @$core.override
  InterestingPlace_Preview createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InterestingPlace_Preview getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InterestingPlace_Preview>(create);
  static InterestingPlace_Preview? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => $_clearField(1);

  @$pb.TagNumber(2)
  Image get image => $_getN(1);
  @$pb.TagNumber(2)
  set image(Image value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasImage() => $_has(1);
  @$pb.TagNumber(2)
  void clearImage() => $_clearField(2);
  @$pb.TagNumber(2)
  Image ensureImage() => $_ensure(1);
}

class InterestingPlace_Location extends $pb.GeneratedMessage {
  factory InterestingPlace_Location({
    Point? point,
  }) {
    final result = create();
    if (point != null) result.point = point;
    return result;
  }

  InterestingPlace_Location._();

  factory InterestingPlace_Location.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InterestingPlace_Location.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InterestingPlace.Location',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Point>(1, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlace_Location clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlace_Location copyWith(
          void Function(InterestingPlace_Location) updates) =>
      super.copyWith((message) => updates(message as InterestingPlace_Location))
          as InterestingPlace_Location;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InterestingPlace_Location create() => InterestingPlace_Location._();
  @$core.override
  InterestingPlace_Location createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InterestingPlace_Location getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InterestingPlace_Location>(create);
  static InterestingPlace_Location? _defaultInstance;

  @$pb.TagNumber(1)
  Point get point => $_getN(0);
  @$pb.TagNumber(1)
  set point(Point value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoint() => $_clearField(1);
  @$pb.TagNumber(1)
  Point ensurePoint() => $_ensure(0);
}

class InterestingPlace_Entity extends $pb.GeneratedMessage {
  factory InterestingPlace_Entity({
    EntitySourceType? sourceType,
    $core.String? id,
  }) {
    final result = create();
    if (sourceType != null) result.sourceType = sourceType;
    if (id != null) result.id = id;
    return result;
  }

  InterestingPlace_Entity._();

  factory InterestingPlace_Entity.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InterestingPlace_Entity.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InterestingPlace.Entity',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aE<EntitySourceType>(1, _omitFieldNames ? '' : 'sourceType',
        enumValues: EntitySourceType.values)
    ..aOS(2, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlace_Entity clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlace_Entity copyWith(
          void Function(InterestingPlace_Entity) updates) =>
      super.copyWith((message) => updates(message as InterestingPlace_Entity))
          as InterestingPlace_Entity;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InterestingPlace_Entity create() => InterestingPlace_Entity._();
  @$core.override
  InterestingPlace_Entity createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InterestingPlace_Entity getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InterestingPlace_Entity>(create);
  static InterestingPlace_Entity? _defaultInstance;

  @$pb.TagNumber(1)
  EntitySourceType get sourceType => $_getN(0);
  @$pb.TagNumber(1)
  set sourceType(EntitySourceType value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasSourceType() => $_has(0);
  @$pb.TagNumber(1)
  void clearSourceType() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get id => $_getSZ(1);
  @$pb.TagNumber(2)
  set id($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasId() => $_has(1);
  @$pb.TagNumber(2)
  void clearId() => $_clearField(2);
}

class InterestingPlace extends $pb.GeneratedMessage {
  factory InterestingPlace({
    $core.String? id,
    InterestingPlace_Preview? preview,
    InterestingPlace_Location? location,
    InterestingPlace_Entity? entity,
    $core.Iterable<InterestingPlaceTag>? tags,
    $core.double? distance,
    $core.bool? pinned,
  }) {
    final result = create();
    if (id != null) result.id = id;
    if (preview != null) result.preview = preview;
    if (location != null) result.location = location;
    if (entity != null) result.entity = entity;
    if (tags != null) result.tags.addAll(tags);
    if (distance != null) result.distance = distance;
    if (pinned != null) result.pinned = pinned;
    return result;
  }

  InterestingPlace._();

  factory InterestingPlace.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InterestingPlace.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InterestingPlace',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<InterestingPlace_Preview>(2, _omitFieldNames ? '' : 'preview',
        subBuilder: InterestingPlace_Preview.create)
    ..aOM<InterestingPlace_Location>(3, _omitFieldNames ? '' : 'location',
        subBuilder: InterestingPlace_Location.create)
    ..aOM<InterestingPlace_Entity>(4, _omitFieldNames ? '' : 'entity',
        subBuilder: InterestingPlace_Entity.create)
    ..pc<InterestingPlaceTag>(
        5, _omitFieldNames ? '' : 'tags', $pb.PbFieldType.KE,
        valueOf: InterestingPlaceTag.valueOf,
        enumValues: InterestingPlaceTag.values,
        defaultEnumValue:
            InterestingPlaceTag.INTERESTING_PLACE_CATEGORY_UNKNOWN)
    ..aD(6, _omitFieldNames ? '' : 'distance', fieldType: $pb.PbFieldType.OF)
    ..aOB(7, _omitFieldNames ? '' : 'pinned')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlace clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlace copyWith(void Function(InterestingPlace) updates) =>
      super.copyWith((message) => updates(message as InterestingPlace))
          as InterestingPlace;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InterestingPlace create() => InterestingPlace._();
  @$core.override
  InterestingPlace createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InterestingPlace getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InterestingPlace>(create);
  static InterestingPlace? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => $_clearField(1);

  @$pb.TagNumber(2)
  InterestingPlace_Preview get preview => $_getN(1);
  @$pb.TagNumber(2)
  set preview(InterestingPlace_Preview value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasPreview() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreview() => $_clearField(2);
  @$pb.TagNumber(2)
  InterestingPlace_Preview ensurePreview() => $_ensure(1);

  @$pb.TagNumber(3)
  InterestingPlace_Location get location => $_getN(2);
  @$pb.TagNumber(3)
  set location(InterestingPlace_Location value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasLocation() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocation() => $_clearField(3);
  @$pb.TagNumber(3)
  InterestingPlace_Location ensureLocation() => $_ensure(2);

  @$pb.TagNumber(4)
  InterestingPlace_Entity get entity => $_getN(3);
  @$pb.TagNumber(4)
  set entity(InterestingPlace_Entity value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasEntity() => $_has(3);
  @$pb.TagNumber(4)
  void clearEntity() => $_clearField(4);
  @$pb.TagNumber(4)
  InterestingPlace_Entity ensureEntity() => $_ensure(3);

  @$pb.TagNumber(5)
  $pb.PbList<InterestingPlaceTag> get tags => $_getList(4);

  @$pb.TagNumber(6)
  $core.double get distance => $_getN(5);
  @$pb.TagNumber(6)
  set distance($core.double value) => $_setFloat(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDistance() => $_has(5);
  @$pb.TagNumber(6)
  void clearDistance() => $_clearField(6);

  @$pb.TagNumber(7)
  $core.bool get pinned => $_getBF(6);
  @$pb.TagNumber(7)
  set pinned($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(7)
  $core.bool hasPinned() => $_has(6);
  @$pb.TagNumber(7)
  void clearPinned() => $_clearField(7);
}

class InterestingPlacesResponse extends $pb.GeneratedMessage {
  factory InterestingPlacesResponse({
    $core.Iterable<InterestingPlace>? interestingPlaces,
  }) {
    final result = create();
    if (interestingPlaces != null)
      result.interestingPlaces.addAll(interestingPlaces);
    return result;
  }

  InterestingPlacesResponse._();

  factory InterestingPlacesResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory InterestingPlacesResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'InterestingPlacesResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..pPM<InterestingPlace>(1, _omitFieldNames ? '' : 'interestingPlaces',
        subBuilder: InterestingPlace.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlacesResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  InterestingPlacesResponse copyWith(
          void Function(InterestingPlacesResponse) updates) =>
      super.copyWith((message) => updates(message as InterestingPlacesResponse))
          as InterestingPlacesResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static InterestingPlacesResponse create() => InterestingPlacesResponse._();
  @$core.override
  InterestingPlacesResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static InterestingPlacesResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<InterestingPlacesResponse>(create);
  static InterestingPlacesResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<InterestingPlace> get interestingPlaces => $_getList(0);
}

class Profile_Photo extends $pb.GeneratedMessage {
  factory Profile_Photo({
    Image? image,
  }) {
    final result = create();
    if (image != null) result.image = image;
    return result;
  }

  Profile_Photo._();

  factory Profile_Photo.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Profile_Photo.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Profile.Photo',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Image>(1, _omitFieldNames ? '' : 'image', subBuilder: Image.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile_Photo clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile_Photo copyWith(void Function(Profile_Photo) updates) =>
      super.copyWith((message) => updates(message as Profile_Photo))
          as Profile_Photo;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Profile_Photo create() => Profile_Photo._();
  @$core.override
  Profile_Photo createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Profile_Photo getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Profile_Photo>(create);
  static Profile_Photo? _defaultInstance;

  @$pb.TagNumber(1)
  Image get image => $_getN(0);
  @$pb.TagNumber(1)
  set image(Image value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage() => $_clearField(1);
  @$pb.TagNumber(1)
  Image ensureImage() => $_ensure(0);
}

class Profile extends $pb.GeneratedMessage {
  factory Profile({
    Profile_Photo? photo,
  }) {
    final result = create();
    if (photo != null) result.photo = photo;
    return result;
  }

  Profile._();

  factory Profile.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Profile.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Profile',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Profile_Photo>(6, _omitFieldNames ? '' : 'photo',
        subBuilder: Profile_Photo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Profile copyWith(void Function(Profile) updates) =>
      super.copyWith((message) => updates(message as Profile)) as Profile;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Profile create() => Profile._();
  @$core.override
  Profile createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Profile getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Profile>(create);
  static Profile? _defaultInstance;

  @$pb.TagNumber(6)
  Profile_Photo get photo => $_getN(0);
  @$pb.TagNumber(6)
  set photo(Profile_Photo value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasPhoto() => $_has(0);
  @$pb.TagNumber(6)
  void clearPhoto() => $_clearField(6);
  @$pb.TagNumber(6)
  Profile_Photo ensurePhoto() => $_ensure(0);
}

class ProfileResponse extends $pb.GeneratedMessage {
  factory ProfileResponse({
    Profile? profile,
  }) {
    final result = create();
    if (profile != null) result.profile = profile;
    return result;
  }

  ProfileResponse._();

  factory ProfileResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory ProfileResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'ProfileResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOM<Profile>(2, _omitFieldNames ? '' : 'profile',
        subBuilder: Profile.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  ProfileResponse copyWith(void Function(ProfileResponse) updates) =>
      super.copyWith((message) => updates(message as ProfileResponse))
          as ProfileResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ProfileResponse create() => ProfileResponse._();
  @$core.override
  ProfileResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static ProfileResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<ProfileResponse>(create);
  static ProfileResponse? _defaultInstance;

  @$pb.TagNumber(2)
  Profile get profile => $_getN(0);
  @$pb.TagNumber(2)
  set profile(Profile value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasProfile() => $_has(0);
  @$pb.TagNumber(2)
  void clearProfile() => $_clearField(2);
  @$pb.TagNumber(2)
  Profile ensureProfile() => $_ensure(0);
}

class CategoryResponse extends $pb.GeneratedMessage {
  factory CategoryResponse({
    $core.Iterable<Category>? categories,
  }) {
    final result = create();
    if (categories != null) result.categories.addAll(categories);
    return result;
  }

  CategoryResponse._();

  factory CategoryResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CategoryResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CategoryResponse',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..pPM<Category>(1, _omitFieldNames ? '' : 'categories',
        subBuilder: Category.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryResponse clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CategoryResponse copyWith(void Function(CategoryResponse) updates) =>
      super.copyWith((message) => updates(message as CategoryResponse))
          as CategoryResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CategoryResponse create() => CategoryResponse._();
  @$core.override
  CategoryResponse createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CategoryResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CategoryResponse>(create);
  static CategoryResponse? _defaultInstance;

  @$pb.TagNumber(1)
  $pb.PbList<Category> get categories => $_getList(0);
}

class StaticAsset extends $pb.GeneratedMessage {
  factory StaticAsset({
    $core.String? iconsUrl,
  }) {
    final result = create();
    if (iconsUrl != null) result.iconsUrl = iconsUrl;
    return result;
  }

  StaticAsset._();

  factory StaticAsset.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory StaticAsset.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'StaticAsset',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'iconsUrl')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StaticAsset clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  StaticAsset copyWith(void Function(StaticAsset) updates) =>
      super.copyWith((message) => updates(message as StaticAsset))
          as StaticAsset;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StaticAsset create() => StaticAsset._();
  @$core.override
  StaticAsset createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static StaticAsset getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<StaticAsset>(create);
  static StaticAsset? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get iconsUrl => $_getSZ(0);
  @$pb.TagNumber(1)
  set iconsUrl($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasIconsUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearIconsUrl() => $_clearField(1);
}

class CreateFeedbackRequest_Context extends $pb.GeneratedMessage {
  factory CreateFeedbackRequest_Context({
    $core.String? appVersion,
    $core.String? mobileOS,
    $core.String? locale,
    $core.String? authId,
    $core.String? feedbackSource,
    $core.String? deviceId,
  }) {
    final result = create();
    if (appVersion != null) result.appVersion = appVersion;
    if (mobileOS != null) result.mobileOS = mobileOS;
    if (locale != null) result.locale = locale;
    if (authId != null) result.authId = authId;
    if (feedbackSource != null) result.feedbackSource = feedbackSource;
    if (deviceId != null) result.deviceId = deviceId;
    return result;
  }

  CreateFeedbackRequest_Context._();

  factory CreateFeedbackRequest_Context.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateFeedbackRequest_Context.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFeedbackRequest.Context',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'appVersion', protoName: 'appVersion')
    ..aOS(2, _omitFieldNames ? '' : 'mobileOS', protoName: 'mobileOS')
    ..aOS(3, _omitFieldNames ? '' : 'locale')
    ..aOS(4, _omitFieldNames ? '' : 'authId', protoName: 'authId')
    ..aOS(5, _omitFieldNames ? '' : 'feedbackSource',
        protoName: 'feedbackSource')
    ..aOS(6, _omitFieldNames ? '' : 'deviceId', protoName: 'deviceId')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedbackRequest_Context clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedbackRequest_Context copyWith(
          void Function(CreateFeedbackRequest_Context) updates) =>
      super.copyWith(
              (message) => updates(message as CreateFeedbackRequest_Context))
          as CreateFeedbackRequest_Context;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFeedbackRequest_Context create() =>
      CreateFeedbackRequest_Context._();
  @$core.override
  CreateFeedbackRequest_Context createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateFeedbackRequest_Context getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFeedbackRequest_Context>(create);
  static CreateFeedbackRequest_Context? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get appVersion => $_getSZ(0);
  @$pb.TagNumber(1)
  set appVersion($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasAppVersion() => $_has(0);
  @$pb.TagNumber(1)
  void clearAppVersion() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get mobileOS => $_getSZ(1);
  @$pb.TagNumber(2)
  set mobileOS($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMobileOS() => $_has(1);
  @$pb.TagNumber(2)
  void clearMobileOS() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.String get locale => $_getSZ(2);
  @$pb.TagNumber(3)
  set locale($core.String value) => $_setString(2, value);
  @$pb.TagNumber(3)
  $core.bool hasLocale() => $_has(2);
  @$pb.TagNumber(3)
  void clearLocale() => $_clearField(3);

  @$pb.TagNumber(4)
  $core.String get authId => $_getSZ(3);
  @$pb.TagNumber(4)
  set authId($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasAuthId() => $_has(3);
  @$pb.TagNumber(4)
  void clearAuthId() => $_clearField(4);

  @$pb.TagNumber(5)
  $core.String get feedbackSource => $_getSZ(4);
  @$pb.TagNumber(5)
  set feedbackSource($core.String value) => $_setString(4, value);
  @$pb.TagNumber(5)
  $core.bool hasFeedbackSource() => $_has(4);
  @$pb.TagNumber(5)
  void clearFeedbackSource() => $_clearField(5);

  @$pb.TagNumber(6)
  $core.String get deviceId => $_getSZ(5);
  @$pb.TagNumber(6)
  set deviceId($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasDeviceId() => $_has(5);
  @$pb.TagNumber(6)
  void clearDeviceId() => $_clearField(6);
}

class CreateFeedbackRequest_Review extends $pb.GeneratedMessage {
  factory CreateFeedbackRequest_Review({
    $core.String? text,
    $core.int? stars,
    $core.Iterable<$core.String>? tags,
  }) {
    final result = create();
    if (text != null) result.text = text;
    if (stars != null) result.stars = stars;
    if (tags != null) result.tags.addAll(tags);
    return result;
  }

  CreateFeedbackRequest_Review._();

  factory CreateFeedbackRequest_Review.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateFeedbackRequest_Review.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFeedbackRequest.Review',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'text')
    ..aI(2, _omitFieldNames ? '' : 'stars')
    ..pPS(3, _omitFieldNames ? '' : 'tags')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedbackRequest_Review clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedbackRequest_Review copyWith(
          void Function(CreateFeedbackRequest_Review) updates) =>
      super.copyWith(
              (message) => updates(message as CreateFeedbackRequest_Review))
          as CreateFeedbackRequest_Review;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFeedbackRequest_Review create() =>
      CreateFeedbackRequest_Review._();
  @$core.override
  CreateFeedbackRequest_Review createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateFeedbackRequest_Review getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFeedbackRequest_Review>(create);
  static CreateFeedbackRequest_Review? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get text => $_getSZ(0);
  @$pb.TagNumber(1)
  set text($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasText() => $_has(0);
  @$pb.TagNumber(1)
  void clearText() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get stars => $_getIZ(1);
  @$pb.TagNumber(2)
  set stars($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasStars() => $_has(1);
  @$pb.TagNumber(2)
  void clearStars() => $_clearField(2);

  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get tags => $_getList(2);
}

class CreateFeedbackRequest extends $pb.GeneratedMessage {
  factory CreateFeedbackRequest({
    $core.String? reviewText,
    CreateFeedbackRequest_Context? context,
    CreateFeedbackRequest_Review? review,
  }) {
    final result = create();
    if (reviewText != null) result.reviewText = reviewText;
    if (context != null) result.context = context;
    if (review != null) result.review = review;
    return result;
  }

  CreateFeedbackRequest._();

  factory CreateFeedbackRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CreateFeedbackRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CreateFeedbackRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'reviewText', protoName: 'reviewText')
    ..aOM<CreateFeedbackRequest_Context>(2, _omitFieldNames ? '' : 'context',
        subBuilder: CreateFeedbackRequest_Context.create)
    ..aOM<CreateFeedbackRequest_Review>(3, _omitFieldNames ? '' : 'review',
        subBuilder: CreateFeedbackRequest_Review.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedbackRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CreateFeedbackRequest copyWith(
          void Function(CreateFeedbackRequest) updates) =>
      super.copyWith((message) => updates(message as CreateFeedbackRequest))
          as CreateFeedbackRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CreateFeedbackRequest create() => CreateFeedbackRequest._();
  @$core.override
  CreateFeedbackRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static CreateFeedbackRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CreateFeedbackRequest>(create);
  static CreateFeedbackRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get reviewText => $_getSZ(0);
  @$pb.TagNumber(1)
  set reviewText($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasReviewText() => $_has(0);
  @$pb.TagNumber(1)
  void clearReviewText() => $_clearField(1);

  @$pb.TagNumber(2)
  CreateFeedbackRequest_Context get context => $_getN(1);
  @$pb.TagNumber(2)
  set context(CreateFeedbackRequest_Context value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasContext() => $_has(1);
  @$pb.TagNumber(2)
  void clearContext() => $_clearField(2);
  @$pb.TagNumber(2)
  CreateFeedbackRequest_Context ensureContext() => $_ensure(1);

  @$pb.TagNumber(3)
  CreateFeedbackRequest_Review get review => $_getN(2);
  @$pb.TagNumber(3)
  set review(CreateFeedbackRequest_Review value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasReview() => $_has(2);
  @$pb.TagNumber(3)
  void clearReview() => $_clearField(3);
  @$pb.TagNumber(3)
  CreateFeedbackRequest_Review ensureReview() => $_ensure(2);
}

class UpdateUserIdRequest extends $pb.GeneratedMessage {
  factory UpdateUserIdRequest({
    $core.String? oldUuid,
    $core.String? newUuid,
  }) {
    final result = create();
    if (oldUuid != null) result.oldUuid = oldUuid;
    if (newUuid != null) result.newUuid = newUuid;
    return result;
  }

  UpdateUserIdRequest._();

  factory UpdateUserIdRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory UpdateUserIdRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'UpdateUserIdRequest',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'balady.protocol'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'oldUuid')
    ..aOS(2, _omitFieldNames ? '' : 'newUuid')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserIdRequest clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  UpdateUserIdRequest copyWith(void Function(UpdateUserIdRequest) updates) =>
      super.copyWith((message) => updates(message as UpdateUserIdRequest))
          as UpdateUserIdRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static UpdateUserIdRequest create() => UpdateUserIdRequest._();
  @$core.override
  UpdateUserIdRequest createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static UpdateUserIdRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<UpdateUserIdRequest>(create);
  static UpdateUserIdRequest? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get oldUuid => $_getSZ(0);
  @$pb.TagNumber(1)
  set oldUuid($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasOldUuid() => $_has(0);
  @$pb.TagNumber(1)
  void clearOldUuid() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.String get newUuid => $_getSZ(1);
  @$pb.TagNumber(2)
  set newUuid($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNewUuid() => $_has(1);
  @$pb.TagNumber(2)
  void clearNewUuid() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
