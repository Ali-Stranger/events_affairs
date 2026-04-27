import 'package:flutter/material.dart';

import '../blogs.dart';
import '../eventplanner.dart';
import 'admin_store.dart';

const Color kPrimary = Color(0xffB4245D);

class AdminEditBlogPage extends StatefulWidget {
  final Blog blog;
  final String? currentAssignedEvent;

  const AdminEditBlogPage({
    super.key,
    required this.blog,
    required this.currentAssignedEvent,
  });

  @override
  State<AdminEditBlogPage> createState() => _AdminEditBlogPageState();
}

class _AdminEditBlogPageState extends State<AdminEditBlogPage> {
  static const List<String> _eventTypes = [
    'Wedding',
    'Venue',
    'Photography',
    'Catering',
    'Decoration',
    'Birthday',
    'Corporate',
  ];

  late Set<String> _selectedEvents;
  String _vendorSearch = '';

  @override
  void initState() {
    super.initState();
    _selectedEvents = {...adminStore.getBlogEvents(widget.blog.id)};
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xff0F0F14) : const Color(0xffF4F7FA);
    final Color card = isDark ? const Color(0xff1A1A24) : Colors.white;
    final attachedVendorServices =
        adminStore.getBlogVendorServices(widget.blog.id);

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: const Text('Edit Blog', style: TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              // persist events selection to store (replace)
              final id = widget.blog.id;
              adminStore.blogEvents[id] = {..._selectedEvents};
              if (adminStore.blogEvents[id]!.isEmpty) {
                adminStore.blogEvents.remove(id);
              }
              adminStore.notifyListenersPublic();
              Navigator.pop(context, const AdminBlogEditResult(assignedEvent: null));
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.blog.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Admin decision: select all events for this blog, and attach vendor services to show in this blog.',
                    style: TextStyle(fontSize: 12, height: 1.3, color: isDark ? Colors.white70 : Colors.black87),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Events (multi-select)',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _eventTypes.map((e) {
                      final selected = _selectedEvents.contains(e);
                      return FilterChip(
                        selected: selected,
                        label: Text(e),
                        selectedColor: kPrimary.withValues(alpha: 0.16),
                        checkmarkColor: kPrimary,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: selected ? kPrimary : (isDark ? Colors.white70 : Colors.black87),
                        ),
                        side: BorderSide(
                          color: selected ? kPrimary : (isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.08)),
                        ),
                        onSelected: (_) => setState(() {
                          selected ? _selectedEvents.remove(e) : _selectedEvents.add(e);
                        }),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Note: bookings are treated as leads only. Vendors contact users directly.',
                    style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black54),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: card,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Attach vendor services',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onChanged: (v) => setState(() => _vendorSearch = v.trim().toLowerCase()),
                    decoration: InputDecoration(
                      hintText: 'Search vendor...',
                      prefixIcon: const Icon(Icons.search, color: kPrimary),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: kPrimary, width: 1.6),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (attachedVendorServices.isNotEmpty) ...[
                    Text(
                      'Attached (${attachedVendorServices.length})',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: attachedVendorServices.map((k) {
                        final parts = k.split('|');
                        final vendorName = parts.isNotEmpty ? parts.first : k;
                        final service = parts.length > 1 ? parts[1] : '';
                        return InputChip(
                          label: Text(service.isEmpty ? vendorName : '$vendorName · $service'),
                          onDeleted: () {
                            adminStore.toggleBlogVendorService(widget.blog.id, vendorName, service);
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  ...allVendors.where((v) {
                    if (_vendorSearch.isEmpty) return true;
                    final primary = adminStore.vendorPrimaryService[v.name] ?? (v.services.isNotEmpty ? v.services.first : v.category);
                    return v.name.toLowerCase().contains(_vendorSearch) ||
                        primary.toLowerCase().contains(_vendorSearch);
                  }).map((v) {
                    final primary = adminStore.vendorPrimaryService[v.name] ?? (v.services.isNotEmpty ? v.services.first : v.category);
                    final isAttached = attachedVendorServices.contains('${v.name}|$primary');
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: kPrimary.withValues(alpha: 0.12),
                        child: Text(v.name.substring(0, 1), style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
                      ),
                      title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                      subtitle: Text('Service: $primary · ${v.location}', style: const TextStyle(fontSize: 12)),
                      trailing: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isAttached ? Colors.grey : kPrimary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          elevation: 0,
                        ),
                        onPressed: () {
                          adminStore.toggleBlogVendorService(widget.blog.id, v.name, primary);
                          setState(() {});
                        },
                        child: Text(isAttached ? 'Added' : 'Add'),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AdminBlogEditResult {
  final String? assignedEvent;
  const AdminBlogEditResult({required this.assignedEvent});
}

