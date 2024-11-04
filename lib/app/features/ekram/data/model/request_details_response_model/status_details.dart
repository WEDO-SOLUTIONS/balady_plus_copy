class StatusDetails {
  int? code;
  String? message;

  StatusDetails({this.code, this.message});

  factory StatusDetails.fromJson(Map<String, dynamic> json) => StatusDetails(
        code: json['code'] as int?,
        message: json['message'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
      };
}
