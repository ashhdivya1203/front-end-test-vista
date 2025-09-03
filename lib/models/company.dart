// lib/models/company.dart
import 'service.dart';

class Company {
  final int id;
  final String name;
  final String registrationNumber;
  final List<ServiceModel> services;
  final DateTime createdAt;
  final DateTime updatedAt;

  Company({
    required this.id,
    required this.name,
    required this.registrationNumber,
    required this.services,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Company.fromJson(Map<String, dynamic> j) => Company(
        id: j['id'] as int,
        name: j['name'] ?? '',
        registrationNumber: j['registrationNumber'] ?? '',
        services: (j['services'] as List? ?? [])
            .map((e) => ServiceModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: DateTime.parse(j['createdAt'] as String),
        updatedAt: DateTime.parse(j['updatedAt'] as String),
      );
}
