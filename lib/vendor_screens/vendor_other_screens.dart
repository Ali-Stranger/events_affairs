// ═══════════════════════════════════════════════════════════════
// vendor_gallery.dart
// ═══════════════════════════════════════════════════════════════
import 'package:flutter/material.dart';
import '../theme_notifier.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

const Color kPrimary = Color(0xffB4245D);
// const kPrimary = Colors.deepPurple;

// class VendorGalleryPage extends StatefulWidget {
//   const VendorGalleryPage({super.key});
//   @override
//   State<VendorGalleryPage> createState() => _VendorGalleryPageState();
// }

// class _VendorGalleryPageState extends State<VendorGalleryPage> {
//   final List<Map<String, String>> _photos = [
//     {'tag': 'Stage Décor', 'isCover': 'true'},
//     {'tag': 'Floral', 'isCover': 'false'},
//     {'tag': 'Lighting', 'isCover': 'false'},
//     {'tag': 'Stage Décor', 'isCover': 'false'},
//     {'tag': 'Floral', 'isCover': 'false'},
//     {'tag': 'Centerpieces', 'isCover': 'false'},
//     {'tag': 'Lighting', 'isCover': 'false'},
//     {'tag': 'Floral', 'isCover': 'false'},
//     {'tag': 'Stage Décor', 'isCover': 'false'},
//   ];

//   String _selectedFilter = 'All';
//   final List<String> _filters = ['All', 'Stage Décor', 'Floral', 'Lighting', 'Centerpieces'];

//   List<Map<String, String>> get _filteredPhotos =>
//       _selectedFilter == 'All' ? _photos : _photos.where((p) => p['tag'] == _selectedFilter).toList();

//   void _addPhoto() => setState(() => _photos.add({'tag': _selectedFilter == 'All' ? 'General' : _selectedFilter, 'isCover': 'false'}));
//   void _removePhoto(int index) => setState(() => _photos.removeAt(index));
//   void _setCover(int index) => setState(() {
//     for (var p in _photos) { p['isCover'] = 'false'; }
//     _photos[index]['isCover'] = 'true';
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: kPrimary,
//         title: Text('Portfolio Gallery (${_photos.length} photos)',
//             style: const TextStyle(color: Colors.white, fontSize: 15)),
//         iconTheme: const IconThemeData(color: Colors.white),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.add_photo_alternate_outlined, color: Colors.white),
//             onPressed: _addPhoto,
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Filter chips
//           SizedBox(
//             height: 50,
//             child: ListView.separated(
//               scrollDirection: Axis.horizontal,
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               itemCount: _filters.length,
//               separatorBuilder: (_, __) => const SizedBox(width: 8),
//               itemBuilder: (ctx, i) {
//                 final isSelected = _selectedFilter == _filters[i];
//                 return GestureDetector(
//                   onTap: () => setState(() => _selectedFilter = _filters[i]),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 180),
//                     padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
//                     decoration: BoxDecoration(
//                       color: isSelected ? kPrimary : Colors.transparent,
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(color: kPrimary),
//                     ),
//                     child: Text(_filters[i],
//                         style: TextStyle(color: isSelected ? Colors.white : kPrimary,
//                             fontSize: 12, fontWeight: FontWeight.w500)),
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Grid
//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.all(12),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 3, crossAxisSpacing: 8, mainAxisSpacing: 8),
//               itemCount: _filteredPhotos.length + 1,
//               itemBuilder: (ctx, i) {
//                 if (i == _filteredPhotos.length) {
//                   return GestureDetector(
//                     onTap: _addPhoto,
//                     child: Container(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: kPrimary, width: 1.5, style: BorderStyle.solid),
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: const Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(Icons.add_photo_alternate_outlined, color: kPrimary, size: 26),
//                           SizedBox(height: 4),
//                           Text('Upload', style: TextStyle(color: kPrimary, fontSize: 10)),
//                         ],
//                       ),
//                     ),
//                   );
//                 }
//                 final photo = _filteredPhotos[i];
//                 final isCover = photo['isCover'] == 'true';
//                 return GestureDetector(
//                   onLongPress: () => _showPhotoOptions(context, i),
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                           color: kPrimary.withOpacity(isCover ? 0.2 : 0.08),
//                           borderRadius: BorderRadius.circular(10),
//                           border: isCover ? Border.all(color: kPrimary, width: 2) : null,
//                         ),
//                         child: Center(
//                           child: Icon(Icons.image_outlined, color: kPrimary.withOpacity(0.5), size: 30),
//                         ),
//                       ),
//                       if (isCover)
//                         Positioned(
//                           bottom: 4, left: 4,
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
//                             decoration: BoxDecoration(
//                                 color: kPrimary, borderRadius: BorderRadius.circular(4)),
//                             child: const Text('Cover', style: TextStyle(color: Colors.white, fontSize: 9)),
//                           ),
//                         ),
//                       Positioned(
//                         top: 4, right: 4,
//                         child: GestureDetector(
//                           onTap: () => _removePhoto(i),
//                           child: Container(
//                             padding: const EdgeInsets.all(2),
//                             decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
//                             child: const Icon(Icons.close, color: Colors.white, size: 12),
//                           ),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: 4, right: 4,
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
//                           decoration: BoxDecoration(
//                             color: Colors.black54, borderRadius: BorderRadius.circular(4)),
//                           child: Text(photo['tag']!, style: const TextStyle(color: Colors.white, fontSize: 8)),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showPhotoOptions(BuildContext context, int index) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (ctx) => Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             ListTile(
//               leading: const Icon(Icons.star_outline, color: kPrimary),
//               title: const Text('Set as Cover Photo'),
//               onTap: () { Navigator.pop(ctx); _setCover(index); },
//             ),
//             ListTile(
//               leading: const Icon(Icons.delete_outline, color: Colors.red),
//               title: const Text('Delete Photo', style: TextStyle(color: Colors.red)),
//               onTap: () { Navigator.pop(ctx); _removePhoto(index); },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// Using your specific color


class VendorGalleryPage extends StatefulWidget {
  const VendorGalleryPage({super.key});
  @override
  State<VendorGalleryPage> createState() => _VendorGalleryPageState();
}

class _VendorGalleryPageState extends State<VendorGalleryPage> {
  // Store actual File objects for real images
  final List<Map<String, dynamic>> _photos = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() {
        // First photo uploaded becomes the cover automatically
        _photos.insert(0, {
          'file': File(image.path),
          'isCover': _photos.isEmpty, 
        });
      });
    }
  }

  void _removePhoto(int index) {
    setState(() {
      bool wasCover = _photos[index]['isCover'];
      _photos.removeAt(index);
      if (wasCover && _photos.isNotEmpty) {
        _photos[0]['isCover'] = true;
      }
    });
  }

  void _setCover(int index) {
    setState(() {
      for (var p in _photos) { p['isCover'] = false; }
      _photos[index]['isCover'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      // Subtle background contrast
      backgroundColor: isDark ? const Color(0xff121212) : const Color(0xffF8F9FA),
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ? const Color(0xff121212) : Colors.white,
        title: Text(
          'Portfolio Gallery',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black87),
      ),
      body: Column(
        children: [
          _buildInfoBar(isDark),
          Expanded(
            child: _photos.isEmpty ? _buildEmptyState(theme) : _buildGrid(theme, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      width: double.infinity,
      child: Text(
        'Upload high-quality images of your work to build trust with clients.',
        style: TextStyle(
          fontSize: 13,
          color: isDark ? Colors.white70 : Colors.black54,
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.add_a_photo_outlined, size: 50, color: kPrimary.withOpacity(0.5)),
          ),
          const SizedBox(height: 20),
          const Text('Your gallery is empty', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          const Text('Tap "Upload" to showcase your services', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _pickImage,
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Upload First Photo'),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(ThemeData theme, bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _photos.length + 1,
      itemBuilder: (ctx, i) {
        if (i == 0) return _buildUploadButton(isDark);

        final index = i - 1;
        final photo = _photos[index];
        final isCover = photo['isCover'] as bool;

        return GestureDetector(
          onTap: () => _showPreview(photo['file']),
          onLongPress: () => _showPhotoOptions(context, index),
          child: Hero(
            tag: 'photo_$index',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
                image: DecorationImage(
                  image: FileImage(photo['file']),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  if (isCover)
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: kPrimary,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text('COVER', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: () => _removePhoto(index),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                        child: const Icon(Icons.close, color: Colors.white, size: 12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUploadButton(bool isDark) {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? Colors.white.withOpacity(0.05) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: kPrimary.withOpacity(0.3), width: 1.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_upload_outlined, color: kPrimary, size: 28),
            const SizedBox(height: 4),
            Text('Upload', style: TextStyle(color: kPrimary, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  void _showPreview(File file) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(file),
        ),
      ),
    );
  }

  void _showPhotoOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.star_outline, color: kPrimary),
              title: const Text('Set as Cover Photo'),
              onTap: () { Navigator.pop(ctx); _setCover(index); },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Delete Photo', style: TextStyle(color: Colors.red)),
              onTap: () { Navigator.pop(ctx); _removePhoto(index); },
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// vendor_analytics.dart
// ═══════════════════════════════════════════════════════════════
// import 'package:flutter/material.dart';

// Assuming kPrimary is defined somewhere in your app. 
// Used Deep Purple here for demonstration.


class VendorAnalyticsPage extends StatefulWidget {
  const VendorAnalyticsPage({super.key});
  @override
  State<VendorAnalyticsPage> createState() => _VendorAnalyticsPageState();
}

class _VendorAnalyticsPageState extends State<VendorAnalyticsPage> {
  int _selectedPeriod = 0; // 0=Month, 1=3 Months, 2=All Time
  final List<String> _periods = ['This Month', 'Last 3 Months', 'All Time'];

  final _weekData = [3, 7, 4, 6, 9, 5, 2];
  final _weekLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  final _servicePerformance = [
    {'name': 'Stage Décor', 'pct': 0.75},
    {'name': 'Floral Arrangements', 'pct': 0.55},
    {'name': 'Lighting', 'pct': 0.30},
    {'name': 'Table Centerpieces', 'pct': 0.20},
  ];

  @override
  Widget build(BuildContext context) {
    // Extracting theme variables for clean, adaptive styling
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final surfaceColor = colorScheme.surface;
    final onSurfaceColor = colorScheme.onSurface;
    final mutedTextColor = colorScheme.onSurfaceVariant;
    final dividerColor = theme.dividerColor.withOpacity(0.1);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          'Analytics & Insights',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(_periods.length, (i) {
                  final isSelected = _selectedPeriod == i;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedPeriod = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimary : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? kPrimary : dividerColor,
                        ),
                      ),
                      child: Text(
                        _periods[i],
                        style: TextStyle(
                          color: isSelected ? Colors.white : onSurfaceColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 24),

            // Stat grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.2, // Adjusted for better text fitting
              children: const [
                _AnalyticStat(value: '1,240', label: 'Profile Views', icon: Icons.visibility_outlined),
                _AnalyticStat(value: '23', label: 'Inquiries', icon: Icons.inbox_outlined),
               // _AnalyticStat(value: '35%', label: 'Conversion Rate', icon: Icons.trending_up),
               //  _AnalyticStat(value: 'PKR 2.4L', label: 'Revenue Earned', icon: Icons.account_balance_wallet_outlined),
              ],
            ),
            const SizedBox(height: 24),

            // Bar chart
            Text(
              'Weekly Inquiries',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: SizedBox(
                height: 140,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_weekData.length, (i) {
                    final maxVal = _weekData.reduce((a, b) => a > b ? a : b);
                    final pct = _weekData[i] / maxVal;
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${_weekData[i]}',
                          style: TextStyle(fontSize: 11, color: mutedTextColor, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 600),
                          width: 24, // Slightly slimmer bars look cleaner
                          height: 90 * pct,
                          decoration: BoxDecoration(
                            color: kPrimary.withOpacity(0.7 + 0.3 * pct),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _weekLabels[i],
                          style: TextStyle(fontSize: 11, color: mutedTextColor),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 8),

            // Location breakdown
            Text(
              'Inquiries by City',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: onSurfaceColor),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: dividerColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  _CityRow(city: 'Karachi', count: 14, pct: 0.60),
                  Divider(color: dividerColor, height: 24),
                  _CityRow(city: 'Lahore', count: 6, pct: 0.26),
                  Divider(color: dividerColor, height: 24),
                  _CityRow(city: 'Islamabad', count: 3, pct: 0.14),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _AnalyticStat extends StatelessWidget {
  final String value, label;
  final IconData icon;
  const _AnalyticStat({required this.value, required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: kPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10), // Rounded rectangles look more modern than circles here
            ),
            child: Icon(icon, color: kPrimary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CityRow extends StatelessWidget {
  final String city;
  final int count;
  final double pct;
  const _CityRow({required this.city, required this.count, required this.pct});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(
            city,
            style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: const AlwaysStoppedAnimation(kPrimary),
              minHeight: 8,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 24,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// vendor_reviews.dart
// ═══════════════════════════════════════════════════════════════


class VendorReviewsPage extends StatefulWidget {
  const VendorReviewsPage({super.key});
  @override
  State<VendorReviewsPage> createState() => _VendorReviewsPageState();
}

class _VendorReviewsPageState extends State<VendorReviewsPage> {
  final List<Map<String, dynamic>> _reviews = [
    {
      'name': 'Ali Khan',
      'rating': 5,
      'date': '2 days ago',
      'service': 'Wedding Décor',
      'text': 'Absolutely stunning work! Our wedding venue looked magical. Highly recommend!',
      'reply': ''
    },
    {
      'name': 'Sara Raza',
      'rating': 4,
      'date': '1 week ago',
      'service': 'Stage Setup',
      'text': 'Very professional team. Delivered on time. Highly recommend!',
      'reply': 'Thank you Sara! It was a pleasure working with you.'
    },
    {
      'name': 'M. Bilal',
      'rating': 5,
      'date': '2 weeks ago',
      'service': 'Floral Arrangement',
      'text': 'Beautiful floral arrangements, exceeded our expectations!',
      'reply': ''
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    double avgRating = _reviews.fold(0.0, (sum, r) => sum + (r['rating'] as int)) / _reviews.length;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xff0F0F12) : const Color(0xffF8FAFC),
      appBar: AppBar(
        backgroundColor: kPrimary,
        elevation: 0,
        centerTitle: true,
        title: const Text('Reviews & Ratings',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Rating Summary Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xff1C1C26) : Colors.white,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Text(avgRating.toStringAsFixed(1),
                            style: TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w900,
                                color: isDark ? Colors.white : const Color(0xff2D3436))),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(5, (i) => Icon(
                            Icons.star_rounded,
                            color: i < avgRating.round() ? Colors.amber : Colors.grey.shade300,
                            size: 20,
                          )),
                        ),
                        const SizedBox(height: 8),
                        Text('Based on ${_reviews.length} reviews',
                            style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey.shade500)),
                      ],
                    ),
                  ),
                  Container(width: 1, height: 80, color: isDark ? Colors.white10 : Colors.grey.shade200),
                  const SizedBox(width: 20),
                  Expanded(
                    flex: 3,
                    child: Column(
                      children: [5, 4, 3, 2, 1].map((star) {
                        final count = _reviews.where((r) => r['rating'] == star).length;
                        final pct = count / _reviews.length;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Row(
                            children: [
                              Text('$star', style: TextStyle(fontSize: 11, color: isDark ? Colors.white60 : Colors.black)),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: LinearProgressIndicator(
                                    value: pct,
                                    backgroundColor: isDark ? Colors.white10 : Colors.grey.shade100,
                                    valueColor: AlwaysStoppedAnimation(star >= 4 ? Colors.amber : kPrimary),
                                    minHeight: 6,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),

            // Reviews List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Recent Reviews', 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.w800, 
                      color: isDark ? Colors.white : const Color(0xff2D3436)
                    )),
                  Icon(Icons.sort_rounded, size: 20, color: isDark ? Colors.white60 : Colors.black54),
                ],
              ),
            ),
            
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              itemCount: _reviews.length,
              itemBuilder: (ctx, i) => _ReviewCard(
                review: _reviews[i],
                isDark: isDark,
                onReply: (text) => setState(() => _reviews[i]['reply'] = text),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

class _ReviewCard extends StatefulWidget {
  final Map<String, dynamic> review;
  final bool isDark;
  final void Function(String) onReply;
  const _ReviewCard({required this.review, required this.onReply, required this.isDark});
  @override
  State<_ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<_ReviewCard> {
  bool _showReplyBox = false;
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.review;
    final isDark = widget.isDark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xff1C1C26) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? Colors.white.withOpacity(0.05) : kPrimary.withOpacity(0.05),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: kPrimary.withOpacity(0.1),
                child: Text((r['name'] as String)[0],
                    style: const TextStyle(color: kPrimary, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(r['name'] as String, 
                      style: TextStyle(
                        fontWeight: FontWeight.bold, 
                        fontSize: 14, 
                        color: isDark ? Colors.white : Colors.black
                      )),
                    Text('${r['date']} • ${r['service']}',
                        style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : Colors.grey.shade500)),
                  ],
                ),
              ),
              Row(
                children: List.generate(5, (i) => Icon(
                  Icons.star_rounded, 
                  color: i < (r['rating'] as int) ? Colors.amber : Colors.grey.withOpacity(0.3), 
                  size: 16
                )),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            r['text'] as String,
            style: TextStyle(
              fontSize: 13, 
              color: isDark ? Colors.white70 : Colors.black87, 
              height: 1.6,
              fontStyle: FontStyle.italic
            ),
          ),
          
          if ((r['reply'] as String).isNotEmpty) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.03) : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(15),
                border: Border(left: BorderSide(color: kPrimary, width: 3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Your Response', 
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: kPrimary, letterSpacing: 0.5)),
                  const SizedBox(height: 6),
                  Text(r['reply'] as String, 
                    style: TextStyle(fontSize: 12, height: 1.5, color: isDark ? Colors.white60 : Colors.black87)),
                ],
              ),
            ),
          ],

          if ((r['reply'] as String).isEmpty) ...[
            const SizedBox(height: 15),
            TextButton.icon(
              onPressed: () => setState(() => _showReplyBox = !_showReplyBox),
              icon: Icon(_showReplyBox ? Icons.close : Icons.reply_rounded, size: 16, color: kPrimary),
              label: Text(_showReplyBox ? 'Cancel' : 'Reply to Customer',
                  style: const TextStyle(fontSize: 12, color: kPrimary, fontWeight: FontWeight.bold)),
            ),
          ],

          if (_showReplyBox) ...[
            const SizedBox(height: 10),
            TextField(
              controller: _ctrl,
              maxLines: 3,
              style: TextStyle(color: isDark ? Colors.white : Colors.black, fontSize: 13),
              decoration: InputDecoration(
                hintText: 'Share your thoughts with the customer...',
                hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                filled: true,
                fillColor: isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () {
                  if (_ctrl.text.trim().isNotEmpty) {
                    widget.onReply(_ctrl.text.trim());
                    setState(() => _showReplyBox = false);
                    _ctrl.clear();
                  }
                },
                child: const Text('Post Response', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// vendor_profile_edit.dart
// ═══════════════════════════════════════════════════════════════

class VendorProfileEditPage extends StatefulWidget {
  const VendorProfileEditPage({super.key});
  @override
  State<VendorProfileEditPage> createState() => _VendorProfileEditPageState();
}

class _VendorProfileEditPageState extends State<VendorProfileEditPage> {
  final _businessCtrl = TextEditingController(text: 'Dream Décor Co.');
  final _taglineCtrl = TextEditingController(text: 'Turning your vision into reality');
  final _priceCtrl = TextEditingController(text: '30,000');
  final _phoneCtrl = TextEditingController(text: '0321-9876543');
  final _whatsappCtrl = TextEditingController(text: '0321-9876543');
  final _instagramCtrl = TextEditingController(text: 'instagram.com/dreamdecorco');
  final _facebookCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController(text: '7');

  final List<String> _selectedServices = ['Stage Décor', 'Floral Arrangements', 'Lighting', 'Table Centerpieces'];
  final _allServices = ['Stage Décor', 'Floral Arrangements', 'Lighting', 'Catering Coordination',
    'Photography', 'Bridal Bouquets', 'Table Centerpieces', 'Venue Booking'];

  bool _isSaving = false;

  @override
  void dispose() {
    _businessCtrl.dispose(); _taglineCtrl.dispose(); _priceCtrl.dispose();
    _phoneCtrl.dispose(); _whatsappCtrl.dispose(); _instagramCtrl.dispose();
    _facebookCtrl.dispose(); _yearsCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() => _isSaving = false);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Profile updated successfully!'),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: const Text('Edit Business Profile', style: TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _save,
            child: _isSaving
                ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover + Logo
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: kPrimary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(child: Icon(Icons.image_outlined, color: kPrimary, size: 40)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kPrimary),
                    foregroundColor: kPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.image, size: 16),
                  label: const Text('Change Cover', style: TextStyle(fontSize: 12)),
                )),
                const SizedBox(width: 10),
                Expanded(child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: kPrimary),
                    foregroundColor: kPrimary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () {},
                  icon: const Icon(Icons.business, size: 16),
                  label: const Text('Add Logo', style: TextStyle(fontSize: 12)),
                )),
              ],
            ),
            const SizedBox(height: 20),
            _profileSectionLabel('Basic Info'),
            const SizedBox(height: 10),
            _editField(ctrl: _businessCtrl, label: 'Business Name', icon: Icons.store_outlined),
            const SizedBox(height: 10),
            _editField(ctrl: _taglineCtrl, label: 'Tagline', icon: Icons.format_quote_outlined),
            const SizedBox(height: 10),
            _editField(ctrl: _priceCtrl, label: 'Starting Price (PKR)', icon: Icons.currency_rupee, type: TextInputType.number),
            const SizedBox(height: 10),
            _editField(ctrl: _yearsCtrl, label: 'Years of Experience', icon: Icons.work_outline, type: TextInputType.number),
            const SizedBox(height: 20),
            _profileSectionLabel('Contact'),
            const SizedBox(height: 10),
            _editField(ctrl: _phoneCtrl, label: 'Phone Number', icon: Icons.phone_outlined, type: TextInputType.phone),
            const SizedBox(height: 10),
            _editField(ctrl: _whatsappCtrl, label: 'WhatsApp Number', icon: Icons.chat_outlined, type: TextInputType.phone),
            const SizedBox(height: 20),
            _profileSectionLabel('Social Media'),
            const SizedBox(height: 10),
            _editField(ctrl: _instagramCtrl, label: 'Instagram URL', icon: Icons.camera_alt_outlined),
            const SizedBox(height: 10),
            _editField(ctrl: _facebookCtrl, label: 'Facebook URL', icon: Icons.facebook),
            const SizedBox(height: 20),
            _profileSectionLabel('Services Offered'),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _allServices.map((s) {
                final isSelected = _selectedServices.contains(s);
                return GestureDetector(
                  onTap: () => setState(() {
                    isSelected ? _selectedServices.remove(s) : _selectedServices.add(s);
                  }),
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
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: _isSaving ? null : _save,
                child: _isSaving
                    ? const SizedBox(height: 22, width: 22,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Save Changes',
                        style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _editField({required TextEditingController ctrl, required String label, required IconData icon, TextInputType? type}) =>
      TextField(
        controller: ctrl,
        keyboardType: type,
        cursorColor: kPrimary,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: kPrimary, size: 20),
          floatingLabelStyle: const TextStyle(color: kPrimary),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: kPrimary, width: 1.8)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300)),
        ),
      );

  Widget _profileSectionLabel(String text) => Row(
    children: [
      Container(width: 3, height: 16,
          decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(2))),
      const SizedBox(width: 8),
      Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimary)),
    ],
  );
}

// ═══════════════════════════════════════════════════════════════
// vendor_notifications.dart
// ═══════════════════════════════════════════════════════════════

class VendorNotificationsPage extends StatelessWidget {
  const VendorNotificationsPage({super.key});

  final _notifs = const [
    {'title': 'New inquiry from Ali Khan', 'sub': 'Wedding Décor request · Just now', 'read': false, 'icon': '📩'},
    {'title': 'New 5-star review received!', 'sub': 'Sara Raza rated you ★★★★★ · 1h ago', 'read': false, 'icon': '⭐'},
    {'title': 'Quote accepted by M. Bilal', 'sub': 'PKR 25,000 booking confirmed · 3h ago', 'read': false, 'icon': '✅'},
    {'title': 'Weekly analytics report ready', 'sub': 'View your performance · Yesterday', 'read': true, 'icon': '📊'},
    {'title': 'Profile approved by admin', 'sub': 'You are now visible in search · 2 days ago', 'read': true, 'icon': '🎉'},
    {'title': 'Tip: Add more photos to boost visibility', 'sub': 'Platform tip · 3 days ago', 'read': true, 'icon': '💡'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: const Text('Notifications', style: TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Mark all read', style: TextStyle(color: Colors.white, fontSize: 12)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifs.length,
        itemBuilder: (ctx, i) {
          final n = _notifs[i];
          final isUnread = !(n['read'] as bool);
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isUnread ? kPrimary.withOpacity(0.05) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: isUnread ? kPrimary.withOpacity(0.2) : Colors.grey.shade100),
            ),
            child: Row(
              children: [
                Text(n['icon'] as String, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n['title'] as String,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: isUnread ? FontWeight.bold : FontWeight.normal)),
                      const SizedBox(height: 2),
                      Text(n['sub'] as String,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                    ],
                  ),
                ),
                if (isUnread)
                  Container(
                    width: 8, height: 8,
                    decoration: const BoxDecoration(color: kPrimary, shape: BoxShape.circle),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// vendor_settings.dart
// ═══════════════════════════════════════════════════════════════

class VendorSettingsPage extends StatefulWidget {
  const VendorSettingsPage({super.key});

  @override
  State<VendorSettingsPage> createState() => _VendorSettingsPageState();
}

class _VendorSettingsPageState extends State<VendorSettingsPage> {
  // Notification States
  bool _newInquiryAlerts = true;
  bool _weeklyReport = true;
  final bool _reviewNotifs = true;
  bool _bookingReminders = false;
  bool _twoFactorEnabled = false;
  
  // Business States
  String _selectedCity = 'Karachi';
  bool _isListingPaused = false;

  final Color kPrimary = const Color(0xffB4245D);

  // ─── HELPERS ───

  void _showCityPicker() {
    final cities = ['Karachi', 'Lahore', 'Islamabad', 'Multan', 'Peshawar'];
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('Select Business City', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          ),
          ...cities.map((city) => ListTile(
                title: Text(city),
                trailing: _selectedCity == city ? Icon(Icons.check, color: kPrimary) : null,
                onTap: () {
                  setState(() => _selectedCity = city);
                  Navigator.pop(context);
                },
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Vendor Account?'),
        content: const Text('This will permanently remove your business listing, reviews, and booking history. This action is irreversible.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () => Navigator.pop(context),
            child: const Text('Delete Permanently', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log out?'),
        content: const Text('You\'ll need to sign in again to manage your vendor dashboard.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: kPrimary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Log Out', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.8)),
    );
  }

  Widget _settingsCard(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(children: children),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kPrimary,
        title: const Text('Vendor Settings', style: TextStyle(color: Colors.white, fontSize: 16)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── VENDOR PROFILE CARD ───
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kPrimary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: kPrimary.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: kPrimary,
                    child: const Text('DD', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Dream Décor Co.', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        Text('Verified Vendor · $_selectedCity', style: const TextStyle(fontSize: 13, color: Colors.grey)),
                      ],
                    ),
                  ),
                  _StatusBadge(isPaused: _isListingPaused),
                ],
              ),
            ),

            // ─── PREFERENCES (App Behavior) ───
            _sectionLabel('Preferences'),
            _settingsCard([
              _SettingsTile(
                icon: Icons.dark_mode_outlined,
                iconBg: kPrimary.withOpacity(0.13),
                title: 'Dark Mode',
                subtitle: 'Switch app appearance',
                trailing: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, mode, _) => Switch(
                    value: mode == ThemeMode.dark,
                    activeThumbColor: kPrimary,
                    onChanged: (val) => themeNotifier.value = val ? ThemeMode.dark : ThemeMode.light,
                  ),
                ),
              ),
              _SettingsTile(
                icon: Icons.location_on_outlined,
                iconBg: Colors.blue.withOpacity(0.13),
                title: 'Service City',
                subtitle: _selectedCity,
                onTap: _showCityPicker,
                showDivider: false,
              ),
            ]),

            // ─── NOTIFICATIONS ───
            _sectionLabel('Notifications'),
            _settingsCard([
              _SettingsTile(
                icon: Icons.notifications_outlined,
                iconBg: Colors.orange.withOpacity(0.13),
                title: 'New Inquiry Alerts',
                trailing: Switch(value: _newInquiryAlerts, activeThumbColor: kPrimary, onChanged: (v) => setState(() => _newInquiryAlerts = v)),
              ),
              _SettingsTile(
                icon: Icons.bar_chart_outlined,
                iconBg: Colors.blue.withOpacity(0.13),
                title: 'Weekly Reports',
                trailing: Switch(value: _weeklyReport, activeThumbColor: kPrimary, onChanged: (v) => setState(() => _weeklyReport = v)),
              ),
              _SettingsTile(
                icon: Icons.calendar_today_outlined,
                iconBg: Colors.green.withOpacity(0.13),
                title: 'Booking Reminders',
                trailing: Switch(value: _bookingReminders, activeThumbColor: kPrimary, onChanged: (v) => setState(() => _bookingReminders = v)),
                showDivider: false,
              ),
            ]),

            // ─── BUSINESS MANAGEMENT ───
            _sectionLabel('Business'),
            _settingsCard([
              _SettingsTile(icon: Icons.event_available_outlined, iconBg: Colors.teal.withOpacity(0.13), title: 'Manage Availability', onTap: () {}),
              _SettingsTile(icon: Icons.description_outlined, iconBg: Colors.purple.withOpacity(0.13), title: 'Business Documents', onTap: () {}),
              _SettingsTile(icon: Icons.account_balance_outlined, iconBg: Colors.indigo.withOpacity(0.13), title: 'Payout Settings', showDivider: false, onTap: () {}),
            ]),

            // ─── SECURITY ───
            _sectionLabel('Security'),
            _settingsCard([
              _SettingsTile(
                icon: Icons.security,
                iconBg: Colors.green.withOpacity(0.13),
                title: 'Two-Factor Auth',
                trailing: Switch(value: _twoFactorEnabled, activeThumbColor: kPrimary, onChanged: (v) => setState(() => _twoFactorEnabled = v)),
              ),
              _SettingsTile(icon: Icons.lock_outline, iconBg: Colors.orange.withOpacity(0.13), title: 'Change Password', showDivider: false, onTap: () {}),
            ]),

            // ─── DANGER ZONE ───
            _sectionLabel('Danger Zone'),
            _settingsCard([
              _SettingsTile(
                icon: _isListingPaused ? Icons.play_arrow : Icons.pause_circle_outline,
                iconBg: (_isListingPaused ? Colors.green : Colors.orange).withOpacity(0.13),
                title: _isListingPaused ? 'Activate Listing' : 'Pause Listing',
                titleColor: _isListingPaused ? Colors.green : Colors.orange,
                onTap: () => setState(() => _isListingPaused = !_isListingPaused),
              ),
              _SettingsTile(
                icon: Icons.delete_outline,
                iconBg: Colors.red.withOpacity(0.13),
                title: 'Delete Vendor Account',
                titleColor: Colors.red,
                showDivider: false,
                onTap: _showDeleteAccountDialog,
              ),
            ]),

            // ─── LOGOUT ───
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.red, width: 1.5),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: _showLogoutDialog,
                  icon: const Icon(Icons.logout),
                  label: const Text('Log Out', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const Center(
              child: Padding(
                padding: EdgeInsets.only(bottom: 24),
                child: Text('Events Affairs v1.0.0 · Vendor Portal', style: TextStyle(fontSize: 12, color: Colors.grey)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── REUSABLE COMPONENTS ───

class _StatusBadge extends StatelessWidget {
  final bool isPaused;
  const _StatusBadge({required this.isPaused});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isPaused ? Colors.orange.withOpacity(0.15) : Colors.green.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isPaused ? 'Paused' : 'Active',
        style: TextStyle(color: isPaused ? Colors.orange : Colors.green, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color iconBg;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color? titleColor;

  const _SettingsTile({
    required this.title, this.subtitle, required this.icon,
    required this.iconBg, this.trailing, this.onTap, this.showDivider = true, this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          leading: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: titleColor ?? Colors.black87),
          ),
          title: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: titleColor)),
          subtitle: subtitle != null ? Text(subtitle!, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null,
          trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, color: Colors.grey, size: 20) : null),
        ),
        if (showDivider) const Divider(height: 1, indent: 70, endIndent: 16),
      ],
    );
  }
}