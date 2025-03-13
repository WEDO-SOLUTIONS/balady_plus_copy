enum WorkersTypesEnum {
  men(type: 1),
  women(type: 2),
  menWomen(type: 3);

  const WorkersTypesEnum({required this.type});

  final int type;
}
