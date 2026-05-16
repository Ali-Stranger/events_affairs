import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// ═══════════════════════════════════════════════════════════════
// MANAGE AVAILABILITY PAGE
// ═══════════════════════════════════════════════════════════════

class ManageAvailabilityPage extends StatefulWidget {
  const ManageAvailabilityPage({super.key});

  @override
  State<ManageAvailabilityPage> createState() => _ManageAvailabilityPageState();
}

class _ManageAvailabilityPageState extends State<ManageAvailabilityPage> {
  static const Color _primary = Color(0xffB4245D);

  DateTime _focusedMonth = DateTime.now();
  final Set<String> _blockedDates = {};
  final Set<String> _bookedDates = {};
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _loadAvailability();
  }

  String _key(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _loadAvailability() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() => _loading = false);
      return;
    }
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      final data = doc.data() ?? {};
      final blocked = (data['blockedDates'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toSet();

      final quotes = await FirebaseFirestore.instance
          .collection('quotes')
          .where('vendorId', isEqualTo: uid)
          .where('status', isEqualTo: 'confirmed')
          .get();

      final booked = <String>{};
      for (final q in quotes.docs) {
        final dateStr = q.data()['eventDate'] as String?;
        if (dateStr != null && dateStr.isNotEmpty) {
          booked.add(dateStr);
        }
      }

      if (!mounted) return;
      setState(() {
        _blockedDates
          ..clear()
          ..addAll(blocked);
        _bookedDates
          ..clear()
          ..addAll(booked);
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  Future<void> _saveBlockedDates() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    setState(() => _saving = true);
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'blockedDates': _blockedDates.toList(),
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Availability saved!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save. Try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
    setState(() => _saving = false);
  }

  void _toggleDate(DateTime date) {
    final key = _key(date);
    final todayKey = _key(DateTime.now());
    if (key.compareTo(todayKey) < 0) return;
    if (_bookedDates.contains(key)) return;
    setState(() {
      if (_blockedDates.contains(key)) {
        _blockedDates.remove(key);
      } else {
        _blockedDates.add(key);
      }
    });
  }

  List<DateTime> _daysInMonth(DateTime month) {
    final last = DateTime(month.year, month.month + 1, 0);
    return List.generate(
      last.day,
      (i) => DateTime(month.year, month.month, i + 1),
    );
  }

  String _monthLabel(DateTime d) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[d.month]} ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? const Color(0xff0F0F14)
          : const Color(0xffF4F7FA),
      appBar: AppBar(
        backgroundColor: _primary,
        title: const Text(
          'Manage Availability',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _saving ? null : _saveBlockedDates,
            child: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: _primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Legend
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xff1A1A24) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tap a date to block/unblock it',
                          style: TextStyle(
                            fontSize: 13,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _legendDot(Colors.green.shade400, 'Available'),
                            const SizedBox(width: 16),
                            _legendDot(_primary, 'Blocked by you'),
                            const SizedBox(width: 16),
                            _legendDot(Colors.grey.shade400, 'Booked'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Calendar
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xff1A1A24) : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        // Month navigation
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.chevron_left),
                                onPressed: () => setState(
                                  () => _focusedMonth = DateTime(
                                    _focusedMonth.year,
                                    _focusedMonth.month - 1,
                                  ),
                                ),
                              ),
                              Text(
                                _monthLabel(_focusedMonth),
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.chevron_right),
                                onPressed: () => setState(
                                  () => _focusedMonth = DateTime(
                                    _focusedMonth.year,
                                    _focusedMonth.month + 1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Day labels
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children:
                                [
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                      'Sun',
                                    ]
                                    .map(
                                      (d) => SizedBox(
                                        width: 36,
                                        child: Text(
                                          d,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: isDark
                                                ? Colors.white38
                                                : Colors.black38,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Calendar grid
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          child: _buildCalendarGrid(isDark),
                        ),

                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Blocked dates summary
                  if (_blockedDates.isNotEmpty) ...[
                    Text(
                      'Blocked Dates (${_blockedDates.length})',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xff1A1A24) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: (_blockedDates.toList()..sort())
                            .map(
                              (key) => Chip(
                                label: Text(
                                  key,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: _primary,
                                deleteIconColor: Colors.white70,
                                onDeleted: () {
                                  setState(() => _blockedDates.remove(key));
                                },
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildCalendarGrid(bool isDark) {
    final days = _daysInMonth(_focusedMonth);
    final firstWeekday = days.first.weekday;
    final todayKey = _key(DateTime.now());

    final cells = <Widget>[];
    for (var i = 1; i < firstWeekday; i++) {
      cells.add(const SizedBox(width: 36, height: 36));
    }

    for (final day in days) {
      final key = _key(day);
      final isPast = key.compareTo(todayKey) < 0;
      final isBlocked = _blockedDates.contains(key);
      final isBooked = _bookedDates.contains(key);
      final isToday = key == todayKey;

      Color bgColor = Colors.transparent;
      Color textColor = isDark ? Colors.white : Colors.black87;

      if (isPast) {
        textColor = isDark ? Colors.white24 : Colors.black26;
      } else if (isBooked) {
        bgColor = Colors.grey.shade400;
        textColor = Colors.white;
      } else if (isBlocked) {
        bgColor = _primary;
        textColor = Colors.white;
      } else {
        bgColor = Colors.green.shade400.withOpacity(0.15);
        textColor = Colors.green.shade700;
      }

      cells.add(
        GestureDetector(
          onTap: () => _toggleDate(day),
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
              border: isToday ? Border.all(color: _primary, width: 2) : null,
            ),
            child: Center(
              child: Text(
                '${day.day}',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                  color: textColor,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return GridView.count(
      crossAxisCount: 7,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 4,
      crossAxisSpacing: 0,
      children: cells,
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
