import '../../../../../../features/_shared_feature_/data/entities/drop_down_item.dart';

class IsicsMainActivity extends DropDownItem {
  String? isicCode;
  String? isicName;
  bool? existInBalady;
  bool? atmActivity;
  bool? valid;
  String? message;

  IsicsMainActivity({
    this.isicCode,
    this.isicName,
    this.existInBalady,
    this.atmActivity,
    this.valid,
    this.message,
  }) : super(
    id: isicCode ?? '',
    name: isicName ?? '',
  );


  factory IsicsMainActivity.fromJson(Map<String, dynamic> json) =>
      IsicsMainActivity(
          isicCode : json['isicCode'],
          isicName : json['isicName'],
          existInBalady:json['existInBalady'],
          atmActivity : json['atmActivity'],
          valid : json['valid'],
         message : json['message']
      );



  Map<String, dynamic> toJson() => {
    "atmActivity": atmActivity,
    "existInBalady": existInBalady,
    "isicCode": isicCode,
    "isicName": isicName,
    "valid": valid,
  };
}