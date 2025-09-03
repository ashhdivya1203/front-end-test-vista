// lib/models/service.dart
class ServiceModel {
  final int id;
  final int companyId;
  final String name;
  final String? description;
  final double price;
  final DateTime createdAt;
  final DateTime updatedAt;

  ServiceModel({
    required this.id,
    required this.companyId,
    required this.name,
    this.description,
    required this.price,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> j) => ServiceModel(
        id: j['id'] as int,
        companyId: j['companyId'] as int,
        name: j['name'] ?? '',
        description: j['description'] as String?,
        price: double.tryParse(j['price'].toString()) ?? 0.0,
        createdAt: DateTime.parse(j['createdAt'] as String),
        updatedAt: DateTime.parse(j['updatedAt'] as String),
      );
}
