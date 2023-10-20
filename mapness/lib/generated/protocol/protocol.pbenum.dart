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


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
