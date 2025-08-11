/// Base class for loading and error states
sealed class PoiLoadingOrError {
  const PoiLoadingOrError();
}

/// Loading state
class PoiLoading extends PoiLoadingOrError {
  const PoiLoading();
}

/// Error state
class PoiError extends PoiLoadingOrError {
  static const platformExceptionCode = 'NotFoundException';

  final String errorTitle;
  final String? errorContent;
  final String? buttonLabel;
  final void Function() onRetry;
  final void Function()? onClose;

  const PoiError({
    required this.errorTitle,
    required this.onRetry,
    this.errorContent,
    this.buttonLabel,
    this.onClose,
  });
}
