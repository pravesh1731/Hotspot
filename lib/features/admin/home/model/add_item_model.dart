import 'package:google_maps_flutter/google_maps_flutter.dart';

 class AddItemState{
   final String? selectedCategory;
   final List<String> categories;
   final String? selectedCondition;
   final List<String> conditions;
   final LatLng? selectedLocation;
   final double rating;
   final List<Map<String, dynamic>> reviewCount;

    AddItemState({
      this.selectedCategory,
      this.categories = const [],
      this.selectedCondition,
      this.conditions = const ['Hotspots', 'Decreasing', 'Increasing', 'Little'],
      this.selectedLocation,
      this.rating = 0.0,
      this.reviewCount = const [],
    });

    AddItemState copyWith({
     String? selectedCategory,
      List<String>? categories,
      String? selectedCondition,
      List<String>? conditions,
      LatLng? selectedLocation,
      double? rating,
      final List<Map<String, dynamic>>? reviewCount,
 }) {
      return AddItemState(
        selectedCategory: selectedCategory ?? this.selectedCategory,
        categories: categories ?? this.categories,
        selectedCondition: selectedCondition ?? this.selectedCondition,
        conditions: conditions ?? this.conditions,
        selectedLocation: selectedLocation ?? this.selectedLocation,
        rating: rating ?? this.rating,
        reviewCount: reviewCount ?? this.reviewCount,
      );
    }
 }