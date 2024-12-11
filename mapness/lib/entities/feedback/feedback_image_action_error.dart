/// Represents the state of feedback image actions.
/// Used while picking images
sealed class FeedbackImagePickError {
  const FeedbackImagePickError();
}

/// Represents an error when the image format is not supported.
///
/// Example: supported formats are `['jpg', 'png']` and the user tries to upload a `gif` image.
class FeedbackImageWrongFormatError extends FeedbackImagePickError {
  /// List of supported image formats.
  final List<String> supportedFormats;

  const FeedbackImageWrongFormatError({required this.supportedFormats});
}

/// Represents an error when the image size exceeds the maximum allowed size.
///
/// Example: maximum allowed size is `5MB` and the user tries to upload a `10MB` image.
class FeedbackImageSizeExceededError extends FeedbackImagePickError {
  /// Maximum allowed file size in bytes.
  final int maxFileSize;

  const FeedbackImageSizeExceededError({required this.maxFileSize});
}
