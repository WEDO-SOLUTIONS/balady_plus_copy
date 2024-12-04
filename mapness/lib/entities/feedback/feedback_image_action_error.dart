/// Represents the state of feedback image actions.
/// Used while picking images
sealed class FeedbackImagePickError {
  const FeedbackImagePickError();
}

/// Represents an error when the image format is not supported.
class FeedbackImageWrongFormatError extends FeedbackImagePickError {
  /// List of supported image formats.
  final List<String> supportedFormats;

  const FeedbackImageWrongFormatError({required this.supportedFormats});
}

/// Represents an error when the image size exceeds the maximum allowed size.
class FeedbackImageSizeExceededError extends FeedbackImagePickError {
  /// Maximum allowed file size in bytes.
  final int maxFileSize;

  const FeedbackImageSizeExceededError({required this.maxFileSize});
}
