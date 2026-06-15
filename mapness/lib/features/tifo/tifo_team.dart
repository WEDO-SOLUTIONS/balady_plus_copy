import 'package:flutter/widgets.dart';

/// One of the four playable TIFO teams. Used across team select, settings
/// and the team dashboard. Colors come from Figma node 1:7137.
enum TifoTeam {
  alHilal(
    name: 'Al Hilal',
    code: 'HIL',
    primary: Color(0xFF3B82F6), // blue-500
  ),
  alNassr(
    name: 'Al Nassr',
    code: 'NAS',
    primary: Color(0xFFEAB308), // yellow-500
  ),
  riyadhFc(
    name: 'Riyadh FC',
    code: 'RYD',
    primary: Color(0xFFEF4444), // red-500
  ),
  alShabab(
    name: 'Al Shabab',
    code: 'SHA',
    primary: Color(0xFFE5E7EB), // gray-200
  );

  const TifoTeam({
    required this.name,
    required this.code,
    required this.primary,
  });

  final String name;
  final String code;
  final Color primary;
}
