// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:balady_plus/app/core/utils/enums/enums.dart';

class UserProfileEntity {
  String? id;
  String? type;
  String? name;
  String? roleName;
  String? roleId;
  String? agencyRequestKey;
  UserProfileType? profileType;
  UserProfileEntity({
    this.id,
    this.type,
    this.name,
    this.roleName,
    this.roleId,
    this.profileType,
    this.agencyRequestKey,
  });

  UserProfileEntity copyWith({
    String? id,
    String? type,
    String? name,
    String? roleName,
    String? roleId,
    UserProfileType? profileType,
    String? agencyRequestKey,
  }) {
    return UserProfileEntity(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      roleName: roleName ?? this.roleName,
      roleId: roleId ?? this.roleId,
      profileType: profileType ?? this.profileType,
      agencyRequestKey: agencyRequestKey ?? this.agencyRequestKey,
    );
  }

  String getRole() {
    if (profileType == UserProfileType.delegator) {
      if (roleId == "20") return "OWNER_MANAGER";
      if (roleId == "30") return "DELEGATOR";
    }

    if (profileType == UserProfileType.agent) {
      return "AGENT";
    }

    return "HIMSELF";
  }
}
