//
//  Generated code. Do not modify.
//  source: protocol.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use envDescriptor instead')
const Env$json = {
  '1': 'Env',
  '2': [
    {'1': 'ENV_UNKNOWN', '2': 0},
    {'1': 'ENV_DEV', '2': 1},
    {'1': 'ENV_SANDBOX', '2': 2},
    {'1': 'ENV_PRODUCTION', '2': 3},
  ],
};

/// Descriptor for `Env`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List envDescriptor =
    $convert.base64Decode('CgNFbnYSDwoLRU5WX1VOS05PV04QABILCgdFTlZfREVWEAESDwoLRU5WX1NBTkRCT1gQAhISCg'
        '5FTlZfUFJPRFVDVElPThAD');

@$core.Deprecated('Use errorDescriptor instead')
const Error$json = {
  '1': 'Error',
  '2': [
    {'1': 'ERROR_UNKNOWN', '2': 0},
    {'1': 'ERROR_BAD_REQUEST', '2': 1},
    {'1': 'ERROR_UNAUTHORIZED', '2': 2},
    {'1': 'ERROR_NOT_FOUND', '2': 3},
    {'1': 'ERROR_INTERNAL_SERVER_ERROR', '2': 4},
  ],
};

/// Descriptor for `Error`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List errorDescriptor =
    $convert.base64Decode('CgVFcnJvchIRCg1FUlJPUl9VTktOT1dOEAASFQoRRVJST1JfQkFEX1JFUVVFU1QQARIWChJFUl'
        'JPUl9VTkFVVEhPUklaRUQQAhITCg9FUlJPUl9OT1RfRk9VTkQQAxIfChtFUlJPUl9JTlRFUk5B'
        'TF9TRVJWRVJfRVJST1IQBA==');

@$core.Deprecated('Use favouriteItemTypeDescriptor instead')
const FavouriteItemType$json = {
  '1': 'FavouriteItemType',
  '2': [
    {'1': 'FAVOURITE_ITEM_TYPE_UNKNOWN', '2': 0},
    {'1': 'FAVOURITE_ITEM_TYPE_HOME', '2': 1},
    {'1': 'FAVOURITE_ITEM_TYPE_WORK', '2': 2},
    {'1': 'FAVOURITE_ITEM_TYPE_PLACE', '2': 3},
  ],
};

/// Descriptor for `FavouriteItemType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List favouriteItemTypeDescriptor =
    $convert.base64Decode('ChFGYXZvdXJpdGVJdGVtVHlwZRIfChtGQVZPVVJJVEVfSVRFTV9UWVBFX1VOS05PV04QABIcCh'
        'hGQVZPVVJJVEVfSVRFTV9UWVBFX0hPTUUQARIcChhGQVZPVVJJVEVfSVRFTV9UWVBFX1dPUksQ'
        'AhIdChlGQVZPVVJJVEVfSVRFTV9UWVBFX1BMQUNFEAM=');

@$core.Deprecated('Use entitySourceTypeDescriptor instead')
const EntitySourceType$json = {
  '1': 'EntitySourceType',
  '2': [
    {'1': 'ENTITY_SOURCE_UNKNOWN', '2': 0},
    {'1': 'ENTITY_SOURCE_URBI', '2': 1},
  ],
};

/// Descriptor for `EntitySourceType`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List entitySourceTypeDescriptor =
    $convert.base64Decode('ChBFbnRpdHlTb3VyY2VUeXBlEhkKFUVOVElUWV9TT1VSQ0VfVU5LTk9XThAAEhYKEkVOVElUWV'
        '9TT1VSQ0VfVVJCSRAB');

@$core.Deprecated('Use interestingPlaceTagDescriptor instead')
const InterestingPlaceTag$json = {
  '1': 'InterestingPlaceTag',
  '2': [
    {'1': 'INTERESTING_PLACE_CATEGORY_UNKNOWN', '2': 0},
    {'1': 'INTERESTING_PLACE_CATEGORY_IMMERSIVE_MODEL', '2': 1},
    {'1': 'INTERESTING_PLACE_CATEGORY_FLOORS', '2': 2},
  ],
};

/// Descriptor for `InterestingPlaceTag`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List interestingPlaceTagDescriptor =
    $convert.base64Decode('ChNJbnRlcmVzdGluZ1BsYWNlVGFnEiYKIklOVEVSRVNUSU5HX1BMQUNFX0NBVEVHT1JZX1VOS0'
        '5PV04QABIuCipJTlRFUkVTVElOR19QTEFDRV9DQVRFR09SWV9JTU1FUlNJVkVfTU9ERUwQARIl'
        'CiFJTlRFUkVTVElOR19QTEFDRV9DQVRFR09SWV9GTE9PUlMQAg==');

@$core.Deprecated('Use iWishStateDescriptor instead')
const IWishState$json = {
  '1': 'IWishState',
  '2': [
    {'1': 'IWISH_STATE_UNKNOWN', '2': 0},
    {'1': 'IWISH_STATE_PLANNED', '2': 1},
    {'1': 'IWISH_STATE_COMPLETED', '2': 2},
  ],
};

/// Descriptor for `IWishState`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List iWishStateDescriptor =
    $convert.base64Decode('CgpJV2lzaFN0YXRlEhcKE0lXSVNIX1NUQVRFX1VOS05PV04QABIXChNJV0lTSF9TVEFURV9QTE'
        'FOTkVEEAESGQoVSVdJU0hfU1RBVEVfQ09NUExFVEVEEAI=');

@$core.Deprecated('Use iWishSizeDescriptor instead')
const IWishSize$json = {
  '1': 'IWishSize',
  '2': [
    {'1': 'IWISH_SIZE_UNKNOWN', '2': 0},
    {'1': 'IWISH_SIZE_NONE', '2': 1},
    {'1': 'IWISH_SIZE_SMALL', '2': 2},
    {'1': 'IWISH_SIZE_MEDIUM', '2': 3},
    {'1': 'IWISH_SIZE_LARGE', '2': 4},
  ],
};

/// Descriptor for `IWishSize`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List iWishSizeDescriptor =
    $convert.base64Decode('CglJV2lzaFNpemUSFgoSSVdJU0hfU0laRV9VTktOT1dOEAASEwoPSVdJU0hfU0laRV9OT05FEA'
        'ESFAoQSVdJU0hfU0laRV9TTUFMTBACEhUKEUlXSVNIX1NJWkVfTUVESVVNEAMSFAoQSVdJU0hf'
        'U0laRV9MQVJHRRAE');

@$core.Deprecated('Use iWishCategoryDescriptor instead')
const IWishCategory$json = {
  '1': 'IWishCategory',
  '2': [
    {'1': 'IWISH_CATEGORY_UNKNOWN', '2': 0},
    {'1': 'IWISH_CATEGORY_JOY_PARKS', '2': 1},
  ],
};

/// Descriptor for `IWishCategory`. Decode as a `google.protobuf.EnumDescriptorProto`.
final $typed_data.Uint8List iWishCategoryDescriptor =
    $convert.base64Decode('Cg1JV2lzaENhdGVnb3J5EhoKFklXSVNIX0NBVEVHT1JZX1VOS05PV04QABIcChhJV0lTSF9DQV'
        'RFR09SWV9KT1lfUEFSS1MQAQ==');

@$core.Deprecated('Use timestampDescriptor instead')
const Timestamp$json = {
  '1': 'Timestamp',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 3, '10': 'value'},
  ],
};

/// Descriptor for `Timestamp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timestampDescriptor = $convert.base64Decode('CglUaW1lc3RhbXASFAoFdmFsdWUYASABKANSBXZhbHVl');

@$core.Deprecated('Use imageDescriptor instead')
const Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `Image`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageDescriptor = $convert.base64Decode('CgVJbWFnZRIQCgN1cmwYASABKAlSA3VybA==');

@$core.Deprecated('Use pointDescriptor instead')
const Point$json = {
  '1': 'Point',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `Point`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pointDescriptor =
    $convert.base64Decode('CgVQb2ludBIaCghsYXRpdHVkZRgBIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgASgBUg'
        'lsb25naXR1ZGU=');

@$core.Deprecated('Use colorDescriptor instead')
const Color$json = {
  '1': 'Color',
  '2': [
    {'1': 'hex', '3': 1, '4': 1, '5': 9, '10': 'hex'},
  ],
};

/// Descriptor for `Color`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List colorDescriptor = $convert.base64Decode('CgVDb2xvchIQCgNoZXgYASABKAlSA2hleA==');

@$core.Deprecated('Use textStyleDescriptor instead')
const TextStyle$json = {
  '1': 'TextStyle',
  '2': [
    {'1': 'color', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Color', '10': 'color'},
  ],
};

/// Descriptor for `TextStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textStyleDescriptor =
    $convert.base64Decode('CglUZXh0U3R5bGUSLAoFY29sb3IYASABKAsyFi5iYWxhZHkucHJvdG9jb2wuQ29sb3JSBWNvbG'
        '9y');

@$core.Deprecated('Use errorResponseDescriptor instead')
const ErrorResponse$json = {
  '1': 'ErrorResponse',
  '2': [
    {'1': 'error', '3': 2, '4': 1, '5': 11, '6': '.balady.protocol.ErrorResponse.ErrorMessage', '10': 'error'},
  ],
  '3': [ErrorResponse_ErrorMessage$json],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use errorResponseDescriptor instead')
const ErrorResponse_ErrorMessage$json = {
  '1': 'ErrorMessage',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.balady.protocol.Error', '10': 'type'},
    {'1': 'int_code', '3': 2, '4': 1, '5': 5, '10': 'intCode'},
    {'1': 'message', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'message', '17': true},
    {'1': 'system_message', '3': 4, '4': 1, '5': 9, '9': 1, '10': 'systemMessage', '17': true},
  ],
  '8': [
    {'1': '_message'},
    {'1': '_system_message'},
  ],
};

/// Descriptor for `ErrorResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List errorResponseDescriptor =
    $convert.base64Decode('Cg1FcnJvclJlc3BvbnNlEkEKBWVycm9yGAIgASgLMisuYmFsYWR5LnByb3RvY29sLkVycm9yUm'
        'VzcG9uc2UuRXJyb3JNZXNzYWdlUgVlcnJvchq/AQoMRXJyb3JNZXNzYWdlEioKBHR5cGUYASAB'
        'KA4yFi5iYWxhZHkucHJvdG9jb2wuRXJyb3JSBHR5cGUSGQoIaW50X2NvZGUYAiABKAVSB2ludE'
        'NvZGUSHQoHbWVzc2FnZRgDIAEoCUgAUgdtZXNzYWdliAEBEioKDnN5c3RlbV9tZXNzYWdlGAQg'
        'ASgJSAFSDXN5c3RlbU1lc3NhZ2WIAQFCCgoIX21lc3NhZ2VCEQoPX3N5c3RlbV9tZXNzYWdlSg'
        'QIARAC');

@$core.Deprecated('Use okResponseDescriptor instead')
const OkResponse$json = {
  '1': 'OkResponse',
  '2': [
    {'1': 'code', '3': 2, '4': 1, '5': 5, '10': 'code'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

/// Descriptor for `OkResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List okResponseDescriptor =
    $convert.base64Decode('CgpPa1Jlc3BvbnNlEhIKBGNvZGUYAiABKAVSBGNvZGVKBAgBEAI=');

@$core.Deprecated('Use storyDescriptor instead')
const Story$json = {
  '1': 'Story',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'preview', '3': 2, '4': 1, '5': 11, '6': '.balady.protocol.Story.Preview', '10': 'preview'},
    {'1': 'frames', '3': 3, '4': 3, '5': 11, '6': '.balady.protocol.Story.Frame', '10': 'frames'},
    {'1': 'is_viewed', '3': 4, '4': 1, '5': 8, '10': 'isViewed'},
    {'1': 'activate_every_n_launches', '3': 5, '4': 1, '5': 5, '9': 0, '10': 'activateEveryNLaunches', '17': true},
  ],
  '3': [Story_Preview$json, Story_Frame$json],
  '8': [
    {'1': '_activate_every_n_launches'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Preview$json = {
  '1': 'Preview',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Image', '10': 'image'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame$json = {
  '1': 'Frame',
  '2': [
    {'1': 'background', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Image', '10': 'background'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'title', '17': true},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'description', '17': true},
    {
      '1': 'action_button',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.Story.Frame.ActionButton',
      '9': 2,
      '10': 'actionButton',
      '17': true
    },
    {'1': 'is_viewed', '3': 5, '4': 1, '5': 8, '10': 'isViewed'},
    {'1': 'duration', '3': 6, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'style', '3': 7, '4': 1, '5': 11, '6': '.balady.protocol.Story.Frame.Style', '10': 'style'},
    {
      '1': 'content',
      '3': 8,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.Story.Frame.Content',
      '9': 3,
      '10': 'content',
      '17': true
    },
  ],
  '3': [Story_Frame_Content$json, Story_Frame_Style$json, Story_Frame_ActionButton$json],
  '8': [
    {'1': '_title'},
    {'1': '_description'},
    {'1': '_action_button'},
    {'1': '_content'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_Content$json = {
  '1': 'Content',
  '2': [
    {'1': 'images', '3': 1, '4': 3, '5': 11, '6': '.balady.protocol.Image', '10': 'images'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_Style$json = {
  '1': 'Style',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.TextStyle', '9': 0, '10': 'title', '17': true},
    {
      '1': 'description',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.TextStyle',
      '9': 1,
      '10': 'description',
      '17': true
    },
  ],
  '8': [
    {'1': '_title'},
    {'1': '_description'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_ActionButton$json = {
  '1': 'ActionButton',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'link', '3': 2, '4': 1, '5': 11, '6': '.balady.protocol.Story.Frame.ActionButton.Link', '10': 'link'},
    {'1': 'style', '3': 3, '4': 1, '5': 11, '6': '.balady.protocol.Story.Frame.ActionButton.Style', '10': 'style'},
    {'1': 'is_enabled', '3': 4, '4': 1, '5': 8, '10': 'isEnabled'},
  ],
  '3': [Story_Frame_ActionButton_Link$json, Story_Frame_ActionButton_Style$json],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_ActionButton_Link$json = {
  '1': 'Link',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_ActionButton_Style$json = {
  '1': 'Style',
  '2': [
    {
      '1': 'background_color',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.Color',
      '9': 0,
      '10': 'backgroundColor',
      '17': true
    },
    {
      '1': 'text_style',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.TextStyle',
      '9': 1,
      '10': 'textStyle',
      '17': true
    },
  ],
  '8': [
    {'1': '_background_color'},
    {'1': '_text_style'},
  ],
};

/// Descriptor for `Story`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storyDescriptor =
    $convert.base64Decode('CgVTdG9yeRIOCgJpZBgBIAEoCVICaWQSOAoHcHJldmlldxgCIAEoCzIeLmJhbGFkeS5wcm90b2'
        'NvbC5TdG9yeS5QcmV2aWV3UgdwcmV2aWV3EjQKBmZyYW1lcxgDIAMoCzIcLmJhbGFkeS5wcm90'
        'b2NvbC5TdG9yeS5GcmFtZVIGZnJhbWVzEhsKCWlzX3ZpZXdlZBgEIAEoCFIIaXNWaWV3ZWQSPg'
        'oZYWN0aXZhdGVfZXZlcnlfbl9sYXVuY2hlcxgFIAEoBUgAUhZhY3RpdmF0ZUV2ZXJ5TkxhdW5j'
        'aGVziAEBGk0KB1ByZXZpZXcSLAoFaW1hZ2UYASABKAsyFi5iYWxhZHkucHJvdG9jb2wuSW1hZ2'
        'VSBWltYWdlEhQKBXRpdGxlGAIgASgJUgV0aXRsZRrACAoFRnJhbWUSNgoKYmFja2dyb3VuZBgB'
        'IAEoCzIWLmJhbGFkeS5wcm90b2NvbC5JbWFnZVIKYmFja2dyb3VuZBIZCgV0aXRsZRgCIAEoCU'
        'gAUgV0aXRsZYgBARIlCgtkZXNjcmlwdGlvbhgDIAEoCUgBUgtkZXNjcmlwdGlvbogBARJTCg1h'
        'Y3Rpb25fYnV0dG9uGAQgASgLMikuYmFsYWR5LnByb3RvY29sLlN0b3J5LkZyYW1lLkFjdGlvbk'
        'J1dHRvbkgCUgxhY3Rpb25CdXR0b26IAQESGwoJaXNfdmlld2VkGAUgASgIUghpc1ZpZXdlZBIa'
        'CghkdXJhdGlvbhgGIAEoBVIIZHVyYXRpb24SOAoFc3R5bGUYByABKAsyIi5iYWxhZHkucHJvdG'
        '9jb2wuU3RvcnkuRnJhbWUuU3R5bGVSBXN0eWxlEkMKB2NvbnRlbnQYCCABKAsyJC5iYWxhZHku'
        'cHJvdG9jb2wuU3RvcnkuRnJhbWUuQ29udGVudEgDUgdjb250ZW50iAEBGjkKB0NvbnRlbnQSLg'
        'oGaW1hZ2VzGAEgAygLMhYuYmFsYWR5LnByb3RvY29sLkltYWdlUgZpbWFnZXMamwEKBVN0eWxl'
        'EjUKBXRpdGxlGAEgASgLMhouYmFsYWR5LnByb3RvY29sLlRleHRTdHlsZUgAUgV0aXRsZYgBAR'
        'JBCgtkZXNjcmlwdGlvbhgCIAEoCzIaLmJhbGFkeS5wcm90b2NvbC5UZXh0U3R5bGVIAVILZGVz'
        'Y3JpcHRpb26IAQFCCAoGX3RpdGxlQg4KDF9kZXNjcmlwdGlvbhqeAwoMQWN0aW9uQnV0dG9uEh'
        'QKBXRpdGxlGAEgASgJUgV0aXRsZRJCCgRsaW5rGAIgASgLMi4uYmFsYWR5LnByb3RvY29sLlN0'
        'b3J5LkZyYW1lLkFjdGlvbkJ1dHRvbi5MaW5rUgRsaW5rEkUKBXN0eWxlGAMgASgLMi8uYmFsYW'
        'R5LnByb3RvY29sLlN0b3J5LkZyYW1lLkFjdGlvbkJ1dHRvbi5TdHlsZVIFc3R5bGUSHQoKaXNf'
        'ZW5hYmxlZBgEIAEoCFIJaXNFbmFibGVkGhgKBExpbmsSEAoDdXJsGAEgASgJUgN1cmwaswEKBV'
        'N0eWxlEkYKEGJhY2tncm91bmRfY29sb3IYASABKAsyFi5iYWxhZHkucHJvdG9jb2wuQ29sb3JI'
        'AFIPYmFja2dyb3VuZENvbG9yiAEBEj4KCnRleHRfc3R5bGUYAiABKAsyGi5iYWxhZHkucHJvdG'
        '9jb2wuVGV4dFN0eWxlSAFSCXRleHRTdHlsZYgBAUITChFfYmFja2dyb3VuZF9jb2xvckINCgtf'
        'dGV4dF9zdHlsZUIICgZfdGl0bGVCDgoMX2Rlc2NyaXB0aW9uQhAKDl9hY3Rpb25fYnV0dG9uQg'
        'oKCF9jb250ZW50QhwKGl9hY3RpdmF0ZV9ldmVyeV9uX2xhdW5jaGVz');

@$core.Deprecated('Use storiesResponseDescriptor instead')
const StoriesResponse$json = {
  '1': 'StoriesResponse',
  '2': [
    {'1': 'stories', '3': 2, '4': 3, '5': 11, '6': '.balady.protocol.Story', '10': 'stories'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

/// Descriptor for `StoriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storiesResponseDescriptor =
    $convert.base64Decode('Cg9TdG9yaWVzUmVzcG9uc2USMAoHc3RvcmllcxgCIAMoCzIWLmJhbGFkeS5wcm90b2NvbC5TdG'
        '9yeVIHc3Rvcmllc0oECAEQAg==');

@$core.Deprecated('Use happinessRequestDescriptor instead')
const HappinessRequest$json = {
  '1': 'HappinessRequest',
  '2': [
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Point', '10': 'point'},
    {'1': 'is_positive', '3': 2, '4': 1, '5': 8, '10': 'isPositive'},
    {'1': 'tags', '3': 3, '4': 3, '5': 11, '6': '.balady.protocol.HappinessRequest.Tag', '10': 'tags'},
    {'1': 'text', '3': 4, '4': 1, '5': 9, '9': 0, '10': 'text', '17': true},
  ],
  '3': [HappinessRequest_Tag$json],
  '8': [
    {'1': '_text'},
  ],
};

@$core.Deprecated('Use happinessRequestDescriptor instead')
const HappinessRequest_Tag$json = {
  '1': 'Tag',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `HappinessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List happinessRequestDescriptor =
    $convert.base64Decode('ChBIYXBwaW5lc3NSZXF1ZXN0EiwKBXBvaW50GAEgASgLMhYuYmFsYWR5LnByb3RvY29sLlBvaW'
        '50UgVwb2ludBIfCgtpc19wb3NpdGl2ZRgCIAEoCFIKaXNQb3NpdGl2ZRI5CgR0YWdzGAMgAygL'
        'MiUuYmFsYWR5LnByb3RvY29sLkhhcHBpbmVzc1JlcXVlc3QuVGFnUgR0YWdzEhcKBHRleHQYBC'
        'ABKAlIAFIEdGV4dIgBARoZCgNUYWcSEgoEbmFtZRgBIAEoCVIEbmFtZUIHCgVfdGV4dA==');

@$core.Deprecated('Use favouriteItemPlaceDescriptor instead')
const FavouriteItemPlace$json = {
  '1': 'FavouriteItemPlace',
  '2': [
    {'1': 'location', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.FavouriteItemPlace.Location', '10': 'location'},
    {
      '1': 'entity',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.FavouriteItemPlace.Entity',
      '9': 0,
      '10': 'entity',
      '17': true
    },
    {'1': 'title', '3': 3, '4': 1, '5': 9, '10': 'title'},
    {'1': 'subtitle', '3': 4, '4': 1, '5': 9, '10': 'subtitle'},
  ],
  '3': [FavouriteItemPlace_Location$json, FavouriteItemPlace_Entity$json],
  '8': [
    {'1': '_entity'},
  ],
};

@$core.Deprecated('Use favouriteItemPlaceDescriptor instead')
const FavouriteItemPlace_Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Point', '10': 'point'},
  ],
};

@$core.Deprecated('Use favouriteItemPlaceDescriptor instead')
const FavouriteItemPlace_Entity$json = {
  '1': 'Entity',
  '2': [
    {'1': 'source_type', '3': 1, '4': 1, '5': 14, '6': '.balady.protocol.EntitySourceType', '10': 'sourceType'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `FavouriteItemPlace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favouriteItemPlaceDescriptor =
    $convert.base64Decode('ChJGYXZvdXJpdGVJdGVtUGxhY2USSAoIbG9jYXRpb24YASABKAsyLC5iYWxhZHkucHJvdG9jb2'
        'wuRmF2b3VyaXRlSXRlbVBsYWNlLkxvY2F0aW9uUghsb2NhdGlvbhJHCgZlbnRpdHkYAiABKAsy'
        'Ki5iYWxhZHkucHJvdG9jb2wuRmF2b3VyaXRlSXRlbVBsYWNlLkVudGl0eUgAUgZlbnRpdHmIAQ'
        'ESFAoFdGl0bGUYAyABKAlSBXRpdGxlEhoKCHN1YnRpdGxlGAQgASgJUghzdWJ0aXRsZRo4CghM'
        'b2NhdGlvbhIsCgVwb2ludBgBIAEoCzIWLmJhbGFkeS5wcm90b2NvbC5Qb2ludFIFcG9pbnQaXA'
        'oGRW50aXR5EkIKC3NvdXJjZV90eXBlGAEgASgOMiEuYmFsYWR5LnByb3RvY29sLkVudGl0eVNv'
        'dXJjZVR5cGVSCnNvdXJjZVR5cGUSDgoCaWQYAiABKAlSAmlkQgkKB19lbnRpdHk=');

@$core.Deprecated('Use favouriteItemDescriptor instead')
const FavouriteItem$json = {
  '1': 'FavouriteItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'place', '3': 2, '4': 1, '5': 11, '6': '.balady.protocol.FavouriteItemPlace', '10': 'place'},
  ],
};

/// Descriptor for `FavouriteItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favouriteItemDescriptor =
    $convert.base64Decode('Cg1GYXZvdXJpdGVJdGVtEg4KAmlkGAEgASgJUgJpZBI5CgVwbGFjZRgCIAEoCzIjLmJhbGFkeS'
        '5wcm90b2NvbC5GYXZvdXJpdGVJdGVtUGxhY2VSBXBsYWNl');

@$core.Deprecated('Use favouritesResponseDescriptor instead')
const FavouritesResponse$json = {
  '1': 'FavouritesResponse',
  '2': [
    {'1': 'places', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.FavouritesResponse.Places', '10': 'places'},
    {'1': 'items', '3': 2, '4': 3, '5': 11, '6': '.balady.protocol.FavouriteItem', '10': 'items'},
  ],
  '3': [FavouritesResponse_Places$json],
};

@$core.Deprecated('Use favouritesResponseDescriptor instead')
const FavouritesResponse_Places$json = {
  '1': 'Places',
  '2': [
    {
      '1': 'home',
      '3': 1,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.FavouriteItemPlace',
      '9': 0,
      '10': 'home',
      '17': true
    },
    {
      '1': 'work',
      '3': 2,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.FavouriteItemPlace',
      '9': 1,
      '10': 'work',
      '17': true
    },
  ],
  '8': [
    {'1': '_home'},
    {'1': '_work'},
  ],
};

/// Descriptor for `FavouritesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favouritesResponseDescriptor =
    $convert.base64Decode('ChJGYXZvdXJpdGVzUmVzcG9uc2USQgoGcGxhY2VzGAEgASgLMiouYmFsYWR5LnByb3RvY29sLk'
        'Zhdm91cml0ZXNSZXNwb25zZS5QbGFjZXNSBnBsYWNlcxI0CgVpdGVtcxgCIAMoCzIeLmJhbGFk'
        'eS5wcm90b2NvbC5GYXZvdXJpdGVJdGVtUgVpdGVtcxqWAQoGUGxhY2VzEjwKBGhvbWUYASABKA'
        'syIy5iYWxhZHkucHJvdG9jb2wuRmF2b3VyaXRlSXRlbVBsYWNlSABSBGhvbWWIAQESPAoEd29y'
        'axgCIAEoCzIjLmJhbGFkeS5wcm90b2NvbC5GYXZvdXJpdGVJdGVtUGxhY2VIAVIEd29ya4gBAU'
        'IHCgVfaG9tZUIHCgVfd29yaw==');

@$core.Deprecated('Use addFavouriteItemsRequestDescriptor instead')
const AddFavouriteItemsRequest$json = {
  '1': 'AddFavouriteItemsRequest',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.balady.protocol.AddFavouriteItemsRequest.Item', '10': 'items'},
  ],
  '3': [AddFavouriteItemsRequest_Item$json],
};

@$core.Deprecated('Use addFavouriteItemsRequestDescriptor instead')
const AddFavouriteItemsRequest_Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.balady.protocol.FavouriteItemType', '10': 'type'},
    {'1': 'point', '3': 2, '4': 1, '5': 11, '6': '.balady.protocol.Point', '10': 'point'},
    {
      '1': 'entity',
      '3': 3,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.AddFavouriteItemsRequest.Item.Entity',
      '9': 0,
      '10': 'entity',
      '17': true
    },
  ],
  '3': [AddFavouriteItemsRequest_Item_Entity$json],
  '8': [
    {'1': '_entity'},
  ],
};

@$core.Deprecated('Use addFavouriteItemsRequestDescriptor instead')
const AddFavouriteItemsRequest_Item_Entity$json = {
  '1': 'Entity',
  '2': [
    {'1': 'source_type', '3': 1, '4': 1, '5': 14, '6': '.balady.protocol.EntitySourceType', '10': 'sourceType'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `AddFavouriteItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFavouriteItemsRequestDescriptor =
    $convert.base64Decode('ChhBZGRGYXZvdXJpdGVJdGVtc1JlcXVlc3QSRAoFaXRlbXMYASADKAsyLi5iYWxhZHkucHJvdG'
        '9jb2wuQWRkRmF2b3VyaXRlSXRlbXNSZXF1ZXN0Lkl0ZW1SBWl0ZW1zGqkCCgRJdGVtEjYKBHR5'
        'cGUYASABKA4yIi5iYWxhZHkucHJvdG9jb2wuRmF2b3VyaXRlSXRlbVR5cGVSBHR5cGUSLAoFcG'
        '9pbnQYAiABKAsyFi5iYWxhZHkucHJvdG9jb2wuUG9pbnRSBXBvaW50ElIKBmVudGl0eRgDIAEo'
        'CzI1LmJhbGFkeS5wcm90b2NvbC5BZGRGYXZvdXJpdGVJdGVtc1JlcXVlc3QuSXRlbS5FbnRpdH'
        'lIAFIGZW50aXR5iAEBGlwKBkVudGl0eRJCCgtzb3VyY2VfdHlwZRgBIAEoDjIhLmJhbGFkeS5w'
        'cm90b2NvbC5FbnRpdHlTb3VyY2VUeXBlUgpzb3VyY2VUeXBlEg4KAmlkGAIgASgJUgJpZEIJCg'
        'dfZW50aXR5');

@$core.Deprecated('Use deleteFavouriteItemsRequestDescriptor instead')
const DeleteFavouriteItemsRequest$json = {
  '1': 'DeleteFavouriteItemsRequest',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.balady.protocol.DeleteFavouriteItemsRequest.Item', '10': 'items'},
  ],
  '3': [DeleteFavouriteItemsRequest_Item$json],
};

@$core.Deprecated('Use deleteFavouriteItemsRequestDescriptor instead')
const DeleteFavouriteItemsRequest_Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.balady.protocol.FavouriteItemType', '10': 'type'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'id', '17': true},
  ],
  '8': [
    {'1': '_id'},
  ],
};

/// Descriptor for `DeleteFavouriteItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteFavouriteItemsRequestDescriptor =
    $convert.base64Decode('ChtEZWxldGVGYXZvdXJpdGVJdGVtc1JlcXVlc3QSRwoFaXRlbXMYASADKAsyMS5iYWxhZHkucH'
        'JvdG9jb2wuRGVsZXRlRmF2b3VyaXRlSXRlbXNSZXF1ZXN0Lkl0ZW1SBWl0ZW1zGloKBEl0ZW0S'
        'NgoEdHlwZRgBIAEoDjIiLmJhbGFkeS5wcm90b2NvbC5GYXZvdXJpdGVJdGVtVHlwZVIEdHlwZR'
        'ITCgJpZBgCIAEoCUgAUgJpZIgBAUIFCgNfaWQ=');

@$core.Deprecated('Use iWishObjectMarkerDescriptor instead')
const IWishObjectMarker$json = {
  '1': 'IWishObjectMarker',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'category', '3': 2, '4': 1, '5': 14, '6': '.balady.protocol.IWishCategory', '10': 'category'},
    {'1': 'location', '3': 3, '4': 1, '5': 11, '6': '.balady.protocol.IWishObjectMarker.Location', '10': 'location'},
    {'1': 'state', '3': 4, '4': 1, '5': 14, '6': '.balady.protocol.IWishState', '10': 'state'},
  ],
  '3': [IWishObjectMarker_Location$json],
};

@$core.Deprecated('Use iWishObjectMarkerDescriptor instead')
const IWishObjectMarker_Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Point', '10': 'point'},
  ],
};

/// Descriptor for `IWishObjectMarker`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iWishObjectMarkerDescriptor =
    $convert.base64Decode('ChFJV2lzaE9iamVjdE1hcmtlchIOCgJpZBgBIAEoCVICaWQSOgoIY2F0ZWdvcnkYAiABKA4yHi'
        '5iYWxhZHkucHJvdG9jb2wuSVdpc2hDYXRlZ29yeVIIY2F0ZWdvcnkSRwoIbG9jYXRpb24YAyAB'
        'KAsyKy5iYWxhZHkucHJvdG9jb2wuSVdpc2hPYmplY3RNYXJrZXIuTG9jYXRpb25SCGxvY2F0aW'
        '9uEjEKBXN0YXRlGAQgASgOMhsuYmFsYWR5LnByb3RvY29sLklXaXNoU3RhdGVSBXN0YXRlGjgK'
        'CExvY2F0aW9uEiwKBXBvaW50GAEgASgLMhYuYmFsYWR5LnByb3RvY29sLlBvaW50UgVwb2ludA'
        '==');

@$core.Deprecated('Use iWishObjectDescriptor instead')
const IWishObject$json = {
  '1': 'IWishObject',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'category', '3': 2, '4': 1, '5': 14, '6': '.balady.protocol.IWishCategory', '10': 'category'},
    {'1': 'state', '3': 3, '4': 1, '5': 14, '6': '.balady.protocol.IWishState', '10': 'state'},
    {'1': 'location', '3': 4, '4': 1, '5': 11, '6': '.balady.protocol.IWishObject.Location', '10': 'location'},
    {'1': 'title', '3': 5, '4': 1, '5': 9, '10': 'title'},
    {'1': 'subtitle', '3': 6, '4': 1, '5': 9, '10': 'subtitle'},
    {'1': 'photos', '3': 7, '4': 3, '5': 11, '6': '.balady.protocol.IWishObject.Photo', '10': 'photos'},
    {'1': 'variants', '3': 8, '4': 3, '5': 11, '6': '.balady.protocol.IWishObject.Variant', '10': 'variants'},
    {'1': 'selected_variant_id', '3': 9, '4': 1, '5': 5, '9': 0, '10': 'selectedVariantId', '17': true},
    {'1': 'feedback_sent', '3': 10, '4': 1, '5': 8, '10': 'feedbackSent'},
    {'1': 'metadata', '3': 11, '4': 1, '5': 11, '6': '.balady.protocol.IWishObject.Metadata', '10': 'metadata'},
    {'1': 'size', '3': 12, '4': 1, '5': 14, '6': '.balady.protocol.IWishSize', '10': 'size'},
  ],
  '3': [
    IWishObject_Location$json,
    IWishObject_Variant$json,
    IWishObject_Voted$json,
    IWishObject_Photo$json,
    IWishObject_Metadata$json
  ],
  '8': [
    {'1': '_selected_variant_id'},
  ],
};

@$core.Deprecated('Use iWishObjectDescriptor instead')
const IWishObject_Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Point', '10': 'point'},
  ],
};

@$core.Deprecated('Use iWishObjectDescriptor instead')
const IWishObject_Variant$json = {
  '1': 'Variant',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
    {'1': 'preview', '3': 3, '4': 1, '5': 11, '6': '.balady.protocol.IWishObject.Variant.Preview', '10': 'preview'},
    {'1': 'photos', '3': 4, '4': 3, '5': 11, '6': '.balady.protocol.IWishObject.Photo', '10': 'photos'},
  ],
  '3': [IWishObject_Variant_Preview$json],
};

@$core.Deprecated('Use iWishObjectDescriptor instead')
const IWishObject_Variant_Preview$json = {
  '1': 'Preview',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Image', '10': 'image'},
  ],
};

@$core.Deprecated('Use iWishObjectDescriptor instead')
const IWishObject_Voted$json = {
  '1': 'Voted',
  '2': [
    {'1': 'variant_index', '3': 1, '4': 1, '5': 5, '10': 'variantIndex'},
    {'1': 'is_feedback_sent', '3': 2, '4': 1, '5': 8, '10': 'isFeedbackSent'},
  ],
};

@$core.Deprecated('Use iWishObjectDescriptor instead')
const IWishObject_Photo$json = {
  '1': 'Photo',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Image', '10': 'image'},
  ],
};

@$core.Deprecated('Use iWishObjectDescriptor instead')
const IWishObject_Metadata$json = {
  '1': 'Metadata',
  '2': [
    {'1': 'area_name', '3': 1, '4': 1, '5': 9, '9': 0, '10': 'areaName', '17': true},
    {'1': 'type_name', '3': 2, '4': 1, '5': 9, '9': 1, '10': 'typeName', '17': true},
    {'1': 'area_size', '3': 3, '4': 1, '5': 5, '9': 2, '10': 'areaSize', '17': true},
    {
      '1': 'opening_date',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.Timestamp',
      '9': 3,
      '10': 'openingDate',
      '17': true
    },
  ],
  '8': [
    {'1': '_area_name'},
    {'1': '_type_name'},
    {'1': '_area_size'},
    {'1': '_opening_date'},
  ],
};

/// Descriptor for `IWishObject`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iWishObjectDescriptor =
    $convert.base64Decode('CgtJV2lzaE9iamVjdBIOCgJpZBgBIAEoCVICaWQSOgoIY2F0ZWdvcnkYAiABKA4yHi5iYWxhZH'
        'kucHJvdG9jb2wuSVdpc2hDYXRlZ29yeVIIY2F0ZWdvcnkSMQoFc3RhdGUYAyABKA4yGy5iYWxh'
        'ZHkucHJvdG9jb2wuSVdpc2hTdGF0ZVIFc3RhdGUSQQoIbG9jYXRpb24YBCABKAsyJS5iYWxhZH'
        'kucHJvdG9jb2wuSVdpc2hPYmplY3QuTG9jYXRpb25SCGxvY2F0aW9uEhQKBXRpdGxlGAUgASgJ'
        'UgV0aXRsZRIaCghzdWJ0aXRsZRgGIAEoCVIIc3VidGl0bGUSOgoGcGhvdG9zGAcgAygLMiIuYm'
        'FsYWR5LnByb3RvY29sLklXaXNoT2JqZWN0LlBob3RvUgZwaG90b3MSQAoIdmFyaWFudHMYCCAD'
        'KAsyJC5iYWxhZHkucHJvdG9jb2wuSVdpc2hPYmplY3QuVmFyaWFudFIIdmFyaWFudHMSMwoTc2'
        'VsZWN0ZWRfdmFyaWFudF9pZBgJIAEoBUgAUhFzZWxlY3RlZFZhcmlhbnRJZIgBARIjCg1mZWVk'
        'YmFja19zZW50GAogASgIUgxmZWVkYmFja1NlbnQSQQoIbWV0YWRhdGEYCyABKAsyJS5iYWxhZH'
        'kucHJvdG9jb2wuSVdpc2hPYmplY3QuTWV0YWRhdGFSCG1ldGFkYXRhEi4KBHNpemUYDCABKA4y'
        'Gi5iYWxhZHkucHJvdG9jb2wuSVdpc2hTaXplUgRzaXplGjgKCExvY2F0aW9uEiwKBXBvaW50GA'
        'EgASgLMhYuYmFsYWR5LnByb3RvY29sLlBvaW50UgVwb2ludBrsAQoHVmFyaWFudBIOCgJpZBgB'
        'IAEoBVICaWQSFAoFdGl0bGUYAiABKAlSBXRpdGxlEkYKB3ByZXZpZXcYAyABKAsyLC5iYWxhZH'
        'kucHJvdG9jb2wuSVdpc2hPYmplY3QuVmFyaWFudC5QcmV2aWV3UgdwcmV2aWV3EjoKBnBob3Rv'
        'cxgEIAMoCzIiLmJhbGFkeS5wcm90b2NvbC5JV2lzaE9iamVjdC5QaG90b1IGcGhvdG9zGjcKB1'
        'ByZXZpZXcSLAoFaW1hZ2UYASABKAsyFi5iYWxhZHkucHJvdG9jb2wuSW1hZ2VSBWltYWdlGlYK'
        'BVZvdGVkEiMKDXZhcmlhbnRfaW5kZXgYASABKAVSDHZhcmlhbnRJbmRleBIoChBpc19mZWVkYm'
        'Fja19zZW50GAIgASgIUg5pc0ZlZWRiYWNrU2VudBo1CgVQaG90bxIsCgVpbWFnZRgBIAEoCzIW'
        'LmJhbGFkeS5wcm90b2NvbC5JbWFnZVIFaW1hZ2Ua7wEKCE1ldGFkYXRhEiAKCWFyZWFfbmFtZR'
        'gBIAEoCUgAUghhcmVhTmFtZYgBARIgCgl0eXBlX25hbWUYAiABKAlIAVIIdHlwZU5hbWWIAQES'
        'IAoJYXJlYV9zaXplGAMgASgFSAJSCGFyZWFTaXpliAEBEkIKDG9wZW5pbmdfZGF0ZRgEIAEoCz'
        'IaLmJhbGFkeS5wcm90b2NvbC5UaW1lc3RhbXBIA1ILb3BlbmluZ0RhdGWIAQFCDAoKX2FyZWFf'
        'bmFtZUIMCgpfdHlwZV9uYW1lQgwKCl9hcmVhX3NpemVCDwoNX29wZW5pbmdfZGF0ZUIWChRfc2'
        'VsZWN0ZWRfdmFyaWFudF9pZA==');

@$core.Deprecated('Use iWishMarkersResponseDescriptor instead')
const IWishMarkersResponse$json = {
  '1': 'IWishMarkersResponse',
  '2': [
    {'1': 'markers', '3': 1, '4': 3, '5': 11, '6': '.balady.protocol.IWishObjectMarker', '10': 'markers'},
  ],
};

/// Descriptor for `IWishMarkersResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iWishMarkersResponseDescriptor =
    $convert.base64Decode('ChRJV2lzaE1hcmtlcnNSZXNwb25zZRI8CgdtYXJrZXJzGAEgAygLMiIuYmFsYWR5LnByb3RvY2'
        '9sLklXaXNoT2JqZWN0TWFya2VyUgdtYXJrZXJz');

@$core.Deprecated('Use iWishItemResponseDescriptor instead')
const IWishItemResponse$json = {
  '1': 'IWishItemResponse',
  '2': [
    {'1': 'object', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.IWishObject', '10': 'object'},
  ],
};

/// Descriptor for `IWishItemResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iWishItemResponseDescriptor =
    $convert.base64Decode('ChFJV2lzaEl0ZW1SZXNwb25zZRI0CgZvYmplY3QYASABKAsyHC5iYWxhZHkucHJvdG9jb2wuSV'
        'dpc2hPYmplY3RSBm9iamVjdA==');

@$core.Deprecated('Use iWishVoteRequestDescriptor instead')
const IWishVoteRequest$json = {
  '1': 'IWishVoteRequest',
  '2': [
    {'1': 'variant_id', '3': 1, '4': 1, '5': 5, '10': 'variantId'},
  ],
};

/// Descriptor for `IWishVoteRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iWishVoteRequestDescriptor =
    $convert.base64Decode('ChBJV2lzaFZvdGVSZXF1ZXN0Eh0KCnZhcmlhbnRfaWQYASABKAVSCXZhcmlhbnRJZA==');

@$core.Deprecated('Use iWishFeedbackRequestDescriptor instead')
const IWishFeedbackRequest$json = {
  '1': 'IWishFeedbackRequest',
  '2': [
    {'1': 'rating', '3': 1, '4': 1, '5': 5, '10': 'rating'},
    {'1': 'tags', '3': 2, '4': 3, '5': 11, '6': '.balady.protocol.IWishFeedbackRequest.Tag', '10': 'tags'},
    {'1': 'text', '3': 3, '4': 1, '5': 9, '9': 0, '10': 'text', '17': true},
  ],
  '3': [IWishFeedbackRequest_Tag$json],
  '8': [
    {'1': '_text'},
  ],
};

@$core.Deprecated('Use iWishFeedbackRequestDescriptor instead')
const IWishFeedbackRequest_Tag$json = {
  '1': 'Tag',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `IWishFeedbackRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List iWishFeedbackRequestDescriptor =
    $convert.base64Decode('ChRJV2lzaEZlZWRiYWNrUmVxdWVzdBIWCgZyYXRpbmcYASABKAVSBnJhdGluZxI9CgR0YWdzGA'
        'IgAygLMikuYmFsYWR5LnByb3RvY29sLklXaXNoRmVlZGJhY2tSZXF1ZXN0LlRhZ1IEdGFncxIX'
        'CgR0ZXh0GAMgASgJSABSBHRleHSIAQEaGQoDVGFnEhIKBG5hbWUYASABKAlSBG5hbWVCBwoFX3'
        'RleHQ=');

@$core.Deprecated('Use interestingPlaceDescriptor instead')
const InterestingPlace$json = {
  '1': 'InterestingPlace',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'preview', '3': 2, '4': 1, '5': 11, '6': '.balady.protocol.InterestingPlace.Preview', '10': 'preview'},
    {'1': 'location', '3': 3, '4': 1, '5': 11, '6': '.balady.protocol.InterestingPlace.Location', '10': 'location'},
    {
      '1': 'entity',
      '3': 4,
      '4': 1,
      '5': 11,
      '6': '.balady.protocol.InterestingPlace.Entity',
      '9': 0,
      '10': 'entity',
      '17': true
    },
    {'1': 'tags', '3': 5, '4': 3, '5': 14, '6': '.balady.protocol.InterestingPlaceTag', '10': 'tags'},
  ],
  '3': [InterestingPlace_Preview$json, InterestingPlace_Location$json, InterestingPlace_Entity$json],
  '8': [
    {'1': '_entity'},
  ],
};

@$core.Deprecated('Use interestingPlaceDescriptor instead')
const InterestingPlace_Preview$json = {
  '1': 'Preview',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 9, '10': 'title'},
    {'1': 'image', '3': 2, '4': 1, '5': 11, '6': '.balady.protocol.Image', '10': 'image'},
  ],
};

@$core.Deprecated('Use interestingPlaceDescriptor instead')
const InterestingPlace_Location$json = {
  '1': 'Location',
  '2': [
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Point', '10': 'point'},
  ],
};

@$core.Deprecated('Use interestingPlaceDescriptor instead')
const InterestingPlace_Entity$json = {
  '1': 'Entity',
  '2': [
    {'1': 'source_type', '3': 1, '4': 1, '5': 14, '6': '.balady.protocol.EntitySourceType', '10': 'sourceType'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `InterestingPlace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interestingPlaceDescriptor =
    $convert.base64Decode('ChBJbnRlcmVzdGluZ1BsYWNlEg4KAmlkGAEgASgJUgJpZBJDCgdwcmV2aWV3GAIgASgLMikuYm'
        'FsYWR5LnByb3RvY29sLkludGVyZXN0aW5nUGxhY2UuUHJldmlld1IHcHJldmlldxJGCghsb2Nh'
        'dGlvbhgDIAEoCzIqLmJhbGFkeS5wcm90b2NvbC5JbnRlcmVzdGluZ1BsYWNlLkxvY2F0aW9uUg'
        'hsb2NhdGlvbhJFCgZlbnRpdHkYBCABKAsyKC5iYWxhZHkucHJvdG9jb2wuSW50ZXJlc3RpbmdQ'
        'bGFjZS5FbnRpdHlIAFIGZW50aXR5iAEBEjgKBHRhZ3MYBSADKA4yJC5iYWxhZHkucHJvdG9jb2'
        'wuSW50ZXJlc3RpbmdQbGFjZVRhZ1IEdGFncxpNCgdQcmV2aWV3EhQKBXRpdGxlGAEgASgJUgV0'
        'aXRsZRIsCgVpbWFnZRgCIAEoCzIWLmJhbGFkeS5wcm90b2NvbC5JbWFnZVIFaW1hZ2UaOAoITG'
        '9jYXRpb24SLAoFcG9pbnQYASABKAsyFi5iYWxhZHkucHJvdG9jb2wuUG9pbnRSBXBvaW50GlwK'
        'BkVudGl0eRJCCgtzb3VyY2VfdHlwZRgBIAEoDjIhLmJhbGFkeS5wcm90b2NvbC5FbnRpdHlTb3'
        'VyY2VUeXBlUgpzb3VyY2VUeXBlEg4KAmlkGAIgASgJUgJpZEIJCgdfZW50aXR5');

@$core.Deprecated('Use interestingPlacesResponseDescriptor instead')
const InterestingPlacesResponse$json = {
  '1': 'InterestingPlacesResponse',
  '2': [
    {
      '1': 'interesting_places',
      '3': 1,
      '4': 3,
      '5': 11,
      '6': '.balady.protocol.InterestingPlace',
      '10': 'interestingPlaces'
    },
  ],
};

/// Descriptor for `InterestingPlacesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List interestingPlacesResponseDescriptor =
    $convert.base64Decode('ChlJbnRlcmVzdGluZ1BsYWNlc1Jlc3BvbnNlElAKEmludGVyZXN0aW5nX3BsYWNlcxgBIAMoCz'
        'IhLmJhbGFkeS5wcm90b2NvbC5JbnRlcmVzdGluZ1BsYWNlUhFpbnRlcmVzdGluZ1BsYWNlcw==');

@$core.Deprecated('Use profileDescriptor instead')
const Profile$json = {
  '1': 'Profile',
  '2': [
    {'1': 'photo', '3': 6, '4': 1, '5': 11, '6': '.balady.protocol.Profile.Photo', '9': 0, '10': 'photo', '17': true},
  ],
  '3': [Profile_Photo$json],
  '8': [
    {'1': '_photo'},
  ],
  '9': [
    {'1': 5, '2': 6},
  ],
};

@$core.Deprecated('Use profileDescriptor instead')
const Profile_Photo$json = {
  '1': 'Photo',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 11, '6': '.balady.protocol.Image', '10': 'image'},
  ],
};

/// Descriptor for `Profile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileDescriptor =
    $convert.base64Decode('CgdQcm9maWxlEjkKBXBob3RvGAYgASgLMh4uYmFsYWR5LnByb3RvY29sLlByb2ZpbGUuUGhvdG'
        '9IAFIFcGhvdG+IAQEaNQoFUGhvdG8SLAoFaW1hZ2UYASABKAsyFi5iYWxhZHkucHJvdG9jb2wu'
        'SW1hZ2VSBWltYWdlQggKBl9waG90b0oECAUQBg==');

@$core.Deprecated('Use profileResponseDescriptor instead')
const ProfileResponse$json = {
  '1': 'ProfileResponse',
  '2': [
    {'1': 'profile', '3': 2, '4': 1, '5': 11, '6': '.balady.protocol.Profile', '10': 'profile'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

/// Descriptor for `ProfileResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List profileResponseDescriptor =
    $convert.base64Decode('Cg9Qcm9maWxlUmVzcG9uc2USMgoHcHJvZmlsZRgCIAEoCzIYLmJhbGFkeS5wcm90b2NvbC5Qcm'
        '9maWxlUgdwcm9maWxlSgQIARAC');
