class SsoUserInfo {
  const SsoUserInfo({
    this.name,
    this.phone,
    this.mail,
    this.arName,
    this.idNo,
    this.nid,
    this.idType,
    this.sex,
    this.dob,
    this.sname,
    this.sub,
    this.nationality,
    this.enName,
    this.givenName,
    this.familyName,
  });

  final String? name;
  final String? phone;
  final String? mail;
  final String? arName;
  final String? enName;
  final String? idNo;
  final String? nid;
  final String? idType;
  final String? sex;
  final String? dob;
  final String? sname;
  final String? sub;
  final String? nationality;
  final String? givenName;
  final String? familyName;

  String getFormattedBirthDate({bool withDash = false}) {
    if (dob != null) {
      final formattedBirthDate = dob!;
      //  formattedBirthDate = formattedBirthDate.replaceAll("-", "/");
      var birthDate = '';
      if (withDash) {
        birthDate = formattedBirthDate.split('/').reversed.join('-');
      } else {
        birthDate = formattedBirthDate.split('/').reversed.join('/');
      }

      return birthDate;
    }
    return '';
  }

  String getFirstName() {
    final names = sname?.split(',') ?? [''];

    return names.first;
  }

  String getLastName() {
    final names = sname?.split(',') ?? [''];

    return names.last;
  }

  String getMiddleName() {
    try {
      final names = sname?.split(',') ?? [''];

      return names.elementAt(1);
    } catch (ex) {
      return ' ';
    }
  }

  String getThirdName() {
    try {
      final names = (sname ?? '').split(',');
      if (names.length >= 4) {
        return names.elementAt(2);
      }
    } catch (ex) {
      return ' ';
    }
    return ' ';
  }

  String getFirstAndLastName() => "${givenName ?? ''} ${familyName ?? ''}";

  String getIdType() {
    if (idNo != null) {
      if (idNo?.startsWith('1') ?? false) {
        return '1';
      } else {
        return '3';
      }

// هوية وطنيه ١
// هوية خليجيه ٤
// رقم حدود ٩
// هوية مقيم ٣
    }
    return '';
  }

  String getIdTypeName() {
    if (idType != null) {
      if (idType?.startsWith('1') ?? false) {
        return 'هوية وطنية';
      } else {
        return 'هوية مقيم';
      }

// هوية وطنيه ١
// هوية خليجيه ٤
// رقم حدود ٩
// هوية مقيم ٣
    }
    return '';
  }

  String getEmail() {
    final email =
        mail?.replaceAll('\u200e', '').replaceAll('\u200f', '').trim() ?? '';
    return email;
  }

  String getPhone() => phone != null
        ? (!phone!.startsWith('0') ? '0${phone!}' : phone!)
        : '';

  String getGender() => sex == '1' ? 'male' : 'female';
}
