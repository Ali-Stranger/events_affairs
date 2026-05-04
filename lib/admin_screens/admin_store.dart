import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../eventplanner.dart';

enum VendorStatus { pending, approved, suspended }

class FirestoreVendor {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String businessName;
  final String category;
  final String city;
  final bool approved;

  FirestoreVendor({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.businessName,
    required this.category,
    required this.city,
    required this.approved,
  });
}

class AdminLead {
  final String id;
  final String name;
  final String phone;
  final String service;
  final String city;
  final String eventDate;
  final DateTime createdAt;
  final String note;

  const AdminLead({
    required this.id,
    required this.name,
    required this.phone,
    required this.service,
    required this.city,
    required this.eventDate,
    required this.createdAt,
    required this.note,
  });
}

class AdminUser {
  final String id;
  final String name;
  final String phone;
  final String city;
  final DateTime createdAt;

  const AdminUser({
    required this.id,
    required this.name,
    required this.phone,
    required this.city,
    required this.createdAt,
  });
}

class AdminStore extends ChangeNotifier {
  /// blogId -> multiple event types
  final Map<int, Set<String>> blogEvents = {};

  /// blogId -> attached vendor services ("Vendor Name|Service")
  final Map<int, Set<String>> blogVendorServices = {};

  /// vendorId -> status
  final Map<String, VendorStatus> vendorStatus = {};

  /// vendorId -> single selected service
  final Map<String, String> vendorPrimaryService = {};

  List<AdminLead> leads = [];
  List<AdminUser> users = [];
  List<FirestoreVendor> firestoreVendors = [];

  AdminStore() {
    // Seed vendor statuses for hardcoded vendors
    for (final v in allVendors) {
      vendorStatus.putIfAbsent(v.name, () => VendorStatus.approved);
      vendorPrimaryService.putIfAbsent(
        v.name,
        () => v.services.isNotEmpty ? v.services.first : v.category,
      );
    }

    // Mark a couple as pending to make admin features visible in UI
    if (allVendors.isNotEmpty) {
      vendorStatus[allVendors.first.name] = VendorStatus.pending;
    }
    if (allVendors.length > 2) {
      vendorStatus[allVendors[2].name] = VendorStatus.pending;
    }

    fetchFromFirebase();
  }

  // ── Firebase fetch ───────────────────────────────────────────
  Future<void> fetchFromFirebase() async {
    // Fetch leads from quotes collection
    final quotesSnap = await FirebaseFirestore.instance
        .collection('quotes')
        .orderBy('createdAt', descending: true)
        .get();

    leads = quotesSnap.docs.map((doc) {
      final d = doc.data();
      return AdminLead(
        id: doc.id,
        name: d['name'] ?? '',
        phone: d['phone'] ?? '',
        service: d['category'] ?? '',
        city: d['city'] ?? '',
        eventDate: d['eventDate'] ?? '',
        createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        note: 'Lead only — vendor should call user directly.',
      );
    }).toList();

    // Fetch users (couples) from users collection
    final usersSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'couple')
        .get();

    users = usersSnap.docs.map((doc) {
      final d = doc.data();
      return AdminUser(
        id: doc.id,
        name: d['name'] ?? 'Unknown',
        phone: d['phone'] ?? 'N/A',
        city: d['city'] ?? 'N/A',
        createdAt: (d['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();

    // Fetch vendors from users collection
    final vendorsSnap = await FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'vendor')
        .get();

    firestoreVendors = vendorsSnap.docs.map((doc) {
      final d = doc.data();
      return FirestoreVendor(
        id: doc.id,
        name: d['name'] ?? 'Unknown',
        email: d['email'] ?? '',
        phone: d['phone'] ?? 'N/A',
        businessName: d['businessName'] ?? 'N/A',
        category: d['businessCategory'] ?? 'N/A',
        city: d['city'] ?? 'N/A',
        approved: d['approved'] ?? false,
      );
    }).toList();

    notifyListeners();
  }

  // ── Blog events ──────────────────────────────────────────────
  void setBlogEvent(int blogId, String? eventType) {
    final v = (eventType ?? '').trim();
    if (v.isEmpty) {
      blogEvents.remove(blogId);
    } else {
      blogEvents[blogId] = {v};
    }
    notifyListeners();
  }

  void toggleBlogEvent(int blogId, String eventType) {
    final v = eventType.trim();
    if (v.isEmpty) return;
    final set = blogEvents.putIfAbsent(blogId, () => <String>{});
    if (set.contains(v)) {
      set.remove(v);
      if (set.isEmpty) blogEvents.remove(blogId);
    } else {
      set.add(v);
    }
    notifyListeners();
  }

  Set<String> getBlogEvents(int blogId) => blogEvents[blogId] ?? <String>{};

  void toggleBlogVendorService(int blogId, String vendorName, String service) {
    final key = '${vendorName.trim()}|${service.trim()}';
    if (key == '|' || vendorName.trim().isEmpty || service.trim().isEmpty)
      return;
    final set = blogVendorServices.putIfAbsent(blogId, () => <String>{});
    if (set.contains(key)) {
      set.remove(key);
      if (set.isEmpty) blogVendorServices.remove(blogId);
    } else {
      set.add(key);
    }
    notifyListeners();
  }

  Set<String> getBlogVendorServices(int blogId) =>
      blogVendorServices[blogId] ?? <String>{};

  // ── Vendor management ────────────────────────────────────────
  void setVendorStatus(String vendorId, VendorStatus status) {
    vendorStatus[vendorId] = status;
    notifyListeners();
  }

  void setVendorPrimaryService(String vendorId, String service) {
    vendorPrimaryService[vendorId] = service;
    notifyListeners();
  }

  void notifyListenersPublic() => notifyListeners();

  int get pendingVendorsCount =>
      vendorStatus.values.where((s) => s == VendorStatus.pending).length;
}

final AdminStore adminStore = AdminStore();
