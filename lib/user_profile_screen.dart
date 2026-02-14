import 'package:bodmas_wealth/auth/auth_service.dart';
import 'package:bodmas_wealth/core/colors.dart';
import 'package:bodmas_wealth/property/widgets/property_browse_card.dart';
import 'package:bodmas_wealth/property_management/add_property_screen.dart';
import 'package:bodmas_wealth/property_management/widgets/property_form_widgets.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool showWishlist = false;
  bool showMyProperties = false;
  bool showInterestedUsers = false;
  bool showEnquiries = false;

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> deleteProperty(BuildContext screenContext, DocumentSnapshot doc) async {
    final confirm = await showDialog<bool>(
      context: screenContext,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Delete Property"),
        content: const Text("Are you sure you want to delete this property?"),
        actions: [

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(false),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF9144FF),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
              ),

              const SizedBox(width: 5),
              Expanded(
                child: SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(dialogContext).pop(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9144FF),
                      foregroundColor: const Color(0xFFDDDDDD),
                    ),
                    child: const Text("Delete"),
                  ),
                ),
              ),
            ],
          ),


        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance.collection("properties").doc(doc.id).delete();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Property deleted successfully")),
    );
  }

  // ===== Complete Profile Dialog =====
  void showCompleteProfileDialog(
      BuildContext context, {
        required bool needsMobile,
        required bool needsType,
      }) {
    final mobileCtrl = TextEditingController();
    String? selectedType;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF1D1D20),
          title: const Text("Update Profile",
              style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFFFFF)),),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (needsMobile)
                darkTextField("Mobile", mobileCtrl,
                  keyboard: TextInputType.phone,
                  validator: (v) {
                    if (v == null || v.isEmpty) return "Required";
                    if (v.length < 10) return "Invalid mobile";
                    return null;
                  },
                ),

              if (needsType) ...[
                const SizedBox(height: 10),

                DropdownButtonFormField<String>(
                  hint: const Text(
                    "Select User Type",
                    style: TextStyle(color: Colors.white70), // hint text color
                  ),
                  dropdownColor: Colors.grey[850], // dropdown menu background
                  style: const TextStyle(color: Colors.white), // selected item text color
                  iconEnabledColor: Colors.white, // dropdown arrow color
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900], // field background
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFB974FF)),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: "buyer", child: Text("Buyer")),
                    DropdownMenuItem(value: "dealer", child: Text("Dealer")),
                    DropdownMenuItem(value: "owner", child: Text("Owner")),
                  ],
                  onChanged: (v) => selectedType = v,
                ),


              ]
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF9144FF),
                      ),
                      child: const Text("Cancel"),
                    ),
                  ),
                ),

                const SizedBox(width: 5),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () async {
                        final updateData = <String, dynamic>{};

                        if (needsMobile && mobileCtrl.text.isNotEmpty) {
                          updateData["mobile"] = mobileCtrl.text.trim();
                        }
                        if (needsType && selectedType != null) {
                          updateData["userType"] = selectedType;
                        }

                        if (updateData.isNotEmpty) {
                          await FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .update(updateData);
                        }
                        if (!context.mounted) return;

                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF9144FF),
                        foregroundColor: const Color(0xFFDDDDDD),
                      ),
                      child: const Text("Save"),
                    ),
                  ),
                ),
              ],
            ),


          ],
        );
      },
    );
  }Widget completeProfileSection(DocumentSnapshot userDoc) {
    final data = userDoc.data() as Map<String, dynamic>? ?? {};

    final String? mobile = data["mobile"] as String?;
    final String? userType = data["userType"] as String?;

    final bool needsMobile = mobile == null || mobile.trim().isEmpty;
    final bool needsType = userType == null || userType.trim().isEmpty;

    if (!needsMobile && !needsType) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF353535),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Complete your profile",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                showCompleteProfileDialog(
                  context,
                  needsMobile: needsMobile,
                  needsType: needsType,
                );
              },
              child: const Text("Update Details"),
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final user = snapshot.data!;
          final data = user.data() as Map<String, dynamic>? ?? {};

          final userType = (data["userType"] ?? "").toString();
          final mobile = (data["mobile"] ?? "").toString();


          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== PROFILE HEADER =====
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                              Text(mobile, style: const TextStyle(color: Colors.grey)),
                              Text(user["userType"], style: const TextStyle(color: Colors.grey)),
                              const SizedBox(height: 2),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===== Complete Profile Section (Correct Placement) =====
                completeProfileSection(user),

                const SizedBox(height: 16),

                // ===== ADD PROPERTY =====
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
                        backgroundColor: const Color(0xFF9144FF),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),

                const SizedBox(height: 16),

                // ===== LOGOUT =====
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
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text("Log Out"),
                  ),
                ),

                const SizedBox(height: 10),
                /// COLLAPSIBLE "MY PROPERTIES" SECTION
                if (userType == "dealer" || userType == "owner")
                  expandableSection(
                    title: "My Properties",
                    isExpanded: showMyProperties,
                    onToggle: () {
                      setState(() {
                        showMyProperties = !showMyProperties;
                      });
                    },
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("properties")
                          .where("postedById", isEqualTo: uid)
                          .snapshots(),
                      builder: (context, snap) {

                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          );
                        }

                        // ✅ If empty → small message only
                        if (!snap.hasData || snap.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "No properties added yet",
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        // ✅ If data exists → fixed height + scrollbar
                        return SizedBox(
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
                  ),



                /// COLLAPSIBLE "MY WISHLIST" SECTION
                if (userType == "buyer" || userType == "owner")
                  expandableSection(
                    title: "My Wishlist",
                    isExpanded: showWishlist,
                    onToggle: () {
                      setState(() {
                        showWishlist = !showWishlist;
                      });
                    },
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .collection("wishlist")
                          .snapshots(),
                      builder: (context, favSnap) {

                        if (favSnap.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          );
                        }

                        // data empty → small message
                        if (!favSnap.hasData || favSnap.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "No favourite properties yet",
                              style: TextStyle(color: Colors.white70),
                            ),

                          );
                        }

                        // fixed height container + scrollbar
                        return SizedBox(
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

                                  return StreamBuilder<DocumentSnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection("properties")
                                        .doc(fav.id)
                                        .snapshots(),
                                    builder: (context, propSnap) {

                                      if (!propSnap.hasData || !propSnap.data!.exists) {
                                        return const SizedBox();
                                      }

                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: PropertyBrowseCard(
                                          data: propSnap.data!,
                                        ),
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
                  ),

                /// COLLAPSIBLE "Interested Users" SECTION
                if (userType == "dealer" || userType == "owner")
                  expandableSection(
                    title: "Interested Users",
                    isExpanded: showInterestedUsers,
                    onToggle: () {
                      setState(() {
                        showInterestedUsers = !showInterestedUsers;
                      });
                    },
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .collection("interestedProperties")
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(12),
                            child: CircularProgressIndicator(),
                          );
                        }

                        // ✅ If empty → small message only
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Text(
                              "No interested users yet",
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        // ✅ If data exists → fixed height container + scrollbar
                        return SizedBox(
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
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final d = snapshot.data!.docs[index].data() as Map<String, dynamic>;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF353535),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          d["buyerName"] ?? "",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 4),

                                        Text(
                                          d["propertyTitle"] ?? "",
                                          style: const TextStyle(color: Color(0xFFD9D9D9)),
                                        ),
                                        const SizedBox(height: 4),

                                        Text(
                                          d["buyerEmail"] ?? "",
                                          style: const TextStyle(color: Color(0xFF99A1AF)),
                                        ),

                                        Text(
                                          d["buyerMobile"] ?? "",
                                          style: const TextStyle(color: Color(0xFF99A1AF)),
                                        ),

                                        const SizedBox(height: 4),

                                        Text(
                                          d["createdAt"] != null
                                              ? DateFormat('dd-MM-yyyy HH:mm').format(
                                            (d["createdAt"] as Timestamp)
                                                .toDate()
                                                .toLocal(),
                                          )
                                              : "",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF99A1AF),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),


                if (userType == "dealer" || userType == "owner")
                  expandableSection(
                    title: "Property Enquiries",
                    isExpanded: showEnquiries,
                    onToggle: () {
                      setState(() {
                        showEnquiries = !showEnquiries;
                      });
                    },
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("users")
                          .doc(uid)
                          .collection("enquiries")
                          .orderBy("createdAt", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {

                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(8),
                            child: CircularProgressIndicator(),
                          );
                        }

                        // ✅ If empty → small message only
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              "No enquiries yet",
                              style: TextStyle(color: Colors.white70),
                            ),
                          );
                        }

                        // ✅ If data exists → fixed height scrollable container
                        return SizedBox(
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
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final d = snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>;

                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF353535),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Color(0x33000000),
                                          blurRadius: 6,
                                          offset: Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [

                                        /// 🔹 Buyer Name
                                        Text(
                                          d["name"] ?? "",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),

                                        const SizedBox(height: 6),

                                        /// 🔹 Contact Info
                                        Row(
                                          children: [
                                            const Icon(Icons.phone,
                                                size: 16, color: Color(0xFFA684FF)),
                                            const SizedBox(width: 6),
                                            Text(
                                              d["mobile"] ?? "",
                                              style: const TextStyle(
                                                  color: Color(0xFFDDDDDD)),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 4),

                                        Row(
                                          children: [
                                            const Icon(Icons.email,
                                                size: 16, color: Color(0xFFA684FF)),
                                            const SizedBox(width: 6),
                                            Text(
                                              d["email"] ?? "",
                                              style: const TextStyle(
                                                  color: Color(0xFFDDDDDD)),
                                            ),
                                          ],
                                        ),

                                        const Divider(height: 15, color: Color(0xFF555555)),

                                        /// 🔹 Property Info
                                        Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Icon(Icons.home_work,
                                                size: 18, color: Color(0xFFA684FF)),
                                            const SizedBox(width: 6),
                                            Expanded(
                                              child: Text(
                                                "Enquired for: ${d["propertyTitle"] ?? ""}\n"
                                                    "${d["propertyAddress"] ?? ""}",
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        const SizedBox(height: 8),

                                        /// 🔹 Message
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1D1D20),
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            d["message"]?.toString().isNotEmpty == true
                                                ? d["message"]
                                                : "Buyer enquired for this property.",
                                            style: const TextStyle(
                                              color: Color(0xFFDDDDDD),
                                              fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 8),

                                        /// 🔹 Time
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Text(
                                            d["createdAt"] != null
                                                ? DateFormat('dd-MM-yyyy HH:mm').format(
                                              (d["createdAt"] as Timestamp)
                                                  .toDate()
                                                  .toLocal(),
                                            )
                                                : "",
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF99A1AF),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),




              ],
            ),
          );
        },
      ),
    );
  }
}

// ===== Reusable Expandable Section =====
Widget expandableSection({
  required String title,
  required bool isExpanded,
  required VoidCallback onToggle,
  required Widget child,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: onToggle,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF9144FF),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Icon(
                isExpanded ? Icons.expand_less : Icons.expand_more,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
      const SizedBox(height: 10),
      AnimatedCrossFade(
        duration: const Duration(milliseconds: 250),
        crossFadeState: isExpanded
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: child,
        secondChild: const SizedBox.shrink(),
      ),
    ],
  );
}
