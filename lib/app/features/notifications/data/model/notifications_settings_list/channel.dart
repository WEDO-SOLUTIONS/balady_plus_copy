class Channel {
  final String? id;
  final String? name;

  const Channel({this.id, this.name});

  factory Channel.fromJson(Map<String, dynamic> json) =>
      Channel(id: json['id'] as String?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  List<Object?> get props => [id, name];
}
