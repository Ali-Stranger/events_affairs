import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'drawer.dart';

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  // late final WebViewController _mapController;

  // // FCCU coordinates
  // static const double _fcculat = 31.5204;
  // static const double _fccuLng = 74.3287;

  static const Color primary = Color(0xffB4245D);

  // @override
  // void initState() {
  //   super.initState();
  //   _mapController = WebViewController()
  //     ..setJavaScriptMode(JavaScriptMode.unrestricted)
  //     ..loadRequest(Uri.parse(
  //       'https://maps.google.com/maps'
  //       '?q=$_fcculat,$_fccuLng'
  //       '&z=16'
  //       '&output=embed',
  //     ));
  // }

  // ── Open Google Maps app / browser ──────────────────────────────────────
  Future<void> _openInMaps() async {
  final uri = Uri.parse(
    'https://www.google.com/maps/search/?api=1&query=Forman+Christian+College+Lahore',
  );

  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
}

  // ── Dial phone ──────────────────────────────────────────────────────────
  Future<void> _dial(String number) async {
  final uri = Uri(scheme: 'tel', path: number);

  await launchUrl(uri);
}

  // ── Open email ──────────────────────────────────────────────────────────
 Future<void> _email(String address) async {
  final uri = Uri(scheme: 'mailto', path: address);

  await launchUrl(uri);
}

  // ── Open URL ────────────────────────────────────────────────────────────
  Future<void> _openUrl(String url) async {
  final uri = Uri.parse(url);

  await launchUrl(
    uri,
    mode: LaunchMode.externalApplication,
  );
}

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ─── Header row ───────────────────────────────────────────
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

            // ─── Title banner ─────────────────────────────────────────
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
              child: const Text(
                'Contact Us',
                style: TextStyle(
                  color: primary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ─── Location heading ─────────────────────────────────────
            _sectionHeading('📍  Location'),

            const SizedBox(height: 10),

            // ─── Embedded Google Map ──────────────────────────────────
            // Container(
            //   height: 220,
            //   margin: const EdgeInsets.symmetric(horizontal: 16),
            //   decoration: BoxDecoration(
            //     borderRadius: BorderRadius.circular(14),
            //     border: Border.all(color: primary.withOpacity(0.25), width: 1.5),
            //     boxShadow: [
            //       BoxShadow(
            //         color: Colors.black.withOpacity(0.08),
            //         blurRadius: 8,
            //         offset: const Offset(0, 3),
            //       ),
            //     ],
            //   ),
            //   clipBehavior: Clip.antiAlias,
            //   child: WebViewWidget(controller: _mapController),
            // ),


            GestureDetector(
  onTap: _openInMaps,
  child: Container(
    height: 220,
    margin: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: primary.withOpacity(0.25), width: 1.5),
      image: const DecorationImage(
        image: AssetImage('assets/images/eventplanner.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.black.withOpacity(0.2),
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: 40,
      ),
    ),
  ),
),

            // ─── Address row with "Open in Maps" button ───────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: primary, size: 20),
                  const SizedBox(width: 6),
                  const Expanded(
                    child: Text(
                      'Forman Christian College (A Chartered University)\nFerozepur Road, Lahore, Punjab, Pakistan',
                      style: TextStyle(fontSize: 13, height: 1.5),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _openInMaps,
                    icon: const Icon(Icons.open_in_new, size: 14),
                    label: const Text('Open', style: TextStyle(fontSize: 12)),
                    style: TextButton.styleFrom(foregroundColor: primary),
                  ),
                ],
              ),
            ),

            const Divider(indent: 16, endIndent: 16),
            const SizedBox(height: 8),

            // ─── Contact details ──────────────────────────────────────
            _sectionHeading('📞  Get In Touch'),
            const SizedBox(height: 12),

            _contactTile(
              icon: Icons.phone_outlined,
              label: 'Call Us',
              value: '+92 42 1234 1234',
              onTap: () => _dial('+924212341234'),
            ),
            _contactTile(
              icon: Icons.email_outlined,
              label: 'Email Us',
              value: 'info@eventaffairs.pk',
              onTap: () => _email('info@eventaffairs.pk'),
            ),
            _contactTile(
              icon: Icons.language_outlined,
              label: 'Website',
              value: 'www.eventaffairs.pk',
              onTap: () => _openUrl('https://www.eventaffairs.pk'),
            ),
            _contactTile(
              icon: Icons.access_time_outlined,
              label: 'Working Hours',
              value: 'Mon – Sat: 9 AM – 6 PM',
              onTap: null,
            ),

            const Divider(indent: 16, endIndent: 16),
            const SizedBox(height: 8),

            // ─── About ───────────────────────────────────────────────
            _sectionHeading('ℹ️  About'),
            const SizedBox(height: 10),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Eventaffairs.pk is Pakistan\'s #1 Event Planning Portal and Mobile Application '
                'where you can find venues of your choice, the best wedding vendors, and much more '
                'with prices and reviews at the click of a button. Whether you are looking to hire '
                'Event Planners, top Photographers, Caterers or just need inspiration for your '
                'events — we have you covered.',
                style: TextStyle(fontSize: 14, height: 1.6),
              ),
            ),

            const SizedBox(height: 24),

            // ─── Social links ─────────────────────────────────────────
            _sectionHeading('🌐  Follow Us'),
            const SizedBox(height: 14),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _socialButton(
                    label: 'Facebook',
                    color: const Color(0xFF1877F2),
                    icon: Icons.facebook,
                    onTap: () => _openUrl('https://facebook.com'),
                  ),
                  const SizedBox(width: 10),
                  _socialButton(
                    label: 'Instagram',
                    color: const Color(0xFFE1306C),
                    icon: Icons.camera_alt_outlined,
                    onTap: () => _openUrl('https://instagram.com'),
                  ),
                  const SizedBox(width: 10),
                  _socialButton(
                    label: 'YouTube',
                    color: const Color(0xFFFF0000),
                    icon: Icons.play_circle_outline,
                    onTap: () => _openUrl('https://youtube.com'),
                  ),
                  const SizedBox(width: 10),
                  _socialButton(
                    label: 'Twitter',
                    color: const Color(0xFF1DA1F2),
                    icon: Icons.tag,
                    onTap: () => _openUrl('https://twitter.com'),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ─── Footer note ──────────────────────────────────────────
            Center(
              child: Text(
                '© 2025 EventAffairs.pk · Made with ❤️ in Pakistan',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────────────────────────────────

  Widget _sectionHeading(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.bold,
          color: primary,
        ),
      ),
    );
  }

  Widget _contactTile({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: primary.withOpacity(0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: primary, size: 20),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
            if (onTap != null) ...[
              const Spacer(),
              const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
            ],
          ],
        ),
      ),
    );
  }

  Widget _socialButton({
    required String label,
    required Color color,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.10),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 4),
              Text(label,
                  style: TextStyle(
                      fontSize: 10,
                      color: color,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
