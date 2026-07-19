import 'package:cloud_firestore/cloud_firestore.dart';

class Hotspots {
  final String id;
  final String locationName;
  final String category;
  final String condition;
  final double latitude;
  final double longitude;
  final double rating;
  final List<Map<String, dynamic>> reviewCount;
  final DateTime createdAt;

  Hotspots({
    required this.id,
    required this.locationName,
    required this.category,
    required this.condition,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.createdAt,
  });

  Hotspots copyWith({
    String? id,
    String? locationName,
    String? category,
    String? condition,
    double? latitude,
    double? longitude,
    double? rating,
    List<Map<String, dynamic>>? reviewCount,
    DateTime? createdAt,
  }) {
    return Hotspots(
      id: id ?? this.id,
      locationName: locationName ?? this.locationName,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  factory Hotspots.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();

    if (data == null) {
      throw Exception("Document data is null");
    }

    return Hotspots(
      id: doc.id,
      locationName: data['locationName'] as String? ?? "",
      category: data['category'] as String? ?? "",
      condition: data['condition'] as String? ?? "",
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (data['reviewCount'] as List? ?? [])
          .map((e) => Map<String, dynamic>.from(e))
          .toList(),
      createdAt:
      (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}