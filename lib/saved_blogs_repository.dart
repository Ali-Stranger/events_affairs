import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Blog document IDs stored at `users/{customerUid}.savedBlogIds`.
class SavedBlogsRepository {
  SavedBlogsRepository._();

  static Future<List<String>> loadOrderedIds() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return [];
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final raw = doc.data()?['savedBlogIds'];
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

  static Future<void> addBlog(String blogId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {'savedBlogIds': FieldValue.arrayUnion([blogId])},
      SetOptions(merge: true),
    );
  }

  static Future<void> removeBlog(String blogId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) throw StateError('Not signed in');
    await FirebaseFirestore.instance.collection('users').doc(uid).set(
      {'savedBlogIds': FieldValue.arrayRemove([blogId])},
      SetOptions(merge: true),
    );
  }
}
