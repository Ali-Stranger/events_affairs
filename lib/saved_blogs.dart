import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'blogs.dart';
import 'drawer.dart';
import 'saved_blogs_repository.dart';

const Color _kPrimary = Color(0xffB4245D);

/// Lists blogs saved by user from the blogs list or blog detail page.
class SavedBlogsPage extends StatefulWidget {
  const SavedBlogsPage({super.key});

  @override
  State<SavedBlogsPage> createState() => _SavedBlogsPageState();
}

class _SavedBlogsPageState extends State<SavedBlogsPage> {
  bool _loading = true;
  String? _error;
  List<Blog> _blogs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) {
      setState(() {
        _loading = false;
        _error = 'Please sign in to see saved blogs.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final ids = await SavedBlogsRepository.loadOrderedIds();
      if (ids.isEmpty) {
        if (!mounted) return;
        setState(() {
          _loading = false;
          _blogs = [];
        });
        return;
      }

      final snaps = await Future.wait(
        ids.map(
          (id) => FirebaseFirestore.instance.collection('blogs').doc(id).get(),
        ),
      );

      final blogs = snaps
          .where((s) => s.exists)
          .map((s) => Blog.fromFirestore(s as DocumentSnapshot<Map<String, dynamic>>))
          .toList();

      if (!mounted) return;
      setState(() {
        _loading = false;
        _blogs = blogs;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = 'Could not load saved blogs. Please try again.';
      });
    }
  }

  Future<void> _removeSaved(String blogId) async {
    try {
      await SavedBlogsRepository.removeBlog(blogId);
      if (!mounted) return;
      await _load();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Removed from saved'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not update. Try again.'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      drawer: const CommonDrawer(),
      appBar: AppBar(
        backgroundColor: _kPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Saved Blogs',
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
        ),
      ),
      body: RefreshIndicator(
        color: _kPrimary,
        backgroundColor: scheme.surfaceContainerHigh,
        onRefresh: _load,
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final muted = scheme.onSurfaceVariant;
    final cardBg = isDark ? const Color(0xff1E1E28) : scheme.surfaceContainerLow;
    final borderColor = scheme.outline.withOpacity(isDark ? 0.28 : 0.14);

    if (_loading) {
      return Center(
        child: CircularProgressIndicator(color: scheme.primary),
      );
    }
    if (_error != null) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.lock_outline, size: 48, color: muted.withOpacity(0.65)),
          const SizedBox(height: 16),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: TextStyle(color: scheme.onSurface, fontSize: 15),
          ),
        ],
      );
    }
    if (_blogs.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        children: [
          Icon(Icons.bookmark_border, size: 56, color: muted.withOpacity(0.55)),
          const SizedBox(height: 16),
          Text(
            'No saved blogs yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: scheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the bookmark icon on a blog to save it for later.',
            textAlign: TextAlign.center,
            style: TextStyle(color: muted, fontSize: 14, height: 1.35),
          ),
        ],
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _blogs.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, i) {
        final blog = _blogs[i];
        final color = categoryColor(blog.category);

        return Material(
          color: cardBg,
          elevation: isDark ? 0 : 0.5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: borderColor),
          ),
          child: InkWell(
            onTap: () {
              Navigator.push<void>(
                context,
                MaterialPageRoute<void>(
                  builder: (_) => BlogDetailPage(blog: blog),
                ),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          blog.category,
                          style: TextStyle(
                            color: color,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Remove button
                      IconButton(
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: () => _removeSaved(blog.id),
                        tooltip: 'Remove from saved',
                        splashRadius: 20,
                        constraints: const BoxConstraints(),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Blog title
                  Text(
                    blog.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: scheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),
                  // Blog description
                  if (blog.description.isNotEmpty)
                    Text(
                      blog.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: muted,
                        height: 1.4,
                      ),
                    )
                  else
                    Text(
                      blog.shortDesc,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: muted,
                        height: 1.4,
                      ),
                    ),
                  const SizedBox(height: 8),
                  // Meta info
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 12, color: muted.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          blog.author,
                          style: TextStyle(
                            fontSize: 11,
                            color: muted.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.timer_outlined, size: 12, color: muted.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(
                        blog.readTime,
                        style: TextStyle(
                          fontSize: 11,
                          color: muted.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.calendar_today_outlined, size: 12, color: muted.withOpacity(0.7)),
                      const SizedBox(width: 4),
                      Text(
                        blog.date,
                        style: TextStyle(
                          fontSize: 11,
                          color: muted.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
