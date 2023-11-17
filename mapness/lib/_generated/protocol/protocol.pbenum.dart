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

import 'package:protobuf/protobuf.dart' as $pb;

class Env extends $pb.ProtobufEnum {
  static const Env ENV_UNKNOWN = Env._(0, _omitEnumNames ? '' : 'ENV_UNKNOWN');
  static const Env ENV_DEV = Env._(1, _omitEnumNames ? '' : 'ENV_DEV');
  static const Env ENV_SANDBOX = Env._(2, _omitEnumNames ? '' : 'ENV_SANDBOX');
  static const Env ENV_PRODUCTION = Env._(3, _omitEnumNames ? '' : 'ENV_PRODUCTION');

  static const $core.List<Env> values = <Env> [
    ENV_UNKNOWN,
    ENV_DEV,
    ENV_SANDBOX,
    ENV_PRODUCTION,
  ];

  static final $core.Map<$core.int, Env> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Env? valueOf($core.int value) => _byValue[value];

  const Env._($core.int v, $core.String n) : super(v, n);
}

class Error extends $pb.ProtobufEnum {
  static const Error ERROR_UNKNOWN = Error._(0, _omitEnumNames ? '' : 'ERROR_UNKNOWN');
  static const Error ERROR_BAD_REQUEST = Error._(1, _omitEnumNames ? '' : 'ERROR_BAD_REQUEST');
  static const Error ERROR_UNAUTHORIZED = Error._(2, _omitEnumNames ? '' : 'ERROR_UNAUTHORIZED');
  static const Error ERROR_NOT_FOUND = Error._(3, _omitEnumNames ? '' : 'ERROR_NOT_FOUND');
  static const Error ERROR_INTERNAL_SERVER_ERROR = Error._(4, _omitEnumNames ? '' : 'ERROR_INTERNAL_SERVER_ERROR');

  static const $core.List<Error> values = <Error> [
    ERROR_UNKNOWN,
    ERROR_BAD_REQUEST,
    ERROR_UNAUTHORIZED,
    ERROR_NOT_FOUND,
    ERROR_INTERNAL_SERVER_ERROR,
  ];

  static final $core.Map<$core.int, Error> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Error? valueOf($core.int value) => _byValue[value];

  const Error._($core.int v, $core.String n) : super(v, n);
}

class FavouriteItemType extends $pb.ProtobufEnum {
  static const FavouriteItemType FAVOURITE_ITEM_TYPE_UNKNOWN = FavouriteItemType._(0, _omitEnumNames ? '' : 'FAVOURITE_ITEM_TYPE_UNKNOWN');
  static const FavouriteItemType FAVOURITE_ITEM_TYPE_HOME = FavouriteItemType._(1, _omitEnumNames ? '' : 'FAVOURITE_ITEM_TYPE_HOME');
  static const FavouriteItemType FAVOURITE_ITEM_TYPE_WORK = FavouriteItemType._(2, _omitEnumNames ? '' : 'FAVOURITE_ITEM_TYPE_WORK');
  static const FavouriteItemType FAVOURITE_ITEM_TYPE_PLACE = FavouriteItemType._(3, _omitEnumNames ? '' : 'FAVOURITE_ITEM_TYPE_PLACE');

  static const $core.List<FavouriteItemType> values = <FavouriteItemType> [
    FAVOURITE_ITEM_TYPE_UNKNOWN,
    FAVOURITE_ITEM_TYPE_HOME,
    FAVOURITE_ITEM_TYPE_WORK,
    FAVOURITE_ITEM_TYPE_PLACE,
  ];

  static final $core.Map<$core.int, FavouriteItemType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static FavouriteItemType? valueOf($core.int value) => _byValue[value];

  const FavouriteItemType._($core.int v, $core.String n) : super(v, n);
}

class EntitySourceType extends $pb.ProtobufEnum {
  static const EntitySourceType ENTITY_SOURCE_UNKNOWN = EntitySourceType._(0, _omitEnumNames ? '' : 'ENTITY_SOURCE_UNKNOWN');
  static const EntitySourceType ENTITY_SOURCE_URBI = EntitySourceType._(1, _omitEnumNames ? '' : 'ENTITY_SOURCE_URBI');

  static const $core.List<EntitySourceType> values = <EntitySourceType> [
    ENTITY_SOURCE_UNKNOWN,
    ENTITY_SOURCE_URBI,
  ];

  static final $core.Map<$core.int, EntitySourceType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static EntitySourceType? valueOf($core.int value) => _byValue[value];

  const EntitySourceType._($core.int v, $core.String n) : super(v, n);
}

class IWishState extends $pb.ProtobufEnum {
  static const IWishState IWISH_STATE_UNKNOWN = IWishState._(0, _omitEnumNames ? '' : 'IWISH_STATE_UNKNOWN');
  static const IWishState IWISH_STATE_PLANNED = IWishState._(1, _omitEnumNames ? '' : 'IWISH_STATE_PLANNED');
  static const IWishState IWISH_STATE_COMPLETED = IWishState._(2, _omitEnumNames ? '' : 'IWISH_STATE_COMPLETED');

  static const $core.List<IWishState> values = <IWishState> [
    IWISH_STATE_UNKNOWN,
    IWISH_STATE_PLANNED,
    IWISH_STATE_COMPLETED,
  ];

  static final $core.Map<$core.int, IWishState> _byValue = $pb.ProtobufEnum.initByValue(values);
  static IWishState? valueOf($core.int value) => _byValue[value];

  const IWishState._($core.int v, $core.String n) : super(v, n);
}

class IWishCategory extends $pb.ProtobufEnum {
  static const IWishCategory IWISH_CATEGORY_UNKNOWN = IWishCategory._(0, _omitEnumNames ? '' : 'IWISH_CATEGORY_UNKNOWN');
  static const IWishCategory IWISH_CATEGORY_JOY_PARKS = IWishCategory._(1, _omitEnumNames ? '' : 'IWISH_CATEGORY_JOY_PARKS');

  static const $core.List<IWishCategory> values = <IWishCategory> [
    IWISH_CATEGORY_UNKNOWN,
    IWISH_CATEGORY_JOY_PARKS,
  ];

  static final $core.Map<$core.int, IWishCategory> _byValue = $pb.ProtobufEnum.initByValue(values);
  static IWishCategory? valueOf($core.int value) => _byValue[value];

  const IWishCategory._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
