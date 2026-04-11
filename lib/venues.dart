import 'package:flutter/material.dart';
import 'footer.dart';
import 'eventplanner.dart';
import 'venuecontact.dart';
import 'drawer.dart';

// ═══════════════════════════════════════════════════════════════
//  DATA MODEL
// ═══════════════════════════════════════════════════════════════

class Venue {
  final String name;
  final String location;
  final String price;
  final String image;
  final String category;
  final double rating;
  final int reviews;
  final String capacity;
  final List<String> amenities;
  final String description;

  const Venue({
    required this.name,
    required this.location,
    required this.price,
    required this.image,
    required this.category,
    required this.rating,
    required this.reviews,
    required this.capacity,
    required this.amenities,
    required this.description,
  });
}

// ═══════════════════════════════════════════════════════════════
//  VENUES DATA
// ═══════════════════════════════════════════════════════════════

const List<Venue> allVenues = [
  Venue(
    name: "Royal Palm Banquet",
    location: "Lahore",
    price: "PKR 150,000",
    image: "assets/images/download.jpg",
    category: "Banquet Hall",
    rating: 4.8,
    reviews: 142,
    capacity: "500–1000 guests",
    amenities: ["AC", "Parking", "Catering", "Décor", "Stage"],
    description:
        "Royal Palm Banquet is one of Lahore\'s most prestigious event venues, offering a regal setting for weddings, corporate events, and celebrations. With lush greenery and elegant interiors, it promises an unforgettable experience.",
  ),
  Venue(
    name: "Pearl Continental Hall",
    location: "Karachi",
    price: "PKR 200,000",
    image: "assets/images/download.jpg",
    category: "Hotel Ballroom",
    rating: 4.9,
    reviews: 230,
    capacity: "300–800 guests",
    amenities: ["AC", "Valet", "5-Star Catering", "AV System", "Bridal Suite"],
    description:
        "The Pearl Continental Hall in Karachi sets the gold standard for luxury events. As part of the iconic PC Hotel, it offers world-class service, stunning décor, and unmatched culinary excellence.",
  ),
  Venue(
    name: "Serena Event Lawn",
    location: "Islamabad",
    price: "PKR 180,000",
    image: "assets/images/download.jpg",
    category: "Garden Venue",
    rating: 4.7,
    reviews: 98,
    capacity: "200–600 guests",
    amenities: ["Outdoor", "Parking", "Catering", "Lighting", "Tent Setup"],
    description:
        "Set against the backdrop of the Margalla Hills, Serena Event Lawn offers a breathtaking open-air venue for daytime and evening events. Perfect for garden weddings and intimate gatherings.",
  ),
  Venue(
    name: "Grand Marquee",
    location: "Multan",
    price: "PKR 120,000",
    image: "assets/images/download.jpg",
    category: "Marquee",
    rating: 4.5,
    reviews: 75,
    capacity: "400–900 guests",
    amenities: ["AC", "Parking", "In-House Décor", "Catering", "Generator"],
    description:
        "Grand Marquee is Multan\'s premier event space, offering flexible layouts and comprehensive packages for weddings and social events. Known for exceptional hospitality and value for money.",
  ),
  Venue(
    name: "Faletti's Grand Hall",
    location: "Lahore",
    price: "PKR 250,000",
    image: "assets/images/download.jpg",
    category: "Heritage Venue",
    rating: 4.9,
    reviews: 187,
    capacity: "150–400 guests",
    amenities: ["AC", "Heritage Setting", "Fine Dining", "Valet", "Bridal Room"],
    description:
        "Step into history at Faletti\'s Grand Hall, Lahore\'s most storied event venue. The colonial-era architecture and timeless elegance make every event truly special and memorable.",
  ),
  Venue(
    name: "Avari Towers Ballroom",
    location: "Karachi",
    price: "PKR 220,000",
    image: "assets/images/download.jpg",
    category: "Hotel Ballroom",
    rating: 4.7,
    reviews: 163,
    capacity: "250–700 guests",
    amenities: ["AC", "5-Star Service", "AV System", "Valet", "Catering"],
    description:
        "Avari Towers Ballroom brings world-class sophistication to Karachi\'s event scene. With its modern design and impeccable service, it\'s the top choice for corporate events and luxury weddings.",
  ),
];

// ═══════════════════════════════════════════════════════════════
//  VENUES PAGE
// ═══════════════════════════════════════════════════════════════

class VenuesPage extends StatefulWidget {
  const VenuesPage({super.key});

  @override
  State<VenuesPage> createState() => _VenuesPageState();
}

class _VenuesPageState extends State<VenuesPage> {
  static const Color primary = Color(0xffB4245D);

  String _searchQuery = '';
  String _selectedLocation = 'All';
  String _selectedCategory = 'All';
  final Set<String> _favorites = {};
  final TextEditingController _searchCtrl = TextEditingController();

  final List<String> locations = ['All', 'Lahore', 'Karachi', 'Islamabad', 'Multan'];
  final List<String> categories = ['All', 'Banquet Hall', 'Hotel Ballroom', 'Garden Venue', 'Marquee', 'Heritage Venue'];

  List<Venue> get filteredVenues {
    return allVenues.where((v) {
      final matchLoc = _selectedLocation == 'All' || v.location == _selectedLocation;
      final matchCat = _selectedCategory == 'All' || v.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          v.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          v.location.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchLoc && matchCat && matchSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final venues = filteredVenues;

    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header ─────────────────────────────────────────────
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

            // ── Title banner ────────────────────────────────────────
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(vertical: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: primary.withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  const Text(
                    'Top Trending Venues',
                    style: TextStyle(
                      color: primary,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${allVenues.length} premium venues across Pakistan',
                    style: TextStyle(color: primary.withOpacity(0.7), fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Search ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                decoration: InputDecoration(
                  hintText: 'Search venues by name or city...',
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
                    borderSide: BorderSide(color: primary.withOpacity(0.25)),
                  ),
                  filled: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ── Location filter chips ───────────────────────────────
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: locations.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final loc = locations[i];
                  final isSelected = _selectedLocation == loc;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedLocation = loc),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? primary : primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? primary : primary.withOpacity(0.3),
                        ),
                      ),
                      child: Text(
                        loc,
                        style: TextStyle(
                          color: isSelected ? Colors.white : primary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 8),

            // ── Category filter chips ───────────────────────────────
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final cat = categories[i];
                  final isSelected = _selectedCategory == cat;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedCategory = cat),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.indigo
                            : Colors.indigo.withOpacity(0.07),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? Colors.indigo
                              : Colors.indigo.withOpacity(0.25),
                        ),
                      ),
                      child: Text(
                        cat,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.indigo,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ── Results count ───────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '${venues.length} venue${venues.length == 1 ? '' : 's'} found',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            const SizedBox(height: 8),

            // ── Venue cards ─────────────────────────────────────────
            venues.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(40),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.location_off,
                              size: 60, color: Colors.grey.shade300),
                          const SizedBox(height: 12),
                          const Text('No venues found',
                              style: TextStyle(fontSize: 16, color: Colors.grey)),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: venues.length,
                    itemBuilder: (ctx, i) => _VenueCard(
                      venue: venues[i],
                      isFavorite: _favorites.contains(venues[i].name),
                      onFavoriteToggle: () {
                        setState(() {
                          if (_favorites.contains(venues[i].name)) {
                            _favorites.remove(venues[i].name);
                          } else {
                            _favorites.add(venues[i].name);
                          }
                        });
                      },
                    ),
                  ),

            const SizedBox(height: 16),

            // ── See More button ─────────────────────────────────────
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const Eventplanner()),
                    ),
                    icon: const Icon(Icons.explore_outlined,
                        color: Colors.white, size: 18),
                    label: const Text(
                      'Explore All Vendors',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
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
//  VENUE CARD WIDGET
// ═══════════════════════════════════════════════════════════════

class _VenueCard extends StatelessWidget {
  final Venue venue;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  static const Color primary = Color(0xffB4245D);

  const _VenueCard({
    required this.venue,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VenueContactPage(
            name: venue.name,
            location: venue.location,
            price: venue.price,
            image: venue.image,
            category: venue.category,
            rating: venue.rating,
            reviews: venue.reviews,
            capacity: venue.capacity,
            amenities: venue.amenities,
            description: venue.description,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ── Image with overlays ────────────────────────────
              Stack(
                children: [
                  Image.asset(
                    venue.image,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: primary.withOpacity(0.1),
                      child: const Icon(Icons.image, size: 60, color: Colors.grey),
                    ),
                  ),
                  // Gradient at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 70,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Category badge top-left
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: primary,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        venue.category,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Favorite button top-right
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                  // Rating bottom-left
                  Positioned(
                    bottom: 10,
                    left: 10,
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 3),
                        Text(
                          '${venue.rating} (${venue.reviews} reviews)',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Price bottom-right
                  Positioned(
                    bottom: 8,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        venue.price,
                        style: const TextStyle(
                          color: primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ── Details section ────────────────────────────────
              Container(
                color: Theme.of(context).cardColor,
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Name + location
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            venue.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: primary, size: 14),
                            const SizedBox(width: 2),
                            Text(
                              venue.location,
                              style: const TextStyle(
                                color: primary,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // Capacity
                    Row(
                      children: [
                        Icon(Icons.people_outline,
                            size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          venue.capacity,
                          style: TextStyle(
                              fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    // Amenity chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: venue.amenities.map((a) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: primary.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: primary.withOpacity(0.2)),
                          ),
                          child: Text(
                            a,
                            style: const TextStyle(
                              color: primary,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 12),

                    // Contact button
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => VenueContactPage(
                              name: venue.name,
                              location: venue.location,
                              price: venue.price,
                              image: venue.image,
                              category: venue.category,
                              rating: venue.rating,
                              reviews: venue.reviews,
                              capacity: venue.capacity,
                              amenities: venue.amenities,
                              description: venue.description,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.phone_outlined,
                            color: Colors.white, size: 16),
                        label: const Text(
                          'Contact Venue',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}