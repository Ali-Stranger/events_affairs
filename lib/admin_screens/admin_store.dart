import 'package:flutter/foundation.dart';

import '../eventplanner.dart';

enum VendorStatus { pending, approved, suspended }

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

  /// vendorName -> status
  final Map<String, VendorStatus> vendorStatus = {};

  /// vendorName -> single selected service (enforces your “one vendor = one service” rule)
  final Map<String, String> vendorPrimaryService = {};

  final List<AdminLead> leads = [
    AdminLead(
      id: 'L-1001',
      name: 'Ali Khan',
      phone: '0300-1234567',
      service: 'Decoration',
      city: 'Lahore',
      eventDate: 'May 15',
      createdAt: DateTime(2026, 4, 25, 9, 10),
      note: 'Lead only — vendor should call user directly.',
    ),
    AdminLead(
      id: 'L-1002',
      name: 'Sara Raza',
      phone: '0321-9876543',
      service: 'Photography',
      city: 'Karachi',
      eventDate: 'Jun 02',
      createdAt: DateTime(2026, 4, 26, 12, 30),
      note: 'No confirmation/revenue tracked in the app.',
    ),
    AdminLead(
      id: 'L-1003',
      name: 'M. Bilal',
      phone: '0333-5556677',
      service: 'Catering',
      city: 'Islamabad',
      eventDate: 'May 28',
      createdAt: DateTime(2026, 4, 26, 18, 5),
      note: 'User shared contact number; vendor to follow up.',
    ),
  ];

  final List<AdminUser> users = [
    AdminUser(
      id: 'U-2001',
      name: 'Ali Khan',
      phone: '0300-1234567',
      city: 'Lahore',
      createdAt: DateTime(2026, 3, 12),
    ),
    AdminUser(
      id: 'U-2002',
      name: 'Sara Raza',
      phone: '0321-9876543',
      city: 'Karachi',
      createdAt: DateTime(2026, 3, 18),
    ),
    AdminUser(
      id: 'U-2003',
      name: 'M. Bilal',
      phone: '0333-5556677',
      city: 'Islamabad',
      createdAt: DateTime(2026, 4, 2),
    ),
  ];

  AdminStore() {
    // Seed vendor statuses + primary service.
    for (final v in allVendors) {
      vendorStatus.putIfAbsent(v.name, () => VendorStatus.approved);
      vendorPrimaryService.putIfAbsent(
        v.name,
        () => v.services.isNotEmpty ? v.services.first : v.category,
      );
    }

    // Mark a couple as pending to make admin features visible in UI.
    if (allVendors.isNotEmpty) {
      vendorStatus[allVendors.first.name] = VendorStatus.pending;
    }
    if (allVendors.length > 2) {
      vendorStatus[allVendors[2].name] = VendorStatus.pending;
    }
  }

  void setBlogEvent(int blogId, String? eventType) {
    // Backwards-compatible alias: set single -> replace set
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
    if (key == '|' || vendorName.trim().isEmpty || service.trim().isEmpty) return;
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

  void setVendorStatus(String vendorName, VendorStatus status) {
    vendorStatus[vendorName] = status;
    notifyListeners();
  }

  void setVendorPrimaryService(String vendorName, String service) {
    vendorPrimaryService[vendorName] = service;
    notifyListeners();
  }

  void notifyListenersPublic() => notifyListeners();

  int get pendingVendorsCount =>
      vendorStatus.values.where((s) => s == VendorStatus.pending).length;
}

final AdminStore adminStore = AdminStore();

