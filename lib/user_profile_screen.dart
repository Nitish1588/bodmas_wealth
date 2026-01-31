import 'package:bodmas_wealth/auth/auth_service.dart';
import 'package:bodmas_wealth/core/colors.dart';
import 'package:bodmas_wealth/property/widgets/property_browse_card.dart';
import 'package:bodmas_wealth/property_management/add_property_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Screen to display the user's profile, their properties, wishlist, and logout functionality
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {

  // Toggles for showing/hiding user's properties and wishlist
  bool showMyProperties = false;
  bool showWishlist = false;

  /// Deletes a property from Firestore after user confirmation
  Future<void> deleteProperty(
      BuildContext screenContext,
      DocumentSnapshot doc,
      ) async {
    // Show a confirmation dialog before deleting
    final confirm = await showDialog<bool>(
      context: screenContext,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Property"),
        content: const Text("Are you sure you want to delete this property?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return; // Do nothing if user cancels

    // Delete the property document from Firestore
    await FirebaseFirestore.instance
        .collection("properties")
        .doc(doc.id)
        .delete();

    if (!mounted) return;

    // Show a snackbar to indicate successful deletion
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Property deleted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid; // Current user's UID

    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("Profile"),
        // backgroundColor: Color(0xFF9144FF),
      ),

      // StreamBuilder to listen for real-time updates to user document
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            // Show loading spinner while fetching data
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;
          final userType = user["userType"]; // Get user type (dealer, owner, buyer, etc.)

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
                        // User's initial as avatar
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            user["name"].toString().substring(0, 1).toUpperCase(),
                            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // User details: name, email, mobile
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

                /// ADD PROPERTY BUTTON (only for dealers or owners)
                if (userType == "dealer" || userType == "owner")
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
                          borderRadius: BorderRadius.circular(10),
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
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged Out Successfully")),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    child: const Text("Log Out"),
                  ),
                ),

                const SizedBox(height: 15),

                /// COLLAPSIBLE "MY PROPERTIES" SECTION
                if (userType == "dealer" || userType == "owner") ...[
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

                // StreamBuilder to show user's added properties in a scrollable list
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
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFFB974FF),
                            ),
                          ),
                        );
                      }
                      if (snap.data!.docs.isEmpty) {
                        return const Text("No properties added yet");
                      }

                      return SizedBox(
                        height: 300,
                        child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: WidgetStateProperty.all(
                              const Color(0xFF9144FF), // scrollbar color
                            ),
                            thickness: WidgetStateProperty.all(4),
                            radius: const Radius.circular(6),
                          ),
                          child: Scrollbar(
                            thumbVisibility: false,
                            child: ListView.builder(
                              itemCount: snap.data!.docs.length,
                              itemBuilder: (context, index) {
                                return PropertyBrowseCard(
                                  data: snap.data!.docs[index],
                                  showActions: true,
                                  onDelete: (doc) => deleteProperty(context, doc),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                const SizedBox(height: 10),

                /// COLLAPSIBLE "MY WISHLIST" SECTION
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

                // StreamBuilder to show user's wishlist properties
                if (showWishlist)
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("wishlist")
                        .snapshots(),
                    builder: (context, favSnap) {
                      if (!favSnap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (favSnap.data!.docs.isEmpty) {
                        return const Text("No favourite properties yet");
                      }

                      return Container(
                        height: 300,
                        child: ScrollbarTheme(
                          data: ScrollbarThemeData(
                            thumbColor: WidgetStateProperty.all(
                              const Color(0xFF9144FF),
                            ),
                            thickness: WidgetStateProperty.all(4),
                            radius: const Radius.circular(6),
                          ),
                          child: Scrollbar(
                            thumbVisibility: false,
                            child: ListView.builder(
                              itemCount: favSnap.data!.docs.length,
                              itemBuilder: (context, index) {
                                final fav = favSnap.data!.docs[index];

                                // Nested StreamBuilder to get property details for wishlist item
                                return StreamBuilder<DocumentSnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection("properties")
                                      .doc(fav.id)
                                      .snapshots(),
                                  builder: (context, propSnap) {
                                    if (!propSnap.hasData || !propSnap.data!.exists) {
                                      return const SizedBox();
                                    }

                                    return PropertyBrowseCard(
                                      data: propSnap.data!,
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ),
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
