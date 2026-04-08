import 'package:flutter/material.dart';

import 'footer.dart';

import 'drawer.dart';
class BlogsPage extends StatefulWidget {
  const BlogsPage({super.key});

  @override
  State<BlogsPage> createState() => _BlogsPageState();
}

class _BlogsPageState extends State<BlogsPage> {
  bool isRegisterMode = false;
  

  final List<Map<String, String>> blogs = [
    {
      "title": "Top Wedding Trends 2026",
      "desc": "Latest wedding decor and planning trends in Pakistan.",
      "image": "assets/images/download.jpg",
    },
    {
      "title": "Best Event Venues",
      "desc": "Find perfect venues for your special events easily.",
      "image": "assets/images/download.jpg",
    },
    {
      "title": "Budget Planning Tips",
      "desc": "Smart ways to plan your event within budget.",
      "image": "assets/images/download.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      // ================= FULL DRAWER =================
      drawer: const CommonDrawer(),
      appBar: const CommonAppBar(),
      // ================= BODY =================
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ================= HEADER =================
            Row(
              children: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 90,
                  height: 90,
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ================= TITLE =================
            Container(
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xffB4245D).withOpacity(0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                "Latest Blogs",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xffB4245D),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ================= BLOG LIST =================
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: blogs.length,
              itemBuilder: (context, index) {
                final blog = blogs[index];

                return Container(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 10),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 6,
                        spreadRadius: 2,
                      )
                    ],
                  ),
                  child: Row(
                    children: [

                      // IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          blog["image"]!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),

                      const SizedBox(width: 10),

                      // TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text(
                              blog["title"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 5),

                            Text(
                              blog["desc"]!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),

                            const SizedBox(height: 8),

                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {},
                                child: const Text(
                                  "Read More",
                                  style: TextStyle(
                                    color: Color(0xffB4245D),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            const AppFooter()
          ],
        ),
      ),
    );
  }
}