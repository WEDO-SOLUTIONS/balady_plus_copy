import 'package:balady_plus/app/features/municipal_services/municipal_advisor/municipal_advisor_exports.dart';
import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String message;
  final bool isResponse;
  final DateTime timeStamp;
  final MunicipalAdvisorSteps step;
  final dynamic data;
  final bool customWidget;

  ChatMessage({
    required this.message,
    required this.isResponse,
    required this.step,
    this.data,
    this.customWidget = false,
  }) : timeStamp = DateTime.now();

  @override
  List<Object?> get props => [
        message,
        isResponse,
        step,
        timeStamp,
        data,
        customWidget,
      ];
}
