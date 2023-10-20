//
//  Generated code. Do not modify.
//  source: protocol.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import 'protocol.pbenum.dart';

export 'protocol.pbenum.dart';

class Timestamp extends $pb.GeneratedMessage {
  factory Timestamp({
    $fixnum.Int64? value,
  }) {
    final $result = create();
    if (value != null) {
      $result.value = value;
    }
    return $result;
  }
  Timestamp._() : super();
  factory Timestamp.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Timestamp.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Timestamp', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aInt64(1, _omitFieldNames ? '' : 'value')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Timestamp clone() => Timestamp()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Timestamp copyWith(void Function(Timestamp) updates) => super.copyWith((message) => updates(message as Timestamp)) as Timestamp;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Timestamp create() => Timestamp._();
  Timestamp createEmptyInstance() => create();
  static $pb.PbList<Timestamp> createRepeated() => $pb.PbList<Timestamp>();
  @$core.pragma('dart2js:noInline')
  static Timestamp getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Timestamp>(create);
  static Timestamp? _defaultInstance;

  @$pb.TagNumber(1)
  $fixnum.Int64 get value => $_getI64(0);
  @$pb.TagNumber(1)
  set value($fixnum.Int64 v) { $_setInt64(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasValue() => $_has(0);
  @$pb.TagNumber(1)
  void clearValue() => clearField(1);
}

class Image extends $pb.GeneratedMessage {
  factory Image({
    $core.String? url,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    return $result;
  }
  Image._() : super();
  factory Image.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Image.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Image', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Image clone() => Image()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Image copyWith(void Function(Image) updates) => super.copyWith((message) => updates(message as Image)) as Image;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Image create() => Image._();
  Image createEmptyInstance() => create();
  static $pb.PbList<Image> createRepeated() => $pb.PbList<Image>();
  @$core.pragma('dart2js:noInline')
  static Image getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Image>(create);
  static Image? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);
}

class Point extends $pb.GeneratedMessage {
  factory Point({
    $core.double? latitude,
    $core.double? longitude,
  }) {
    final $result = create();
    if (latitude != null) {
      $result.latitude = latitude;
    }
    if (longitude != null) {
      $result.longitude = longitude;
    }
    return $result;
  }
  Point._() : super();
  factory Point.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Point.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Point', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..a<$core.double>(1, _omitFieldNames ? '' : 'latitude', $pb.PbFieldType.OD)
    ..a<$core.double>(2, _omitFieldNames ? '' : 'longitude', $pb.PbFieldType.OD)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Point clone() => Point()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Point copyWith(void Function(Point) updates) => super.copyWith((message) => updates(message as Point)) as Point;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Point create() => Point._();
  Point createEmptyInstance() => create();
  static $pb.PbList<Point> createRepeated() => $pb.PbList<Point>();
  @$core.pragma('dart2js:noInline')
  static Point getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Point>(create);
  static Point? _defaultInstance;

  @$pb.TagNumber(1)
  $core.double get latitude => $_getN(0);
  @$pb.TagNumber(1)
  set latitude($core.double v) { $_setDouble(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasLatitude() => $_has(0);
  @$pb.TagNumber(1)
  void clearLatitude() => clearField(1);

  @$pb.TagNumber(2)
  $core.double get longitude => $_getN(1);
  @$pb.TagNumber(2)
  set longitude($core.double v) { $_setDouble(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasLongitude() => $_has(1);
  @$pb.TagNumber(2)
  void clearLongitude() => clearField(2);
}

class ErrorResponse_ErrorMessage extends $pb.GeneratedMessage {
  factory ErrorResponse_ErrorMessage({
    Error? type,
    $core.int? intCode,
    $core.String? message,
    $core.String? systemMessage,
  }) {
    final $result = create();
    if (type != null) {
      $result.type = type;
    }
    if (intCode != null) {
      $result.intCode = intCode;
    }
    if (message != null) {
      $result.message = message;
    }
    if (systemMessage != null) {
      $result.systemMessage = systemMessage;
    }
    return $result;
  }
  ErrorResponse_ErrorMessage._() : super();
  factory ErrorResponse_ErrorMessage.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ErrorResponse_ErrorMessage.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ErrorResponse.ErrorMessage', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..e<Error>(1, _omitFieldNames ? '' : 'type', $pb.PbFieldType.OE, defaultOrMaker: Error.ERROR_UNKNOWN, valueOf: Error.valueOf, enumValues: Error.values)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'intCode', $pb.PbFieldType.O3)
    ..aOS(3, _omitFieldNames ? '' : 'message')
    ..aOS(4, _omitFieldNames ? '' : 'systemMessage')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ErrorResponse_ErrorMessage clone() => ErrorResponse_ErrorMessage()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ErrorResponse_ErrorMessage copyWith(void Function(ErrorResponse_ErrorMessage) updates) => super.copyWith((message) => updates(message as ErrorResponse_ErrorMessage)) as ErrorResponse_ErrorMessage;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorResponse_ErrorMessage create() => ErrorResponse_ErrorMessage._();
  ErrorResponse_ErrorMessage createEmptyInstance() => create();
  static $pb.PbList<ErrorResponse_ErrorMessage> createRepeated() => $pb.PbList<ErrorResponse_ErrorMessage>();
  @$core.pragma('dart2js:noInline')
  static ErrorResponse_ErrorMessage getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ErrorResponse_ErrorMessage>(create);
  static ErrorResponse_ErrorMessage? _defaultInstance;

  @$pb.TagNumber(1)
  Error get type => $_getN(0);
  @$pb.TagNumber(1)
  set type(Error v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasType() => $_has(0);
  @$pb.TagNumber(1)
  void clearType() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get intCode => $_getIZ(1);
  @$pb.TagNumber(2)
  set intCode($core.int v) { $_setSignedInt32(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasIntCode() => $_has(1);
  @$pb.TagNumber(2)
  void clearIntCode() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get message => $_getSZ(2);
  @$pb.TagNumber(3)
  set message($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasMessage() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessage() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get systemMessage => $_getSZ(3);
  @$pb.TagNumber(4)
  set systemMessage($core.String v) { $_setString(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasSystemMessage() => $_has(3);
  @$pb.TagNumber(4)
  void clearSystemMessage() => clearField(4);
}

class ErrorResponse extends $pb.GeneratedMessage {
  factory ErrorResponse({
    ErrorResponse_ErrorMessage? error,
  }) {
    final $result = create();
    if (error != null) {
      $result.error = error;
    }
    return $result;
  }
  ErrorResponse._() : super();
  factory ErrorResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ErrorResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ErrorResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOM<ErrorResponse_ErrorMessage>(2, _omitFieldNames ? '' : 'error', subBuilder: ErrorResponse_ErrorMessage.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ErrorResponse clone() => ErrorResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ErrorResponse copyWith(void Function(ErrorResponse) updates) => super.copyWith((message) => updates(message as ErrorResponse)) as ErrorResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ErrorResponse create() => ErrorResponse._();
  ErrorResponse createEmptyInstance() => create();
  static $pb.PbList<ErrorResponse> createRepeated() => $pb.PbList<ErrorResponse>();
  @$core.pragma('dart2js:noInline')
  static ErrorResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ErrorResponse>(create);
  static ErrorResponse? _defaultInstance;

  @$pb.TagNumber(2)
  ErrorResponse_ErrorMessage get error => $_getN(0);
  @$pb.TagNumber(2)
  set error(ErrorResponse_ErrorMessage v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(2)
  void clearError() => clearField(2);
  @$pb.TagNumber(2)
  ErrorResponse_ErrorMessage ensureError() => $_ensure(0);
}

class OkResponse extends $pb.GeneratedMessage {
  factory OkResponse({
    $core.int? code,
  }) {
    final $result = create();
    if (code != null) {
      $result.code = code;
    }
    return $result;
  }
  OkResponse._() : super();
  factory OkResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory OkResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'OkResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'code', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  OkResponse clone() => OkResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  OkResponse copyWith(void Function(OkResponse) updates) => super.copyWith((message) => updates(message as OkResponse)) as OkResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static OkResponse create() => OkResponse._();
  OkResponse createEmptyInstance() => create();
  static $pb.PbList<OkResponse> createRepeated() => $pb.PbList<OkResponse>();
  @$core.pragma('dart2js:noInline')
  static OkResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<OkResponse>(create);
  static OkResponse? _defaultInstance;

  @$pb.TagNumber(2)
  $core.int get code => $_getIZ(0);
  @$pb.TagNumber(2)
  set code($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(2)
  $core.bool hasCode() => $_has(0);
  @$pb.TagNumber(2)
  void clearCode() => clearField(2);
}

class Story_Preview extends $pb.GeneratedMessage {
  factory Story_Preview({
    Image? image,
    $core.String? title,
  }) {
    final $result = create();
    if (image != null) {
      $result.image = image;
    }
    if (title != null) {
      $result.title = title;
    }
    return $result;
  }
  Story_Preview._() : super();
  factory Story_Preview.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Story_Preview.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Story.Preview', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOM<Image>(1, _omitFieldNames ? '' : 'image', subBuilder: Image.create)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Story_Preview clone() => Story_Preview()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Story_Preview copyWith(void Function(Story_Preview) updates) => super.copyWith((message) => updates(message as Story_Preview)) as Story_Preview;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Preview create() => Story_Preview._();
  Story_Preview createEmptyInstance() => create();
  static $pb.PbList<Story_Preview> createRepeated() => $pb.PbList<Story_Preview>();
  @$core.pragma('dart2js:noInline')
  static Story_Preview getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Story_Preview>(create);
  static Story_Preview? _defaultInstance;

  @$pb.TagNumber(1)
  Image get image => $_getN(0);
  @$pb.TagNumber(1)
  set image(Image v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasImage() => $_has(0);
  @$pb.TagNumber(1)
  void clearImage() => clearField(1);
  @$pb.TagNumber(1)
  Image ensureImage() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);
}

class Story_Frame_ActionButton_Call extends $pb.GeneratedMessage {
  factory Story_Frame_ActionButton_Call({
    $core.String? phone,
  }) {
    final $result = create();
    if (phone != null) {
      $result.phone = phone;
    }
    return $result;
  }
  Story_Frame_ActionButton_Call._() : super();
  factory Story_Frame_ActionButton_Call.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Story_Frame_ActionButton_Call.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Story.Frame.ActionButton.Call', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'phone')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton_Call clone() => Story_Frame_ActionButton_Call()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton_Call copyWith(void Function(Story_Frame_ActionButton_Call) updates) => super.copyWith((message) => updates(message as Story_Frame_ActionButton_Call)) as Story_Frame_ActionButton_Call;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_Call create() => Story_Frame_ActionButton_Call._();
  Story_Frame_ActionButton_Call createEmptyInstance() => create();
  static $pb.PbList<Story_Frame_ActionButton_Call> createRepeated() => $pb.PbList<Story_Frame_ActionButton_Call>();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_Call getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Story_Frame_ActionButton_Call>(create);
  static Story_Frame_ActionButton_Call? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get phone => $_getSZ(0);
  @$pb.TagNumber(1)
  set phone($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasPhone() => $_has(0);
  @$pb.TagNumber(1)
  void clearPhone() => clearField(1);
}

class Story_Frame_ActionButton_ExternalUrl extends $pb.GeneratedMessage {
  factory Story_Frame_ActionButton_ExternalUrl({
    $core.String? url,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    return $result;
  }
  Story_Frame_ActionButton_ExternalUrl._() : super();
  factory Story_Frame_ActionButton_ExternalUrl.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Story_Frame_ActionButton_ExternalUrl.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Story.Frame.ActionButton.ExternalUrl', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton_ExternalUrl clone() => Story_Frame_ActionButton_ExternalUrl()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton_ExternalUrl copyWith(void Function(Story_Frame_ActionButton_ExternalUrl) updates) => super.copyWith((message) => updates(message as Story_Frame_ActionButton_ExternalUrl)) as Story_Frame_ActionButton_ExternalUrl;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_ExternalUrl create() => Story_Frame_ActionButton_ExternalUrl._();
  Story_Frame_ActionButton_ExternalUrl createEmptyInstance() => create();
  static $pb.PbList<Story_Frame_ActionButton_ExternalUrl> createRepeated() => $pb.PbList<Story_Frame_ActionButton_ExternalUrl>();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_ExternalUrl getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Story_Frame_ActionButton_ExternalUrl>(create);
  static Story_Frame_ActionButton_ExternalUrl? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);
}

class Story_Frame_ActionButton_OpenCard extends $pb.GeneratedMessage {
  factory Story_Frame_ActionButton_OpenCard({
    $core.String? id,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    return $result;
  }
  Story_Frame_ActionButton_OpenCard._() : super();
  factory Story_Frame_ActionButton_OpenCard.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Story_Frame_ActionButton_OpenCard.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Story.Frame.ActionButton.OpenCard', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton_OpenCard clone() => Story_Frame_ActionButton_OpenCard()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton_OpenCard copyWith(void Function(Story_Frame_ActionButton_OpenCard) updates) => super.copyWith((message) => updates(message as Story_Frame_ActionButton_OpenCard)) as Story_Frame_ActionButton_OpenCard;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_OpenCard create() => Story_Frame_ActionButton_OpenCard._();
  Story_Frame_ActionButton_OpenCard createEmptyInstance() => create();
  static $pb.PbList<Story_Frame_ActionButton_OpenCard> createRepeated() => $pb.PbList<Story_Frame_ActionButton_OpenCard>();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_OpenCard getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Story_Frame_ActionButton_OpenCard>(create);
  static Story_Frame_ActionButton_OpenCard? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);
}

class Story_Frame_ActionButton_Deeplink extends $pb.GeneratedMessage {
  factory Story_Frame_ActionButton_Deeplink({
    $core.String? url,
  }) {
    final $result = create();
    if (url != null) {
      $result.url = url;
    }
    return $result;
  }
  Story_Frame_ActionButton_Deeplink._() : super();
  factory Story_Frame_ActionButton_Deeplink.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Story_Frame_ActionButton_Deeplink.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Story.Frame.ActionButton.Deeplink', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'url')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton_Deeplink clone() => Story_Frame_ActionButton_Deeplink()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton_Deeplink copyWith(void Function(Story_Frame_ActionButton_Deeplink) updates) => super.copyWith((message) => updates(message as Story_Frame_ActionButton_Deeplink)) as Story_Frame_ActionButton_Deeplink;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_Deeplink create() => Story_Frame_ActionButton_Deeplink._();
  Story_Frame_ActionButton_Deeplink createEmptyInstance() => create();
  static $pb.PbList<Story_Frame_ActionButton_Deeplink> createRepeated() => $pb.PbList<Story_Frame_ActionButton_Deeplink>();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton_Deeplink getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Story_Frame_ActionButton_Deeplink>(create);
  static Story_Frame_ActionButton_Deeplink? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get url => $_getSZ(0);
  @$pb.TagNumber(1)
  set url($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasUrl() => $_has(0);
  @$pb.TagNumber(1)
  void clearUrl() => clearField(1);
}

enum Story_Frame_ActionButton_Action {
  call, 
  externalUrl, 
  openCard, 
  deeplink, 
  notSet
}

class Story_Frame_ActionButton extends $pb.GeneratedMessage {
  factory Story_Frame_ActionButton({
    $core.String? title,
    Story_Frame_ActionButton_Call? call,
    Story_Frame_ActionButton_ExternalUrl? externalUrl,
    Story_Frame_ActionButton_OpenCard? openCard,
    Story_Frame_ActionButton_Deeplink? deeplink,
  }) {
    final $result = create();
    if (title != null) {
      $result.title = title;
    }
    if (call != null) {
      $result.call = call;
    }
    if (externalUrl != null) {
      $result.externalUrl = externalUrl;
    }
    if (openCard != null) {
      $result.openCard = openCard;
    }
    if (deeplink != null) {
      $result.deeplink = deeplink;
    }
    return $result;
  }
  Story_Frame_ActionButton._() : super();
  factory Story_Frame_ActionButton.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Story_Frame_ActionButton.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static const $core.Map<$core.int, Story_Frame_ActionButton_Action> _Story_Frame_ActionButton_ActionByTag = {
    2 : Story_Frame_ActionButton_Action.call,
    3 : Story_Frame_ActionButton_Action.externalUrl,
    4 : Story_Frame_ActionButton_Action.openCard,
    5 : Story_Frame_ActionButton_Action.deeplink,
    0 : Story_Frame_ActionButton_Action.notSet
  };
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Story.Frame.ActionButton', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..oo(0, [2, 3, 4, 5])
    ..aOS(1, _omitFieldNames ? '' : 'title')
    ..aOM<Story_Frame_ActionButton_Call>(2, _omitFieldNames ? '' : 'call', subBuilder: Story_Frame_ActionButton_Call.create)
    ..aOM<Story_Frame_ActionButton_ExternalUrl>(3, _omitFieldNames ? '' : 'externalUrl', subBuilder: Story_Frame_ActionButton_ExternalUrl.create)
    ..aOM<Story_Frame_ActionButton_OpenCard>(4, _omitFieldNames ? '' : 'openCard', subBuilder: Story_Frame_ActionButton_OpenCard.create)
    ..aOM<Story_Frame_ActionButton_Deeplink>(5, _omitFieldNames ? '' : 'deeplink', subBuilder: Story_Frame_ActionButton_Deeplink.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton clone() => Story_Frame_ActionButton()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Story_Frame_ActionButton copyWith(void Function(Story_Frame_ActionButton) updates) => super.copyWith((message) => updates(message as Story_Frame_ActionButton)) as Story_Frame_ActionButton;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton create() => Story_Frame_ActionButton._();
  Story_Frame_ActionButton createEmptyInstance() => create();
  static $pb.PbList<Story_Frame_ActionButton> createRepeated() => $pb.PbList<Story_Frame_ActionButton>();
  @$core.pragma('dart2js:noInline')
  static Story_Frame_ActionButton getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Story_Frame_ActionButton>(create);
  static Story_Frame_ActionButton? _defaultInstance;

  Story_Frame_ActionButton_Action whichAction() => _Story_Frame_ActionButton_ActionByTag[$_whichOneof(0)]!;
  void clearAction() => clearField($_whichOneof(0));

  @$pb.TagNumber(1)
  $core.String get title => $_getSZ(0);
  @$pb.TagNumber(1)
  set title($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasTitle() => $_has(0);
  @$pb.TagNumber(1)
  void clearTitle() => clearField(1);

  @$pb.TagNumber(2)
  Story_Frame_ActionButton_Call get call => $_getN(1);
  @$pb.TagNumber(2)
  set call(Story_Frame_ActionButton_Call v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasCall() => $_has(1);
  @$pb.TagNumber(2)
  void clearCall() => clearField(2);
  @$pb.TagNumber(2)
  Story_Frame_ActionButton_Call ensureCall() => $_ensure(1);

  @$pb.TagNumber(3)
  Story_Frame_ActionButton_ExternalUrl get externalUrl => $_getN(2);
  @$pb.TagNumber(3)
  set externalUrl(Story_Frame_ActionButton_ExternalUrl v) { setField(3, v); }
  @$pb.TagNumber(3)
  $core.bool hasExternalUrl() => $_has(2);
  @$pb.TagNumber(3)
  void clearExternalUrl() => clearField(3);
  @$pb.TagNumber(3)
  Story_Frame_ActionButton_ExternalUrl ensureExternalUrl() => $_ensure(2);

  @$pb.TagNumber(4)
  Story_Frame_ActionButton_OpenCard get openCard => $_getN(3);
  @$pb.TagNumber(4)
  set openCard(Story_Frame_ActionButton_OpenCard v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasOpenCard() => $_has(3);
  @$pb.TagNumber(4)
  void clearOpenCard() => clearField(4);
  @$pb.TagNumber(4)
  Story_Frame_ActionButton_OpenCard ensureOpenCard() => $_ensure(3);

  @$pb.TagNumber(5)
  Story_Frame_ActionButton_Deeplink get deeplink => $_getN(4);
  @$pb.TagNumber(5)
  set deeplink(Story_Frame_ActionButton_Deeplink v) { setField(5, v); }
  @$pb.TagNumber(5)
  $core.bool hasDeeplink() => $_has(4);
  @$pb.TagNumber(5)
  void clearDeeplink() => clearField(5);
  @$pb.TagNumber(5)
  Story_Frame_ActionButton_Deeplink ensureDeeplink() => $_ensure(4);
}

class Story_Frame extends $pb.GeneratedMessage {
  factory Story_Frame({
    Image? background,
    $core.String? title,
    $core.String? description,
    Story_Frame_ActionButton? actionButton,
    $core.bool? isViewed,
  }) {
    final $result = create();
    if (background != null) {
      $result.background = background;
    }
    if (title != null) {
      $result.title = title;
    }
    if (description != null) {
      $result.description = description;
    }
    if (actionButton != null) {
      $result.actionButton = actionButton;
    }
    if (isViewed != null) {
      $result.isViewed = isViewed;
    }
    return $result;
  }
  Story_Frame._() : super();
  factory Story_Frame.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Story_Frame.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Story.Frame', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOM<Image>(1, _omitFieldNames ? '' : 'background', subBuilder: Image.create)
    ..aOS(2, _omitFieldNames ? '' : 'title')
    ..aOS(3, _omitFieldNames ? '' : 'description')
    ..aOM<Story_Frame_ActionButton>(4, _omitFieldNames ? '' : 'actionButton', subBuilder: Story_Frame_ActionButton.create)
    ..aOB(5, _omitFieldNames ? '' : 'isViewed')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Story_Frame clone() => Story_Frame()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Story_Frame copyWith(void Function(Story_Frame) updates) => super.copyWith((message) => updates(message as Story_Frame)) as Story_Frame;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story_Frame create() => Story_Frame._();
  Story_Frame createEmptyInstance() => create();
  static $pb.PbList<Story_Frame> createRepeated() => $pb.PbList<Story_Frame>();
  @$core.pragma('dart2js:noInline')
  static Story_Frame getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Story_Frame>(create);
  static Story_Frame? _defaultInstance;

  @$pb.TagNumber(1)
  Image get background => $_getN(0);
  @$pb.TagNumber(1)
  set background(Image v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasBackground() => $_has(0);
  @$pb.TagNumber(1)
  void clearBackground() => clearField(1);
  @$pb.TagNumber(1)
  Image ensureBackground() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.String get title => $_getSZ(1);
  @$pb.TagNumber(2)
  set title($core.String v) { $_setString(1, v); }
  @$pb.TagNumber(2)
  $core.bool hasTitle() => $_has(1);
  @$pb.TagNumber(2)
  void clearTitle() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get description => $_getSZ(2);
  @$pb.TagNumber(3)
  set description($core.String v) { $_setString(2, v); }
  @$pb.TagNumber(3)
  $core.bool hasDescription() => $_has(2);
  @$pb.TagNumber(3)
  void clearDescription() => clearField(3);

  @$pb.TagNumber(4)
  Story_Frame_ActionButton get actionButton => $_getN(3);
  @$pb.TagNumber(4)
  set actionButton(Story_Frame_ActionButton v) { setField(4, v); }
  @$pb.TagNumber(4)
  $core.bool hasActionButton() => $_has(3);
  @$pb.TagNumber(4)
  void clearActionButton() => clearField(4);
  @$pb.TagNumber(4)
  Story_Frame_ActionButton ensureActionButton() => $_ensure(3);

  @$pb.TagNumber(5)
  $core.bool get isViewed => $_getBF(4);
  @$pb.TagNumber(5)
  set isViewed($core.bool v) { $_setBool(4, v); }
  @$pb.TagNumber(5)
  $core.bool hasIsViewed() => $_has(4);
  @$pb.TagNumber(5)
  void clearIsViewed() => clearField(5);
}

class Story extends $pb.GeneratedMessage {
  factory Story({
    $core.String? id,
    Story_Preview? preview,
    $core.Iterable<Story_Frame>? frames,
    $core.bool? isViewed,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (preview != null) {
      $result.preview = preview;
    }
    if (frames != null) {
      $result.frames.addAll(frames);
    }
    if (isViewed != null) {
      $result.isViewed = isViewed;
    }
    return $result;
  }
  Story._() : super();
  factory Story.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory Story.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'Story', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..aOM<Story_Preview>(2, _omitFieldNames ? '' : 'preview', subBuilder: Story_Preview.create)
    ..pc<Story_Frame>(3, _omitFieldNames ? '' : 'frames', $pb.PbFieldType.PM, subBuilder: Story_Frame.create)
    ..aOB(4, _omitFieldNames ? '' : 'isViewed')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  Story clone() => Story()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  Story copyWith(void Function(Story) updates) => super.copyWith((message) => updates(message as Story)) as Story;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Story create() => Story._();
  Story createEmptyInstance() => create();
  static $pb.PbList<Story> createRepeated() => $pb.PbList<Story>();
  @$core.pragma('dart2js:noInline')
  static Story getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Story>(create);
  static Story? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  Story_Preview get preview => $_getN(1);
  @$pb.TagNumber(2)
  set preview(Story_Preview v) { setField(2, v); }
  @$pb.TagNumber(2)
  $core.bool hasPreview() => $_has(1);
  @$pb.TagNumber(2)
  void clearPreview() => clearField(2);
  @$pb.TagNumber(2)
  Story_Preview ensurePreview() => $_ensure(1);

  @$pb.TagNumber(3)
  $core.List<Story_Frame> get frames => $_getList(2);

  @$pb.TagNumber(4)
  $core.bool get isViewed => $_getBF(3);
  @$pb.TagNumber(4)
  set isViewed($core.bool v) { $_setBool(3, v); }
  @$pb.TagNumber(4)
  $core.bool hasIsViewed() => $_has(3);
  @$pb.TagNumber(4)
  void clearIsViewed() => clearField(4);
}

class ViewedStoriesRequest_ViewedStory_ViewedStoryFrame extends $pb.GeneratedMessage {
  factory ViewedStoriesRequest_ViewedStory_ViewedStoryFrame({
    $core.int? index,
  }) {
    final $result = create();
    if (index != null) {
      $result.index = index;
    }
    return $result;
  }
  ViewedStoriesRequest_ViewedStory_ViewedStoryFrame._() : super();
  factory ViewedStoriesRequest_ViewedStory_ViewedStoryFrame.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ViewedStoriesRequest_ViewedStory_ViewedStoryFrame.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ViewedStoriesRequest.ViewedStory.ViewedStoryFrame', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'index', $pb.PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ViewedStoriesRequest_ViewedStory_ViewedStoryFrame clone() => ViewedStoriesRequest_ViewedStory_ViewedStoryFrame()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ViewedStoriesRequest_ViewedStory_ViewedStoryFrame copyWith(void Function(ViewedStoriesRequest_ViewedStory_ViewedStoryFrame) updates) => super.copyWith((message) => updates(message as ViewedStoriesRequest_ViewedStory_ViewedStoryFrame)) as ViewedStoriesRequest_ViewedStory_ViewedStoryFrame;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ViewedStoriesRequest_ViewedStory_ViewedStoryFrame create() => ViewedStoriesRequest_ViewedStory_ViewedStoryFrame._();
  ViewedStoriesRequest_ViewedStory_ViewedStoryFrame createEmptyInstance() => create();
  static $pb.PbList<ViewedStoriesRequest_ViewedStory_ViewedStoryFrame> createRepeated() => $pb.PbList<ViewedStoriesRequest_ViewedStory_ViewedStoryFrame>();
  @$core.pragma('dart2js:noInline')
  static ViewedStoriesRequest_ViewedStory_ViewedStoryFrame getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ViewedStoriesRequest_ViewedStory_ViewedStoryFrame>(create);
  static ViewedStoriesRequest_ViewedStory_ViewedStoryFrame? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get index => $_getIZ(0);
  @$pb.TagNumber(1)
  set index($core.int v) { $_setSignedInt32(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasIndex() => $_has(0);
  @$pb.TagNumber(1)
  void clearIndex() => clearField(1);
}

class ViewedStoriesRequest_ViewedStory extends $pb.GeneratedMessage {
  factory ViewedStoriesRequest_ViewedStory({
    $core.String? id,
    $core.Iterable<ViewedStoriesRequest_ViewedStory_ViewedStoryFrame>? frames,
  }) {
    final $result = create();
    if (id != null) {
      $result.id = id;
    }
    if (frames != null) {
      $result.frames.addAll(frames);
    }
    return $result;
  }
  ViewedStoriesRequest_ViewedStory._() : super();
  factory ViewedStoriesRequest_ViewedStory.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ViewedStoriesRequest_ViewedStory.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ViewedStoriesRequest.ViewedStory', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'id')
    ..pc<ViewedStoriesRequest_ViewedStory_ViewedStoryFrame>(2, _omitFieldNames ? '' : 'frames', $pb.PbFieldType.PM, subBuilder: ViewedStoriesRequest_ViewedStory_ViewedStoryFrame.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ViewedStoriesRequest_ViewedStory clone() => ViewedStoriesRequest_ViewedStory()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ViewedStoriesRequest_ViewedStory copyWith(void Function(ViewedStoriesRequest_ViewedStory) updates) => super.copyWith((message) => updates(message as ViewedStoriesRequest_ViewedStory)) as ViewedStoriesRequest_ViewedStory;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ViewedStoriesRequest_ViewedStory create() => ViewedStoriesRequest_ViewedStory._();
  ViewedStoriesRequest_ViewedStory createEmptyInstance() => create();
  static $pb.PbList<ViewedStoriesRequest_ViewedStory> createRepeated() => $pb.PbList<ViewedStoriesRequest_ViewedStory>();
  @$core.pragma('dart2js:noInline')
  static ViewedStoriesRequest_ViewedStory getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ViewedStoriesRequest_ViewedStory>(create);
  static ViewedStoriesRequest_ViewedStory? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get id => $_getSZ(0);
  @$pb.TagNumber(1)
  set id($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasId() => $_has(0);
  @$pb.TagNumber(1)
  void clearId() => clearField(1);

  @$pb.TagNumber(2)
  $core.List<ViewedStoriesRequest_ViewedStory_ViewedStoryFrame> get frames => $_getList(1);
}

class ViewedStoriesRequest extends $pb.GeneratedMessage {
  factory ViewedStoriesRequest({
    $core.Iterable<ViewedStoriesRequest_ViewedStory>? stories,
  }) {
    final $result = create();
    if (stories != null) {
      $result.stories.addAll(stories);
    }
    return $result;
  }
  ViewedStoriesRequest._() : super();
  factory ViewedStoriesRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory ViewedStoriesRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'ViewedStoriesRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..pc<ViewedStoriesRequest_ViewedStory>(2, _omitFieldNames ? '' : 'stories', $pb.PbFieldType.PM, subBuilder: ViewedStoriesRequest_ViewedStory.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  ViewedStoriesRequest clone() => ViewedStoriesRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  ViewedStoriesRequest copyWith(void Function(ViewedStoriesRequest) updates) => super.copyWith((message) => updates(message as ViewedStoriesRequest)) as ViewedStoriesRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static ViewedStoriesRequest create() => ViewedStoriesRequest._();
  ViewedStoriesRequest createEmptyInstance() => create();
  static $pb.PbList<ViewedStoriesRequest> createRepeated() => $pb.PbList<ViewedStoriesRequest>();
  @$core.pragma('dart2js:noInline')
  static ViewedStoriesRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<ViewedStoriesRequest>(create);
  static ViewedStoriesRequest? _defaultInstance;

  @$pb.TagNumber(2)
  $core.List<ViewedStoriesRequest_ViewedStory> get stories => $_getList(0);
}

class StoriesResponse extends $pb.GeneratedMessage {
  factory StoriesResponse({
    $core.Iterable<Story>? stories,
  }) {
    final $result = create();
    if (stories != null) {
      $result.stories.addAll(stories);
    }
    return $result;
  }
  StoriesResponse._() : super();
  factory StoriesResponse.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory StoriesResponse.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'StoriesResponse', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..pc<Story>(2, _omitFieldNames ? '' : 'stories', $pb.PbFieldType.PM, subBuilder: Story.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  StoriesResponse clone() => StoriesResponse()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  StoriesResponse copyWith(void Function(StoriesResponse) updates) => super.copyWith((message) => updates(message as StoriesResponse)) as StoriesResponse;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static StoriesResponse create() => StoriesResponse._();
  StoriesResponse createEmptyInstance() => create();
  static $pb.PbList<StoriesResponse> createRepeated() => $pb.PbList<StoriesResponse>();
  @$core.pragma('dart2js:noInline')
  static StoriesResponse getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<StoriesResponse>(create);
  static StoriesResponse? _defaultInstance;

  @$pb.TagNumber(2)
  $core.List<Story> get stories => $_getList(0);
}

class HappinessRequest_Tag extends $pb.GeneratedMessage {
  factory HappinessRequest_Tag({
    $core.String? name,
  }) {
    final $result = create();
    if (name != null) {
      $result.name = name;
    }
    return $result;
  }
  HappinessRequest_Tag._() : super();
  factory HappinessRequest_Tag.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HappinessRequest_Tag.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HappinessRequest.Tag', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HappinessRequest_Tag clone() => HappinessRequest_Tag()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HappinessRequest_Tag copyWith(void Function(HappinessRequest_Tag) updates) => super.copyWith((message) => updates(message as HappinessRequest_Tag)) as HappinessRequest_Tag;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HappinessRequest_Tag create() => HappinessRequest_Tag._();
  HappinessRequest_Tag createEmptyInstance() => create();
  static $pb.PbList<HappinessRequest_Tag> createRepeated() => $pb.PbList<HappinessRequest_Tag>();
  @$core.pragma('dart2js:noInline')
  static HappinessRequest_Tag getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HappinessRequest_Tag>(create);
  static HappinessRequest_Tag? _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) { $_setString(0, v); }
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);
}

class HappinessRequest extends $pb.GeneratedMessage {
  factory HappinessRequest({
    Point? point,
    $core.Iterable<HappinessRequest_Tag>? tags,
  }) {
    final $result = create();
    if (point != null) {
      $result.point = point;
    }
    if (tags != null) {
      $result.tags.addAll(tags);
    }
    return $result;
  }
  HappinessRequest._() : super();
  factory HappinessRequest.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory HappinessRequest.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(_omitMessageNames ? '' : 'HappinessRequest', package: const $pb.PackageName(_omitMessageNames ? '' : 'baladi.protocol'), createEmptyInstance: create)
    ..aOM<Point>(1, _omitFieldNames ? '' : 'point', subBuilder: Point.create)
    ..pc<HappinessRequest_Tag>(2, _omitFieldNames ? '' : 'tags', $pb.PbFieldType.PM, subBuilder: HappinessRequest_Tag.create)
    ..hasRequiredFields = false
  ;

  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
  'Will be removed in next major version')
  HappinessRequest clone() => HappinessRequest()..mergeFromMessage(this);
  @$core.Deprecated(
  'Using this can add significant overhead to your binary. '
  'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
  'Will be removed in next major version')
  HappinessRequest copyWith(void Function(HappinessRequest) updates) => super.copyWith((message) => updates(message as HappinessRequest)) as HappinessRequest;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static HappinessRequest create() => HappinessRequest._();
  HappinessRequest createEmptyInstance() => create();
  static $pb.PbList<HappinessRequest> createRepeated() => $pb.PbList<HappinessRequest>();
  @$core.pragma('dart2js:noInline')
  static HappinessRequest getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<HappinessRequest>(create);
  static HappinessRequest? _defaultInstance;

  @$pb.TagNumber(1)
  Point get point => $_getN(0);
  @$pb.TagNumber(1)
  set point(Point v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasPoint() => $_has(0);
  @$pb.TagNumber(1)
  void clearPoint() => clearField(1);
  @$pb.TagNumber(1)
  Point ensurePoint() => $_ensure(0);

  @$pb.TagNumber(2)
  $core.List<HappinessRequest_Tag> get tags => $_getList(1);
}


const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames = $core.bool.fromEnvironment('protobuf.omit_message_names');
