import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'login.dart';
//  import 'drawer.dart';

// ═══════════════════════════════════════════════════════════════
//  CONSTANTS
// ═══════════════════════════════════════════════════════════════

const Color kPrimary = Color(0xffB4245D);

const List<String> _vendorCategories = [
  'Event Planner',
  'Catering',
  'Photography',
  'Decoration / Florist',
  'Banquet Hall',
  'Marquee',
  'Farm House',
  'Videography',
  'Makeup Artist',
  'DJ / Entertainment',
];

const List<String> _cities = [
  'Lahore',
  'Karachi',
  'Islamabad',
  'Multan',
  'Peshawar',
  'Faisalabad',
  'Rawalpindi',
  'Quetta',
];

// ═══════════════════════════════════════════════════════════════
//  COUPLE SIGNUP PAGE
// ═══════════════════════════════════════════════════════════════

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameCtrl = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  final _passCtrl     = TextEditingController();
  final _confirmCtrl  = TextEditingController();

  bool _obscurePass    = true;
  bool _obscureConfirm = true;
  bool _agreeTerms     = false;
  bool _isLoading      = false;
  bool _isSuccess      = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // ── Password strength ──────────────────────────────────────────────────────
  int _passStrength(String p) {
    int score = 0;
    if (p.length >= 8) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) score++;
    return score; // 0–4
  }

  Color _strengthColor(int s) {
    if (s <= 1) return Colors.red;
    if (s == 2) return Colors.orange;
    if (s == 3) return Colors.amber;
    return Colors.green;
  }

  String _strengthLabel(int s) {
    if (s == 0) return '';
    if (s <= 1) return 'Weak';
    if (s == 2) return 'Fair';
    if (s == 3) return 'Good';
    return 'Strong';
  }

  // ── Submit ─────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(_snack(
        'Please accept the Terms & Conditions to continue.',
        Colors.orange,
      ));
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
  }

  SnackBar _snack(String msg, Color color) => SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ── Hero banner ─────────────────────────────────────────
            _HeroBanner(
              title: 'Create Account',
              subtitle: 'Join Pakistan\'s #1 event platform',
            ),

            // ── Tab switcher ────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -16),
              child: _AccountTypeTabs(
                selectedIndex: 0,
                onCoupleTap: () {},
                onVendorTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CreateAccountPageVendor()),
                ),
              ),
            ),

            // ── Form card ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _isSuccess
                  ? _SuccessCard(
                      message: 'Your couple account has been created!',
                      onLogin: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (r) => false,
                      ),
                    )
                  : _FormCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            _sectionLabel('Personal Details'),
                            const SizedBox(height: 12),

                            // Username
                            _field(
                              ctrl: _usernameCtrl,
                              label: 'Full Name',
                              icon: Icons.person_outline,
                              validator: (v) => v == null || v.trim().length < 3
                                  ? 'Enter at least 3 characters'
                                  : null,
                            ),
                            const SizedBox(height: 12),

                            // Email
                            _field(
                              ctrl: _emailCtrl,
                              label: 'Email Address',
                              icon: Icons.email_outlined,
                              type: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(v.trim())) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            // Phone
                            _field(
                              ctrl: _phoneCtrl,
                              label: 'Phone Number',
                              icon: Icons.phone_outlined,
                              type: TextInputType.phone,
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                              ],
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Enter your phone number';
                                }
                                if (v.length < 10) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),
                            _sectionLabel('Security'),
                            const SizedBox(height: 12),

                            // Password
                            _passField(
                              ctrl: _passCtrl,
                              label: 'Password',
                              obscure: _obscurePass,
                              onToggle: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Enter a password';
                                }
                                if (v.length < 6) {
                                  return 'At least 6 characters required';
                                }
                                return null;
                              },
                              onChanged: (_) => setState(() {}),
                            ),

                            // Strength bar
                            if (_passCtrl.text.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _StrengthBar(
                                strength: _passStrength(_passCtrl.text),
                                color: _strengthColor(
                                    _passStrength(_passCtrl.text)),
                                label: _strengthLabel(
                                    _passStrength(_passCtrl.text)),
                              ),
                            ],

                            const SizedBox(height: 12),

                            // Confirm password
                            _passField(
                              ctrl: _confirmCtrl,
                              label: 'Confirm Password',
                              obscure: _obscureConfirm,
                              onToggle: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (v != _passCtrl.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            // Terms checkbox
                            _TermsRow(
                              value: _agreeTerms,
                              onChanged: (v) =>
                                  setState(() => _agreeTerms = v!),
                            ),

                            const SizedBox(height: 20),

                            // Submit button
                            _SubmitButton(
                              label: 'Create Couple Account',
                              isLoading: _isLoading,
                              onPressed: _submit,
                            ),

                            const SizedBox(height: 16),
                            _LoginLink(),
                          ],
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  VENDOR SIGNUP PAGE
// ═══════════════════════════════════════════════════════════════

class CreateAccountPageVendor extends StatefulWidget {
  const CreateAccountPageVendor({super.key});

  @override
  State<CreateAccountPageVendor> createState() =>
      _CreateAccountPageVendorState();
}

class _CreateAccountPageVendorState extends State<CreateAccountPageVendor> {
  final _formKey = GlobalKey<FormState>();

  final _usernameCtrl    = TextEditingController();
  final _emailCtrl       = TextEditingController();
  final _phoneCtrl       = TextEditingController();
  final _businessCtrl    = TextEditingController();
  final _descCtrl        = TextEditingController();
  final _passCtrl        = TextEditingController();
  final _confirmCtrl     = TextEditingController();

  String? _selectedCategory;
  String? _selectedCity;
  bool _obscurePass      = true;
  bool _obscureConfirm   = true;
  bool _agreeTerms       = false;
  bool _isLoading        = false;
  bool _isSuccess        = false;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _businessCtrl.dispose();
    _descCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  int _passStrength(String p) {
    int score = 0;
    if (p.length >= 8) score++;
    if (p.contains(RegExp(r'[A-Z]'))) score++;
    if (p.contains(RegExp(r'[0-9]'))) score++;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) score++;
    return score;
  }

  Color _strengthColor(int s) {
    if (s <= 1) return Colors.red;
    if (s == 2) return Colors.orange;
    if (s == 3) return Colors.amber;
    return Colors.green;
  }

  String _strengthLabel(int s) {
    if (s == 0) return '';
    if (s <= 1) return 'Weak';
    if (s == 2) return 'Fair';
    if (s == 3) return 'Good';
    return 'Strong';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(_snack(
        'Please select your business category.',
        Colors.orange,
      ));
      return;
    }
    if (_selectedCity == null) {
      ScaffoldMessenger.of(context).showSnackBar(_snack(
        'Please select your city.',
        Colors.orange,
      ));
      return;
    }
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(_snack(
        'Please accept the Terms & Conditions.',
        Colors.orange,
      ));
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _isLoading = false;
      _isSuccess = true;
    });
  }

  SnackBar _snack(String msg, Color color) => SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ── Hero banner ─────────────────────────────────────────
            _HeroBanner(
              title: 'Vendor Registration',
              subtitle: 'Grow your business with us',
            ),

            // ── Tab switcher ────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -16),
              child: _AccountTypeTabs(
                selectedIndex: 1,
                onCoupleTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const CreateAccountPage()),
                ),
                onVendorTap: () {},
              ),
            ),

            // ── Form card ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _isSuccess
                  ? _SuccessCard(
                      message:
                          'Your vendor account is under review. We\'ll notify you within 24 hours.',
                      onLogin: () => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                        (r) => false,
                      ),
                    )
                  : _FormCard(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            _sectionLabel('Owner Details'),
                            const SizedBox(height: 12),

                            _field(
                              ctrl: _usernameCtrl,
                              label: 'Owner Full Name',
                              icon: Icons.person_outline,
                              validator: (v) =>
                                  v == null || v.trim().length < 3
                                      ? 'Enter at least 3 characters'
                                      : null,
                            ),
                            const SizedBox(height: 12),

                            _field(
                              ctrl: _emailCtrl,
                              label: 'Business Email',
                              icon: Icons.email_outlined,
                              type: TextInputType.emailAddress,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Enter your email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(v.trim())) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),

                            _field(
                              ctrl: _phoneCtrl,
                              label: 'Business Phone',
                              icon: Icons.phone_outlined,
                              type: TextInputType.phone,
                              formatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(11),
                              ],
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Enter your phone number';
                                }
                                if (v.length < 10) {
                                  return 'Enter a valid phone number';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 20),
                            _sectionLabel('Business Details'),
                            const SizedBox(height: 12),

                            _field(
                              ctrl: _businessCtrl,
                              label: 'Business Name',
                              icon: Icons.store_outlined,
                              validator: (v) =>
                                  v == null || v.trim().isEmpty
                                      ? 'Enter your business name'
                                      : null,
                            ),
                            const SizedBox(height: 12),

                            // Category dropdown
                            _Dropdown(
                              value: _selectedCategory,
                              hint: 'Business Category',
                              icon: Icons.category_outlined,
                              items: _vendorCategories,
                              onChanged: (v) =>
                                  setState(() => _selectedCategory = v),
                            ),
                            const SizedBox(height: 12),

                            // City dropdown
                            _Dropdown(
                              value: _selectedCity,
                              hint: 'Select City',
                              icon: Icons.location_on_outlined,
                              items: _cities,
                              onChanged: (v) =>
                                  setState(() => _selectedCity = v),
                            ),
                            const SizedBox(height: 12),

                            // Description
                            TextFormField(
                              controller: _descCtrl,
                              maxLines: 3,
                              cursorColor: kPrimary,
                              decoration: InputDecoration(
                                labelText: 'Business Description',
                                alignLabelWithHint: true,
                                prefixIcon: const Padding(
                                  padding: EdgeInsets.only(bottom: 40),
                                  child: Icon(Icons.description_outlined,
                                      color: kPrimary, size: 20),
                                ),
                                floatingLabelStyle:
                                    const TextStyle(color: kPrimary),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                      color: kPrimary, width: 1.8),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.grey.shade300),
                                ),
                                hintText:
                                    'Describe your services briefly...',
                              ),
                              validator: (v) =>
                                  v == null || v.trim().length < 10
                                      ? 'Write at least 10 characters'
                                      : null,
                            ),

                            const SizedBox(height: 20),
                            _sectionLabel('Security'),
                            const SizedBox(height: 12),

                            _passField(
                              ctrl: _passCtrl,
                              label: 'Password',
                              obscure: _obscurePass,
                              onToggle: () =>
                                  setState(() => _obscurePass = !_obscurePass),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Enter a password';
                                }
                                if (v.length < 6) {
                                  return 'At least 6 characters required';
                                }
                                return null;
                              },
                              onChanged: (_) => setState(() {}),
                            ),

                            if (_passCtrl.text.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              _StrengthBar(
                                strength: _passStrength(_passCtrl.text),
                                color: _strengthColor(
                                    _passStrength(_passCtrl.text)),
                                label: _strengthLabel(
                                    _passStrength(_passCtrl.text)),
                              ),
                            ],

                            const SizedBox(height: 12),

                            _passField(
                              ctrl: _confirmCtrl,
                              label: 'Confirm Password',
                              obscure: _obscureConfirm,
                              onToggle: () => setState(
                                  () => _obscureConfirm = !_obscureConfirm),
                              validator: (v) {
                                if (v == null || v.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                if (v != _passCtrl.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(height: 16),

                            _TermsRow(
                              value: _agreeTerms,
                              onChanged: (v) =>
                                  setState(() => _agreeTerms = v!),
                            ),

                            const SizedBox(height: 20),

                            _SubmitButton(
                              label: 'Register as Vendor',
                              isLoading: _isLoading,
                              onPressed: _submit,
                            ),

                            const SizedBox(height: 16),
                            _LoginLink(),
                          ],
                        ),
                      ),
                    ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  SHARED HELPER FUNCTIONS
// ═══════════════════════════════════════════════════════════════

Widget _sectionLabel(String text) => Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: kPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: kPrimary,
            ),
          ),
        ],
      ),
    );

Widget _field({
  required TextEditingController ctrl,
  required String label,
  required IconData icon,
  TextInputType? type,
  List<TextInputFormatter>? formatters,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
}) {
  return TextFormField(
    controller: ctrl,
    keyboardType: type,
    inputFormatters: formatters,
    cursorColor: kPrimary,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kPrimary, size: 20),
      floatingLabelStyle: const TextStyle(color: kPrimary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimary, width: 1.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.8),
      ),
    ),
    validator: validator,
  );
}

Widget _passField({
  required TextEditingController ctrl,
  required String label,
  required bool obscure,
  required VoidCallback onToggle,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
}) {
  return TextFormField(
    controller: ctrl,
    obscureText: obscure,
    cursorColor: kPrimary,
    onChanged: onChanged,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: const Icon(Icons.lock_outline, color: kPrimary, size: 20),
      suffixIcon: IconButton(
        icon: Icon(
          obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: kPrimary,
          size: 20,
        ),
        onPressed: onToggle,
      ),
      floatingLabelStyle: const TextStyle(color: kPrimary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimary, width: 1.8),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.8),
      ),
    ),
    validator: validator,
  );
}

// ═══════════════════════════════════════════════════════════════
//  SHARED WIDGETS
// ═══════════════════════════════════════════════════════════════

class _HeroBanner extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeroBanner({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 180,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xff8B1A3E), kPrimary, Color(0xffD4456E)],
            ),
          ),
        ),
        // Decorative circles
        Positioned(
          top: -30, right: -30,
          child: Container(
            width: 130, height: 130,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ),
        Positioned(
          bottom: -20, left: -20,
          child: Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.07),
            ),
          ),
        ),
        Positioned.fill(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 60, height: 60,
                color: Colors.white,
                colorBlendMode: BlendMode.srcIn,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.celebration, size: 50, color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
class _AccountTypeTabs extends StatelessWidget {
  final int selectedIndex;
  final VoidCallback onCoupleTap;
  final VoidCallback onVendorTap;

  const _AccountTypeTabs({
    required this.selectedIndex,
    required this.onCoupleTap,
    required this.onVendorTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPrimary, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: kPrimary.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: onCoupleTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedIndex == 0 ? kPrimary : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(10),
                      bottomLeft: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('👫',
                          style: TextStyle(
                              fontSize: selectedIndex == 0 ? 16 : 14)),
                      const SizedBox(width: 6),
                      Text(
                        'As a Couple',
                        style: TextStyle(
                          color: selectedIndex == 0
                              ? Colors.white
                              : kPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: onVendorTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: selectedIndex == 1 ? kPrimary : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('🏢',
                          style: TextStyle(
                              fontSize: selectedIndex == 1 ? 16 : 14)),
                      const SizedBox(width: 6),
                      Text(
                        'As a Vendor',
                        style: TextStyle(
                          color: selectedIndex == 1
                              ? Colors.white
                              : kPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
class _FormCard extends StatelessWidget {
  final Widget child;
  const _FormCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 18,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }
}

// ──────────────────────────────────────────────────────────────
class _StrengthBar extends StatelessWidget {
  final int strength;
  final Color color;
  final String label;

  const _StrengthBar(
      {required this.strength,
      required this.color,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: List.generate(4, (i) {
            return Expanded(
              child: Container(
                height: 4,
                margin:
                    EdgeInsets.only(right: i < 3 ? 4 : 0),
                decoration: BoxDecoration(
                  color: i < strength ? color : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 4),
        if (label.isNotEmpty)
          Text(
            'Password strength: $label',
            style: TextStyle(
                fontSize: 11, color: color, fontWeight: FontWeight.w500),
          ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
class _Dropdown extends StatelessWidget {
  final String? value;
  final String hint;
  final IconData icon;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _Dropdown({
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, color: kPrimary, size: 20),
              const SizedBox(width: 10),
              Text(hint,
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
            ],
          ),
          selectedItemBuilder: (ctx) => items
              .map((item) => Row(
                    children: [
                      Icon(icon, color: kPrimary, size: 20),
                      const SizedBox(width: 10),
                      Text(item,
                          style: const TextStyle(fontSize: 14)),
                    ],
                  ))
              .toList(),
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
class _TermsRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _TermsRow({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            activeColor: kPrimary,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4)),
            onChanged: onChanged,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.5),
              children: [
                TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                      color: kPrimary, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                      color: kPrimary, fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' of Events Affairs.'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────────────────────
class _SubmitButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const _SubmitButton({
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: kPrimary,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2.5),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.3,
                ),
              ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
class _LoginLink extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (r) => false,
        ),
        child: RichText(
          text: const TextSpan(
            style: TextStyle(fontSize: 13),
            children: [
              TextSpan(
                  text: 'Already have an account? ',
                  style: TextStyle(color: Colors.black54)),
              TextSpan(
                text: 'Login',
                style: TextStyle(
                    color: kPrimary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────
class _SuccessCard extends StatelessWidget {
  final String message;
  final VoidCallback onLogin;

  const _SuccessCard({required this.message, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_outline,
                color: Colors.green, size: 44),
          ),
          const SizedBox(height: 18),
          const Text(
            'Account Created! 🎉',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13, color: Colors.grey, height: 1.6),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: onLogin,
              child: const Text(
                'Go to Login',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}