class ActorContext {
  final String? id;
  final String? name;

  const ActorContext({this.id, this.name});

  factory ActorContext.fromJson(Map<String, dynamic> json) =>
      ActorContext(id: json['id'] as String?, name: json['name'] as String?);

  Map<String, dynamic> toJson() => {'id': id, 'name': name};

  List<Object?> get props => [id, name];
}
