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
final $typed_data.Uint8List envDescriptor = $convert.base64Decode(
    'CgNFbnYSDwoLRU5WX1VOS05PV04QABILCgdFTlZfREVWEAESDwoLRU5WX1NBTkRCT1gQAhISCg'
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
final $typed_data.Uint8List errorDescriptor = $convert.base64Decode(
    'CgVFcnJvchIRCg1FUlJPUl9VTktOT1dOEAASFQoRRVJST1JfQkFEX1JFUVVFU1QQARIWChJFUl'
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
final $typed_data.Uint8List favouriteItemTypeDescriptor = $convert.base64Decode(
    'ChFGYXZvdXJpdGVJdGVtVHlwZRIfChtGQVZPVVJJVEVfSVRFTV9UWVBFX1VOS05PV04QABIcCh'
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
final $typed_data.Uint8List entitySourceTypeDescriptor = $convert.base64Decode(
    'ChBFbnRpdHlTb3VyY2VUeXBlEhkKFUVOVElUWV9TT1VSQ0VfVU5LTk9XThAAEhYKEkVOVElUWV'
    '9TT1VSQ0VfVVJCSRAB');

@$core.Deprecated('Use timestampDescriptor instead')
const Timestamp$json = {
  '1': 'Timestamp',
  '2': [
    {'1': 'value', '3': 1, '4': 1, '5': 3, '10': 'value'},
  ],
};

/// Descriptor for `Timestamp`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List timestampDescriptor = $convert.base64Decode(
    'CglUaW1lc3RhbXASFAoFdmFsdWUYASABKANSBXZhbHVl');

@$core.Deprecated('Use imageDescriptor instead')
const Image$json = {
  '1': 'Image',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `Image`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List imageDescriptor = $convert.base64Decode(
    'CgVJbWFnZRIQCgN1cmwYASABKAlSA3VybA==');

@$core.Deprecated('Use pointDescriptor instead')
const Point$json = {
  '1': 'Point',
  '2': [
    {'1': 'latitude', '3': 1, '4': 1, '5': 1, '10': 'latitude'},
    {'1': 'longitude', '3': 2, '4': 1, '5': 1, '10': 'longitude'},
  ],
};

/// Descriptor for `Point`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List pointDescriptor = $convert.base64Decode(
    'CgVQb2ludBIaCghsYXRpdHVkZRgBIAEoAVIIbGF0aXR1ZGUSHAoJbG9uZ2l0dWRlGAIgASgBUg'
    'lsb25naXR1ZGU=');

@$core.Deprecated('Use colorDescriptor instead')
const Color$json = {
  '1': 'Color',
  '2': [
    {'1': 'hex', '3': 1, '4': 1, '5': 9, '10': 'hex'},
  ],
};

/// Descriptor for `Color`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List colorDescriptor = $convert.base64Decode(
    'CgVDb2xvchIQCgNoZXgYASABKAlSA2hleA==');

@$core.Deprecated('Use textStyleDescriptor instead')
const TextStyle$json = {
  '1': 'TextStyle',
  '2': [
    {'1': 'color', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.Color', '10': 'color'},
  ],
};

/// Descriptor for `TextStyle`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List textStyleDescriptor = $convert.base64Decode(
    'CglUZXh0U3R5bGUSLAoFY29sb3IYASABKAsyFi5iYWxhZGkucHJvdG9jb2wuQ29sb3JSBWNvbG'
    '9y');

@$core.Deprecated('Use errorResponseDescriptor instead')
const ErrorResponse$json = {
  '1': 'ErrorResponse',
  '2': [
    {'1': 'error', '3': 2, '4': 1, '5': 11, '6': '.baladi.protocol.ErrorResponse.ErrorMessage', '10': 'error'},
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
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.baladi.protocol.Error', '10': 'type'},
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
final $typed_data.Uint8List errorResponseDescriptor = $convert.base64Decode(
    'Cg1FcnJvclJlc3BvbnNlEkEKBWVycm9yGAIgASgLMisuYmFsYWRpLnByb3RvY29sLkVycm9yUm'
    'VzcG9uc2UuRXJyb3JNZXNzYWdlUgVlcnJvchq/AQoMRXJyb3JNZXNzYWdlEioKBHR5cGUYASAB'
    'KA4yFi5iYWxhZGkucHJvdG9jb2wuRXJyb3JSBHR5cGUSGQoIaW50X2NvZGUYAiABKAVSB2ludE'
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
final $typed_data.Uint8List okResponseDescriptor = $convert.base64Decode(
    'CgpPa1Jlc3BvbnNlEhIKBGNvZGUYAiABKAVSBGNvZGVKBAgBEAI=');

@$core.Deprecated('Use storyDescriptor instead')
const Story$json = {
  '1': 'Story',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'preview', '3': 2, '4': 1, '5': 11, '6': '.baladi.protocol.Story.Preview', '10': 'preview'},
    {'1': 'frames', '3': 3, '4': 3, '5': 11, '6': '.baladi.protocol.Story.Frame', '10': 'frames'},
    {'1': 'is_viewed', '3': 4, '4': 1, '5': 8, '10': 'isViewed'},
  ],
  '3': [Story_Preview$json, Story_Frame$json],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Preview$json = {
  '1': 'Preview',
  '2': [
    {'1': 'image', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.Image', '10': 'image'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '10': 'title'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame$json = {
  '1': 'Frame',
  '2': [
    {'1': 'background', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.Image', '10': 'background'},
    {'1': 'title', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'title', '17': true},
    {'1': 'description', '3': 3, '4': 1, '5': 9, '9': 1, '10': 'description', '17': true},
    {'1': 'action_button', '3': 4, '4': 1, '5': 11, '6': '.baladi.protocol.Story.Frame.ActionButton', '9': 2, '10': 'actionButton', '17': true},
    {'1': 'is_viewed', '3': 5, '4': 1, '5': 8, '10': 'isViewed'},
    {'1': 'duration', '3': 6, '4': 1, '5': 5, '10': 'duration'},
    {'1': 'style', '3': 7, '4': 1, '5': 11, '6': '.baladi.protocol.Story.Frame.Style', '10': 'style'},
  ],
  '3': [Story_Frame_Style$json, Story_Frame_ActionButton$json],
  '8': [
    {'1': '_title'},
    {'1': '_description'},
    {'1': '_action_button'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_Style$json = {
  '1': 'Style',
  '2': [
    {'1': 'title', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.TextStyle', '9': 0, '10': 'title', '17': true},
    {'1': 'description', '3': 2, '4': 1, '5': 11, '6': '.baladi.protocol.TextStyle', '9': 1, '10': 'description', '17': true},
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
    {'1': 'call', '3': 2, '4': 1, '5': 11, '6': '.baladi.protocol.Story.Frame.ActionButton.Call', '9': 0, '10': 'call'},
    {'1': 'external_url', '3': 3, '4': 1, '5': 11, '6': '.baladi.protocol.Story.Frame.ActionButton.ExternalUrl', '9': 0, '10': 'externalUrl'},
    {'1': 'open_card', '3': 4, '4': 1, '5': 11, '6': '.baladi.protocol.Story.Frame.ActionButton.OpenCard', '9': 0, '10': 'openCard'},
    {'1': 'deeplink', '3': 5, '4': 1, '5': 11, '6': '.baladi.protocol.Story.Frame.ActionButton.Deeplink', '9': 0, '10': 'deeplink'},
    {'1': 'style', '3': 51, '4': 1, '5': 11, '6': '.baladi.protocol.Story.Frame.ActionButton.Style', '10': 'style'},
  ],
  '3': [Story_Frame_ActionButton_Style$json, Story_Frame_ActionButton_Call$json, Story_Frame_ActionButton_ExternalUrl$json, Story_Frame_ActionButton_OpenCard$json, Story_Frame_ActionButton_Deeplink$json],
  '8': [
    {'1': 'action'},
  ],
  '9': [
    {'1': 6, '2': 51},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_ActionButton_Style$json = {
  '1': 'Style',
  '2': [
    {'1': 'background_color', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.Color', '9': 0, '10': 'backgroundColor', '17': true},
    {'1': 'text_style', '3': 2, '4': 1, '5': 11, '6': '.baladi.protocol.TextStyle', '9': 1, '10': 'textStyle', '17': true},
  ],
  '8': [
    {'1': '_background_color'},
    {'1': '_text_style'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_ActionButton_Call$json = {
  '1': 'Call',
  '2': [
    {'1': 'phone', '3': 1, '4': 1, '5': 9, '10': 'phone'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_ActionButton_ExternalUrl$json = {
  '1': 'ExternalUrl',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_ActionButton_OpenCard$json = {
  '1': 'OpenCard',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
  ],
};

@$core.Deprecated('Use storyDescriptor instead')
const Story_Frame_ActionButton_Deeplink$json = {
  '1': 'Deeplink',
  '2': [
    {'1': 'url', '3': 1, '4': 1, '5': 9, '10': 'url'},
  ],
};

/// Descriptor for `Story`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storyDescriptor = $convert.base64Decode(
    'CgVTdG9yeRIOCgJpZBgBIAEoCVICaWQSOAoHcHJldmlldxgCIAEoCzIeLmJhbGFkaS5wcm90b2'
    'NvbC5TdG9yeS5QcmV2aWV3UgdwcmV2aWV3EjQKBmZyYW1lcxgDIAMoCzIcLmJhbGFkaS5wcm90'
    'b2NvbC5TdG9yeS5GcmFtZVIGZnJhbWVzEhsKCWlzX3ZpZXdlZBgEIAEoCFIIaXNWaWV3ZWQaTQ'
    'oHUHJldmlldxIsCgVpbWFnZRgBIAEoCzIWLmJhbGFkaS5wcm90b2NvbC5JbWFnZVIFaW1hZ2US'
    'FAoFdGl0bGUYAiABKAlSBXRpdGxlGocKCgVGcmFtZRI2CgpiYWNrZ3JvdW5kGAEgASgLMhYuYm'
    'FsYWRpLnByb3RvY29sLkltYWdlUgpiYWNrZ3JvdW5kEhkKBXRpdGxlGAIgASgJSABSBXRpdGxl'
    'iAEBEiUKC2Rlc2NyaXB0aW9uGAMgASgJSAFSC2Rlc2NyaXB0aW9uiAEBElMKDWFjdGlvbl9idX'
    'R0b24YBCABKAsyKS5iYWxhZGkucHJvdG9jb2wuU3RvcnkuRnJhbWUuQWN0aW9uQnV0dG9uSAJS'
    'DGFjdGlvbkJ1dHRvbogBARIbCglpc192aWV3ZWQYBSABKAhSCGlzVmlld2VkEhoKCGR1cmF0aW'
    '9uGAYgASgFUghkdXJhdGlvbhI4CgVzdHlsZRgHIAEoCzIiLmJhbGFkaS5wcm90b2NvbC5TdG9y'
    'eS5GcmFtZS5TdHlsZVIFc3R5bGUamwEKBVN0eWxlEjUKBXRpdGxlGAEgASgLMhouYmFsYWRpLn'
    'Byb3RvY29sLlRleHRTdHlsZUgAUgV0aXRsZYgBARJBCgtkZXNjcmlwdGlvbhgCIAEoCzIaLmJh'
    'bGFkaS5wcm90b2NvbC5UZXh0U3R5bGVIAVILZGVzY3JpcHRpb26IAQFCCAoGX3RpdGxlQg4KDF'
    '9kZXNjcmlwdGlvbhrxBQoMQWN0aW9uQnV0dG9uEhQKBXRpdGxlGAEgASgJUgV0aXRsZRJECgRj'
    'YWxsGAIgASgLMi4uYmFsYWRpLnByb3RvY29sLlN0b3J5LkZyYW1lLkFjdGlvbkJ1dHRvbi5DYW'
    'xsSABSBGNhbGwSWgoMZXh0ZXJuYWxfdXJsGAMgASgLMjUuYmFsYWRpLnByb3RvY29sLlN0b3J5'
    'LkZyYW1lLkFjdGlvbkJ1dHRvbi5FeHRlcm5hbFVybEgAUgtleHRlcm5hbFVybBJRCglvcGVuX2'
    'NhcmQYBCABKAsyMi5iYWxhZGkucHJvdG9jb2wuU3RvcnkuRnJhbWUuQWN0aW9uQnV0dG9uLk9w'
    'ZW5DYXJkSABSCG9wZW5DYXJkElAKCGRlZXBsaW5rGAUgASgLMjIuYmFsYWRpLnByb3RvY29sLl'
    'N0b3J5LkZyYW1lLkFjdGlvbkJ1dHRvbi5EZWVwbGlua0gAUghkZWVwbGluaxJFCgVzdHlsZRgz'
    'IAEoCzIvLmJhbGFkaS5wcm90b2NvbC5TdG9yeS5GcmFtZS5BY3Rpb25CdXR0b24uU3R5bGVSBX'
    'N0eWxlGrMBCgVTdHlsZRJGChBiYWNrZ3JvdW5kX2NvbG9yGAEgASgLMhYuYmFsYWRpLnByb3Rv'
    'Y29sLkNvbG9ySABSD2JhY2tncm91bmRDb2xvcogBARI+Cgp0ZXh0X3N0eWxlGAIgASgLMhouYm'
    'FsYWRpLnByb3RvY29sLlRleHRTdHlsZUgBUgl0ZXh0U3R5bGWIAQFCEwoRX2JhY2tncm91bmRf'
    'Y29sb3JCDQoLX3RleHRfc3R5bGUaHAoEQ2FsbBIUCgVwaG9uZRgBIAEoCVIFcGhvbmUaHwoLRX'
    'h0ZXJuYWxVcmwSEAoDdXJsGAEgASgJUgN1cmwaGgoIT3BlbkNhcmQSDgoCaWQYASABKAlSAmlk'
    'GhwKCERlZXBsaW5rEhAKA3VybBgBIAEoCVIDdXJsQggKBmFjdGlvbkoECAYQM0IICgZfdGl0bG'
    'VCDgoMX2Rlc2NyaXB0aW9uQhAKDl9hY3Rpb25fYnV0dG9u');

@$core.Deprecated('Use viewedStoriesRequestDescriptor instead')
const ViewedStoriesRequest$json = {
  '1': 'ViewedStoriesRequest',
  '2': [
    {'1': 'stories', '3': 2, '4': 3, '5': 11, '6': '.baladi.protocol.ViewedStoriesRequest.ViewedStory', '10': 'stories'},
  ],
  '3': [ViewedStoriesRequest_ViewedStory$json],
  '9': [
    {'1': 1, '2': 2},
  ],
};

@$core.Deprecated('Use viewedStoriesRequestDescriptor instead')
const ViewedStoriesRequest_ViewedStory$json = {
  '1': 'ViewedStory',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'frames', '3': 2, '4': 3, '5': 11, '6': '.baladi.protocol.ViewedStoriesRequest.ViewedStory.ViewedStoryFrame', '10': 'frames'},
  ],
  '3': [ViewedStoriesRequest_ViewedStory_ViewedStoryFrame$json],
};

@$core.Deprecated('Use viewedStoriesRequestDescriptor instead')
const ViewedStoriesRequest_ViewedStory_ViewedStoryFrame$json = {
  '1': 'ViewedStoryFrame',
  '2': [
    {'1': 'index', '3': 1, '4': 1, '5': 5, '10': 'index'},
  ],
};

/// Descriptor for `ViewedStoriesRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List viewedStoriesRequestDescriptor = $convert.base64Decode(
    'ChRWaWV3ZWRTdG9yaWVzUmVxdWVzdBJLCgdzdG9yaWVzGAIgAygLMjEuYmFsYWRpLnByb3RvY2'
    '9sLlZpZXdlZFN0b3JpZXNSZXF1ZXN0LlZpZXdlZFN0b3J5UgdzdG9yaWVzGqMBCgtWaWV3ZWRT'
    'dG9yeRIOCgJpZBgBIAEoCVICaWQSWgoGZnJhbWVzGAIgAygLMkIuYmFsYWRpLnByb3RvY29sLl'
    'ZpZXdlZFN0b3JpZXNSZXF1ZXN0LlZpZXdlZFN0b3J5LlZpZXdlZFN0b3J5RnJhbWVSBmZyYW1l'
    'cxooChBWaWV3ZWRTdG9yeUZyYW1lEhQKBWluZGV4GAEgASgFUgVpbmRleEoECAEQAg==');

@$core.Deprecated('Use storiesResponseDescriptor instead')
const StoriesResponse$json = {
  '1': 'StoriesResponse',
  '2': [
    {'1': 'stories', '3': 2, '4': 3, '5': 11, '6': '.baladi.protocol.Story', '10': 'stories'},
  ],
  '9': [
    {'1': 1, '2': 2},
  ],
};

/// Descriptor for `StoriesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List storiesResponseDescriptor = $convert.base64Decode(
    'Cg9TdG9yaWVzUmVzcG9uc2USMAoHc3RvcmllcxgCIAMoCzIWLmJhbGFkaS5wcm90b2NvbC5TdG'
    '9yeVIHc3Rvcmllc0oECAEQAg==');

@$core.Deprecated('Use happinessRequestDescriptor instead')
const HappinessRequest$json = {
  '1': 'HappinessRequest',
  '2': [
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.Point', '10': 'point'},
    {'1': 'is_positive', '3': 2, '4': 1, '5': 8, '10': 'isPositive'},
    {'1': 'tags', '3': 3, '4': 3, '5': 11, '6': '.baladi.protocol.HappinessRequest.Tag', '10': 'tags'},
  ],
  '3': [HappinessRequest_Tag$json],
};

@$core.Deprecated('Use happinessRequestDescriptor instead')
const HappinessRequest_Tag$json = {
  '1': 'Tag',
  '2': [
    {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
  ],
};

/// Descriptor for `HappinessRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List happinessRequestDescriptor = $convert.base64Decode(
    'ChBIYXBwaW5lc3NSZXF1ZXN0EiwKBXBvaW50GAEgASgLMhYuYmFsYWRpLnByb3RvY29sLlBvaW'
    '50UgVwb2ludBIfCgtpc19wb3NpdGl2ZRgCIAEoCFIKaXNQb3NpdGl2ZRI5CgR0YWdzGAMgAygL'
    'MiUuYmFsYWRpLnByb3RvY29sLkhhcHBpbmVzc1JlcXVlc3QuVGFnUgR0YWdzGhkKA1RhZxISCg'
    'RuYW1lGAEgASgJUgRuYW1l');

@$core.Deprecated('Use favouriteItemPlaceDescriptor instead')
const FavouriteItemPlace$json = {
  '1': 'FavouriteItemPlace',
  '2': [
    {'1': 'location', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.FavouriteItemPlace.Location', '10': 'location'},
    {'1': 'entity', '3': 2, '4': 1, '5': 11, '6': '.baladi.protocol.FavouriteItemPlace.Entity', '9': 0, '10': 'entity', '17': true},
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
    {'1': 'point', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.Point', '10': 'point'},
  ],
};

@$core.Deprecated('Use favouriteItemPlaceDescriptor instead')
const FavouriteItemPlace_Entity$json = {
  '1': 'Entity',
  '2': [
    {'1': 'source_type', '3': 1, '4': 1, '5': 14, '6': '.baladi.protocol.EntitySourceType', '10': 'sourceType'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `FavouriteItemPlace`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favouriteItemPlaceDescriptor = $convert.base64Decode(
    'ChJGYXZvdXJpdGVJdGVtUGxhY2USSAoIbG9jYXRpb24YASABKAsyLC5iYWxhZGkucHJvdG9jb2'
    'wuRmF2b3VyaXRlSXRlbVBsYWNlLkxvY2F0aW9uUghsb2NhdGlvbhJHCgZlbnRpdHkYAiABKAsy'
    'Ki5iYWxhZGkucHJvdG9jb2wuRmF2b3VyaXRlSXRlbVBsYWNlLkVudGl0eUgAUgZlbnRpdHmIAQ'
    'ESFAoFdGl0bGUYAyABKAlSBXRpdGxlEhoKCHN1YnRpdGxlGAQgASgJUghzdWJ0aXRsZRo4CghM'
    'b2NhdGlvbhIsCgVwb2ludBgBIAEoCzIWLmJhbGFkaS5wcm90b2NvbC5Qb2ludFIFcG9pbnQaXA'
    'oGRW50aXR5EkIKC3NvdXJjZV90eXBlGAEgASgOMiEuYmFsYWRpLnByb3RvY29sLkVudGl0eVNv'
    'dXJjZVR5cGVSCnNvdXJjZVR5cGUSDgoCaWQYAiABKAlSAmlkQgkKB19lbnRpdHk=');

@$core.Deprecated('Use favouriteItemDescriptor instead')
const FavouriteItem$json = {
  '1': 'FavouriteItem',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 9, '10': 'id'},
    {'1': 'place', '3': 2, '4': 1, '5': 11, '6': '.baladi.protocol.FavouriteItemPlace', '10': 'place'},
  ],
};

/// Descriptor for `FavouriteItem`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favouriteItemDescriptor = $convert.base64Decode(
    'Cg1GYXZvdXJpdGVJdGVtEg4KAmlkGAEgASgJUgJpZBI5CgVwbGFjZRgCIAEoCzIjLmJhbGFkaS'
    '5wcm90b2NvbC5GYXZvdXJpdGVJdGVtUGxhY2VSBXBsYWNl');

@$core.Deprecated('Use favouritesResponseDescriptor instead')
const FavouritesResponse$json = {
  '1': 'FavouritesResponse',
  '2': [
    {'1': 'places', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.FavouritesResponse.Places', '10': 'places'},
    {'1': 'items', '3': 2, '4': 3, '5': 11, '6': '.baladi.protocol.FavouriteItem', '10': 'items'},
  ],
  '3': [FavouritesResponse_Places$json],
};

@$core.Deprecated('Use favouritesResponseDescriptor instead')
const FavouritesResponse_Places$json = {
  '1': 'Places',
  '2': [
    {'1': 'home', '3': 1, '4': 1, '5': 11, '6': '.baladi.protocol.FavouriteItemPlace', '9': 0, '10': 'home', '17': true},
    {'1': 'work', '3': 2, '4': 1, '5': 11, '6': '.baladi.protocol.FavouriteItemPlace', '9': 1, '10': 'work', '17': true},
  ],
  '8': [
    {'1': '_home'},
    {'1': '_work'},
  ],
};

/// Descriptor for `FavouritesResponse`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List favouritesResponseDescriptor = $convert.base64Decode(
    'ChJGYXZvdXJpdGVzUmVzcG9uc2USQgoGcGxhY2VzGAEgASgLMiouYmFsYWRpLnByb3RvY29sLk'
    'Zhdm91cml0ZXNSZXNwb25zZS5QbGFjZXNSBnBsYWNlcxI0CgVpdGVtcxgCIAMoCzIeLmJhbGFk'
    'aS5wcm90b2NvbC5GYXZvdXJpdGVJdGVtUgVpdGVtcxqWAQoGUGxhY2VzEjwKBGhvbWUYASABKA'
    'syIy5iYWxhZGkucHJvdG9jb2wuRmF2b3VyaXRlSXRlbVBsYWNlSABSBGhvbWWIAQESPAoEd29y'
    'axgCIAEoCzIjLmJhbGFkaS5wcm90b2NvbC5GYXZvdXJpdGVJdGVtUGxhY2VIAVIEd29ya4gBAU'
    'IHCgVfaG9tZUIHCgVfd29yaw==');

@$core.Deprecated('Use addFavouriteItemsRequestDescriptor instead')
const AddFavouriteItemsRequest$json = {
  '1': 'AddFavouriteItemsRequest',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.baladi.protocol.AddFavouriteItemsRequest.Item', '10': 'items'},
  ],
  '3': [AddFavouriteItemsRequest_Item$json],
};

@$core.Deprecated('Use addFavouriteItemsRequestDescriptor instead')
const AddFavouriteItemsRequest_Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.baladi.protocol.FavouriteItemType', '10': 'type'},
    {'1': 'point', '3': 2, '4': 1, '5': 11, '6': '.baladi.protocol.Point', '10': 'point'},
    {'1': 'entity', '3': 3, '4': 1, '5': 11, '6': '.baladi.protocol.AddFavouriteItemsRequest.Item.Entity', '9': 0, '10': 'entity', '17': true},
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
    {'1': 'source_type', '3': 1, '4': 1, '5': 14, '6': '.baladi.protocol.EntitySourceType', '10': 'sourceType'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '10': 'id'},
  ],
};

/// Descriptor for `AddFavouriteItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List addFavouriteItemsRequestDescriptor = $convert.base64Decode(
    'ChhBZGRGYXZvdXJpdGVJdGVtc1JlcXVlc3QSRAoFaXRlbXMYASADKAsyLi5iYWxhZGkucHJvdG'
    '9jb2wuQWRkRmF2b3VyaXRlSXRlbXNSZXF1ZXN0Lkl0ZW1SBWl0ZW1zGqkCCgRJdGVtEjYKBHR5'
    'cGUYASABKA4yIi5iYWxhZGkucHJvdG9jb2wuRmF2b3VyaXRlSXRlbVR5cGVSBHR5cGUSLAoFcG'
    '9pbnQYAiABKAsyFi5iYWxhZGkucHJvdG9jb2wuUG9pbnRSBXBvaW50ElIKBmVudGl0eRgDIAEo'
    'CzI1LmJhbGFkaS5wcm90b2NvbC5BZGRGYXZvdXJpdGVJdGVtc1JlcXVlc3QuSXRlbS5FbnRpdH'
    'lIAFIGZW50aXR5iAEBGlwKBkVudGl0eRJCCgtzb3VyY2VfdHlwZRgBIAEoDjIhLmJhbGFkaS5w'
    'cm90b2NvbC5FbnRpdHlTb3VyY2VUeXBlUgpzb3VyY2VUeXBlEg4KAmlkGAIgASgJUgJpZEIJCg'
    'dfZW50aXR5');

@$core.Deprecated('Use deleteFavouriteItemsRequestDescriptor instead')
const DeleteFavouriteItemsRequest$json = {
  '1': 'DeleteFavouriteItemsRequest',
  '2': [
    {'1': 'items', '3': 1, '4': 3, '5': 11, '6': '.baladi.protocol.DeleteFavouriteItemsRequest.Item', '10': 'items'},
  ],
  '3': [DeleteFavouriteItemsRequest_Item$json],
};

@$core.Deprecated('Use deleteFavouriteItemsRequestDescriptor instead')
const DeleteFavouriteItemsRequest_Item$json = {
  '1': 'Item',
  '2': [
    {'1': 'type', '3': 1, '4': 1, '5': 14, '6': '.baladi.protocol.FavouriteItemType', '10': 'type'},
    {'1': 'id', '3': 2, '4': 1, '5': 9, '9': 0, '10': 'id', '17': true},
  ],
  '8': [
    {'1': '_id'},
  ],
};

/// Descriptor for `DeleteFavouriteItemsRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List deleteFavouriteItemsRequestDescriptor = $convert.base64Decode(
    'ChtEZWxldGVGYXZvdXJpdGVJdGVtc1JlcXVlc3QSRwoFaXRlbXMYASADKAsyMS5iYWxhZGkucH'
    'JvdG9jb2wuRGVsZXRlRmF2b3VyaXRlSXRlbXNSZXF1ZXN0Lkl0ZW1SBWl0ZW1zGloKBEl0ZW0S'
    'NgoEdHlwZRgBIAEoDjIiLmJhbGFkaS5wcm90b2NvbC5GYXZvdXJpdGVJdGVtVHlwZVIEdHlwZR'
    'ITCgJpZBgCIAEoCUgAUgJpZIgBAUIFCgNfaWQ=');

