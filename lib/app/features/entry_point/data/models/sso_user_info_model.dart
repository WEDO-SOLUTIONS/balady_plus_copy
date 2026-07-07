import '../../entry_point_exports.dart';

class SsoUserInfoModel extends SsoUserInfo {
  const SsoUserInfoModel({
    super.name,
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
    super.tnm,
    super.loginType,
    super.isEmailVerified,
    super.isEmailEditable,
    super.isSSOLocked,
    super.completeProfile,
  });

  factory SsoUserInfoModel.fromJson(Map<String, dynamic> json) {
    final loginTypeRaw = json['loginType']?.toString();
    final loginType = loginTypeRaw == SsoLoginType.otp.name
        ? SsoLoginType.otp
        : SsoLoginType.nationalId;

    return SsoUserInfoModel(
      name: json['name'],
      phone: json['phone'],
      mail: json['mail'] ?? json['email'],
      arName: json['ar_name'] ?? json['nameAr'],
      enName: json['en_name'],
      idNo: json['id_no'],
      nid: json['nid'],
      idType: json['id_type'],
      sex: json['sex'],
      dob: json['dob'],
      sname: json['sname'],
      sub: json['sub'],
      nationality: json['nationality'],
      tnm: json['tnm'],
      loginType: loginType,
      isEmailVerified: json['isEmailVerified'] == true,
      isEmailEditable: json['isEmailEditable'] ?? true,
      isSSOLocked: json['isSSOLocked'] ?? false,
      completeProfile: json['complete_profile'] ?? json['completeProfile'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'name': name,
        'phone': phone,
        'mail': mail,
        'ar_name': arName,
        'en_name': enName,
        'id_no': idNo,
        'nid': nid,
        'id_type': idType,
        'sex': sex,
        'dob': dob,
        'sname': sname,
        'sub': sub,
        'nationality': nationality,
        'tnm': tnm,
        'loginType': loginType.name,
        'isEmailVerified': isEmailVerified,
        'isEmailEditable': isEmailEditable,
        'isSSOLocked': isSSOLocked,
        'complete_profile': completeProfile,
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
        tnm: tnm,
        loginType: loginType,
        isEmailVerified: isEmailVerified,
        isEmailEditable: isEmailEditable,
        isSSOLocked: isSSOLocked,
        completeProfile: completeProfile,
      );
}
