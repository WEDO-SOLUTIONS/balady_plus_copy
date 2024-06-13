/*import 'package:balady_plus/app/core/shared_local_services/app_colors.dart';
import 'package:balady_plus/app/core/shared_local_services/enums.dart';
import 'package:balady_plus/app/core/shared_local_services/helpers.dart';
import 'package:flutter/material.dart';

class MapScreenDetails extends StatefulWidget {
  var address;
  Function submitLocation;
  bool isValidLocation;
  CustomerVoiceType incidentType;

  MapScreenDetails(
      {this.address,
      required this.submitLocation,
      required this.isValidLocation,
      this.incidentType = CustomerVoiceType.Balady940});

  @override
  _MapScreenDetailsState createState() => _MapScreenDetailsState();
}

class _MapScreenDetailsState extends State<MapScreenDetails> {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
          padding:
              const EdgeInsets.only(top: 5, right: 15, left: 15, bottom: 20),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 20, bottom: 20, left: 20, right: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      textDirection: !Helpers.isArabic(context)
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      children: <Widget>[
                        Text(
                          widget.incidentType == CustomerVoiceType.REQ
                              ? "العنوان"
                              : Helpers.translatingWord(
                                  "lbl_violation_location"),
                          textScaleFactor: 1,
                          style: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  const Divider(
                    color: Colors.black,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      textDirection: !Helpers.isArabic(context)
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Image.asset(
                          "assets/images/marker2@3x.png",
                          height: 18.0,
                          width: 18.0,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            widget.address ??
                                    widget.incidentType ==
                                            CustomerVoiceType.REQ ||
                                        widget.incidentType ==
                                            CustomerVoiceType.None
                                ? Helpers.translatingWord(
                                    "select_request_location")
                                : Helpers.translatingWord(
                                    "select_incident_location"),
                            textDirection: !Helpers.isArabic(context)
                                ? TextDirection.ltr
                                : TextDirection.rtl,
                            maxLines: 3,
                            textScaleFactor: 1,
                            style: const TextStyle(
                                color: AppColor.kGray115,
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          color:
                              (widget.address != null || widget.isValidLocation)
                                  ? AppColor.baladyDarkGreen2
                                  : AppColor.kGray230,
                          borderRadius: new BorderRadius.circular(2.0)),
                      child: TextButton(
                        onPressed: () {
                          if (widget.isValidLocation) widget.submitLocation();
                        },
                        child: Text(
                          Helpers.translatingWord(
                              "lbl_confirm_incident_address"),
                          textScaleFactor: 1,
                          style: TextStyle(
                            color: (widget.address != null ||
                                    widget.isValidLocation)
                                ? Colors.white
                                : AppColor.kGray153,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
*/
