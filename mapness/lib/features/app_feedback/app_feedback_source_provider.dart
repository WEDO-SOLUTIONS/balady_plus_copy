import 'package:flutter/widgets.dart';
import 'package:mapness/entities/app_feedback/feedback_source.dart';

class FeedbackSourceProvider extends InheritedWidget {
  final FeedbackSource source;

  const FeedbackSourceProvider({
    required this.source,
    required super.child,
    super.key,
  });

  static FeedbackSourceProvider? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<FeedbackSourceProvider>();

  static FeedbackSourceProvider of(BuildContext context) {
    final FeedbackSourceProvider? result = maybeOf(context);
    assert(result != null, 'No FeedbackSourceProvider found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(covariant FeedbackSourceProvider oldWidget) => source != oldWidget.source;
}
