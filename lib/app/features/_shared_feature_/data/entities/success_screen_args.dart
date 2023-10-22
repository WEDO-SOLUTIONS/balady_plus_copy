import '../../../../core/utils/enums/enums.dart';

class SuccessScreenArgs {
  String? idNumber;
  PAGE_TYPE type;
  String? msg;
  bool? fromHomePage;
  String? municipilaty;
  String? thanksMessage;
  bool? isFawry;

  SuccessScreenArgs(
      {this.idNumber,
      this.msg,
      this.municipilaty,
      required this.type,
      this.thanksMessage,
      this.isFawry = false,
      this.fromHomePage = false});
}
