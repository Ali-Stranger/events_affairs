import 'package:flutter/material.dart';
import 'homepage.dart';
import 'signup.dart';
import 'vendor_screens/vendor_dashboard.dart';
import 'admin_screens/admin_home.dart';

// ═══════════════════════════════════════════════════════════════
//  CONSTANTS
// ═══════════════════════════════════════════════════════════════

const Color kPrimary = Color(0xffB4245D);

// ═══════════════════════════════════════════════════════════════
//  DEMO CREDENTIALS  (replace with real auth later)
// ═══════════════════════════════════════════════════════════════

const String _demoUser = 'user';
const String _demoPass = 'user';
// vendor user
const String _venUser = 'vendor';
const String _venPass = 'vendor';



// admin user
const String _adminUser = 'admin';
const String _adminPass = 'admin';

// ═══════════════════════════════════════════════════════════════
//  LOGIN PAGE
// ═══════════════════════════════════════════════════════════════

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isLoading = false;
  int _failedAttempts = 0;

  late final AnimationController _shakeCtrl;
  late final Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnim = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeCtrl, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  // ── Login logic ────────────────────────────────────────────────────────────
  Future<void> _login() async {
    // Validate form fields first
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 900));

    final username = _usernameCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (username == _demoUser && password == _demoPass) {
      // Success — navigate and remove all routes behind
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CreateHomePage()),
        (route) => false,
      );
    }

    else if(username == _venUser && password == _venPass) 
 {
      // Success — navigate and remove all routes behind
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const VendorDashboardPage()),
        (route) => false,
      );

    }

    else if (username == _adminUser && password == _adminPass) {
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const AdminHomePage()),
        (route) => false,
      );
    }


     else {
      // Failure
      setState(() {
        _isLoading = false;
        _failedAttempts++;
      });
      _shakeCtrl.forward(from: 0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _failedAttempts >= 3
                      ? 'Too many attempts. Hint: username & password are both "user"'
                      : 'Invalid username or password. Please try again.',
                ),
              ),
            ],
          ),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  // ── Forgot password ────────────────────────────────────────────────────────
  void _forgotPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _ForgotPasswordSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // ── Hero banner ─────────────────────────────────────────
            Stack(
              children: [
                // Gradient banner
                Container(
                  height: 200,
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
                  top: -30,
                  right: -30,
                  child: Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -20,
                  left: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.07),
                    ),
                  ),
                ),
                // Logo + text
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 80,
                        height: 80,
                        color: Colors.white,
                        colorBlendMode: BlendMode.srcIn,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.celebration,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Events Affairs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const Text(
                        'Pakistan\'s #1 Event Planning Platform',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // ── Form card ───────────────────────────────────────────
            Transform.translate(
              offset: const Offset(0, -24),
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.10),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Heading
                      const Text(
                        'Welcome Back 👋',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Sign in to manage your events',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // ── Username / Email ──────────────────────────
                      AnimatedBuilder(
                        animation: _shakeAnim,
                        builder: (ctx, child) => Transform.translate(
                          offset: Offset(
                            _shakeCtrl.isAnimating
                                ? 6 * (0.5 - _shakeAnim.value).abs() * 6
                                : 0,
                            0,
                          ),
                          child: child,
                        ),
                        child: TextFormField(
                          controller: _usernameCtrl,
                          cursorColor: kPrimary,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: _inputDeco(
                            label: 'Username or Email',
                            icon: Icons.person_outline,
                          ),
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Please enter your username or email';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Password ─────────────────────────────────
                      AnimatedBuilder(
                        animation: _shakeAnim,
                        builder: (ctx, child) => Transform.translate(
                          offset: Offset(
                            _shakeCtrl.isAnimating
                                ? 6 * (0.5 - _shakeAnim.value).abs() * 6
                                : 0,
                            0,
                          ),
                          child: child,
                        ),
                        child: TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          cursorColor: kPrimary,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _login(),
                          decoration: _inputDeco(
                            label: 'Password',
                            icon: Icons.lock_outline,
                            suffix: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: kPrimary,
                                size: 20,
                              ),
                              onPressed: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter your password';
                            }
                            if (v.length < 4) {
                              return 'Password must be at least 4 characters';
                            }
                            return null;
                          },
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ── Remember me + Forgot password ─────────────
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              activeColor: kPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              onChanged: (v) =>
                                  setState(() => _rememberMe = v!),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Remember me',
                              style: TextStyle(fontSize: 13)),
                          const Spacer(),
                          TextButton(
                            onPressed: _forgotPassword,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: kPrimary,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // ── Login button ─────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          onPressed: _isLoading ? null : _login,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : const Text(
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // ── Divider ───────────────────────────────────
                      Row(
                        children: [
                          Expanded(
                              child: Divider(color: Colors.grey.shade300)),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('or',
                                style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 13)),
                          ),
                          Expanded(
                              child: Divider(color: Colors.grey.shade300)),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ── Create account ────────────────────────────
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                                color: kPrimary, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            foregroundColor: kPrimary,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CreateAccountPage()),
                          ),
                          child: const Text(
                            'Create an Account',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ── Demo hint ─────────────────────────────────
                      
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

  // ── Input decoration helper ────────────────────────────────────────────────
  InputDecoration _inputDeco({
    required String label,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kPrimary, size: 20),
      suffixIcon: suffix,
      floatingLabelStyle: const TextStyle(color: kPrimary),
      // cursorColor: kPrimary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kPrimary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.red, width: 1.8),
      ),
      filled: true,
      fillColor: Theme.of(context).scaffoldBackgroundColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  FORGOT PASSWORD BOTTOM SHEET
// ═══════════════════════════════════════════════════════════════

class _ForgotPasswordSheet extends StatefulWidget {
  const _ForgotPasswordSheet();

  @override
  State<_ForgotPasswordSheet> createState() => _ForgotPasswordSheetState();
}

class _ForgotPasswordSheetState extends State<_ForgotPasswordSheet> {
  final _emailCtrl = TextEditingController();
  final _sheetFormKey = GlobalKey<FormState>();
  bool _sent = false;
  bool _sending = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _sendReset() async {
    if (!_sheetFormKey.currentState!.validate()) return;
    setState(() => _sending = true);
    await Future.delayed(const Duration(milliseconds: 900));
    setState(() {
      _sending = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          const SizedBox(height: 20),

          if (!_sent) ...[
            const Text(
              'Reset Password',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Enter your email address and we\'ll send you a reset link.',
              style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
            ),
            const SizedBox(height: 20),
            Form(
              key: _sheetFormKey,
              child: TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                cursorColor: kPrimary,
                decoration: InputDecoration(
                  labelText: 'Email Address',
                  prefixIcon: const Icon(Icons.email_outlined,
                      color: kPrimary, size: 20),
                  floatingLabelStyle: const TextStyle(color: kPrimary),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
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
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'Enter a valid email address';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _sending ? null : _sendReset,
                child: _sending
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2),
                      )
                    : const Text('Send Reset Link',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w600)),
              ),
            ),
          ] else ...[
            // Success state
            Center(
              child: Column(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.mark_email_read_outlined,
                        color: Colors.green, size: 36),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Check Your Email!',
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'A password reset link has been sent to ${_emailCtrl.text.trim()}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                        height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: kPrimary),
                      foregroundColor: kPrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Back to Login'),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 8),
        ],
      ),
    );
  }
}