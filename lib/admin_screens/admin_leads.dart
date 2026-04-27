import 'package:flutter/material.dart';

import 'admin_store.dart';

const Color kPrimary = Color(0xffB4245D);

class AdminLeadsPage extends StatelessWidget {
  const AdminLeadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Color bg = isDark ? const Color(0xff0F0F14) : const Color(0xffF4F7FA);

    return AnimatedBuilder(
      animation: adminStore,
      builder: (context, _) => Scaffold(
        backgroundColor: bg,
        appBar: AppBar(
          backgroundColor: kPrimary,
          title: const Text('Leads (Inquiries)', style: TextStyle(color: Colors.white, fontSize: 16)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: adminStore.leads.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final lead = adminStore.leads[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1A1A24) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: kPrimary.withValues(alpha: 0.1),
                        child: Text(
                          lead.name.substring(0, 1),
                          style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lead.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              '${lead.service} · ${lead.city} · ${lead.eventDate}',
                              style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black54),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: kPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Lead',
                          style: TextStyle(color: kPrimary, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Phone: ${lead.phone}',
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white70 : Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    lead.note,
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black54, height: 1.3),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
