import 'package:freezed_annotation/freezed_annotation.dart';

part 'file_upload.freezed.dart';

@freezed
sealed class FileUpload with _$FileUpload {
  const factory FileUpload.init({
    required String srcPath,
  }) = FileUploadInit;
  const factory FileUpload.progress({
    /// where file is located in client device
    required String srcPath,

    /// from 0 to 1
    required double progress,
  }) = FileUploadProgress;

  const factory FileUpload.success({
    required String srcPath,

    /// determine location on s3 or other service for storing
    required String serverUrl,
  }) = FileUploadSuccess;

  const factory FileUpload.cancelled({
    required String srcPath,
  }) = FileUploadCancelled;

  /// filetype is bad.
  const factory FileUpload.clientError({
    required String srcPath,
    required ClientErrorReason reason,
  }) = FileUploadClientError;

  /// something not related to client or server
  const factory FileUpload.networkError({
    required String srcPath,
    required NetworkErrorReason reason,
  }) = FileUploadNetworkError;

  /// actually server error is kinda panic situation.
  /// and client don't actually supposed to handle it
  const factory FileUpload.unknownError({
    required String srcPath,
    required String message,
  }) = FileUploadUnknownError;
}

enum ClientErrorReason {
  size,
  filetype,
}

enum NetworkErrorReason {
  sendTimeout,
  receiveTimeout,
  connectTimeout,
  connectionError,
}
