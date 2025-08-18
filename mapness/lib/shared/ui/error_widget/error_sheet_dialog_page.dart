import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mapness/shared/ui/sheets/error_sheet.dart';
import 'package:sheetify/sheetify.dart';

@RoutePage()
class ErrorSheetDialogPage extends ConsumerWidget {
  /// This page use to call dialog with error stateless bottom sheet
  final VoidCallback onRetry;
  final String? buttonLabel;
  final String? errorLabel;
  final ToggleSheetOnCloseCallback? onClose;

  /// Add barrier to bottom sheet background
  final bool hasBarrier;

  /// Called on background barrier tap (cause not always context.pop is not enough)
  final VoidCallback? onBarrierTap;

  const ErrorSheetDialogPage({
    required this.onRetry,
    this.buttonLabel,
    this.errorLabel,
    this.onClose,
    this.hasBarrier = false,
    this.onBarrierTap,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => ErrorSheetWidget(
        hasBarrier: hasBarrier,
        onBarrierTap: onBarrierTap,
        onRetry: onRetry,
        buttonLabel: buttonLabel,
        errorLabel: errorLabel,
        onClose: onClose,
      );
}
