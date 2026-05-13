import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'footer.dart';
import 'drawer.dart';
import 'eventplanner.dart';
import 'venuecontact.dart';
import 'saved_blogs_repository.dart';

// ═══════════════════════════════════════════════════════════════
//  DATA MODEL (Firestore `blogs` collection)
// ═══════════════════════════════════════════════════════════════

class Blog {
  /// Firestore document id.
  final String id;
  final String title;
  final String shortDesc;
  final String fullContent;
  final String description;
  final String image;
  final String category;
  final String author;
  final String date;
  final String readTime;
  /// Event tags (admin multi-select + optional `event` on create).
  final List<String> eventTypes;
  /// `VendorBusinessName|Service` keys attached by admin.
  final List<String> vendorServiceKeys;
  final DateTime? createdAt;

  const Blog({
    required this.id,
    required this.title,
    required this.shortDesc,
    required this.fullContent,
    this.description = '',
    required this.image,
    required this.category,
    required this.author,
    required this.date,
    required this.readTime,
    this.eventTypes = const [],
    this.vendorServiceKeys = const [],
    this.createdAt,
  });

  factory Blog.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    final title = (d['title'] ?? '').toString().trim();
    final author = (d['author'] ?? '').toString().trim();
    final category = (d['category'] ?? 'Wedding').toString().trim();
    final description = (d['description'] ?? '').toString().trim();
    final rawContent = (d['fullContent'] ?? d['content'] ?? '').toString();
    final shortDesc = (d['shortDesc'] ?? d['summary'] ?? '').toString().trim();
    final effectiveShort = shortDesc.isNotEmpty
        ? shortDesc
        : (rawContent.length > 160
            ? '${rawContent.substring(0, 157)}...'
            : rawContent);
    final image = (d['image'] ?? 'assets/images/download.jpg').toString();
    final readTime = (d['readTime'] ?? '5 min read').toString();
    final ts = d['createdAt'];
    DateTime? created;
    if (ts is Timestamp) created = ts.toDate();

    final events = <String>[];
    final rawEvents = d['events'];
    if (rawEvents is List) {
      for (final e in rawEvents) {
        final s = e.toString().trim();
        if (s.isNotEmpty) events.add(s);
      }
    }
    final single = (d['event'] ?? '').toString().trim();
    if (single.isNotEmpty && !events.contains(single)) {
      events.insert(0, single);
    }

    final vendorKeys = <String>[];
    final rawVendors = d['vendorServices'];
    if (rawVendors is List) {
      for (final e in rawVendors) {
        final s = e.toString().trim();
        if (s.isNotEmpty) vendorKeys.add(s);
      }
    }

    String dateStr = '';
    if (created != null) {
      const months = [
        '', 'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
      ];
      dateStr = '${months[created.month]} ${created.day}, ${created.year}';
    }

    return Blog(
      id: doc.id,
      title: title.isEmpty ? 'Untitled' : title,
      shortDesc: effectiveShort.isEmpty ? 'No description yet.' : effectiveShort,
      fullContent: rawContent,
      description: description,
      image: image,
      category: category,
      author: author.isEmpty ? 'Events Affairs' : author,
      date: dateStr.isEmpty ? 'Recently' : dateStr,
      readTime: readTime,
      eventTypes: events,
      vendorServiceKeys: vendorKeys,
      createdAt: created,
    );
  }
  }


Widget blogCoverImage(
  String image, {
  double? height,
  double? width,
  BoxFit fit = BoxFit.cover,
  Widget? placeholder,
}) {
  final ph = placeholder ??
      Container(
        color: Colors.grey.shade200,
        child: const Icon(Icons.image_outlined, size: 48, color: Colors.grey),
      );
  if (image.startsWith('http://') || image.startsWith('https://')) {
    return Image.network(
      image,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (_, __, ___) => ph,
    );
  }
  return Image.asset(
    image,
    height: height,
    width: width,
    fit: fit,
    errorBuilder: (_, __, ___) => ph,
  );
}

// ═══════════════════════════════════════════════════════════════
//  CATEGORY COLORS
// ═══════════════════════════════════════════════════════════════

const Map<String, Color> categoryColors = {
  'Weddings': Color(0xffB4245D),
  'Wedding': Color(0xffB4245D),
  'Venues': Color(0xff1565C0),
  'Venue': Color(0xff1565C0),
  'Tips': Color(0xff2E7D32),
  'Photography': Color(0xff6A1B9A),
  'Catering': Color(0xffE65100),
  'Decoration': Color(0xff00695C),
  'Birthday': Color(0xffAD1457),
  'Corporate': Color(0xff37474F),
};

Color categoryColor(String cat) {
  final t = cat.trim();
  if (categoryColors.containsKey(t)) return categoryColors[t]!;
  return const Color(0xffB4245D);
}

/// Firestore `blogs` collection. When [publishedOnly] is true, only documents
/// with `status` missing or `'published'` are returned (user-facing list).
Stream<List<Blog>> watchBlogList({bool publishedOnly = false}) {
  return FirebaseFirestore.instance
      .collection('blogs')
      .snapshots()
      .map((snap) {
    var docs = snap.docs;
    if (publishedOnly) {
      docs = docs
          .where((d) {
            final st = (d.data()['status'] ?? 'published').toString();
            return st == 'published';
          })
          .toList();
    }
    final list = docs.map(Blog.fromFirestore).toList();
    list.sort((a, b) {
      final ta = a.createdAt;
      final tb = b.createdAt;
      if (ta == null && tb == null) return 0;
      if (ta == null) return 1;
      if (tb == null) return -1;
      return tb.compareTo(ta);
    });
    return list;
  });
}

void openVenueContactFromVendor(
    BuildContext context, EventPlannerVendor v) {
  Navigator.push<void>(
    context,
    MaterialPageRoute<void>(
      builder: (_) => VenueContactPage(
        name: v.name,
        location: v.location,
        price: v.price,
        image: v.image,
        category: v.category,
        rating: v.rating,
        reviews: v.reviews,
        capacity: v.capacity,
        amenities: v.services,
        description: v.description,
      ),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
//  BLOGS LIST PAGE
// ═══════════════════════════════════════════════════════════════

class BlogsPage extends StatefulWidget {
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  static const Color primary = Color(0xffB4245D);

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchCtrl = TextEditingController();

  List<String> _categoriesFromBlogs(List<Blog> blogs) {
    final set = <String>{};
    for (final b in blogs) {
      if (b.category.isNotEmpty) set.add(b.category);
    }
    final sorted = set.toList()..sort();
    return ['All', ...sorted];
  }

  List<Blog> _filterBlogs(List<Blog> blogs) {
    return blogs.where((b) {
      final matchCat =
          _selectedCategory == 'All' || b.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          b.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.shortDesc.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  Stream<List<Blog>> _publishedBlogsStream() =>
      watchBlogList(publishedOnly: true);

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),
      body: StreamBuilder<List<Blog>>(
        stream: _publishedBlogsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: primary),
            );
          }
          if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: Text(
                  'Could not load blogs. Check connection or Firestore rules.\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final allPublished = snapshot.data ?? [];
          final blogs = _filterBlogs(allPublished);
          final categories = _categoriesFromBlogs(allPublished);

          if (_selectedCategory != 'All' &&
              !categories.contains(_selectedCategory)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) setState(() => _selectedCategory = 'All');
            });
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                      Image.asset(
                        'assets/images/logo.png',
                        width: 80,
                        height: 80,
                      ),
                    ],
                  ),
                ),

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: primary.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: primary.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Event Blogs',
                        style: TextStyle(
                          color: primary,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        allPublished.isEmpty
                            ? 'New articles from our team will appear here'
                            : '${allPublished.length} article${allPublished.length == 1 ? '' : 's'} on weddings, venues & more',
                        style: TextStyle(
                          color: primary.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: (v) => setState(() => _searchQuery = v),
                    decoration: InputDecoration(
                      hintText: 'Search blogs...',
                      prefixIcon: const Icon(Icons.search, color: primary),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() => _searchQuery = '');
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: primary.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            const BorderSide(color: primary, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide:
                            BorderSide(color: primary.withOpacity(0.25)),
                      ),
                      filled: true,
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, i) {
                      final cat = categories[i];
                      final isSelected = _selectedCategory == cat;
                      final color =
                          cat == 'All' ? primary : categoryColor(cat);
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedCategory = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color
                                : color.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? color
                                  : color.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: isSelected ? Colors.white : color,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                if (allPublished.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.article_outlined,
                            size: 60,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No blog posts yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Check back soon for wedding tips and venue guides.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (blogs.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 60,
                            color: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'No blogs match your search',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else ...[
                  if (blogs.isNotEmpty) ...[
                    _FeaturedBlogCard(blog: blogs.first),
                    const SizedBox(height: 16),
                  ],
                  if (blogs.length > 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'More Articles (${blogs.length - 1})',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: blogs.length > 1 ? blogs.length - 1 : 0,
                    itemBuilder: (context, index) {
                      return _BlogListCard(blog: blogs[index + 1]);
                    },
                  ),
                ],

                const SizedBox(height: 20),
                const AppFooter(),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  FEATURED BLOG CARD (large, top card)
// ═══════════════════════════════════════════════════════════════

class _FeaturedBlogCard extends StatelessWidget {
  final Blog blog;
  const _FeaturedBlogCard({required this.blog});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(blog.category);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BlogDetailPage(blog: blog)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.18),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              // Background image
              Image.asset(
                blog.image,
                height: 240,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 240,
                  color: color.withOpacity(0.15),
                  child: Icon(Icons.image, size: 60, color: color.withOpacity(0.4)),
                ),
              ),
              // Gradient overlay
              Container(
                height: 240,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.75),
                    ],
                  ),
                ),
              ),
              // Content on top
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category + featured badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              blog.category,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              '★ Featured',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        blog.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        blog.shortDesc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.person_outline,
                              color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Text(blog.author,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const SizedBox(width: 12),
                          const Icon(Icons.calendar_today_outlined,
                              color: Colors.white70, size: 13),
                          const SizedBox(width: 4),
                          Text(blog.date,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                          const Spacer(),
                          const Icon(Icons.timer_outlined,
                              color: Colors.white70, size: 13),
                          const SizedBox(width: 4),
                          Text(blog.readTime,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BLOG LIST CARD (compact row card)
// ═══════════════════════════════════════════════════════════════

class _BlogListCard extends StatelessWidget {
  final Blog blog;
  const _BlogListCard({required this.blog});

  @override
  Widget build(BuildContext context) {
    final color = categoryColor(blog.category);
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => BlogDetailPage(blog: blog)),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Left color accent
            Container(
              width: 4,
              height: 100,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(14),
                  bottomLeft: Radius.circular(14),
                ),
              ),
            ),

            // Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                bottomLeft: Radius.circular(2),
              ),
              child: blogCoverImage(
                blog.image,
                width: 88,
                height: 100,
                fit: BoxFit.cover,
                placeholder: Container(
                  width: 88,
                  height: 100,
                  color: color.withOpacity(0.12),
                  child: Icon(Icons.image, color: color.withOpacity(0.4)),
                ),
              ),
            ),

            // Text content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        blog.category,
                        style: TextStyle(
                          color: color,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      blog.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 12, color: Colors.grey.shade500),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            '${blog.author} · ${blog.readTime}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Arrow
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Icon(Icons.arrow_forward_ios, size: 14, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
//  BLOG DETAIL PAGE (full article)
// ═══════════════════════════════════════════════════════════════

class BlogDetailPage extends StatefulWidget {
  final Blog blog;
  const BlogDetailPage({super.key, required this.blog});

  @override
  State<BlogDetailPage> createState() => _BlogDetailPageState();
}

class _BlogDetailPageState extends State<BlogDetailPage> {
  bool _isBookmarked = false;
  bool _isLiked = false;
  int _likes = 0;
  bool _isLoadingBookmark = false;

  static const Color primary = Color(0xffB4245D);

  @override
  void initState() {
    super.initState();
    _checkIfBookmarked();
  }

  Future<void> _checkIfBookmarked() async {
    try {
      final saved = await SavedBlogsRepository.loadIdSet();
      if (mounted) {
        setState(() => _isBookmarked = saved.contains(widget.blog.id));
      }
    } catch (_) {}
  }

  Future<void> _toggleBookmark() async {
    if (_isLoadingBookmark) return;
    setState(() => _isLoadingBookmark = true);

    try {
      if (_isBookmarked) {
        await SavedBlogsRepository.removeBlog(widget.blog.id);
      } else {
        await SavedBlogsRepository.addBlog(widget.blog.id);
      }
      if (mounted) {
        setState(() {
          _isBookmarked = !_isBookmarked;
          _isLoadingBookmark = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _isBookmarked ? 'Blog saved' : 'Blog removed from saved',
            ),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingBookmark = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final blog = widget.blog;
    final color = categoryColor(blog.category);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Collapsible header image ─────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            backgroundColor: color,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.35),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: [
              // Bookmark button
              GestureDetector(
                onTap: _isLoadingBookmark ? null : _toggleBookmark,
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: _isLoadingBookmark
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: Colors.white,
                          size: 20,
                        ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  SizedBox.expand(
                    child: blogCoverImage(
                      blog.image,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          Container(color: color.withOpacity(0.2)),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.6),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Article content ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Category + read time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          blog.category,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.timer_outlined,
                          size: 14, color: Colors.grey.shade500),
                      const SizedBox(width: 4),
                      Text(blog.readTime,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Title
                  Text(
                    blog.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Author + date row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: color.withOpacity(0.15),
                        child: Text(
                          blog.author.substring(0, 1),
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.author,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            blog.date,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 20),

                  // Full article content or admin description fallback
                  Text(
                    blog.fullContent.trim().isNotEmpty
                        ? blog.fullContent.trim()
                        : (blog.description.trim().isNotEmpty
                            ? blog.description.trim()
                            : 'Content will appear here once the admin publishes the full article.'),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.8,
                    ),
                  ),

                  if (blog.eventTypes.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text(
                      'Related event types',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: blog.eventTypes
                          .map(
                            (e) => Chip(
                              label: Text(e),
                              backgroundColor:
                                  categoryColor(e).withOpacity(0.12),
                              side: BorderSide(
                                  color: categoryColor(e).withOpacity(0.35)),
                            ),
                          )
                          .toList(),
                    ),
                  ],

                  if (blog.vendorServiceKeys.isNotEmpty) ...[
                    const SizedBox(height: 28),
                    const Text(
                      'Vendors featured in this article',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap a vendor to view details and send an inquiry.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      future: FirebaseFirestore.instance
                          .collection('users')
                          .where('role', isEqualTo: 'vendor')
                          .get(),
                      builder: (context, vSnap) {
                        if (vSnap.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: primary,
                                strokeWidth: 2,
                              ),
                            ),
                          );
                        }
                        if (vSnap.hasError || !vSnap.hasData) {
                          return Text(
                            'Could not load vendors.',
                            style: TextStyle(color: Colors.grey.shade600),
                          );
                        }
                        final vendorDocs = vSnap.data!.docs;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: blog.vendorServiceKeys.map((key) {
                            final parts = key.split('|');
                            final bn = parts.isNotEmpty
                                ? parts[0].trim()
                                : key.trim();
                            final svc = parts.length > 1
                                ? parts[1].trim()
                                : '';
                            QueryDocumentSnapshot<Map<String, dynamic>>?
                                match;
                            for (final doc in vendorDocs) {
                              final data = doc.data();
                              final name = (data['businessName'] ??
                                      data['name'] ??
                                      '')
                                  .toString()
                                  .trim();
                              if (name.toLowerCase() == bn.toLowerCase()) {
                                match = doc;
                                break;
                              }
                            }
                            if (match == null) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(Icons.store_outlined,
                                    color: Colors.grey.shade400),
                                title: Text(bn),
                                subtitle: Text(
                                  svc.isEmpty
                                      ? 'Not found on the platform'
                                      : '$svc · not found on the platform',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey.shade600),
                                ),
                              );
                            }
                            final v =
                                EventPlannerVendor.fromFirestore(match.data());
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              elevation: 0,
                              color: Colors.grey.shade50,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade200),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor:
                                      color.withOpacity(0.15),
                                  child: Text(
                                    v.name.isNotEmpty
                                        ? v.name[0].toUpperCase()
                                        : '?',
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  v.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600),
                                ),
                                subtitle: Text(
                                  svc.isNotEmpty
                                      ? '$svc · ${v.location}'
                                      : v.location,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                trailing:
                                    Icon(Icons.chevron_right, color: color),
                                onTap: () => openVenueContactFromVendor(
                                    context, v),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],

                  const SizedBox(height: 30),
                  Divider(color: Colors.grey.shade200),
                  const SizedBox(height: 16),

                  // Like + bookmark + share row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // Like
                      GestureDetector(
                        onTap: () => setState(() {
                          _isLiked = !_isLiked;
                          _likes += _isLiked ? 1 : -1;
                        }),
                        child: Column(
                          children: [
                            Icon(
                              _isLiked
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isLiked ? Colors.red : Colors.grey,
                              size: 28,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _likes > 0 ? '$_likes Likes' : 'Like',
                              style: TextStyle(
                                color: _isLiked ? Colors.red : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Bookmark
                      GestureDetector(
                        onTap: () =>
                            setState(() => _isBookmarked = !_isBookmarked),
                        child: Column(
                          children: [
                            Icon(
                              _isBookmarked
                                  ? Icons.bookmark
                                  : Icons.bookmark_border,
                              color: _isBookmarked ? color : Colors.grey,
                              size: 28,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _isBookmarked ? 'Saved' : 'Save',
                              style: TextStyle(
                                color:
                                    _isBookmarked ? color : Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Share
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  'Sharing "${blog.title}"...'),
                              backgroundColor: color,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Icon(Icons.share_outlined,
                                color: Colors.grey, size: 28),
                            const SizedBox(height: 4),
                            const Text('Share',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),

                  // ── Related blogs (from Firestore) ─────────────────
                  const Text(
                    'Related Articles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  StreamBuilder<List<Blog>>(
                    stream: watchBlogList(publishedOnly: true),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: primary,
                              ),
                            ),
                          ),
                        );
                      }
                      final all = snap.data!;
                      var related = all
                          .where((b) =>
                              b.id != blog.id &&
                              b.category == blog.category)
                          .take(2)
                          .toList();
                      if (related.isEmpty) {
                        related = all
                            .where((b) => b.id != blog.id)
                            .take(2)
                            .toList();
                      }
                      if (related.isEmpty) {
                        return Text(
                          'No other articles yet.',
                          style: TextStyle(color: Colors.grey.shade600),
                        );
                      }
                      return Column(
                        children: related
                            .map((r) => _BlogListCard(blog: r))
                            .toList(),
                      );
                    },
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
