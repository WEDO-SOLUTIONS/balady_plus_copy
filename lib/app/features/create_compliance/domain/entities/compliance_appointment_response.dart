// To parse this JSON data, do
//
//     final complainceAppointmentResponse = complainceAppointmentResponseFromJson(jsonString);

import 'dart:convert';

ComplainceAppointmentResponse complainceAppointmentResponseFromJson(String str) => ComplainceAppointmentResponse.fromJson(json.decode(str));

String complainceAppointmentResponseToJson(ComplainceAppointmentResponse data) => json.encode(data.toJson());

class ComplainceAppointmentResponse {
    List<DayItem> result;

    ComplainceAppointmentResponse({
        required this.result,
    });

    factory ComplainceAppointmentResponse.fromJson(Map<String, dynamic> json) => ComplainceAppointmentResponse(
        result: List<DayItem>.from(json["result"].map((x) => DayItem.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class DayItem {
    List<Slot> slots;
    String slotDate;
    String pxListSubscript;
    String day;

    DayItem({
        required this.slots,
        required this.slotDate,
        required this.pxListSubscript,
        required this.day,
    });

    factory DayItem.fromJson(Map<String, dynamic> json) => DayItem(
        slots: List<Slot>.from(json["Slots"].map((x) => Slot.fromJson(x))),
        slotDate: json["SlotDate"],
        pxListSubscript: json["pxListSubscript"],
        day: json["Day"],
    );

    Map<String, dynamic> toJson() => {
        "Slots": List<dynamic>.from(slots.map((x) => x.toJson())),
        "SlotDate": slotDate,
        "pxListSubscript": pxListSubscript,
        "Day": day,
    };
}

class Slot {
    String endTime;
    String startTime;

    Slot({
        required this.endTime,
        required this.startTime,
    });

    factory Slot.fromJson(Map<String, dynamic> json) => Slot(
        endTime: json["EndTime"],
        startTime: json["StartTime"],
    );

    Map<String, dynamic> toJson() => {
        "EndTime": endTime,
        "StartTime": startTime,
    };
}
