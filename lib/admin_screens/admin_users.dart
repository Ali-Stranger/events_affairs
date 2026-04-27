import 'package:flutter/material.dart';

import 'admin_store.dart';

const Color kPrimary = Color(0xffB4245D);

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

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
          title: const Text('Users', style: TextStyle(color: Colors.white, fontSize: 16)),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: adminStore.users.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, i) {
            final u = adminStore.users[i];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1A1A24) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: kPrimary.withValues(alpha: 0.12),
                    child: Text(
                      u.name.substring(0, 1),
                      style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          u.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${u.city} · ${u.phone}',
                          style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.black54),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Text(
                      'Active',
                      style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
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

