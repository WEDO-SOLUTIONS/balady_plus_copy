import '../../municipal_advisor_exports.dart';

enum MunicipalAdvisorSteps {
  start(ChatBubbleType.text),
  topic(ChatBubbleType.checkbox),
  location(ChatBubbleType.map);

  const MunicipalAdvisorSteps(this.type);

  final ChatBubbleType type;
}
