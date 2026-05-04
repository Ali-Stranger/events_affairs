import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'eventplanner.dart';
import 'venues.dart';
import 'footer.dart';
import 'drawer.dart';

// ═══════════════════════════════════════════════════════════════
//  CONSTANTS
// ═══════════════════════════════════════════════════════════════

const Color kPrimary = Color(0xffB4245D);

const List<String> kCategories = [
  "Wedding",
  "Catering",
  "Photography",
  "Decoration",
  "Marquee",
  "Farm House",
];

const List<String> kLocations = [
  "Lahore",
  "Karachi",
  "Islamabad",
  "Multan",
  "Peshawar",
];

// ═══════════════════════════════════════════════════════════════
//  CATEGORY DATA
// ═══════════════════════════════════════════════════════════════

class _CategoryItem {
  final String title;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _CategoryItem({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.icon,
  });
}

const List<_CategoryItem> kCategoryItems = [
  _CategoryItem(
    title: 'Event Planners',
    subtitle: 'Find the best Event Planners',
    color: Color(0xFFF4D5C2),
    icon: Icons.event_outlined,
  ),
  _CategoryItem(
    title: 'Florist / Decoration',
    subtitle: 'Search best florists & decorators',
    color: Color(0xFFCFCDB8),
    icon: Icons.local_florist_outlined,
  ),
  _CategoryItem(
    title: 'Banquet Halls',
    subtitle: 'Find the perfect banquet halls',
    color: Color(0xFFDFB2AD),
    icon: Icons.business_outlined,
  ),
  _CategoryItem(
    title: 'Marquees',
    subtitle: 'Find the best marquees',
    color: Color(0xFFD8DFFC),
    icon: Icons.celebration_outlined,
  ),
  _CategoryItem(
    title: 'Farm Houses',
    subtitle: 'Search beautiful farm houses',
    color: Color(0xFFE5D3BD),
    icon: Icons.villa_outlined,
  ),
  _CategoryItem(
    title: 'Photographers',
    subtitle: 'Search best photographers',
    color: Color(0xFFDCF7F7),
    icon: Icons.camera_alt_outlined,
  ),
];

// ═══════════════════════════════════════════════════════════════
//  HOME PAGE
// ═══════════════════════════════════════════════════════════════

class CreateHomePage extends StatefulWidget {
  const CreateHomePage({super.key});

  @override
  State<CreateHomePage> createState() => _CreateHomePageState();
}

class _CreateHomePageState extends State<CreateHomePage> {
  // Search bar state
  String? _selectedCategory;
  String? _selectedLocation;
  final TextEditingController _vendorSearchCtrl = TextEditingController();

  // Quote form state
  final _quoteFormKey = GlobalKey<FormState>();
  final _quoteNameCtrl = TextEditingController();
  final _quotePhoneCtrl = TextEditingController();
  String? _formCategory;
  String? _formLocation;
  DateTime? _eventDate;
  bool _quoteSubmitted = false;
  bool _quoteSubmitting = false;

  @override
  void dispose() {
    _vendorSearchCtrl.dispose();
    _quoteNameCtrl.dispose();
    _quotePhoneCtrl.dispose();
    super.dispose();
  }

  // ── Find vendor ────────────────────────────────────────────────────────────
  void _findVendor() {
    final name = _vendorSearchCtrl.text.trim();
    if (name.isEmpty &&
        _selectedCategory == null &&
        _selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a vendor name, category, or location.'),
          backgroundColor: kPrimary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const Eventplanner()),
    );
  }

  // ── Date picker ────────────────────────────────────────────────────────────
  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: DateTime(now.year + 3),
      builder: (ctx, child) => Theme(
        data: Theme.of(
          ctx,
        ).copyWith(colorScheme: const ColorScheme.light(primary: kPrimary)),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _eventDate = picked);
  }

  String _formatDate(DateTime d) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${d.day} ${months[d.month]} ${d.year}';
  }

  // ── Submit quote ───────────────────────────────────────────────────────────
  Future<void> _submitQuote() async {
    if (!_quoteFormKey.currentState!.validate()) return;

    if (_formCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a category.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_formLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a city.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    if (_eventDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an event date.'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _quoteSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('quotes').add({
        'name': _quoteNameCtrl.text.trim(),
        'phone': _quotePhoneCtrl.text.trim(),
        'category': _formCategory,
        'city': _formLocation,
        'eventDate': _formatDate(_eventDate!),
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'pending',
      });

      setState(() {
        _quoteSubmitting = false;
        _quoteSubmitted = true;
      });
    } catch (e) {
      setState(() => _quoteSubmitting = false);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to submit. Please try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // ── Reset quote form ───────────────────────────────────────────────────────
  void _resetQuote() {
    _quoteNameCtrl.clear();
    _quotePhoneCtrl.clear();
    setState(() {
      _formCategory = null;
      _formLocation = null;
      _eventDate = null;
      _quoteSubmitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                  Image.asset('assets/images/logo.png', width: 80, height: 80),
                ],
              ),
            ),

            // ── Hero + Search Stack ──────────────────────────────────
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Background image
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/download.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                // Dark overlay + text
                Container(
                  height: 280,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.25),
                        Colors.black.withOpacity(0.65),
                      ],
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.only(left: 20, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find Your Perfect',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          'Event Vendor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Pakistan\'s #1 Event Planning Platform',
                          style: TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                // Search box — half inside half outside
                Positioned(
                  top: 190,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1818).withOpacity(0.88),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.35),
                          blurRadius: 14,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Vendor name field
                        TextField(
                          controller: _vendorSearchCtrl,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            hintText: 'Type vendor name...',
                            hintStyle: const TextStyle(color: Colors.white54),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: kPrimary,
                              size: 20,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: kPrimary,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: kPrimary,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Category + Location row
                        Row(
                          children: [
                            // Category
                            Expanded(
                              child: _darkDropdown<String>(
                                value: _selectedCategory,
                                hint: 'Category',
                                icon: Icons.category_outlined,
                                items: kCategories,
                                onChanged: (v) =>
                                    setState(() => _selectedCategory = v),
                              ),
                            ),
                            const SizedBox(width: 10),
                            // Location
                            Expanded(
                              child: _darkDropdown<String>(
                                value: _selectedLocation,
                                hint: 'City',
                                icon: Icons.location_on_outlined,
                                items: kLocations,
                                onChanged: (v) =>
                                    setState(() => _selectedLocation = v),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Find Vendor button
                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onPressed: _findVendor,
                            icon: const Icon(
                              Icons.search,
                              color: Colors.white,
                              size: 18,
                            ),
                            label: const Text(
                              'Find Vendor',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // ── Spacer for search box overflow ──────────────────────
            const SizedBox(height: 150),

            // ── Stats row ────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _statChip('500+', 'Vendors'),
                  const SizedBox(width: 10),
                  _statChip('4 Cities', 'Covered'),
                  const SizedBox(width: 10),
                  _statChip('10K+', 'Happy Clients'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ── Section heading ──────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Explore Wedding Categories',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Browse vendors by type — caterers, florists, planners & more.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ── Category list ────────────────────────────────────────
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: kCategoryItems.length,
              itemBuilder: (ctx, i) => _CategoryCard(item: kCategoryItems[i]),
            ),

            const SizedBox(height: 24),

            // ── Quote section heading ────────────────────────────────
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimary.withOpacity(0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kPrimary.withOpacity(0.2)),
              ),
              child: const Column(
                children: [
                  Text(
                    'Get Best Quote For Your Event',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Fill the form and get instant quotes from multiple vendors.',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Quote Form ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _quoteSubmitted
                  ? _QuoteSuccessCard(onReset: _resetQuote)
                  : Form(
                      key: _quoteFormKey,
                      child: Column(
                        children: [
                          // Row 1: Name + Category
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _quoteNameCtrl,
                                  decoration: _inputDecoration(
                                    'Your Name',
                                    Icons.person_outline,
                                  ),
                                  validator: (v) =>
                                      v == null || v.trim().isEmpty
                                      ? 'Enter your name'
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _lightDropdown<String>(
                                  value: _formCategory,
                                  hint: 'Category',
                                  icon: Icons.category_outlined,
                                  items: kCategories,
                                  onChanged: (v) =>
                                      setState(() => _formCategory = v),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          // Row 2: City
                          _lightDropdown<String>(
                            value: _formLocation,
                            hint: 'Select City',
                            icon: Icons.location_on_outlined,
                            items: kLocations,
                            onChanged: (v) => setState(() => _formLocation = v),
                          ),

                          const SizedBox(height: 12),

                          // Row 3: Phone
                          TextFormField(
                            controller: _quotePhoneCtrl,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(11),
                            ],
                            decoration: _inputDecoration(
                              'Contact Number',
                              Icons.phone_outlined,
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Enter your phone number';
                              }
                              if (v.length < 10) return 'Enter a valid number';
                              return null;
                            },
                          ),

                          const SizedBox(height: 12),

                          // Row 4: Date picker
                          GestureDetector(
                            onTap: _pickDate,
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.calendar_today_outlined,
                                    color: kPrimary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    _eventDate == null
                                        ? 'Select Event Date'
                                        : 'Event: ${_formatDate(_eventDate!)}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: _eventDate == null
                                          ? Colors.grey.shade500
                                          : Colors.black87,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey.shade500,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          // Submit button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: _quoteSubmitting ? null : _submitQuote,
                              child: _quoteSubmitting
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      'Get a Quote',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),

            const SizedBox(height: 24),

            // ── Browse Venues CTA ────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kPrimary, width: 1.5),
                    foregroundColor: kPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const VenuesPage()),
                  ),
                  icon: const Icon(Icons.location_city_outlined, size: 18),
                  label: const Text(
                    'Browse Top Venues',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),
            const AppFooter(),
          ],
        ),
      ),
    );
  }

  // ── Dark dropdown (for search box) ────────────────────────────────────────
  Widget _darkDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimary, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Row(
            children: [
              Icon(icon, color: Colors.white54, size: 14),
              const SizedBox(width: 4),
              Text(
                hint,
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
          isExpanded: true,
          dropdownColor: const Color(0xFF1A1818),
          iconEnabledColor: kPrimary,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          items: items
              .map(
                (v) => DropdownMenuItem<T>(
                  value: v as T,
                  child: Text(
                    v,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ),
              )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── Light dropdown (for quote form) ──────────────────────────────────────
  Widget _lightDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<String> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(10),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          hint: Row(
            children: [
              Icon(icon, color: kPrimary, size: 16),
              const SizedBox(width: 6),
              Text(hint, style: TextStyle(color: Colors.grey.shade500)),
            ],
          ),
          items: items
              .map((v) => DropdownMenuItem<T>(value: v as T, child: Text(v)))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  // ── Input decoration helper ────────────────────────────────────────────────
  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kPrimary, size: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: kPrimary, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.shade400),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.red),
      ),
    );
  }

  // ── Stat chip ─────────────────────────────────────────────────────────────
  Widget _statChip(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: kPrimary.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kPrimary.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kPrimary,
              ),
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  CATEGORY CARD
// ═══════════════════════════════════════════════════════════════

class _CategoryCard extends StatelessWidget {
  final _CategoryItem item;
  const _CategoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: item.color,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const Eventplanner()),
        ),
        child: Row(
          children: [
            // Icon box
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: kPrimary, size: 26),
            ),

            const SizedBox(width: 14),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    item.subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Arrow
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                size: 13,
                color: kPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  QUOTE SUCCESS CARD
// ═══════════════════════════════════════════════════════════════

class _QuoteSuccessCard extends StatelessWidget {
  final VoidCallback onReset;
  const _QuoteSuccessCard({required this.onReset});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: Colors.green,
              size: 40,
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Quote Request Sent!',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'We\'ve received your request. Multiple vendors will contact you with their best quotes shortly.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: onReset,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: kPrimary),
              foregroundColor: kPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            icon: const Icon(Icons.refresh, size: 16),
            label: const Text('Submit Another Request'),
          ),
        ],
      ),
    );
  }
}
