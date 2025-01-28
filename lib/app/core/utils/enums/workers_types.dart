enum WorkersTypes {
  men(type: 1),
  women(type: 2),
  menWomen(type: 3);

  const WorkersTypes({required this.type});

  final int type;
}
