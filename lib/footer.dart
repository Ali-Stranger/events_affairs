import 'package:flutter/material.dart';

import 'app_localizations.dart';
import 'blogs.dart';
import 'contactus.dart';
import 'eventplanner.dart';
import 'venues.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      color: const Color(0xffB4245D),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
            t.translate('eventsAffairsTitle'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            t.translate('footerDescription'),
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            t.translate('quickLinks'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          _footerLink(context, t.translate('venues'), const VenuesPage()),
          _footerLink(context, t.translate('vendors'), const Eventplanner()),
          _footerLink(context, t.translate('blogs'), const BlogsPage()),
          _footerLink(context, t.translate('contactUs'), const ContactUs()),

          const SizedBox(height: 20),

          Text(
            t.translate('contact'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 8),

          Text(t.translate('phoneContact'), style: const TextStyle(color: Colors.white70)),
          Text(t.translate('emailContact'), style: const TextStyle(color: Colors.white70)),

          const SizedBox(height: 20),

          const Divider(color: Colors.white38),

          const SizedBox(height: 10),

          Center(
            child: Text(
              t.translate('footerCopyright'),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _footerLink(BuildContext context, String label, Widget page) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Text(
          '• $label',
          style: const TextStyle(color: Colors.white70, decoration: TextDecoration.underline),
        ),
      ),
    );
  }
        
      
    
  }
