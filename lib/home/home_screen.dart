import 'package:bodmas_wealth/auth/auth_service.dart';
import 'package:bodmas_wealth/home/widgets/property_list.dart';
import 'package:bodmas_wealth/home/widgets/property_search.dart';
import 'package:bodmas_wealth/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

import '../core/colors.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Query? _query;
  int? _budget;
  String? _type;
  bool _showResult = false;

  void onSearch(Query q, int budget, String? type) {
    setState(() {
      _query = q;
      _budget = budget;
      _type = type;
      _showResult = true;
    });
  }



  final String phoneNumber = '+919170051973';
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
        padding: const EdgeInsets.fromLTRB(20,2,20,0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [





              const SizedBox(height: 10),
              // IMAGE
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  "assets/images/home_image.jpg", // replace if needed
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 16),

              // TITLE
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

              // SUBTITLE
              const Text(
                "Apply for an Online Personal Loan at low interest rates and get instant approval.",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 16),

              // FEATURES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF5AF2FF), size: 18),
                      SizedBox(width: 6),
                      Text("Quick Process", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFF3DFFB7), size: 18),
                      SizedBox(width: 6),
                      Text("No Hidden Fees", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.check_circle, color: Color(0xFFB97CFF), size: 18),
                      SizedBox(width: 6),
                      Text("Flexible Terms", style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ],
              ),




              const SizedBox(height: 18),

              // CONTACT BUTTON
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

              // STATS
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

              const SizedBox(height: 30),


              // logo here with gradient and container
              Container(
                width: 150,
                // height: 64,
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

              PropertySearch(onSearch: onSearch),
              // 📦 SEARCH RESULT SECTION
              if (_showResult && _query != null && _budget != null)
                Container(
                  height: MediaQuery.of(context).size.height * 0.45, // 👈 fixed height
                  margin: const EdgeInsets.only(top: 8),
                  decoration: BoxDecoration(
                    color: Color(0x08ffffff),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(10),
                      bottom: Radius.circular(10),

                    ),
                  ),
                  child: PropertyList(query: _query!,     // 🔥 yahin se aata hai
                    budget: _budget!,   // 🔥 yahin se aata hai
                    type: _type,   ),
                ),




              const SizedBox(height: 30),

              SizedBox(
                width: 200, // Sets the width
                height: 50, //
                child: ElevatedButton(
                  onPressed: () async{

                    await AuthService().logout();



                    //Navigator.pushNamed(context, AppRoutes.home);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Log Out Successfully")),
                    );
                  },

                  style: ElevatedButton.styleFrom(
                    // Set the background color of the button
                    backgroundColor: Color(0xFF9144FF),

                    // Set the text color (foreground color)
                    foregroundColor: Color(0xFFDDDDDD),
                    textStyle: TextStyle(
                      fontSize: 15.0, //  font size here
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("Log Out"),
                ),
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity, // Sets the width
                height: 50, // Optional: specify a fixed height
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MainScreen()),
                    );

                  },
                  style: ElevatedButton.styleFrom(
                    // Set the background color of the button
                    backgroundColor: Color(0xFFFFFFFF),

                    // Set the text color (foreground color)
                    foregroundColor: Color(0xFF9144FF),
                    textStyle: TextStyle(
                      fontSize: 15.0, //  font size here
                      fontWeight: FontWeight.w500,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text("main"),
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
