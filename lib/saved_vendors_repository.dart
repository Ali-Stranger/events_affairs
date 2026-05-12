import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Vendor **users** document IDs stored at `users/{customerUid}.savedVendorIds`.
class SavedVendorsRepository {
  SavedVendorsRepository._();

  static Future<List<String>> loadOrderedIds() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final raw = doc.data()?['savedVendorIds'];
    if (raw is! List) return [];
    return raw
        .map((e) => e.toString())
        .where((s) => s.isNotEmpty)
        .toList();
  }

  static Future<Set<String>> loadIdSet() async {
    final list = await loadOrderedIds();
    return list.toSet();
  }

  static Future<void> addVendor(String vendorUserId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {'savedVendorIds': FieldValue.arrayUnion([vendorUserId])},
      SetOptions(merge: true),
    );
  }

  static Future<void> removeVendor(String vendorUserId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {'savedVendorIds': FieldValue.arrayRemove([vendorUserId])},
      SetOptions(merge: true),
    );
  }
}
