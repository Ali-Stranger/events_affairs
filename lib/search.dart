import 'package:flutter/material.dart';
import 'eventplanner.dart';
import 'blogs.dart';
import 'venues.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<String> data = [
    "Event Planners",
    "Florist",
    "Decoration",
    "Banquet Halls",
    "Marque",
    "Farm House",
    "Photographers",
    "Venues",
    "Blogs",
  ];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = "";
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = data
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: results.map((item) {
        return ListTile(
          title: Text(item),
          onTap: () {
            // 🔥 NAVIGATION
            if (item == "Event Planners") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => Eventplanner()),
              );
            } else if (item == "Blogs") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => BlogsPage()),
              );
            } else if (item == "Venues") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => VenuesPage()),
              );
            }
          },
        );
      }).toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = data
        .where((item) => item.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: suggestions.map((item) {
        return ListTile(
          title: Text(item),
          onTap: () {
            query = item;
            showResults(context);
          },
        );
      }).toList(),
    );
  }
}
