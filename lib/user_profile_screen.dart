import 'package:bodmas_wealth/auth/auth_service.dart';
import 'package:bodmas_wealth/property/property_browse_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'add_property_screen.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .doc(uid)
            .snapshots(),
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

                /// USER INFO
                Text("Name: ${user["name"]}"),
                Text("Email: ${user["email"]}"),
                Text("Mobile: ${user["mobile"]}"),

                const SizedBox(height: 16),

                /// DEALER BUTTON
                if (userType == "dealer")
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text("Add Property"),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddPropertyScreen(),
                        ),
                      );
                    },
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

                const SizedBox(height: 30),

                /// DEALER PROPERTIES
                if (userType == "dealer") ...[
                  const Text("My Properties",
                      style:
                      TextStyle(fontSize: 18,
                          fontWeight: FontWeight.bold)),
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("properties")
                        .where("postedById", isEqualTo: uid)
                        .snapshots(),
                    builder: (context, snap) {
                      if (!snap.hasData) {
                        return const CircularProgressIndicator();
                      }
                      if (snap.data!.docs.isEmpty) {
                        return const Text("No properties added");
                      }

                      return Column(
                        children: snap.data!.docs
                            .map((doc) =>
                            PropertyBrowseCard(data: doc))
                            .toList(),
                      );
                    },
                  ),
                ],

                const SizedBox(height: 30),

                /// WISHLIST
                const Text("My Wishlist",
                    style:
                    TextStyle(fontSize: 18,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("users")
                      .doc(uid)
                      .collection("wishlist")
                      .snapshots(),
                  builder: (context, favSnap) {
                    if (!favSnap.hasData) {
                      return const CircularProgressIndicator();
                    }

                    if (favSnap.data!.docs.isEmpty) {
                      return const Text("No favourite properties");
                    }

                    return Column(
                      children: favSnap.data!.docs.map((fav) {
                        return StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection("properties")
                              .doc(fav.id)
                              .snapshots(),
                          builder: (context, propSnap) {
                            if (!propSnap.hasData) {
                              return const SizedBox();
                            }
                            return PropertyBrowseCard(
                              data: propSnap.data!
                            );
                          },
                        );
                      }).toList(),
                    );
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
