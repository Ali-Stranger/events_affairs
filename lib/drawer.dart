// common_widgets.dart
import 'package:flutter/material.dart';
import 'app_localizations.dart';
import 'blogs.dart';
import 'venues.dart';
import 'contactus.dart';
import 'homePage.dart';
import 'setting.dart';

// =============================================
// ✅ REUSABLE APPBAR
// =============================================
class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Text(
          t.translate('appDescription'),
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      backgroundColor: const Color(0xffB4245D),
      actions: [
        // Padding(
        //   padding: const EdgeInsets.only(top: 16),
        //   child: IconButton(
        //     tooltip: 'Search vendors',
        //     onPressed: () {
        //       Navigator.of(context).push(
        //         MaterialPageRoute<void>(
        //           builder: (_) => const VenuesPage(),
        //         ),
        //       );
        //     },
        //     icon: const Icon(Icons.search, color: Colors.white),
        //   ),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// =============================================
// ✅ REUSABLE DRAWER
// =============================================
class CommonDrawer extends StatefulWidget {
  const CommonDrawer({super.key});

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  bool isRegisterMode = false;

  static const TextStyle headingStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Color(0xffB4245D),
  );

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ===== NORMAL MENU HEADER =====
          SizedBox(
            height: 88,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Color(0xffB4245D)),
              child: Text(
                t.translate('eventsAffairsMenu'),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(t.translate('home'), style: headingStyle),
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const CreateHomePage()),
              (route) => false,
            ),
          ),
          ListTile(
            title: Text(t.translate('venues'), style: headingStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VenuesPage()),
            ),
          ),
          ListTile(
            title: Text(t.translate('blogs'), style: headingStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const BlogsPage()),
            ),
          ),

          ListTile(
            title: Text(t.translate('contactUs'), style: headingStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContactUs()),
            ),
          ),
          ListTile(
            title: Text(t.translate('settings'), style: headingStyle),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SettingsPage()),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================
// ✅ REUSABLE HEADER ROW (Menu + Logo)
// =============================================
class CommonHeader extends StatelessWidget {
  const CommonHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        Image.asset('assets/images/logo.png', width: 90, height: 90),
      ],
    );
  }
}
