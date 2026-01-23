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

import 'package:protobuf/protobuf.dart' as $pb;

class Env extends $pb.ProtobufEnum {
  static const Env ENV_UNKNOWN = Env._(0, _omitEnumNames ? '' : 'ENV_UNKNOWN');
  static const Env ENV_DEV = Env._(1, _omitEnumNames ? '' : 'ENV_DEV');
  static const Env ENV_SANDBOX = Env._(2, _omitEnumNames ? '' : 'ENV_SANDBOX');
  static const Env ENV_PRODUCTION =
      Env._(3, _omitEnumNames ? '' : 'ENV_PRODUCTION');

  static const $core.List<Env> values = <Env>[
    ENV_UNKNOWN,
    ENV_DEV,
    ENV_SANDBOX,
    ENV_PRODUCTION,
  ];

  static final $core.List<Env?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Env? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Env._(super.value, super.name);
}

class Error extends $pb.ProtobufEnum {
  static const Error ERROR_UNKNOWN =
      Error._(0, _omitEnumNames ? '' : 'ERROR_UNKNOWN');
  static const Error ERROR_BAD_REQUEST =
      Error._(1, _omitEnumNames ? '' : 'ERROR_BAD_REQUEST');
  static const Error ERROR_UNAUTHORIZED =
      Error._(2, _omitEnumNames ? '' : 'ERROR_UNAUTHORIZED');
  static const Error ERROR_NOT_FOUND =
      Error._(3, _omitEnumNames ? '' : 'ERROR_NOT_FOUND');
  static const Error ERROR_INTERNAL_SERVER_ERROR =
      Error._(4, _omitEnumNames ? '' : 'ERROR_INTERNAL_SERVER_ERROR');

  static const $core.List<Error> values = <Error>[
    ERROR_UNKNOWN,
    ERROR_BAD_REQUEST,
    ERROR_UNAUTHORIZED,
    ERROR_NOT_FOUND,
    ERROR_INTERNAL_SERVER_ERROR,
  ];

  static final $core.List<Error?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static Error? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Error._(super.value, super.name);
}

class FavouriteItemType extends $pb.ProtobufEnum {
  static const FavouriteItemType FAVOURITE_ITEM_TYPE_UNKNOWN =
      FavouriteItemType._(
          0, _omitEnumNames ? '' : 'FAVOURITE_ITEM_TYPE_UNKNOWN');
  static const FavouriteItemType FAVOURITE_ITEM_TYPE_HOME =
      FavouriteItemType._(1, _omitEnumNames ? '' : 'FAVOURITE_ITEM_TYPE_HOME');
  static const FavouriteItemType FAVOURITE_ITEM_TYPE_WORK =
      FavouriteItemType._(2, _omitEnumNames ? '' : 'FAVOURITE_ITEM_TYPE_WORK');
  static const FavouriteItemType FAVOURITE_ITEM_TYPE_PLACE =
      FavouriteItemType._(3, _omitEnumNames ? '' : 'FAVOURITE_ITEM_TYPE_PLACE');

  static const $core.List<FavouriteItemType> values = <FavouriteItemType>[
    FAVOURITE_ITEM_TYPE_UNKNOWN,
    FAVOURITE_ITEM_TYPE_HOME,
    FAVOURITE_ITEM_TYPE_WORK,
    FAVOURITE_ITEM_TYPE_PLACE,
  ];

  static final $core.List<FavouriteItemType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static FavouriteItemType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const FavouriteItemType._(super.value, super.name);
}

class EntitySourceType extends $pb.ProtobufEnum {
  static const EntitySourceType ENTITY_SOURCE_UNKNOWN =
      EntitySourceType._(0, _omitEnumNames ? '' : 'ENTITY_SOURCE_UNKNOWN');
  static const EntitySourceType ENTITY_SOURCE_URBI =
      EntitySourceType._(1, _omitEnumNames ? '' : 'ENTITY_SOURCE_URBI');

  static const $core.List<EntitySourceType> values = <EntitySourceType>[
    ENTITY_SOURCE_UNKNOWN,
    ENTITY_SOURCE_URBI,
  ];

  static final $core.List<EntitySourceType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static EntitySourceType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EntitySourceType._(super.value, super.name);
}

class InterestingPlaceTag extends $pb.ProtobufEnum {
  static const InterestingPlaceTag INTERESTING_PLACE_CATEGORY_UNKNOWN =
      InterestingPlaceTag._(
          0, _omitEnumNames ? '' : 'INTERESTING_PLACE_CATEGORY_UNKNOWN');
  static const InterestingPlaceTag INTERESTING_PLACE_CATEGORY_IMMERSIVE_MODEL =
      InterestingPlaceTag._(1,
          _omitEnumNames ? '' : 'INTERESTING_PLACE_CATEGORY_IMMERSIVE_MODEL');
  static const InterestingPlaceTag INTERESTING_PLACE_CATEGORY_FLOORS =
      InterestingPlaceTag._(
          2, _omitEnumNames ? '' : 'INTERESTING_PLACE_CATEGORY_FLOORS');

  static const $core.List<InterestingPlaceTag> values = <InterestingPlaceTag>[
    INTERESTING_PLACE_CATEGORY_UNKNOWN,
    INTERESTING_PLACE_CATEGORY_IMMERSIVE_MODEL,
    INTERESTING_PLACE_CATEGORY_FLOORS,
  ];

  static final $core.List<InterestingPlaceTag?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static InterestingPlaceTag? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const InterestingPlaceTag._(super.value, super.name);
}

class IWishState extends $pb.ProtobufEnum {
  static const IWishState IWISH_STATE_UNKNOWN =
      IWishState._(0, _omitEnumNames ? '' : 'IWISH_STATE_UNKNOWN');
  static const IWishState IWISH_STATE_PLANNED =
      IWishState._(1, _omitEnumNames ? '' : 'IWISH_STATE_PLANNED');
  static const IWishState IWISH_STATE_COMPLETED =
      IWishState._(2, _omitEnumNames ? '' : 'IWISH_STATE_COMPLETED');

  static const $core.List<IWishState> values = <IWishState>[
    IWISH_STATE_UNKNOWN,
    IWISH_STATE_PLANNED,
    IWISH_STATE_COMPLETED,
  ];

  static final $core.List<IWishState?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static IWishState? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IWishState._(super.value, super.name);
}

class IWishSize extends $pb.ProtobufEnum {
  static const IWishSize IWISH_SIZE_UNKNOWN =
      IWishSize._(0, _omitEnumNames ? '' : 'IWISH_SIZE_UNKNOWN');
  static const IWishSize IWISH_SIZE_NONE =
      IWishSize._(1, _omitEnumNames ? '' : 'IWISH_SIZE_NONE');
  static const IWishSize IWISH_SIZE_SMALL =
      IWishSize._(2, _omitEnumNames ? '' : 'IWISH_SIZE_SMALL');
  static const IWishSize IWISH_SIZE_MEDIUM =
      IWishSize._(3, _omitEnumNames ? '' : 'IWISH_SIZE_MEDIUM');
  static const IWishSize IWISH_SIZE_LARGE =
      IWishSize._(4, _omitEnumNames ? '' : 'IWISH_SIZE_LARGE');

  static const $core.List<IWishSize> values = <IWishSize>[
    IWISH_SIZE_UNKNOWN,
    IWISH_SIZE_NONE,
    IWISH_SIZE_SMALL,
    IWISH_SIZE_MEDIUM,
    IWISH_SIZE_LARGE,
  ];

  static final $core.List<IWishSize?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 4);
  static IWishSize? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IWishSize._(super.value, super.name);
}

class IWishCategory extends $pb.ProtobufEnum {
  static const IWishCategory IWISH_CATEGORY_UNKNOWN =
      IWishCategory._(0, _omitEnumNames ? '' : 'IWISH_CATEGORY_UNKNOWN');
  static const IWishCategory IWISH_CATEGORY_JOY_PARKS =
      IWishCategory._(1, _omitEnumNames ? '' : 'IWISH_CATEGORY_JOY_PARKS');

  static const $core.List<IWishCategory> values = <IWishCategory>[
    IWISH_CATEGORY_UNKNOWN,
    IWISH_CATEGORY_JOY_PARKS,
  ];

  static final $core.List<IWishCategory?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static IWishCategory? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IWishCategory._(super.value, super.name);
}

class IWishFeedbackRating extends $pb.ProtobufEnum {
  static const IWishFeedbackRating IWISH_FEEDBACK_RATING_HAPPY =
      IWishFeedbackRating._(
          0, _omitEnumNames ? '' : 'IWISH_FEEDBACK_RATING_HAPPY');
  static const IWishFeedbackRating IWISH_FEEDBACK_RATING_NEUTRAL =
      IWishFeedbackRating._(
          1, _omitEnumNames ? '' : 'IWISH_FEEDBACK_RATING_NEUTRAL');
  static const IWishFeedbackRating IWISH_FEEDBACK_RATING_UPSET =
      IWishFeedbackRating._(
          2, _omitEnumNames ? '' : 'IWISH_FEEDBACK_RATING_UPSET');

  static const $core.List<IWishFeedbackRating> values = <IWishFeedbackRating>[
    IWISH_FEEDBACK_RATING_HAPPY,
    IWISH_FEEDBACK_RATING_NEUTRAL,
    IWISH_FEEDBACK_RATING_UPSET,
  ];

  static final $core.List<IWishFeedbackRating?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static IWishFeedbackRating? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const IWishFeedbackRating._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
