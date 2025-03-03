part of 'feedback_select_options_component_widget.dart';

class FeedbackSelectOptionsFormContainer extends StatelessWidget {
  const FeedbackSelectOptionsFormContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) => FeedbackFormContainer(
        title: context.l10n.whatsNew,
        isSendVisible: false,
        child: child,
      );
}
