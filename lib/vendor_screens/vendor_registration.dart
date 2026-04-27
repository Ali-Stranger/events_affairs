// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'vendor_dashboard.dart';
// import '../login.dart';

// const Color kPrimary = Color(0xffB4245D);

// const List<String> _vendorCategories = [
//   'Event Planner', 'Catering', 'Photography', 'Decoration / Florist',
//   'Banquet Hall', 'Marquee', 'Farm House', 'Videography',
//   'Makeup Artist', 'DJ / Entertainment',
// ];

// const List<String> _cities = [
//   'Lahore', 'Karachi', 'Islamabad', 'Multan',
//   'Peshawar', 'Faisalabad', 'Rawalpindi', 'Quetta',
// ];

// const List<String> _services = [
//   'Full Event Planning', 'Stage Décor', 'Floral Arrangements', 'Lighting',
//   'Catering Coordination', 'Photography', 'Videography', 'Drone Shots',
//   'Albums', 'Table Centerpieces', 'Bridal Bouquets', 'Buffet Setup',
//   'Live Stations', 'Staffing', 'Venue Booking', 'Makeup',
// ];

// // ═══════════════════════════════════════════════════════════════
// //  VENDOR REGISTRATION — 3-STEP WIZARD
// // ═══════════════════════════════════════════════════════════════

// class VendorRegistrationPage extends StatefulWidget {
//   const VendorRegistrationPage({super.key});

//   @override
//   State<VendorRegistrationPage> createState() => _VendorRegistrationPageState();
// }

// class _VendorRegistrationPageState extends State<VendorRegistrationPage> {
//   final PageController _pageCtrl = PageController();
//   int _currentStep = 0;

//   // Step 1 controllers
//   final _ownerNameCtrl  = TextEditingController();
//   final _emailCtrl      = TextEditingController();
//   final _phoneCtrl      = TextEditingController();
//   final _businessCtrl   = TextEditingController();
//   final _taglineCtrl    = TextEditingController();
//   final _priceCtrl      = TextEditingController();
//   final _descCtrl       = TextEditingController();
//   String? _selectedCategory;
//   String? _selectedCity;

//   // Step 2 state
//   final List<String> _selectedServices = [];
//   final List<String> _portfolioImages = []; // store file paths/base64 in real app
//   String? _cnicPath;

//   // Step 3 state
//   final _passCtrl    = TextEditingController();
//   final _confirmCtrl = TextEditingController();
//   bool _obscurePass    = true;
//   bool _obscureConfirm = true;
//   bool _agreeTerms     = false;
//   bool _isLoading      = false;
//   bool _isSuccess      = false;

//   final _step1Key = GlobalKey<FormState>();
//   final _step3Key = GlobalKey<FormState>();

//   @override
//   void dispose() {
//     _pageCtrl.dispose();
//     _ownerNameCtrl.dispose();
//     _emailCtrl.dispose();
//     _phoneCtrl.dispose();
//     _businessCtrl.dispose();
//     _taglineCtrl.dispose();
//     _priceCtrl.dispose();
//     _descCtrl.dispose();
//     _passCtrl.dispose();
//     _confirmCtrl.dispose();
//     super.dispose();
//   }

//   void _nextStep() {
//     if (_currentStep == 0) {
//       if (!_step1Key.currentState!.validate()) return;
//       if (_selectedCategory == null) {
//         _snack('Please select your business category.');
//         return;
//       }
//       if (_selectedCity == null) {
//         _snack('Please select your city.');
//         return;
//       }
//     }
//     if (_currentStep == 1) {
//       if (_selectedServices.isEmpty) {
//         _snack('Please select at least one service.');
//         return;
//       }
//       if (_portfolioImages.length < 3) {
//         _snack('Please upload at least 3 portfolio photos.');
//         return;
//       }
//     }
//     setState(() => _currentStep++);
//     _pageCtrl.animateToPage(_currentStep,
//         duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
//   }

//   void _prevStep() {
//     setState(() => _currentStep--);
//     _pageCtrl.animateToPage(_currentStep,
//         duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
//   }

//   Future<void> _submit() async {
//     if (!_step3Key.currentState!.validate()) return;
//     if (!_agreeTerms) {
//       _snack('Please accept the Terms & Conditions.');
//       return;
//     }
//     setState(() => _isLoading = true);
//     await Future.delayed(const Duration(seconds: 1));
//     setState(() { _isLoading = false; _isSuccess = true; });
//   }

//   void _snack(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//       content: Text(msg),
//       backgroundColor: Colors.orange,
//       behavior: SnackBarBehavior.floating,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//     ));
//   }

//   // ── Mock photo upload ────────────────────────────────────────────────────
//   void _addPhoto() {
//     setState(() {
//       if (_portfolioImages.length < 9) {
//         _portfolioImages.add('photo_${_portfolioImages.length + 1}');
//       }
//     });
//   }

//   void _removePhoto(int index) {
//     setState(() => _portfolioImages.removeAt(index));
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isSuccess) return _SuccessScreen();

//     return Scaffold(
//       body: Column(
//         children: [
//           // ── Hero ───────────────────────────────────────────────────
//           _VendorHeroBanner(),
//           // ── Stepper ────────────────────────────────────────────────
//           _StepIndicator(currentStep: _currentStep),
//           // ── Pages ──────────────────────────────────────────────────
//           Expanded(
//             child: PageView(
//               controller: _pageCtrl,
//               physics: const NeverScrollableScrollPhysics(),
//               children: [
//                 _Step1BusinessDetails(
//                   formKey: _step1Key,
//                   ownerNameCtrl: _ownerNameCtrl,
//                   emailCtrl: _emailCtrl,
//                   phoneCtrl: _phoneCtrl,
//                   businessCtrl: _businessCtrl,
//                   taglineCtrl: _taglineCtrl,
//                   priceCtrl: _priceCtrl,
//                   descCtrl: _descCtrl,
//                   selectedCategory: _selectedCategory,
//                   selectedCity: _selectedCity,
//                   onCategoryChanged: (v) => setState(() => _selectedCategory = v),
//                   onCityChanged: (v) => setState(() => _selectedCity = v),
//                 ),
//                 _Step2MediaServices(
//                   selectedServices: _selectedServices,
//                   portfolioImages: _portfolioImages,
//                   cnicPath: _cnicPath,
//                   onAddPhoto: _addPhoto,
//                   onRemovePhoto: _removePhoto,
//                   onServiceToggle: (s) => setState(() {
//                     _selectedServices.contains(s)
//                         ? _selectedServices.remove(s)
//                         : _selectedServices.add(s);
//                   }),
//                   onUploadCnic: () => setState(() => _cnicPath = 'cnic_document.pdf'),
//                 ),
//                 _Step3Security(
//                   formKey: _step3Key,
//                   passCtrl: _passCtrl,
//                   confirmCtrl: _confirmCtrl,
//                   obscurePass: _obscurePass,
//                   obscureConfirm: _obscureConfirm,
//                   agreeTerms: _agreeTerms,
//                   isLoading: _isLoading,
//                   onTogglePass: () => setState(() => _obscurePass = !_obscurePass),
//                   onToggleConfirm: () => setState(() => _obscureConfirm = !_obscureConfirm),
//                   onTermsChanged: (v) => setState(() => _agreeTerms = v!),
//                   onSubmit: _submit,
//                   passValue: _passCtrl.text,
//                   onPassChanged: (_) => setState(() {}),
//                 ),
//               ],
//             ),
//           ),
//           // ── Bottom navigation ───────────────────────────────────────
//           _BottomNav(
//             currentStep: _currentStep,
//             onNext: _nextStep,
//             onPrev: _prevStep,
//             onSubmit: _submit,
//             isLoading: _isLoading,
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Step indicator ─────────────────────────────────────────────────────────
// class _StepIndicator extends StatelessWidget {
//   final int currentStep;
//   const _StepIndicator({required this.currentStep});

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
//       child: Row(
//         children: List.generate(5, (i) {
//           if (i.isOdd) {
//             final lineIndex = i ~/ 2;
//             return Expanded(
//               child: Container(
//                 height: 2,
//                 color: lineIndex < currentStep ? kPrimary : Colors.grey.shade300,
//               ),
//             );
//           }
//           final stepIndex = i ~/ 2;
//           final isDone = stepIndex < currentStep;
//           final isActive = stepIndex == currentStep;
//           return Container(
//             width: 30,
//             height: 30,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: isDone
//                   ? kPrimary
//                   : isActive
//                       ? kPrimary.withOpacity(0.15)
//                       : Colors.grey.shade200,
//               border: isActive ? Border.all(color: kPrimary, width: 2) : null,
//             ),
//             child: Center(
//               child: isDone
//                   ? const Icon(Icons.check, color: Colors.white, size: 14)
//                   : Text(
//                       '${stepIndex + 1}',
//                       style: TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                         color: isActive ? kPrimary : Colors.grey,
//                       ),
//                     ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }

// // ── Bottom nav ─────────────────────────────────────────────────────────────
// class _BottomNav extends StatelessWidget {
//   final int currentStep;
//   final VoidCallback onNext, onPrev, onSubmit;
//   final bool isLoading;
//   const _BottomNav({
//     required this.currentStep, required this.onNext,
//     required this.onPrev, required this.onSubmit, required this.isLoading,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         border: Border(top: BorderSide(color: Colors.grey.shade200)),
//       ),
//       child: Row(
//         children: [
//           if (currentStep > 0)
//             Expanded(
//               child: OutlinedButton(
//                 style: OutlinedButton.styleFrom(
//                   side: const BorderSide(color: kPrimary),
//                   foregroundColor: kPrimary,
//                   padding: const EdgeInsets.symmetric(vertical: 14),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//                 onPressed: onPrev,
//                 child: const Text('Back'),
//               ),
//             ),
//           if (currentStep > 0) const SizedBox(width: 12),
//           Expanded(
//             flex: 2,
//             child: ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: kPrimary,
//                 padding: const EdgeInsets.symmetric(vertical: 14),
//                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//               ),
//               onPressed: isLoading ? null : (currentStep < 2 ? onNext : onSubmit),
//               child: isLoading
//                   ? const SizedBox(
//                       height: 20, width: 20,
//                       child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
//                     )
//                   : Text(
//                       currentStep < 2 ? 'Continue →' : 'Submit for Review',
//                       style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // ── Hero ───────────────────────────────────────────────────────────────────
// class _VendorHeroBanner extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 130,
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xff8B1A3E), kPrimary, Color(0xffD4456E)],
//         ),
//       ),
//       child: SafeArea(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset('assets/images/logo.png', width: 45, height: 45,
//               color: Colors.white, colorBlendMode: BlendMode.srcIn,
//               errorBuilder: (_, __, ___) => const Icon(Icons.store, size: 40, color: Colors.white),
//             ),
//             const SizedBox(height: 4),
//             const Text('Vendor Registration',
//                 style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
//             const Text('Grow your business with Events Affairs',
//                 style: TextStyle(color: Colors.white70, fontSize: 11)),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Step 1: Business Details ───────────────────────────────────────────────
// class _Step1BusinessDetails extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//   final TextEditingController ownerNameCtrl, emailCtrl, phoneCtrl,
//       businessCtrl, taglineCtrl, priceCtrl, descCtrl;
//   final String? selectedCategory, selectedCity;
//   final ValueChanged<String?> onCategoryChanged, onCityChanged;

//   const _Step1BusinessDetails({
//     required this.formKey, required this.ownerNameCtrl,
//     required this.emailCtrl, required this.phoneCtrl,
//     required this.businessCtrl, required this.taglineCtrl,
//     required this.priceCtrl, required this.descCtrl,
//     required this.selectedCategory, required this.selectedCity,
//     required this.onCategoryChanged, required this.onCityChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Form(
//         key: formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _sectionLabel('Owner Details'),
//             const SizedBox(height: 12),
//             _field(ctrl: ownerNameCtrl, label: 'Owner Full Name',
//                 icon: Icons.person_outline,
//                 validator: (v) => v!.trim().length < 3 ? 'Min 3 characters' : null),
//             const SizedBox(height: 10),
//             _field(ctrl: emailCtrl, label: 'Business Email',
//                 icon: Icons.email_outlined, type: TextInputType.emailAddress,
//                 validator: (v) => !v!.contains('@') ? 'Enter valid email' : null),
//             const SizedBox(height: 10),
//             _field(ctrl: phoneCtrl, label: 'Business Phone',
//                 icon: Icons.phone_outlined, type: TextInputType.phone,
//                 formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
//                 validator: (v) => v!.length < 10 ? 'Enter valid phone' : null),
//             const SizedBox(height: 20),
//             _sectionLabel('Business Info'),
//             const SizedBox(height: 12),
//             _field(ctrl: businessCtrl, label: 'Business Name',
//                 icon: Icons.store_outlined,
//                 validator: (v) => v!.trim().isEmpty ? 'Required' : null),
//             const SizedBox(height: 10),
//             _field(ctrl: taglineCtrl, label: 'Tagline (optional)',
//                 icon: Icons.format_quote_outlined),
//             const SizedBox(height: 10),
//             _field(ctrl: priceCtrl, label: 'Starting Price (PKR)',
//                 icon: Icons.currency_rupee, type: TextInputType.number,
//                 validator: (v) => v!.trim().isEmpty ? 'Required' : null),
//             const SizedBox(height: 10),
//             // Category
//             _dropdownField(
//               value: selectedCategory, hint: 'Business Category',
//               icon: Icons.category_outlined, items: _vendorCategories,
//               onChanged: onCategoryChanged,
//             ),
//             const SizedBox(height: 10),
//             // City
//             _dropdownField(
//               value: selectedCity, hint: 'Select City',
//               icon: Icons.location_on_outlined, items: _cities,
//               onChanged: onCityChanged,
//             ),
//             const SizedBox(height: 10),
//             // Description
//             TextFormField(
//               controller: descCtrl,
//               maxLines: 4,
//               cursorColor: kPrimary,
//               decoration: _inputDeco(label: 'Business Description (min. 50 chars)',
//                   icon: Icons.description_outlined),
//               validator: (v) => v!.trim().length < 50 ? 'Write at least 50 characters' : null,
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Step 2: Media & Services ───────────────────────────────────────────────
// class _Step2MediaServices extends StatelessWidget {
//   final List<String> selectedServices, portfolioImages;
//   final String? cnicPath;
//   final VoidCallback onAddPhoto, onUploadCnic;
//   final void Function(String) onServiceToggle;
//   final void Function(int) onRemovePhoto;

//   const _Step2MediaServices({
//     required this.selectedServices, required this.portfolioImages,
//     required this.cnicPath, required this.onAddPhoto,
//     required this.onRemovePhoto, required this.onServiceToggle,
//     required this.onUploadCnic,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _sectionLabel('Portfolio Photos (min. 3)'),
//           const SizedBox(height: 4),
//           Text('These appear in your public profile & search results.',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//           const SizedBox(height: 12),
//           GridView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
//             itemCount: portfolioImages.length + (portfolioImages.length < 9 ? 1 : 0),
//             itemBuilder: (ctx, i) {
//               if (i == portfolioImages.length) {
//                 return GestureDetector(
//                   onTap: onAddPhoto,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       border: Border.all(color: kPrimary, width: 1.5),
//                       borderRadius: BorderRadius.circular(10),
//                       color: kPrimary.withOpacity(0.04),
//                     ),
//                     child: const Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.add_photo_alternate_outlined, color: kPrimary, size: 28),
//                         SizedBox(height: 4),
//                         Text('Add Photo', style: TextStyle(color: kPrimary, fontSize: 10)),
//                       ],
//                     ),
//                   ),
//                 );
//               }
//               return Stack(
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                       color: kPrimary.withOpacity(0.12),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Center(child: Icon(Icons.image, color: kPrimary, size: 32)),
//                   ),
//                   Positioned(
//                     top: 4, right: 4,
//                     child: GestureDetector(
//                       onTap: () => onRemovePhoto(i),
//                       child: Container(
//                         padding: const EdgeInsets.all(2),
//                         decoration: const BoxDecoration(
//                             color: Colors.red, shape: BoxShape.circle),
//                         child: const Icon(Icons.close, color: Colors.white, size: 12),
//                       ),
//                     ),
//                   ),
//                   if (i == 0)
//                     Positioned(
//                       bottom: 4, left: 4,
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                         decoration: BoxDecoration(
//                             color: kPrimary, borderRadius: BorderRadius.circular(4)),
//                         child: const Text('Cover', style: TextStyle(color: Colors.white, fontSize: 9)),
//                       ),
//                     ),
//                 ],
//               );
//             },
//           ),
//           const SizedBox(height: 20),
//           _sectionLabel('Services Offered'),
//           const SizedBox(height: 8),
//           Wrap(
//             spacing: 8, runSpacing: 8,
//             children: _services.map((s) {
//               final isSelected = selectedServices.contains(s);
//               return GestureDetector(
//                 onTap: () => onServiceToggle(s),
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 180),
//                   padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
//                   decoration: BoxDecoration(
//                     color: isSelected ? kPrimary : Colors.transparent,
//                     borderRadius: BorderRadius.circular(20),
//                     border: Border.all(color: kPrimary),
//                   ),
//                   child: Text(s, style: TextStyle(
//                       fontSize: 12, fontWeight: FontWeight.w500,
//                       color: isSelected ? Colors.white : kPrimary)),
//                 ),
//               );
//             }).toList(),
//           ),
//           const SizedBox(height: 20),
//           _sectionLabel('Verification Document'),
//           const SizedBox(height: 4),
//           Text('Upload CNIC or Business Registration certificate.',
//               style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
//           const SizedBox(height: 10),
//           GestureDetector(
//             onTap: onUploadCnic,
//             child: Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 border: Border.all(
//                     color: cnicPath != null ? Colors.green : Colors.grey.shade300),
//                 borderRadius: BorderRadius.circular(12),
//                 color: cnicPath != null ? Colors.green.withOpacity(0.05) : null,
//               ),
//               child: Row(
//                 children: [
//                   Icon(
//                     cnicPath != null ? Icons.check_circle_outline : Icons.upload_file_outlined,
//                     color: cnicPath != null ? Colors.green : kPrimary,
//                     size: 22,
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: Text(
//                       cnicPath ?? 'Tap to upload CNIC / Business Certificate',
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: cnicPath != null ? Colors.green : Colors.grey.shade600),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//         ],
//       ),
//     );
//   }
// }

// // ── Step 3: Security ───────────────────────────────────────────────────────
// class _Step3Security extends StatelessWidget {
//   final GlobalKey<FormState> formKey;
//   final TextEditingController passCtrl, confirmCtrl;
//   final bool obscurePass, obscureConfirm, agreeTerms, isLoading;
//   final VoidCallback onTogglePass, onToggleConfirm, onSubmit;
//   final ValueChanged<bool?> onTermsChanged;
//   final ValueChanged<String> onPassChanged;
//   final String passValue;

//   const _Step3Security({
//     required this.formKey, required this.passCtrl, required this.confirmCtrl,
//     required this.obscurePass, required this.obscureConfirm,
//     required this.agreeTerms, required this.isLoading,
//     required this.onTogglePass, required this.onToggleConfirm,
//     required this.onSubmit, required this.onTermsChanged,
//     required this.onPassChanged, required this.passValue,
//   });

//   int _strength(String p) {
//     int s = 0;
//     if (p.length >= 8) s++;
//     if (p.contains(RegExp(r'[A-Z]'))) s++;
//     if (p.contains(RegExp(r'[0-9]'))) s++;
//     if (p.contains(RegExp(r'[!@#\$%^&*]'))) s++;
//     return s;
//   }

//   Color _strengthColor(int s) {
//     if (s <= 1) return Colors.red;
//     if (s == 2) return Colors.orange;
//     if (s == 3) return Colors.amber;
//     return Colors.green;
//   }

//   String _strengthLabel(int s) {
//     const labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];
//     return labels[s.clamp(0, 4)];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final strength = _strength(passValue);
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(20),
//       child: Form(
//         key: formKey,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _sectionLabel('Set Your Password'),
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: passCtrl,
//               obscureText: obscurePass,
//               cursorColor: kPrimary,
//               onChanged: onPassChanged,
//               decoration: _inputDeco(
//                 label: 'Password',
//                 icon: Icons.lock_outline,
//                 suffix: IconButton(
//                   icon: Icon(
//                     obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                     color: kPrimary, size: 20,
//                   ),
//                   onPressed: onTogglePass,
//                 ),
//               ),
//               validator: (v) {
//                 if (v == null || v.isEmpty) return 'Enter a password';
//                 if (v.length < 6) return 'At least 6 characters';
//                 return null;
//               },
//             ),
//             if (passValue.isNotEmpty) ...[
//               const SizedBox(height: 8),
//               Row(
//                 children: List.generate(4, (i) => Expanded(
//                   child: Container(
//                     height: 4,
//                     margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
//                     decoration: BoxDecoration(
//                       color: i < strength ? _strengthColor(strength) : Colors.grey.shade200,
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 )),
//               ),
//               const SizedBox(height: 4),
//               if (_strengthLabel(strength).isNotEmpty)
//                 Text('Password strength: ${_strengthLabel(strength)}',
//                     style: TextStyle(
//                         fontSize: 11, color: _strengthColor(strength),
//                         fontWeight: FontWeight.w500)),
//             ],
//             const SizedBox(height: 12),
//             TextFormField(
//               controller: confirmCtrl,
//               obscureText: obscureConfirm,
//               cursorColor: kPrimary,
//               decoration: _inputDeco(
//                 label: 'Confirm Password',
//                 icon: Icons.lock_outline,
//                 suffix: IconButton(
//                   icon: Icon(
//                     obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
//                     color: kPrimary, size: 20,
//                   ),
//                   onPressed: onToggleConfirm,
//                 ),
//               ),
//               validator: (v) {
//                 if (v == null || v.isEmpty) return 'Confirm your password';
//                 if (v != passCtrl.text) return 'Passwords do not match';
//                 return null;
//               },
//             ),
//             const SizedBox(height: 20),
//             _sectionLabel('Review & Submit'),
//             const SizedBox(height: 12),
//             Container(
//               padding: const EdgeInsets.all(14),
//               decoration: BoxDecoration(
//                 color: kPrimary.withOpacity(0.05),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: kPrimary.withOpacity(0.2)),
//               ),
//               child: Column(
//                 children: [
//                   Row(children: [
//                     const Icon(Icons.info_outline, color: kPrimary, size: 18),
//                     const SizedBox(width: 8),
//                     const Expanded(child: Text(
//                       'Your profile will be reviewed by our team within 24–48 hours. '
//                       'You will receive an email once approved.',
//                       style: TextStyle(fontSize: 12, height: 1.5),
//                     )),
//                   ]),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 SizedBox(
//                   height: 24, width: 24,
//                   child: Checkbox(
//                     value: agreeTerms,
//                     activeColor: kPrimary,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
//                     onChanged: onTermsChanged,
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 const Expanded(
//                   child: Text(
//                     'I agree to the Terms & Conditions, Privacy Policy and Vendor Guidelines of Events Affairs.',
//                     style: TextStyle(fontSize: 12, height: 1.5),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// }

// // ── Success screen ─────────────────────────────────────────────────────────
// class _SuccessScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(32),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(
//                 width: 90, height: 90,
//                 decoration: BoxDecoration(
//                   color: Colors.green.withOpacity(0.12), shape: BoxShape.circle),
//                 child: const Icon(Icons.check_circle_outline,
//                     color: Colors.green, size: 54),
//               ),
//               const SizedBox(height: 24),
//               const Text('Application Submitted! 🎉',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 12),
//               Text(
//                 'Your vendor profile is under review. We\'ll notify you within 24–48 hours once approved.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.6),
//               ),
//               const SizedBox(height: 32),
//               SizedBox(
//                 width: double.infinity,
//                 height: 50,
//                 child: ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: kPrimary,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                   ),
//                   onPressed: () => Navigator.pushAndRemoveUntil(
//                     context,
//                     MaterialPageRoute(builder: (_) => const LoginPage()),
//                     (r) => false,
//                   ),
//                   child: const Text('Go to Login',
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // ── Shared helpers ─────────────────────────────────────────────────────────
// Widget _sectionLabel(String text) => Row(
//   children: [
//     Container(width: 3, height: 16,
//         decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(2))),
//     const SizedBox(width: 8),
//     Text(text, style: const TextStyle(
//         fontSize: 14, fontWeight: FontWeight.bold, color: kPrimary)),
//   ],
// );

// InputDecoration _inputDeco({required String label, required IconData icon, Widget? suffix}) =>
//     InputDecoration(
//       labelText: label,
//       prefixIcon: Icon(icon, color: kPrimary, size: 20),
//       suffixIcon: suffix,
//       floatingLabelStyle: const TextStyle(color: kPrimary),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: kPrimary, width: 1.8)),
//       enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: BorderSide(color: Colors.grey.shade300)),
//       errorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.red)),
//       focusedErrorBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(12),
//           borderSide: const BorderSide(color: Colors.red, width: 1.8)),
//     );

// Widget _field({
//   required TextEditingController ctrl,
//   required String label,
//   required IconData icon,
//   TextInputType? type,
//   List<TextInputFormatter>? formatters,
//   String? Function(String?)? validator,
//   void Function(String)? onChanged,
// }) =>
//     TextFormField(
//       controller: ctrl,
//       keyboardType: type,
//       inputFormatters: formatters,
//       cursorColor: kPrimary,
//       onChanged: onChanged,
//       decoration: _inputDeco(label: label, icon: icon),
//       validator: validator,
//     );

// Widget _dropdownField({
//   required String? value,
//   required String hint,
//   required IconData icon,
//   required List<String> items,
//   required ValueChanged<String?> onChanged,
// }) =>
//     Container(
//       padding: const EdgeInsets.symmetric(horizontal: 14),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: DropdownButtonHideUnderline(
//         child: DropdownButton<String>(
//           value: value,
//           isExpanded: true,
//           hint: Row(children: [
//             Icon(icon, color: kPrimary, size: 20),
//             const SizedBox(width: 10),
//             Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
//           ]),
//           selectedItemBuilder: (ctx) => items.map((item) =>
//               Row(children: [
//                 Icon(icon, color: kPrimary, size: 20),
//                 const SizedBox(width: 10),
//                 Text(item, style: const TextStyle(fontSize: 14)),
//               ])).toList(),
//           items: items.map((item) =>
//               DropdownMenuItem(value: item, child: Text(item))).toList(),
//           onChanged: onChanged,
//         ),
//       ),
//     );


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../login.dart';

const Color kPrimary = Color(0xffB4245D);

const List<String> _vendorCategories = [
  'Event Planner', 'Catering', 'Photography', 'Decoration / Florist',
  'Banquet Hall', 'Marquee', 'Farm House', 'Videography',
  'Makeup Artist', 'DJ / Entertainment',
];

const List<String> _cities = [
  'Lahore', 'Karachi', 'Islamabad', 'Multan',
  'Peshawar', 'Faisalabad', 'Rawalpindi', 'Quetta',
];

const List<String> _services = [
  'Full Event Planning', 'Stage Décor', 'Floral Arrangements', 'Lighting',
  'Catering Coordination', 'Photography', 'Videography', 'Drone Shots',
  'Albums', 'Table Centerpieces', 'Bridal Bouquets', 'Buffet Setup',
  'Live Stations', 'Staffing', 'Venue Booking', 'Makeup',
];

// ═══════════════════════════════════════════════════════════════
//  VENDOR REGISTRATION — 3-STEP WIZARD
// ═══════════════════════════════════════════════════════════════

class VendorRegistrationPage extends StatefulWidget {
  const VendorRegistrationPage({super.key});

  @override
  State<VendorRegistrationPage> createState() => _VendorRegistrationPageState();
}

class _VendorRegistrationPageState extends State<VendorRegistrationPage> {
  final PageController _pageCtrl = PageController();
  int _currentStep = 0;

  // Step 1 controllers
  final _ownerNameCtrl  = TextEditingController();
  final _emailCtrl      = TextEditingController();
  final _phoneCtrl      = TextEditingController();
  final _businessCtrl   = TextEditingController();
  final _taglineCtrl    = TextEditingController();
  final _priceCtrl      = TextEditingController();
  final _descCtrl       = TextEditingController();
  String? _selectedCategory;
  String? _selectedCity;

  // Step 2 state
  final List<String> _selectedServices = [];
  final List<String> _portfolioImages = []; // store file paths/base64 in real app
  String? _cnicPath;

  // Step 3 state
  final _passCtrl    = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass    = true;
  bool _obscureConfirm = true;
  bool _agreeTerms     = false;
  bool _isLoading      = false;
  bool _isSuccess      = false;

  final _step1Key = GlobalKey<FormState>();
  final _step3Key = GlobalKey<FormState>();

  @override
  void dispose() {
    _pageCtrl.dispose();
    _ownerNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _businessCtrl.dispose();
    _taglineCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0) {
      if (!_step1Key.currentState!.validate()) return;
      if (_selectedCategory == null) {
        _snack('Please select your business category.');
        return;
      }
      if (_selectedCity == null) {
        _snack('Please select your city.');
        return;
      }
    }
    if (_currentStep == 1) {
      if (_selectedServices.isEmpty) {
        _snack('Please select at least one service.');
        return;
      }
      if (_portfolioImages.length < 3) {
        _snack('Please upload at least 3 portfolio photos.');
        return;
      }
    }
    setState(() => _currentStep++);
    _pageCtrl.animateToPage(_currentStep,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  void _prevStep() {
    setState(() => _currentStep--);
    _pageCtrl.animateToPage(_currentStep,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }

  Future<void> _submit() async {
    if (!_step3Key.currentState!.validate()) return;
    if (!_agreeTerms) {
      _snack('Please accept the Terms & Conditions.');
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() { _isLoading = false; _isSuccess = true; });
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: Colors.orange,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── Mock photo upload ────────────────────────────────────────────────────
  void _addPhoto() {
    setState(() {
      if (_portfolioImages.length < 9) {
        _portfolioImages.add('photo_${_portfolioImages.length + 1}');
      }
    });
  }

  void _removePhoto(int index) {
    setState(() => _portfolioImages.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) return _SuccessScreen();

    return Scaffold(
      body: Column(
        children: [
          // ── Hero ───────────────────────────────────────────────────
          _VendorHeroBanner(),
          // ── Stepper ────────────────────────────────────────────────
          _StepIndicator(currentStep: _currentStep),
          // ── Pages ──────────────────────────────────────────────────
          Expanded(
            child: PageView(
              controller: _pageCtrl,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _Step1BusinessDetails(
                  formKey: _step1Key,
                  ownerNameCtrl: _ownerNameCtrl,
                  emailCtrl: _emailCtrl,
                  phoneCtrl: _phoneCtrl,
                  businessCtrl: _businessCtrl,
                  taglineCtrl: _taglineCtrl,
                  priceCtrl: _priceCtrl,
                  descCtrl: _descCtrl,
                  selectedCategory: _selectedCategory,
                  selectedCity: _selectedCity,
                  onCategoryChanged: (v) => setState(() => _selectedCategory = v),
                  onCityChanged: (v) => setState(() => _selectedCity = v),
                ),
                _Step2MediaServices(
                  selectedServices: _selectedServices,
                  portfolioImages: _portfolioImages,
                  cnicPath: _cnicPath,
                  onAddPhoto: _addPhoto,
                  onRemovePhoto: _removePhoto,
                  onServiceToggle: (s) => setState(() {
                    _selectedServices.contains(s)
                        ? _selectedServices.remove(s)
                        : _selectedServices.add(s);
                  }),
                  onUploadCnic: () => setState(() => _cnicPath = 'cnic_document.pdf'),
                ),
                _Step3Security(
                  formKey: _step3Key,
                  passCtrl: _passCtrl,
                  confirmCtrl: _confirmCtrl,
                  obscurePass: _obscurePass,
                  obscureConfirm: _obscureConfirm,
                  agreeTerms: _agreeTerms,
                  isLoading: _isLoading,
                  onTogglePass: () => setState(() => _obscurePass = !_obscurePass),
                  onToggleConfirm: () => setState(() => _obscureConfirm = !_obscureConfirm),
                  onTermsChanged: (v) => setState(() => _agreeTerms = v!),
                  onSubmit: _submit,
                  passValue: _passCtrl.text,
                  onPassChanged: (_) => setState(() {}),
                ),
              ],
            ),
          ),
          // ── Bottom navigation ───────────────────────────────────────
          _BottomNav(
            currentStep: _currentStep,
            onNext: _nextStep,
            onPrev: _prevStep,
            onSubmit: _submit,
            isLoading: _isLoading,
          ),
        ],
      ),
    );
  }
}

// ── Step indicator ─────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  const _StepIndicator({required this.currentStep});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Row(
        children: List.generate(5, (i) {
          if (i.isOdd) {
            final lineIndex = i ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                color: lineIndex < currentStep ? kPrimary : Colors.grey.shade300,
              ),
            );
          }
          final stepIndex = i ~/ 2;
          final isDone = stepIndex < currentStep;
          final isActive = stepIndex == currentStep;
          return Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone
                  ? kPrimary
                  : isActive
                      ? kPrimary.withOpacity(0.15)
                      : Colors.grey.shade200,
              border: isActive ? Border.all(color: kPrimary, width: 2) : null,
            ),
            child: Center(
              child: isDone
                  ? const Icon(Icons.check, color: Colors.white, size: 14)
                  : Text(
                      '${stepIndex + 1}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isActive ? kPrimary : Colors.grey,
                      ),
                    ),
            ),
          );
        }),
      ),
    );
  }
}

// ── Bottom nav ─────────────────────────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext, onPrev, onSubmit;
  final bool isLoading;
  const _BottomNav({
    required this.currentStep, required this.onNext,
    required this.onPrev, required this.onSubmit, required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: kPrimary),
                  foregroundColor: kPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onPrev,
                child: const Text('Back'),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: isLoading ? null : (currentStep < 2 ? onNext : onSubmit),
              child: isLoading
                  ? const SizedBox(
                      height: 20, width: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : Text(
                      currentStep < 2 ? 'Continue →' : 'Submit for Review',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Hero ───────────────────────────────────────────────────────────────────
class _VendorHeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff8B1A3E), kPrimary, Color(0xffD4456E)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', width: 45, height: 45,
              color: Colors.white, colorBlendMode: BlendMode.srcIn,
              errorBuilder: (_, __, ___) => const Icon(Icons.store, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 4),
            const Text('Vendor Registration',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            const Text('Grow your business with Events Affairs',
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ── Step 1: Business Details ───────────────────────────────────────────────
class _Step1BusinessDetails extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController ownerNameCtrl, emailCtrl, phoneCtrl,
      businessCtrl, taglineCtrl, priceCtrl, descCtrl;
  final String? selectedCategory, selectedCity;
  final ValueChanged<String?> onCategoryChanged, onCityChanged;

  const _Step1BusinessDetails({
    required this.formKey, required this.ownerNameCtrl,
    required this.emailCtrl, required this.phoneCtrl,
    required this.businessCtrl, required this.taglineCtrl,
    required this.priceCtrl, required this.descCtrl,
    required this.selectedCategory, required this.selectedCity,
    required this.onCategoryChanged, required this.onCityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Owner Details'),
            const SizedBox(height: 12),
            _field(ctrl: ownerNameCtrl, label: 'Owner Full Name',
                icon: Icons.person_outline,
                validator: (v) => v!.trim().length < 3 ? 'Min 3 characters' : null),
            const SizedBox(height: 10),
            _field(ctrl: emailCtrl, label: 'Business Email',
                icon: Icons.email_outlined, type: TextInputType.emailAddress,
                validator: (v) => !v!.contains('@') ? 'Enter valid email' : null),
            const SizedBox(height: 10),
            _field(ctrl: phoneCtrl, label: 'Business Phone',
                icon: Icons.phone_outlined, type: TextInputType.phone,
                formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(11)],
                validator: (v) => v!.length < 10 ? 'Enter valid phone' : null),
            const SizedBox(height: 20),
            _sectionLabel('Business Info'),
            const SizedBox(height: 12),
            _field(ctrl: businessCtrl, label: 'Business Name',
                icon: Icons.store_outlined,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null),
            const SizedBox(height: 10),
            _field(ctrl: taglineCtrl, label: 'Tagline (optional)',
                icon: Icons.format_quote_outlined),
            const SizedBox(height: 10),
            _field(ctrl: priceCtrl, label: 'Starting Price (PKR)',
                icon: Icons.currency_rupee, type: TextInputType.number,
                validator: (v) => v!.trim().isEmpty ? 'Required' : null),
            const SizedBox(height: 10),
            // Category
            _dropdownField(
              value: selectedCategory, hint: 'Business Category',
              icon: Icons.category_outlined, items: _vendorCategories,
              onChanged: onCategoryChanged,
            ),
            const SizedBox(height: 10),
            // City
            _dropdownField(
              value: selectedCity, hint: 'Select City',
              icon: Icons.location_on_outlined, items: _cities,
              onChanged: onCityChanged,
            ),
            const SizedBox(height: 10),
            // Description
            TextFormField(
              controller: descCtrl,
              maxLines: 4,
              cursorColor: kPrimary,
              decoration: _inputDeco(label: 'Business Description (min. 50 chars)',
                  icon: Icons.description_outlined),
              validator: (v) => v!.trim().length < 50 ? 'Write at least 50 characters' : null,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Step 2: Media & Services ───────────────────────────────────────────────
class _Step2MediaServices extends StatelessWidget {
  final List<String> selectedServices, portfolioImages;
  final String? cnicPath;
  final VoidCallback onAddPhoto, onUploadCnic;
  final void Function(String) onServiceToggle;
  final void Function(int) onRemovePhoto;

  const _Step2MediaServices({
    required this.selectedServices, required this.portfolioImages,
    required this.cnicPath, required this.onAddPhoto,
    required this.onRemovePhoto, required this.onServiceToggle,
    required this.onUploadCnic,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionLabel('Portfolio Photos (min. 3)'),
          const SizedBox(height: 4),
          Text('These appear in your public profile & search results.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          const SizedBox(height: 12),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
            itemCount: portfolioImages.length + (portfolioImages.length < 9 ? 1 : 0),
            itemBuilder: (ctx, i) {
              if (i == portfolioImages.length) {
                return GestureDetector(
                  onTap: onAddPhoto,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: kPrimary, width: 1.5),
                      borderRadius: BorderRadius.circular(10),
                      color: kPrimary.withOpacity(0.04),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate_outlined, color: kPrimary, size: 28),
                        SizedBox(height: 4),
                        Text('Add Photo', style: TextStyle(color: kPrimary, fontSize: 10)),
                      ],
                    ),
                  ),
                );
              }
              return Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: kPrimary.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(child: Icon(Icons.image, color: kPrimary, size: 32)),
                  ),
                  Positioned(
                    top: 4, right: 4,
                    child: GestureDetector(
                      onTap: () => onRemovePhoto(i),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            color: Colors.red, shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 12),
                      ),
                    ),
                  ),
                  if (i == 0)
                    Positioned(
                      bottom: 4, left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                            color: kPrimary, borderRadius: BorderRadius.circular(4)),
                        child: const Text('Cover', style: TextStyle(color: Colors.white, fontSize: 9)),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          _sectionLabel('Services Offered'),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8, runSpacing: 8,
            children: _services.map((s) {
              final isSelected = selectedServices.contains(s);
              return GestureDetector(
                onTap: () => onServiceToggle(s),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: isSelected ? kPrimary : Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: kPrimary),
                  ),
                  child: Text(s, style: TextStyle(
                      fontSize: 12, fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : kPrimary)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          _sectionLabel('Verification Document'),
          const SizedBox(height: 4),
          Text('Upload CNIC or Business Registration certificate.',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
          const SizedBox(height: 10),
          GestureDetector(
            onTap: onUploadCnic,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                border: Border.all(
                    color: cnicPath != null ? Colors.green : Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: cnicPath != null ? Colors.green.withOpacity(0.05) : null,
              ),
              child: Row(
                children: [
                  Icon(
                    cnicPath != null ? Icons.check_circle_outline : Icons.upload_file_outlined,
                    color: cnicPath != null ? Colors.green : kPrimary,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      cnicPath ?? 'Tap to upload CNIC / Business Certificate',
                      style: TextStyle(
                          fontSize: 13,
                          color: cnicPath != null ? Colors.green : Colors.grey.shade600),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

// ── Step 3: Security ───────────────────────────────────────────────────────
class _Step3Security extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController passCtrl, confirmCtrl;
  final bool obscurePass, obscureConfirm, agreeTerms, isLoading;
  final VoidCallback onTogglePass, onToggleConfirm, onSubmit;
  final ValueChanged<bool?> onTermsChanged;
  final ValueChanged<String> onPassChanged;
  final String passValue;

  const _Step3Security({
    required this.formKey, required this.passCtrl, required this.confirmCtrl,
    required this.obscurePass, required this.obscureConfirm,
    required this.agreeTerms, required this.isLoading,
    required this.onTogglePass, required this.onToggleConfirm,
    required this.onSubmit, required this.onTermsChanged,
    required this.onPassChanged, required this.passValue,
  });

  int _strength(String p) {
    int s = 0;
    if (p.length >= 8) s++;
    if (p.contains(RegExp(r'[A-Z]'))) s++;
    if (p.contains(RegExp(r'[0-9]'))) s++;
    if (p.contains(RegExp(r'[!@#\$%^&*]'))) s++;
    return s;
  }

  Color _strengthColor(int s) {
    if (s <= 1) return Colors.red;
    if (s == 2) return Colors.orange;
    if (s == 3) return Colors.amber;
    return Colors.green;
  }

  String _strengthLabel(int s) {
    const labels = ['', 'Weak', 'Fair', 'Good', 'Strong'];
    return labels[s.clamp(0, 4)];
  }

  @override
  Widget build(BuildContext context) {
    final strength = _strength(passValue);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel('Set Your Password'),
            const SizedBox(height: 12),
            TextFormField(
              controller: passCtrl,
              obscureText: obscurePass,
              cursorColor: kPrimary,
              onChanged: onPassChanged,
              decoration: _inputDeco(
                label: 'Password',
                icon: Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: kPrimary, size: 20,
                  ),
                  onPressed: onTogglePass,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Enter a password';
                if (v.length < 6) return 'At least 6 characters';
                return null;
              },
            ),
            if (passValue.isNotEmpty) ...[
              const SizedBox(height: 8),
              Row(
                children: List.generate(4, (i) => Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.only(right: i < 3 ? 4 : 0),
                    decoration: BoxDecoration(
                      color: i < strength ? _strengthColor(strength) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                )),
              ),
              const SizedBox(height: 4),
              if (_strengthLabel(strength).isNotEmpty)
                Text('Password strength: ${_strengthLabel(strength)}',
                    style: TextStyle(
                        fontSize: 11, color: _strengthColor(strength),
                        fontWeight: FontWeight.w500)),
            ],
            const SizedBox(height: 12),
            TextFormField(
              controller: confirmCtrl,
              obscureText: obscureConfirm,
              cursorColor: kPrimary,
              decoration: _inputDeco(
                label: 'Confirm Password',
                icon: Icons.lock_outline,
                suffix: IconButton(
                  icon: Icon(
                    obscureConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    color: kPrimary, size: 20,
                  ),
                  onPressed: onToggleConfirm,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'Confirm your password';
                if (v != passCtrl.text) return 'Passwords do not match';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _sectionLabel('Review & Submit'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: kPrimary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kPrimary.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  Row(children: [
                    const Icon(Icons.info_outline, color: kPrimary, size: 18),
                    const SizedBox(width: 8),
                    const Expanded(child: Text(
                      'Your profile will be reviewed by our team within 24–48 hours. '
                      'You will receive an email once approved.',
                      style: TextStyle(fontSize: 12, height: 1.5),
                    )),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 24, width: 24,
                  child: Checkbox(
                    value: agreeTerms,
                    activeColor: kPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: onTermsChanged,
                  ),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'I agree to the Terms & Conditions, Privacy Policy and Vendor Guidelines of Events Affairs.',
                    style: TextStyle(fontSize: 12, height: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

// ── Success screen ─────────────────────────────────────────────────────────
class _SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.12), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_outline,
                    color: Colors.green, size: 54),
              ),
              const SizedBox(height: 24),
              const Text('Application Submitted! 🎉',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text(
                'Your vendor profile is under review. We\'ll notify you within 24–48 hours once approved.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey.shade600, height: 1.6),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () => Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                    (r) => false,
                  ),
                  child: const Text('Go to Login',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared helpers ─────────────────────────────────────────────────────────
Widget _sectionLabel(String text) => Row(
  children: [
    Container(width: 3, height: 16,
        decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(2))),
    const SizedBox(width: 8),
    Text(text, style: const TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: kPrimary)),
  ],
);

InputDecoration _inputDeco({required String label, required IconData icon, Widget? suffix}) =>
    InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: kPrimary, size: 20),
      suffixIcon: suffix,
      floatingLabelStyle: const TextStyle(color: kPrimary),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimary, width: 1.8)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 1.8)),
    );

Widget _field({
  required TextEditingController ctrl,
  required String label,
  required IconData icon,
  TextInputType? type,
  List<TextInputFormatter>? formatters,
  String? Function(String?)? validator,
  void Function(String)? onChanged,
}) =>
    TextFormField(
      controller: ctrl,
      keyboardType: type,
      inputFormatters: formatters,
      cursorColor: kPrimary,
      onChanged: onChanged,
      decoration: _inputDeco(label: label, icon: icon),
      validator: validator,
    );

Widget _dropdownField({
  required String? value,
  required String hint,
  required IconData icon,
  required List<String> items,
  required ValueChanged<String?> onChanged,
}) =>
    Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Row(children: [
            Icon(icon, color: kPrimary, size: 20),
            const SizedBox(width: 10),
            Text(hint, style: TextStyle(color: Colors.grey.shade500, fontSize: 14)),
          ]),
          selectedItemBuilder: (ctx) => items.map((item) =>
              Row(children: [
                Icon(icon, color: kPrimary, size: 20),
                const SizedBox(width: 10),
                Text(item, style: const TextStyle(fontSize: 14)),
              ])).toList(),
          items: items.map((item) =>
              DropdownMenuItem(value: item, child: Text(item))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
