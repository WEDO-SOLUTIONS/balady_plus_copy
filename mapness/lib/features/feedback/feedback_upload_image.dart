import 'dart:async';

import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/features/feedback/feedback_dio.dart';
import 'package:mapness/shared/lib/file_upload.dart';
import 'package:mapness/shared/utils/detach.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'feedback_upload_image.g.dart';

@riverpod
class FeedbackUploadImage extends _$FeedbackUploadImage {
  CancelToken? _cancelToken;

  @override
  FileUpload build(String filePath) {
    /// if instance changes, need reupload
    ref.watch(feedbackDioProvider);

    final file = XFile(filePath);

    /// if provider refreshed, cancel old operation
    _cancelToken?.cancel();
    final cancelToken = CancelToken();
    _cancelToken = cancelToken;

    /// if consumer does not wait for upload => cancel
    ref.onDispose(() => cancelToken.cancel());

    /// start upload
    detach(_dioExceptionHandler(() => _sendFile(file, cancelToken)), tag: 'feedbackUploadImage.dioExceptionHandler');

    return FileUploadInit(srcPath: filePath);
  }

  Future<void> cancelUpload() async {
    _cancelToken?.cancel();
  }

  Future<void> _sendFile(XFile file, CancelToken cancelToken) async {
    final Dio dio = await ref.read(feedbackDioProvider.future);

    final fileBytes = await file.readAsBytes();
    state = FileUpload.progress(srcPath: filePath, progress: 0);

    try {
      final response = await dio.post(
        '/upload/image',

        /// api is used for some extra purposes, we only upload images
        queryParameters: {'type': 'discrepancy_images'},
        data: Stream.fromIterable(fileBytes.map((e) => [e])),
        options: Options(
          sendTimeout: const Duration(days: 1),
          headers: {
            ...dio.options.headers,
            'Content-Type': 'application/octet-stream',
            'Accept': 'application/json',
          },
          contentType: 'application/octet-stream',
        ),
        cancelToken: cancelToken,
        onReceiveProgress: _receiveProgress,
      );

      final url = (response.data as Map<String, dynamic>)['url'] as String?;
      if (url == null) {
        state = FileUpload.unknownError(
          srcPath: filePath,
          message: 'server returned no url',
        );
        return;
      }
      state = FileUploadSuccess(serverUrl: url, srcPath: filePath);
    } on DioException catch (_) {
      cancelToken.cancel();
      state = FileUpload.unknownError(
        srcPath: filePath,
        message: 'Server returned bad response',
      );
    }
  }

  void _receiveProgress(int sent, int total) {
    final progress = sent / total;
    state = FileUploadProgress(progress: progress, srcPath: filePath);
  }

  Future<void> _dioExceptionHandler(Future<void> Function() request) async {
    try {
      await request();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        state = FileUpload.cancelled(srcPath: filePath);
        return;
      }

      final networkError = switch (e.type) {
        DioExceptionType.connectionTimeout => NetworkErrorReason.connectTimeout,
        DioExceptionType.sendTimeout => NetworkErrorReason.sendTimeout,
        DioExceptionType.receiveTimeout => NetworkErrorReason.receiveTimeout,
        DioExceptionType.connectionError => NetworkErrorReason.connectionError,
        _ => null,
      };

      if (networkError != null) {
        state = FileUpload.networkError(srcPath: filePath, reason: networkError);
        return;
      }
    } catch (e) {
      state = FileUpload.unknownError(srcPath: filePath, message: 'An unexpected error occurred: $e');
    }
  }
}
