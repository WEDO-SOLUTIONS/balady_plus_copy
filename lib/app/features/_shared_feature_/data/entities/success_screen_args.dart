import '../../../../core/utils/enums/enums.dart';

class SuccessScreenArgs {
  String? idNumber;
  PAGE_TYPE type;
  String? msg;
  bool? fromHomePage;
  String? municipilaty;
  String? thanksMessage;

  SuccessScreenArgs(
      {this.idNumber,
      this.msg,
      this.municipilaty,
      required this.type,
      this.thanksMessage,
      this.fromHomePage = false});
}
