import '../../../../../core/utils/utils_exports.dart' show PageTypes;

class SuccessScreenArgs {
  String? idNumber;
  PageTypes type;
  String? msg;
  String? icon;
  bool? fromHomePage;
  bool? changeProvider;
  String? thanksMessage;
  double? iconHeight;
  double? iconWidth;

  SuccessScreenArgs(
      {this.idNumber,
      this.msg,
      required this.type,
      this.thanksMessage,
      this.icon,
      this.fromHomePage = false,
      this.changeProvider = false,
      this.iconHeight = 228,
      this.iconWidth = 167});
}
