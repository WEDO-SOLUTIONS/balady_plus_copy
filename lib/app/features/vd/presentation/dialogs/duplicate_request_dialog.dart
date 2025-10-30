import 'package:balady_plus/app/core/utils/constants/keys/general_keys.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/constants.dart';
import '../../../../core/utils/constants/paths/icon_paths.dart';

class DuplicateRequestDialog extends StatelessWidget {
  final Function onSelect;
  final String title;
  final String body;
  final String confirmButtonText;
  final String cancelButtonText;

  const DuplicateRequestDialog(
      {Key? key,
      required this.onSelect,
      required this.title,
      required this.body,
      required this.cancelButtonText,
      required this.confirmButtonText})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 421.0,
        width: 327.0,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        onSelect(null);
                        Navigator.of(context).pop();
                      },
                      child: Image.asset(
                        IconPath.qrWhiteCloseIcon,
                        height: 16.0,
                        width: 16.0,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset(
                "assets/images/duplicate@3x.png",
                height: 80.0,
                width: 128.0,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 28),
                child: Text(title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontFamily: GeneralKey.appFontType,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.normal,
                        fontSize: 22.0),
                    textScaleFactor: 1.0,
                    textAlign: TextAlign.center),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                  child: Text(
                    body,
                    style: TextStyle(
                        color: AppColor.kGray115,
                        fontFamily: GeneralKey.appFontType,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 15.0,
                        height: 1.5),
                    textAlign: TextAlign.center,
                    textScaleFactor: 1.0,
                  )),
              Container(
                child: Padding(
                    padding: EdgeInsets.only(top: 20, right: 27, left: 27),
                    child: Container(
                      width: 274,
                      height: 56,
                      decoration: BoxDecoration(
                          color: AppColor.primary900Light,
                          borderRadius: new BorderRadius.circular(2.0)),
                      child: TextButton(
                        onPressed: () {
                          onSelect(false);
                        },
                        child: Text(
                          cancelButtonText,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: GeneralKey.appFontType,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    )),
              ),
              Container(
                child: Padding(
                    padding: EdgeInsets.only(top: 10, right: 27, left: 27),
                    child: Container(
                      width: 274,
                      height: 56,
                      child: TextButton(
                        onPressed: () {
                          onSelect(true);

                          Navigator.of(context).pop();
                        },
                        child: Text(
                          confirmButtonText,
                          textAlign: TextAlign.center,
                          textScaleFactor: 1.0,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: GeneralKey.appFontType,
                              fontWeight: FontWeight.w500,
                              color: AppColor.primary900Light),
                        ),
                      ),
                    )),
              ),
            ],
          ),
        ));
  }
}
