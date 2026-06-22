import 'package:dgis_map/library.dart';
import 'package:equatable/equatable.dart';

class NearbyItem extends Equatable {
  final DirectoryObjectMessage object;

  const NearbyItem({required this.object});

  @override
  List<Object?> get props => [object];
}
