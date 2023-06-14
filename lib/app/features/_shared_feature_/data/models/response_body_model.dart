class ResponseBodyModel {
  final ResponseStatusDetails statusDetails;
  final ResponseData data;

  ResponseBodyModel({required this.statusDetails, required this.data});

  factory ResponseBodyModel.fromMap(Map<String, dynamic> map) {
    return ResponseBodyModel(
      statusDetails: (map['statusDetails'] is List<dynamic>)
          ? ResponseStatusDetails.fromMap(
              (map['statusDetails'] as List<dynamic>).first,
            )
          : ResponseStatusDetails.fromMap(map['statusDetails']),
      data: ResponseData.fromMap(map['data']),
    );
  }
}

class ResponseStatusDetails {
  final dynamic code;
  final String message;

  ResponseStatusDetails({required this.code, required this.message});

  factory ResponseStatusDetails.fromMap(Map<String, dynamic> map) {
    return ResponseStatusDetails(
      code: map['code'] ?? 400,
      message: map['message'] ?? '',
    );
  }
}

/* 
{statusDetails: {code: 200, message: Ok}, 
data: {responseCode: 1, responseMessage: success, 
result: {ReceiptResult: 1, ReferenceNumber: REFID-193}}}
 */

class ResponseData {
  final dynamic responseCode;
  final String responseMessage;
  final dynamic result;

  // Returned when submit visit
  // final String referenceNumber;

  ResponseData({
    required this.responseCode,
    required this.responseMessage,
    required this.result,
    //
    // required this.referenceNumber,
  });

  factory ResponseData.fromMap(Map<String, dynamic> map) {
    return ResponseData(
      responseCode: map['responseCode'] ?? 400,
      responseMessage: map['responseMessage'] ?? '',
      result: map['result'],
      //
      // referenceNumber: map['ReferenceNumber'] ?? '',
    );
  }
}
