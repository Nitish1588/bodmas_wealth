import 'package:bodmas_wealth/home/widgets/LatestListingsWidget.dart';
import 'package:bodmas_wealth/home/widgets/property_list.dart';
import 'package:bodmas_wealth/home/widgets/property_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../core/colors.dart';

/// HomeScreen displays the main content of the app, including:
/// - Banner image and title
/// - Features and stats
/// - Contact button
/// - Latest property listings
/// - Property search with results
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Query? _query;       // Stores Firestore query for search results
  int? _budget;        // Stores budget from search
  String? _type;       // Stores property type from search (BHK/RK)
  bool _showResult = false; // Toggle to show/hide search results

  /// Callback passed to PropertySearch widget
  /// Updates query, budget, type and shows result section
  void onSearch(Query q, int budget, String? type) {
    setState(() {
      _query = q;
      _budget = budget;
      _type = type;
      _showResult = true;
    });
  }

  /// Firestore query to fetch latest 5 properties
  final latestPropertiesQuery = FirebaseFirestore.instance
      .collection('properties')
      .orderBy('createdAt', descending: true)
      .limit(5);

  /// Customer support phone number
  final String phoneNumber = '+919170051973';

  /// Launch phone dialer with pre-filled number
  void _callNumber() async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await url_launcher.canLaunchUrl(launchUri)) {
      await url_launcher.launchUrl(launchUri);
    } else {
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text("Home")),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(15, 2, 15, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10),

              /// Banner Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/home_image.jpg",
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              /// Title with gradient colors for emphasis
              RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    const TextSpan(
                      text: "Affordable Interest, ",
                      style: TextStyle(color: Color(0xFF3DFFB7)),
                    ),
                    const TextSpan(
                      text: "Simplified Procedures, ",
                      style: TextStyle(color: Colors.white),
                    ),
                    const TextSpan(
                      text: "Instant Approval",
                      style: TextStyle(color: Color(0xFFB97CFF)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              /// Subtitle / description
              const Text(
                "Apply for an Online Personal Loan at low interest rates and get instant approval.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 16),

              /// Features Row (Quick Process, No Hidden Fees, Flexible Terms)
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: const [
              //     Row(
              //       children: [
              //         Icon(Icons.check_circle, color: Color(0xFF5AF2FF), size: 18),
              //         SizedBox(width: 6),
              //         Text("Quick Process", style: TextStyle(color: Colors.white70)),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         Icon(Icons.check_circle, color: Color(0xFF3DFFB7), size: 18),
              //         SizedBox(width: 6),
              //         Text("No Hidden Fees", style: TextStyle(color: Colors.white70)),
              //       ],
              //     ),
              //     Row(
              //       children: [
              //         Icon(Icons.check_circle, color: Color(0xFFB97CFF), size: 18),
              //         SizedBox(width: 6),
              //         Text("Flexible Terms", style: TextStyle(color: Colors.white70)),
              //       ],
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF5AF2FF), size: 18),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            "Quick Process",
                            style: TextStyle(color: Colors.white70),
                            overflow: TextOverflow.ellipsis, // prevents overflow
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFF3DFFB7), size: 18),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            "No Hidden Fees",
                            style: TextStyle(color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.check_circle, color: Color(0xFFB97CFF), size: 18),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            "Flexible Terms",
                            style: TextStyle(color: Colors.white70),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              /// Contact Us Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _callNumber,
                  icon: const Icon(Icons.call),
                  label: const Text("Contact Us"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9144FF),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              /// Stats Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Column(
                    children: [
                      Text("₹50L+",
                          style: TextStyle(
                              color: Color(0xFF3DFFB7),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Loans Approved",
                          style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("24hrs",
                          style: TextStyle(
                              color: Color(0xFF5AF2FF),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Quick Approval",
                          style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("8.5%",
                          style: TextStyle(
                              color: Color(0xFFB97CFF),
                              fontSize: 20,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text("Starting Rate",
                          style: TextStyle(color: Colors.white54, fontSize: 12)),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Section Title: Latest Listings
              const Text(
                "Latest Listings",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              const SizedBox(height: 5),

              /// Latest Listings Widget (scrollable)
              Container(
                height: MediaQuery.of(context).size.height * 0.45, // fixed height
                decoration: BoxDecoration(
                  color: Color(0x01FFFFFF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: RawScrollbar(
                  thumbColor: Color(0xFF9144FF), // Purple color for thumb
                  radius: Radius.circular(10),
                  thickness: 4,
                  thumbVisibility: false, // Always show scrollbar
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: LatestListingsWidget(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Logo with gradient background
              Container(
                width: 150,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFB974FF),
                      Color(0xFFFFFFFF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: Image.asset(
                    'assets/images/logo.webp',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Start Your Property Hunt",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.text_2,
                ),
              ),
              const SizedBox(height: 15),

              /// Property Search Widget
              PropertySearch(onSearch: onSearch),

              /// Search Result Section
              if (_showResult && _query != null && _budget != null)
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Color(0x08ffffff),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(10),
                    ),
                  ),
                  child: RawScrollbar(
                    thumbColor: Color(0xFFB974FF), // Another theme color
                    radius: Radius.circular(10),
                    thickness: 4,
                    thumbVisibility: false,
                    child: PropertyList(
                      query: _query!,
                      budget: _budget!,
                      type: _type,
                    ),
                  ),
                ),

              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}
