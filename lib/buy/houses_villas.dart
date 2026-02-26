import 'package:bodmas_wealth/core/colors.dart';
import 'package:flutter/material.dart';

class HousesVillasScreen extends StatelessWidget {
  const HousesVillasScreen({super.key});

  final String headerImage =
      'https://fastly.picsum.photos/id/128/600/600.jpg?hmac=P7ZKWCHsmg7jDjJlfyGXMmA_e44yWJDqteCoKImMtno'; // image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text("Houses/Villas"),

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
                        'Houses/Villas',
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
                            'Houses/Villas',
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

            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// IMAGE
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          child: Image.network(
                            "https://www.shutterstock.com/shutterstock/photos/1018259074/display_1500/stock-photo-front-elevation-facade-of-a-new-modern-australian-style-home-1018259074.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),

                        /// Top Tags
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Row(
                            children: [
                              _chip("Villa", Colors.deepPurple),
                              const SizedBox(width: 6),
                              _chip("NEW", Colors.orange),
                              const SizedBox(width: 6),
                              _chip("Ready to Move", Colors.green),
                            ],
                          ),
                        ),

                        /// Verified
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.check, size: 14, color: Colors.white),
                                SizedBox(width: 4),
                                Text(
                                  "Verified",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// TITLE
                  const Text(
                    "4 BHK Premium Villa in Vasant Kunj",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  /// LOCATION
                  const Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16, color: Color(0xFFB974FF)),
                      SizedBox(width: 6),
                      Text(
                        "Vasant Kunj, Delhi",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// OWNER
                  const Text(
                    "Owner: Jeet Kumar",
                    style: TextStyle(color: Colors.white70),
                  ),

                  const SizedBox(height: 14),

                  /// FEATURE BOX
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A1A),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Column(
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text("4 BHK",
                                style: TextStyle(color: Colors.white70)),
                            Text("3 Bathrooms",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text("950 sq.ft",
                                style: TextStyle(color: Colors.white70)),
                            Text("Available",
                                style: TextStyle(color: Colors.white70)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// PRICE
                  const Text(
                    "₹1.8 Cr",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// BUTTONS
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("Contact Agent",
                          style: TextStyle(color: Color(0xFFFFFFFF))),
                    ),
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9144FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text("View Details",
                          style: TextStyle(color: Color(0xFFFFFFFF))),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  /// simple chip
  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(
            color: Colors.white, fontSize: 10),
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