import 'package:bodmas_wealth/auth/auth_service.dart';
import 'package:bodmas_wealth/core/colors.dart';
import 'package:bodmas_wealth/property/property_browse_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_property_screen.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool showMyProperties = false; // toggle for showing properties
  bool showWishlist = false;     // toggle for Wishlist

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("Profile"),
       // backgroundColor: Color(0xFF9144FF),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;
          final userType = user["userType"];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// PROFILE HEADER
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: Colors.white,
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            user["name"].toString().substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user["name"], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Text(user["email"], style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 2),
                              Text(user["mobile"], style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// DEALER BUTTON
                if (userType == "dealer")
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text("Add Property"),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AddPropertyScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF9144FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                /// LOG OUT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService().logout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged Out Successfully")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    child: const Text("Log Out"),
                  ),
                ),

                const SizedBox(height: 20),

                if (userType == "dealer") ...[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        showMyProperties = !showMyProperties;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Color(0xFF9144FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "My Properties",
                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Icon(
                            showMyProperties ? Icons.expand_less : Icons.expand_more,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Expandable list
                if (showMyProperties)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("properties")
                        .where("postedById", isEqualTo: uid)
                        .snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            // Use valueColor for the indicator's color
                            valueColor: AlwaysStoppedAnimation<Color>(Color(
                                0xFFB974FF)),
                          ),
                        );
                      }

                      if (snap.data!.docs.isEmpty) return const Text("No properties added yet");

                      return Container(
                        height: 300, // adjust as needed
                        child: ListView.builder(
                          itemCount: snap.data!.docs.length,
                          itemBuilder: (context, index) => PropertyBrowseCard(data: snap.data!.docs[index]),
                        ),
                      );
                    },
                  ),


                const SizedBox(height: 15),

                // My Wishlist
                GestureDetector(
                  onTap: () => setState(() => showWishlist = !showWishlist),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9144FF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "My Wishlist",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        Icon(
                          showWishlist ? Icons.expand_less : Icons.expand_more,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (showWishlist)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("wishlist")
                        .snapshots(),
                    builder: (context, favSnap) {
                      if (!favSnap.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 4.0, // Thicker loader
                            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFB974FF)), // Custom color
                          ),
                        );
                      }
                      if (favSnap.data!.docs.isEmpty) return const Text("No favourite properties yet");

                      return Container(
                        height: 300,
                        child: ListView.builder(
                          itemCount: favSnap.data!.docs.length,
                          itemBuilder: (context, index) {
                            final fav = favSnap.data!.docs[index];
                            return StreamBuilder<DocumentSnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("properties")
                                  .doc(fav.id)
                                  .snapshots(),
                              builder: (context, propSnap) {
                                if (!propSnap.hasData) return const SizedBox();
                                return PropertyBrowseCard(data: propSnap.data!);
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),


                const SizedBox(height: 30),

                /// DEALER PROPERTIES
                if (userType == "dealer") ...[
                  const Text("My Properties", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("properties")
                        .where("postedById", isEqualTo: uid)
                        .snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData) return const CircularProgressIndicator();
                      if (snap.data!.docs.isEmpty) return const Text("No properties added yet");

                      return Column(
                        children: snap.data!.docs.map((doc) => PropertyBrowseCard(data: doc)).toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                ],

                /// WISHLIST
                const Text("My Wishlist", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .collection("wishlist")
                      .snapshots(),
                  builder: (context, favSnap) {
                    if (!favSnap.hasData) return const CircularProgressIndicator();
                    if (favSnap.data!.docs.isEmpty) return const Text("No favourite properties yet");

                    return Column(
                      children: favSnap.data!.docs.map((fav) {
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("properties")
                              .doc(fav.id)
                              .snapshots(),
                          builder: (context, propSnap) {
                            if (!propSnap.hasData) return const SizedBox();
                            return PropertyBrowseCard(data: propSnap.data!);
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
