import 'package:flutter/material.dart';
import 'footer.dart';
import 'drawer.dart'; 

// ═══════════════════════════════════════════════════════════════
//  DATA MODEL
// ═══════════════════════════════════════════════════════════════

class Blog {
  final int id;
  final String title;
  final String shortDesc;
  final String fullContent;
  final String image;
  final String category;
  final String author;
  final String date;
  final String readTime;

  const Blog({
    required this.id,
    required this.title,
    required this.shortDesc,
    required this.fullContent,
    required this.image,
    required this.category,
    required this.author,
    required this.date,
    required this.readTime,
  });
}

// ═══════════════════════════════════════════════════════════════
//  BLOG DATA
// ═══════════════════════════════════════════════════════════════

const List<Blog> allBlogs = [
  Blog(
    id: 1,
    title: "Top Wedding Trends 2026",
    shortDesc: "Discover the hottest wedding décor and planning trends taking Pakistan by storm this year.",
    fullContent: """
Wedding trends in Pakistan for 2026 are all about blending tradition with modern elegance. Here's what's trending this year:

🌸 Floral Ceiling Installations
Gone are the days of simple bouquets. Couples are now investing in dramatic ceiling installations with fresh flowers, creating a magical canopy effect in wedding halls.

🕯️ Candlelit Intimate Weddings
Smaller, more intimate weddings with atmospheric candle lighting are replacing grand, crowded events. Quality over quantity is the new mantra.

🎨 Earthy & Jewel Tones
Deep emeralds, burnt oranges, terracotta, and dusty rose palettes are replacing the classic reds and pinks. These tones photograph beautifully and look stunning in person.

📸 Cinematic Wedding Films
Short film-style wedding videos with storytelling are now more popular than traditional photography. Couples invest in creative directors and cinematographers.

🍽️ Live Food Stations
Interactive food stations — from live chaat counters to custom dessert bars — are replacing traditional buffets, adding an element of fun and engagement.

💌 Personalized Details
Custom monograms, handwritten menus, and bespoke wedding favors are a big trend. Couples are making every detail uniquely theirs.

Whether you're planning a grand shaadi or an intimate nikkah, these trends will inspire your perfect wedding day!
    """,
    image: "assets/images/download.jpg",
    category: "Weddings",
    author: "Ayesha Malik",
    date: "March 15, 2026",
    readTime: "5 min read",
  ),
  Blog(
    id: 2,
    title: "Best Event Venues in Lahore",
    shortDesc: "A curated guide to Lahore's most stunning and affordable banquet halls and marquees.",
    fullContent: """
Lahore is home to some of Pakistan's most spectacular event venues. Whether you're planning a wedding, corporate event, or birthday celebration, here are the top picks:

🏛️ Gulberg Marquees
The Gulberg area is packed with premium marquees offering state-of-the-art facilities. Expect top-tier catering, elegant décor packages, and professional staff.

🌿 Canal-Side Farmhouses
For a more relaxed, open-air experience, farmhouses along the Canal Road offer lush green settings perfect for daytime events and smaller gatherings.

🌆 DHA Banquet Halls
DHA offers a range of venues from budget-friendly to luxury. Many include in-house catering, decoration services, and valet parking.

🏨 5-Star Hotel Ballrooms
Hotels like PC Lahore and Avari offer world-class ballrooms with unmatched service. Perfect for high-profile corporate events and grand weddings.

🌸 Garden Venues
Outdoor garden venues in Model Town and Garden Town are perfect for spring events. The natural backdrop reduces decoration costs significantly.

💡 Tips for Choosing:
• Book at least 6 months in advance for peak season
• Always visit the venue in person before booking
• Confirm if outside catering is allowed
• Ask about parking capacity for your guest count
    """,
    image: "assets/images/download.jpg",
    category: "Venues",
    author: "Bilal Ahmed",
    date: "March 22, 2026",
    readTime: "4 min read",
  ),
  Blog(
    id: 3,
    title: "Budget Planning Tips for Events",
    shortDesc: "Smart, practical strategies to host an unforgettable event without breaking the bank.",
    fullContent: """
Planning a memorable event on a budget is an art. Here are the most effective strategies our experts recommend:

📋 Start with a Master Budget Sheet
List every single expense category: venue, catering, décor, photography, entertainment, invitations, and miscellaneous. Assign a maximum amount to each and track spending weekly.

🤝 Negotiate Everything
Most vendors in Pakistan expect negotiation. Don't accept the first price — ask for package deals, off-season discounts, or bundled services (e.g., photography + videography from one vendor).

📅 Choose Off-Peak Dates
Weddings and events in January-February and July-August are significantly cheaper than the October-December peak season. Weekday events are also more affordable.

🌿 DIY Décor Elements
Simple DIY items like table centerpieces, balloon arches, and photo walls can save tens of thousands of rupees. YouTube tutorials make this easier than ever.

🍴 Smart Catering Choices
• Opt for a smaller menu with higher quality
• Choose a seasonal menu (ingredients cost less)
• Consider food stations over full buffets
• Negotiate a per-head rate rather than a flat fee

📸 Hire Emerging Talent
New photographers and videographers often offer competitive rates while delivering excellent quality. Review portfolios carefully on social media.

💌 Digital Invitations
WhatsApp and email invitations for informal guests save significantly on printing costs while being more eco-friendly.

Remember: a well-planned modest event always beats a poorly executed grand one!
    """,
    image: "assets/images/download.jpg",
    category: "Tips",
    author: "Sara Khan",
    date: "April 1, 2026",
    readTime: "6 min read",
  ),
  Blog(
    id: 4,
    title: "Photography Guide for Weddings",
    shortDesc: "Everything you need to know to get the most stunning wedding photos in Pakistan.",
    fullContent: """
Your wedding photos will last a lifetime — here's how to make sure they're extraordinary.

🎯 Hire the Right Photographer
Look for a photographer whose style matches your vision. Browse their full galleries (not just highlights), check reviews, and meet them in person before booking.

⏰ Create a Shot List
Work with your photographer to create a comprehensive shot list including:
• Family formal portraits
• Candid moments
• Detail shots (rings, mehndi, décor)
• Venue shots
• Getting ready moments

🌅 Golden Hour Magic
The hour after sunrise and before sunset offers the most flattering, beautiful natural light. Schedule outdoor portraits during this time for magical results.

👗 Coordinate Outfits
Ensure bridal party outfits complement each other and photograph well together. Avoid overly busy patterns that clash.

📍 Scout Locations
Visit your venue with your photographer beforehand to identify the best photo spots and plan the day's timeline accordingly.

💡 Technical Tips:
• Ensure the venue has adequate lighting or discuss additional lighting equipment
• Have a backup plan for outdoor shoots in case of bad weather
• Book your photographer for the full day to capture all moments
• Request RAW files or high-resolution JPEGs for future reprints
    """,
    image: "assets/images/download.jpg",
    category: "Photography",
    author: "Zara Hussain",
    date: "April 5, 2026",
    readTime: "7 min read",
  ),
  Blog(
    id: 5,
    title: "Catering Secrets from Top Chefs",
    shortDesc: "Professional catering tips and the most popular menu choices for Pakistani events.",
    fullContent: """
Great food is the soul of any Pakistani event. Here's what the top catering professionals recommend:

🍖 The Classic Pakistani Menu
No event is complete without:
• Biryani (always the star dish)
• Karahi — Chicken or Mutton
• Dal Makhni or Dal Tadka
• Naan & Roti from tandoor
• Raita, salads, and chutneys
• Desserts: Kheer, Gulab Jamun, Zarda

🌟 Trending Additions for 2026
• Live Chaat Counter (Pani Puri, Dahi Bhalla, Aloo Tikki)
• BBQ Station with freshly grilled kebabs
• Continental options (pasta, grilled chicken) for diverse guests
• Dessert Bar with multiple sweet options
• Fresh juice and mocktail station

📏 Portion Planning
• For a standard event: 1.5 servings per person
• Always add 10% buffer for unexpected guests
• Plan more for evening events (guests eat more at dinner)

🧑‍🍳 Questions to Ask Your Caterer:
• Do you provide all crockery and serving staff?
• What is your policy for leftover food?
• Can you accommodate dietary restrictions?
• Do you have a tasting session before the event?

❄️ Food Safety
Ensure your caterer follows proper food safety protocols, especially for outdoor events in warm weather. Ask about refrigeration and how long food will be kept before serving.
    """,
    image: "assets/images/download.jpg",
    category: "Catering",
    author: "Chef Imran Ali",
    date: "April 8, 2026",
    readTime: "5 min read",
  ),
  Blog(
    id: 6,
    title: "Decoration Ideas on a Budget",
    shortDesc: "Creative, beautiful decoration ideas that won't drain your event budget.",
    fullContent: """
You don't need a massive budget to create a stunning event space. Here are our top decoration ideas:

🌸 Floral Alternatives
Fresh flowers are beautiful but expensive. Consider:
• Dried pampas grass (lasts forever, very trendy)
• Silk flowers that photograph almost identically to real ones
• Tropical leaves as table centerpieces
• Mix real and artificial flowers to reduce costs

🕯️ Candles & Fairy Lights
Nothing transforms a space like warm lighting. Use:
• Pillar candles in varying heights
• Fairy lights draped over fabric
• Lanterns scattered on tables and pathways
• LED candles for safety at indoor venues

🎨 Backdrop Ideas
• Balloon garlands (easy DIY, huge impact)
• Fabric draping with fairy lights
• Floral wall using mix of real and fake flowers
• Photo walls with personalized elements

🌿 Greenery as Décor
Rent large indoor plants from nurseries for the event. They're affordable, beautiful, and create a lush atmosphere without a big spend.

🪴 DIY Projects:
• Mason jar centerpieces with candles and flowers
• Painted glass bottles as vases
• Geometric cardboard frames with flower inserts
• Paper flower installations for photo walls

📸 Focus Your Budget
Identify the 2-3 areas that will be most photographed (main stage, entrance, dining area) and spend most of your budget there. Simpler décor in other areas won't be noticed.
    """,
    image: "assets/images/download.jpg",
    category: "Decoration",
    author: "Hina Butt",
    date: "April 10, 2026",
    readTime: "5 min read",
  ),
];

// ═══════════════════════════════════════════════════════════════
//  CATEGORY COLORS
// ═══════════════════════════════════════════════════════════════

const Map<String, Color> categoryColors = {
  'Weddings': Color(0xffB4245D),
  'Venues': Color(0xff1565C0),
  'Tips': Color(0xff2E7D32),
  'Photography': Color(0xff6A1B9A),
  'Catering': Color(0xffE65100),
  'Decoration': Color(0xff00695C),
};

Color categoryColor(String cat) =>
    categoryColors[cat] ?? const Color(0xffB4245D);

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

  final List<String> categories = [
    'All',
    'Weddings',
    'Venues',
    'Tips',
    'Photography',
    'Catering',
    'Decoration',
  ];

  List<Blog> get filteredBlogs {
    return allBlogs.where((b) {
      final matchCat =
          _selectedCategory == 'All' || b.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          b.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.shortDesc.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blogs = filteredBlogs;

    return Scaffold(
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

            // ── Title banner ─────────────────────────────────────────
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
                    '${allBlogs.length} articles on weddings, venues & more',
                    style: TextStyle(
                      color: primary.withOpacity(0.7),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Search bar ───────────────────────────────────────────
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
                    borderSide: BorderSide(color: primary.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: primary, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        BorderSide(color: primary.withOpacity(0.25)),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ── Category chips ───────────────────────────────────────
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
                  final color = cat == 'All' ? primary : categoryColor(cat);
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? color : color.withOpacity(0.08),
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

            // ── Featured blog (first in list) ────────────────────────
            if (blogs.isNotEmpty) ...[
              _FeaturedBlogCard(blog: blogs.first),
              const SizedBox(height: 16),
            ],

            // ── Results count ────────────────────────────────────────
            if (blogs.length > 1)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  blogs.length > 1
                      ? 'More Articles (${blogs.length - 1})'
                      : '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            // ── Blog list ────────────────────────────────────────────
            if (blogs.isEmpty)
              Padding(
                padding: const EdgeInsets.all(40),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off,
                          size: 60, color: Colors.grey.shade300),
                      const SizedBox(height: 12),
                      const Text(
                        'No blogs found',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                // skip first (shown as featured)
                itemCount: blogs.length > 1 ? blogs.length - 1 : 0,
                itemBuilder: (context, index) {
                  return _BlogListCard(blog: blogs[index + 1]);
                },
              ),

            const SizedBox(height: 20),
            const AppFooter(),
          ],
        ),
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
              child: Image.asset(
                blog.image,
                width: 88,
                height: 100,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
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

  static const Color primary = Color(0xffB4245D);

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
                onTap: () => setState(() => _isBookmarked = !_isBookmarked),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.35),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
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
                  Image.asset(
                    blog.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: color.withOpacity(0.2)),
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

                  // Full article content
                  Text(
                    blog.fullContent.trim(),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.8,
                    ),
                  ),

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

                  // ── Related blogs ──────────────────────────────────
                  const Text(
                    'Related Articles',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  ...allBlogs
                      .where((b) =>
                          b.id != blog.id && b.category == blog.category)
                      .take(2)
                      .map((related) => _BlogListCard(blog: related)),

                  // If no same-category, show any 2
                  if (allBlogs
                          .where((b) =>
                              b.id != blog.id &&
                              b.category == blog.category)
                          .isEmpty)
                    ...allBlogs
                        .where((b) => b.id != blog.id)
                        .take(2)
                        .map((related) => _BlogListCard(blog: related)),

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
