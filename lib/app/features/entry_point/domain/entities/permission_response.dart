import 'package:equatable/equatable.dart';

class PermissionResponse extends Equatable {
  final List<String>? roles;
  final List<String>? permissions;

  const PermissionResponse({this.permissions, this.roles});

  @override
  List<Object?> get props => [];
}
