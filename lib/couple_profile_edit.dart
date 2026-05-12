import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const Color _kPrimary = Color(0xffB4245D);

const List<String> kCoupleProfileCities = [
  'Lahore',
  'Karachi',
  'Islamabad',
  'Multan',
  'Peshawar',
  'Faisalabad',
  'Rawalpindi',
  'Quetta',
];

/// Edit couple / customer profile (`users` doc: name, phone, city) — similar flow to vendor edit.
class CoupleProfileEditPage extends StatefulWidget {
  const CoupleProfileEditPage({super.key});

  @override
  State<CoupleProfileEditPage> createState() => _CoupleProfileEditPageState();
}

class _CoupleProfileEditPageState extends State<CoupleProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  String? _city;
  bool _loading = true;
  bool _saving = false;

  List<String> get _cityItems {
    final out = List<String>.from(kCoupleProfileCities);
    if (_city != null &&
        _city!.isNotEmpty &&
        !out.contains(_city)) {
      out.insert(0, _city!);
    }
    return out;
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      if (mounted) setState(() => _loading = false);
      return;
    }
    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!mounted) return;
      if (doc.exists) {
        final d = doc.data()!;
        _nameCtrl.text = (d['name'] ?? '').toString();
        _phoneCtrl.text = (d['phone'] ?? '').toString();
        final c = (d['city'] ?? '').toString().trim();
        _city = c.isNotEmpty ? c : null;
      } else {
        final u = FirebaseAuth.instance.currentUser;
        _nameCtrl.text = u?.displayName ?? '';
      }
      setState(() => _loading = false);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_city == null || _city!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select your city.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    setState(() => _saving = true);
    try {
      final name = _nameCtrl.text.trim();
      await FirebaseFirestore.instance.collection('users').doc(uid).set(
        {
          'name': name,
          'phone': _phoneCtrl.text.trim(),
          'city': _city,
        },
        SetOptions(merge: true),
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user != null && name.isNotEmpty) {
        await user.updateDisplayName(name);
      }

      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    required String label,
    required IconData icon,
    String? hint,
  }) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor =
        isDark ? scheme.outline.withOpacity(0.35) : Colors.grey.shade300;
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, color: _kPrimary, size: 20),
      floatingLabelStyle: const TextStyle(color: _kPrimary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: _kPrimary, width: 1.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: borderColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final email = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: _kPrimary,
        foregroundColor: Colors.white,
        title: const Text(
          'Edit profile',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
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
          ? const Center(child: CircularProgressIndicator(color: _kPrimary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Email is tied to your login and cannot be changed here.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      initialValue: email,
                      readOnly: true,
                      decoration: _fieldDecoration(
                        context,
                        label: 'Email',
                        icon: Icons.email_outlined,
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _nameCtrl,
                      textCapitalization: TextCapitalization.words,
                      decoration: _fieldDecoration(
                        context,
                        label: 'Full name',
                        icon: Icons.person_outline,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      decoration: _fieldDecoration(
                        context,
                        label: 'Phone number',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Enter your phone number';
                        }
                        if (v.trim().length < 10) {
                          return 'Enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    DropdownButtonFormField<String>(
                      value: _city,
                      decoration: _fieldDecoration(
                        context,
                        label: 'City',
                        icon: Icons.location_on_outlined,
                      ),
                      hint: const Text('Select city'),
                      items: _cityItems
                          .map(
                            (c) => DropdownMenuItem(value: c, child: Text(c)),
                          )
                          .toList(),
                      onChanged: (v) => setState(() => _city = v),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Select your city' : null,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
