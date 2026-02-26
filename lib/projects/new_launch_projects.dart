import 'package:bodmas_wealth/core/colors.dart';
import 'package:flutter/material.dart';

class NewLaunchProjectsScreen extends StatelessWidget {
  const NewLaunchProjectsScreen({super.key});

  final String headerImage =
      'https://fastly.picsum.photos/id/985/800/600.jpg?hmac=BkifHLvuiFXlBeDDBThQHWLb5Fv5jS5hy1Ni109ziVE'; // image URL

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text("New Launch Projects"),

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
                        'New Launch Projects',
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
                            'New Launch Projects',
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

              /// IMAGE + TOP TAGS + PAGE INDICATOR
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  children: [
                    SizedBox(
                      height: 180,
                      width: double.infinity,
                      child: Image.network(
                        "https://www.shutterstock.com/shutterstock/photos/2085793303/display_1500/stock-photo-kuala-lumpur-malaysia-november-model-apartments-condominiums-at-a-residential-property-2085793303.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),

                    /// Top Tags Row
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Row(
                        children: [
                          _chip("New Launch", Colors.green),
                          const SizedBox(width: 6),
                          _chip("Commercial", Color(0xFF9144FF)),
                          const SizedBox(width: 6),
                          _chip("High Return", Color(0xFFB974FF)),
                        ],
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 18),

              /// TITLE + LOCATION + SHARE ICON
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "The Omaxe State",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 16, color: Color(0xFFB974FF)),
                            SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                "Sector 19B, Dwarka, Delhi, Delhi",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                ],
              ),
            ],
          ),
        ),


        /// --------- SECOND CONTAINER ---------

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Developer + Size Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoTag(
                    icon: Icons.apartment,
                    label: "Developer",
                    value: "Omaxe",
                    color: Colors.blue,
                  ),
                  _infoTag(
                    icon: Icons.square_foot,
                    label: "Size",
                    value: "50-330 sq.ft",
                    color: Colors.green,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// Price + Possession + Available Floors Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoTag(
                    icon: Icons.attach_money,
                    label: "Price",
                    value: "₹37.5L *onwards",
                    color: Colors.amber,
                  ),
                  _infoTag(
                    icon: Icons.calendar_today,
                    label: "Possession",
                    value: "Dec 2026",
                    color: Colors.brown,
                  ),

                ],
              ),

              const SizedBox(height: 18),

              /// Key Amenities Label + Chips
              const Text(
                "Key Amenities",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  _amenityChip("Ample Parking Space"),
                  _amenityChip("24x7 Security"),
                  _amenityChip("High-Speed Elevators"),
                  _amenityChip("+4 more"),
                ],
              ),

              const SizedBox(height: 16),

              /// Nearby Landmarks
              const Text(
                "Nearby Landmarks",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),

              const SizedBox(height: 8),

              Row(
                children: const [
                  Icon(Icons.radio_button_checked,
                      size: 14, color: Color(0xFF9144FF)),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Opp. Dwarka Sec 21 Metro Station",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 6),

              Row(
                children: const [
                  Icon(Icons.radio_button_checked,
                      size: 14, color: Color(0xFF9144FF)),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      "Near IGI Airport",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// BUTTONS ROW
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9144FF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text("View Details",
                          style: TextStyle(color: Color(0xFFFFFFFF))),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {},
                      child: const Text("Call Now",
                          style: TextStyle(color: Color(0xFFFFFFFF))),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),




          ],
        ),
      ),
    );
  }

  /// Helper Widgets

  Widget _chip(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }

  Widget _infoTag({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withAlpha(40),

        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
              Text(value,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.w600,
                      fontSize: 14)),
            ],
          )
        ],
      ),
    );
  }

  Widget _amenityChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Color(0xFF9144FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white70, fontSize: 12),
      ),
    );
  }}