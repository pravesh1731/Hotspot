import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hotspot/features/admin/home/model/add_item_model.dart';

class AddItemsNotifier extends StateNotifier<AddItemState> {
  AddItemsNotifier() : super(AddItemState()) {
    _fetchedCategory();
  }

  void setSelectedCategory(String category) {
    state = state.copyWith(selectedCategory: category);
  }

  void setSelectedCondition(String condition) {
    state = state.copyWith(selectedCondition: condition);
  }

  void setSelectedLocation(LatLng location) {
    state = state.copyWith(selectedLocation: location);
  }

  Future<void> _fetchedCategory() async {
    final snapshot = await FirebaseFirestore.instance
        .collection("FishCategory")
        .get();
    final categories = snapshot.docs.map((doc) => doc['name'] as String).toList();
    state = state.copyWith(categories: categories);
  }

  Future<void> addCategory(String categoryName) async {
    if (categoryName.isEmpty) {
      throw Exception("Condition name can not be empty");
    }
    final lowerCaseCategoryName = categoryName.toLowerCase();
    if (state.categories.any(
      (category) => category.toLowerCase() == lowerCaseCategoryName,
    )) {
      throw Exception("Category already exists");
    }
    try {
      await FirebaseFirestore.instance.collection("FishCategory").add({
        'name': categoryName,
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _fetchedCategory();
    } catch (e) {
      throw Exception("Failed to add category: $e");
    }
  }

  Future<void> saveItems({
    required String locationName,
    required BuildContext context,
  }) async {
    if (locationName.isEmpty ||
        state.selectedCategory == null ||
        state.selectedLocation == null ||
        state.selectedCondition == null) {
      throw Exception("Please fill all the fields");
    }
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception("User not logged in");
      }

      await FirebaseFirestore.instance.collection("hotspots").add({
        'locationName': locationName,
        'category': state.selectedCategory,
        'condition': state.selectedCondition,
        'latitude': state.selectedLocation!.latitude,
        'longitude': state.selectedLocation!.longitude,
        'rating': state.rating,
        'reviewCount': state.reviewCount,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
      });
      resetState();
    } catch (e) {
      throw Exception("Failed to save items: $e");
    }
  }

  void resetState() {
     state = AddItemState(
        categories: state.categories,
        conditions: state.conditions,
     );
  }
}

final addItemProvider = StateNotifierProvider<AddItemsNotifier, AddItemState>((ref) {
   return AddItemsNotifier();
});