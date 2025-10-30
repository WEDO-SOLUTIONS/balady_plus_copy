// To parse this JSON data, do
//
//     final objectionEnquiryDetails = objectionEnquiryDetailsFromJson(jsonString);

import 'dart:convert';

ObjectionEnquiryDetails objectionEnquiryDetailsFromJson(String str) =>
    ObjectionEnquiryDetails.fromJson(json.decode(str));

String objectionEnquiryDetailsToJson(ObjectionEnquiryDetails data) =>
    json.encode(data.toJson());

class ObjectionEnquiryDetails {
  final DateTime? enquiryDate;
  final String? objectionRequestNumber;
  final List<EnquiryQuestionList>? enquiryQuestionList;
  final String? enquiryStatusId;
  final String? enquiryRequestNumber;
  final DateTime? enquiryDueDate;
  final String? enquiryStatusName;
  final String? enquiryRequestedFromName;
  final String? enquiryRequestedFromId;
  final DateTime? enquiryResponseDate;

  ObjectionEnquiryDetails({
    this.enquiryDate,
    this.objectionRequestNumber,
    this.enquiryQuestionList,
    this.enquiryStatusId,
    this.enquiryRequestNumber,
    this.enquiryDueDate,
    this.enquiryStatusName,
    this.enquiryRequestedFromName,
    this.enquiryRequestedFromId,
    this.enquiryResponseDate,
  });

  factory ObjectionEnquiryDetails.fromJson(Map<String, dynamic> json) =>
      ObjectionEnquiryDetails(
        enquiryDate: json["EnquiryDate"] == null
            ? null
            : DateTime.parse(json["EnquiryDate"]),
        objectionRequestNumber: json["ObjectionRequestNumber"],
        enquiryQuestionList: json["EnquiryQuestionList"] == null
            ? []
            : List<EnquiryQuestionList>.from(json["EnquiryQuestionList"]!
                .map((x) => EnquiryQuestionList.fromJson(x))),
        enquiryStatusId: json["EnquiryStatusId"],
        enquiryRequestNumber: json["EnquiryRequestNumber"],
        enquiryDueDate: json["EnquiryDueDate"] == null
            ? null
            : DateTime.parse(json["EnquiryDueDate"]),
        enquiryStatusName: json["EnquiryStatusName"],
        enquiryRequestedFromName: json["EnquiryRequestedFromName"],
        enquiryRequestedFromId: json["EnquiryRequestedFromId"],
        enquiryResponseDate: json["EnquiryResponseDate"] == null
            ? null
            : DateTime.tryParse(json["EnquiryResponseDate"]),
      );

  Map<String, dynamic> toJson() => {
        "EnquiryDate": enquiryDate?.toIso8601String(),
        "ObjectionRequestNumber": objectionRequestNumber,
        "EnquiryQuestionList": enquiryQuestionList == null
            ? []
            : List<dynamic>.from(enquiryQuestionList!.map((x) => x.toJson())),
        "EnquiryStatusId": enquiryStatusId,
        "EnquiryRequestNumber": enquiryRequestNumber,
        "EnquiryDueDate": enquiryDueDate?.toIso8601String(),
        "EnquiryStatusName": enquiryStatusName,
        "EnquiryRequestedFromName": enquiryRequestedFromName,
        "EnquiryRequestedFromId": enquiryRequestedFromId,
        "EnquiryResponseDate": enquiryResponseDate?.toIso8601String(),
      };
}

class EnquiryQuestionList {
  final String? answer;
  final List<QuestionAttachmentList>? questionAttachmentList;
  final String? questionId;
  final List<AnswerAttachmentList>? answerAttachmentList;
  final String? question;

  EnquiryQuestionList({
    this.answer,
    this.questionAttachmentList,
    this.questionId,
    this.answerAttachmentList,
    this.question,
  });

  factory EnquiryQuestionList.fromJson(Map<String, dynamic> json) =>
      EnquiryQuestionList(
        answer: json["Answer"],
        questionAttachmentList: json["QuestionAttachmentList"] == null
            ? []
            : List<QuestionAttachmentList>.from(json["QuestionAttachmentList"]!
                .map((x) => QuestionAttachmentList.fromJson(x))),
        questionId: json["QuestionID"],
        answerAttachmentList: json["AnswerAttachmentList"] == null
            ? []
            : List<AnswerAttachmentList>.from(json["AnswerAttachmentList"]!
                .map((x) => AnswerAttachmentList.fromJson(x))),
        question: json["Question"],
      );

  Map<String, dynamic> toJson() => {
        "Answer": answer,
        "QuestionAttachmentList": questionAttachmentList == null
            ? []
            : List<dynamic>.from(
                questionAttachmentList!.map((x) => x.toJson())),
        "QuestionID": questionId,
        "AnswerAttachmentList": answerAttachmentList == null
            ? []
            : List<dynamic>.from(answerAttachmentList!.map((x) => x)),
        "Question": question,
      };
}

class QuestionAttachmentList {
  final String? questionAttachmentName;
  final String? questionAttachmentLocation;

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

class AnswerAttachmentList {
  final String? answerAttachmentName;
  final String? answerAttachmentLocation;

  AnswerAttachmentList({
    this.answerAttachmentName,
    this.answerAttachmentLocation,
  });

  factory AnswerAttachmentList.fromJson(Map<String, dynamic> json) =>
      AnswerAttachmentList(
        answerAttachmentName: json["AnswerAttachmentName"],
        answerAttachmentLocation: json["AnswerAttachmentLocation"],
      );

  Map<String, dynamic> toJson() => {
        "answerAttachmentName": answerAttachmentName,
        "answerAttachmentLocation": answerAttachmentLocation,
      };
}
