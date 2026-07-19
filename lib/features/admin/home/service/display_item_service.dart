import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/display_item_model.dart';

final adminHotspots = StreamProvider<List<Hotspots>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) {
    return Stream.value([]);
  }
  return FirebaseFirestore.instance
      .collection("hotspots")
      .where("createdBy", isEqualTo: user.uid)
      .snapshots()
      .map((snapshot) {
        return snapshot.docs
            .map(
              (doc) => Hotspots.fromFirestore(
                doc as DocumentSnapshot<Map<String, dynamic>>,
              ),
            )
            .toList();
      });
});

final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});
