import 'package:bodmas_wealth/core/colors.dart';
import 'package:flutter/material.dart';

class BlogArticlesScreen extends StatelessWidget {
  const BlogArticlesScreen({super.key});

  final String headerImage =
      'https://www.bodmaswealth.com/assets/BlogArticles-Banner-WIChljdQ.jpg'; // image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text("Blog & Articles"),

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image with overlay text
            Stack(
              children: [
                SizedBox(
                  height: 220,
                  width: double.infinity,
                  child: Image.network(
                    headerImage,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.darken,
                    color: Colors.black.withAlpha(20), // 128 is ~50% opacity
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Blog & Articles',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          shadows: [
                            Shadow(
                              blurRadius: 6,
                              color: Colors.black54,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            'Home',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white70,
                            size: 18,
                          ),
                          Text(
                            'Blog & Articles',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Section header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Text(
                    'INSIGHTS & UPDATES',
                    style: TextStyle(
                      color: Color(0xFFB974FF),
                      letterSpacing: 2,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Latest ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                      ),
                      children: [
                        TextSpan(
                          text: 'Blog & Articles ',
                          style: TextStyle(
                            color: Color(0xFFA684FF),
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Stay informed with our latest insights, market updates, and expert analysis on wealth management and financial planning.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF3B4143),
                      Color(0xFF090210),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// IMAGE SECTION
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: Stack(
                        children: [

                          /// Image
                          Image.network(
                            "https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=400&h=250&fit=crop", //image
                            width: double.infinity,
                            height: 180,
                            fit: BoxFit.cover,
                          ),

                          /// Purple Tag
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF8A63FF),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                "E-commerce",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          /// 5 min read
                          Positioned(
                            bottom: 12,
                            right: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(150),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Text(
                                "5 min read",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// CONTENT SECTION
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [

                          /// Admin + Date
                          Row(
                            children: [
                              Icon(Icons.person,
                                  size: 14, color: Color(0xFFA0A0A0)),
                              SizedBox(width: 6),
                              Text(
                                "admin",
                                style: TextStyle(
                                  color: Color(0xFFA0A0A0),
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(width: 14),
                              Icon(Icons.calendar_today,
                                  size: 14, color: Color(0xFFA0A0A0)),
                              SizedBox(width: 6),
                              Text(
                                "Feb 26, 2025",
                                style: TextStyle(
                                  color: Color(0xFFA0A0A0),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 12),

                          /// Title
                          Text(
                            "5 Best Shopify Bots for Auto Checkout & Sneaker Bots Examples",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                            ),
                          ),

                          SizedBox(height: 10),

                          /// Description
                          Text(
                            "30 Best Bots for Marketers in 2023. Aiovio helps you provide a unified shopping experience...",
                            style: TextStyle(
                              color: Color(0xFFA0A0A0),
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),

                          SizedBox(height: 16),

                          /// Read More
                          Row(
                            children: [
                              Text(
                                "Read More",
                                style: TextStyle(
                                  color: Color(0xFF8A63FF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(width: 6),
                              Icon(
                                Icons.arrow_forward,
                                size: 16,
                                color: Color(0xFF8A63FF),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
    );
  }

  Widget featureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            Icons.check_circle,
            color: Colors.greenAccent,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}