import '../../entry_point_exports.dart';

class SsoUserInfoModel extends SsoUserInfo {
  SsoUserInfoModel(
      {super.name,
      super.phone,
      super.mail,
      super.arName,
      super.enName,
      super.idNo,
      super.nid,
      super.idType,
      super.sex,
      super.dob,
      super.sname,
      super.sub,
      super.nationality,
      super.tnm});

  factory SsoUserInfoModel.fromJson(Map<String, dynamic> json) => SsoUserInfoModel(
      name: json["name"],
      phone: json["phone"],
      mail: json["mail"],
      arName: json["ar_name"],
      enName: json["en_name"],
      idNo: json["id_no"],
      nid: json["nid"],
      idType: json["id_type"],
      sex: json["sex"],
      dob: json["dob"],
      sname: json["sname"],
      sub: json["sub"],
      nationality: json["nationality"],
      tnm: json["tnm"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "phone": phone,
        "mail": mail,
        "ar_name": arName,
        "en_name": enName,
        "id_no": idNo,
        "nid": nid,
        "id_type": idType,
        "sex": sex,
        "dob": dob,
        "sname": sname,
        "sub": sub,
        "nationality": nationality,
        "tnm": tnm
      };
}

extension SSOUserInfoModelFromEntity on SsoUserInfo {
  SsoUserInfoModel get toModel => SsoUserInfoModel(
      arName: arName,
      enName: enName,
      dob: dob,
      idNo: idNo,
      idType: idType,
      mail: mail,
      name: name,
      nid: nid,
      phone: phone,
      sex: sex,
      sname: sname,
      sub: sub,
      nationality: nationality,
      tnm: tnm);
}
