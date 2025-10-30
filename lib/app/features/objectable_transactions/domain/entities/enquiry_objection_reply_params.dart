// ignore_for_file: public_member_api_docs, sort_constructors_first
import '../../../_shared_feature_/data/entities/file_data_item.dart';

class EnquiryObjectionReplyDetails {
  String? objectionRequestNumber;
  String? enquiryRequestNumber;

  List<EnquiryQuestionList>? enquiryQuestionList;

  EnquiryObjectionReplyDetails({
    this.objectionRequestNumber,
    this.enquiryRequestNumber,
    this.enquiryQuestionList,
  });

  factory EnquiryObjectionReplyDetails.fromJson(Map<String, dynamic> json) =>
      EnquiryObjectionReplyDetails(
        objectionRequestNumber: json["ObjectionRequestNumber"],
        enquiryRequestNumber: json["EnquiryRequestNumber"],
        enquiryQuestionList: json["EnquiryQuestionList"] == null
            ? []
            : List<EnquiryQuestionList>.from(json["EnquiryQuestionList"]!
                .map((x) => EnquiryQuestionList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "ObjectionRequestNumber": objectionRequestNumber,
        "EnquiryRequestNumber": enquiryRequestNumber,
        "EnquiryQuestionList": enquiryQuestionList == null
            ? []
            : List<dynamic>.from(enquiryQuestionList!.map((x) => x.toJson())),
      };
}

class EnquiryQuestionList {
  String? answer;
  String? questionId;
  String? question;
  List<QuestionAttachmentList>? questionAttachmentList;
  List<AnswerAttachmentList>? answerAttachmentList;

  EnquiryQuestionList({
    this.answer,
    this.questionId,
    this.question,
    this.questionAttachmentList,
    this.answerAttachmentList,
  });

  factory EnquiryQuestionList.fromJson(Map<String, dynamic> json) =>
      EnquiryQuestionList(
        answer: json["Answer"],
        questionId: json["QuestionID"],
        questionAttachmentList: json["QuestionAttachmentList"] == null
            ? []
            : List<QuestionAttachmentList>.from(json["QuestionAttachmentList"]!
                .map((x) => QuestionAttachmentList.fromJson(x))),
        answerAttachmentList: json["AnswerAttachmentList"] == null
            ? []
            : List<AnswerAttachmentList>.from(json["AnswerAttachmentList"]!
                .map((x) => AnswerAttachmentList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "Answer": answer,
        "QuestionID": questionId,
        "QuestionAttachmentList": questionAttachmentList == null
            ? []
            : List<dynamic>.from(
                questionAttachmentList!.map((x) => x.toJson())),
        "AnswerAttachmentList": answerAttachmentList == null
            ? []
            : List<dynamic>.from(answerAttachmentList!.map((x) => x.toJson())),
      };
}

class AnswerAttachmentList {
  String? answerAttachmentLocation;
  String? answerAttachmentName;
  FileDataItem? file;

  AnswerAttachmentList(
      {this.answerAttachmentLocation, this.answerAttachmentName, this.file});

  factory AnswerAttachmentList.fromJson(Map<String, dynamic> json) =>
      AnswerAttachmentList(
        answerAttachmentLocation: json["AnswerAttachmentLocation"],
        answerAttachmentName: json["AnswerAttachmentName"],
      );

  Map<String, dynamic> toJson() => {
        "AnswerAttachmentLocation": answerAttachmentLocation,
        "AnswerAttachmentName": answerAttachmentName,
      };

  AnswerAttachmentList copyWith({
    String? answerAttachmentLocation,
    String? answerAttachmentName,
    FileDataItem? file,
  }) {
    return AnswerAttachmentList(
      answerAttachmentLocation:
          answerAttachmentLocation ?? this.answerAttachmentLocation,
      answerAttachmentName: answerAttachmentName ?? this.answerAttachmentName,
      file: file ?? this.file,
    );
  }
}

class QuestionAttachmentList {
  String? questionAttachmentName;
  String? questionAttachmentLocation;

  QuestionAttachmentList({
    this.questionAttachmentName,
    this.questionAttachmentLocation,
  });

  factory QuestionAttachmentList.fromJson(Map<String, dynamic> json) =>
      QuestionAttachmentList(
        questionAttachmentName: json["QuestionAttachmentName"],
        questionAttachmentLocation: json["QuestionAttachmentLocation"],
      );

  Map<String, dynamic> toJson() => {
        "QuestionAttachmentName": questionAttachmentName,
        "QuestionAttachmentLocation": questionAttachmentLocation,
      };
}
