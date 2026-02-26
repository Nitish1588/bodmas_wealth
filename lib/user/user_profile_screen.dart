import 'package:bodmas_wealth/auth/auth_service.dart';
import 'package:bodmas_wealth/core/colors.dart';
import 'package:bodmas_wealth/property/widgets/property_browse_card.dart';
import 'package:bodmas_wealth/property_management/add_property_screen.dart';
import 'package:bodmas_wealth/property_management/widgets/property_form_widgets.dart';
import 'package:bodmas_wealth/user/widgets/expandable_section_widget.dart';
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
  }
  Widget completeProfileSection(DocumentSnapshot userDoc) {
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
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Scaffold.of(context).openEndDrawer();
            },
          ),
        ],
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

                if (userType == "dealer" || userType == "owner")
                  StreamBuilder<QuerySnapshot>(
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

                      final isEmpty =
                          !snap.hasData || snap.data!.docs.isEmpty;

                      return ExpandableSectionWidget(
                        title: "My Properties",
                        isEmpty: isEmpty,
                        emptyMessage: "No properties added yet",
                        child: SizedBox(
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
                                onDelete: (doc) =>
                                    deleteProperty(context, doc),
                              );
                            },
                          ),
                        ),
                            ),
                        ),
                      );
                    },
                  ),


                if (userType == "buyer" || userType == "owner")
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("wishlist")
                        .snapshots(),
                    builder: (context, favSnap) {

                      if (favSnap.connectionState ==
                          ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(8),
                          child: CircularProgressIndicator(),
                        );
                      }

                      final isEmpty =
                          !favSnap.hasData || favSnap.data!.docs.isEmpty;

                      return ExpandableSectionWidget(
                        title: "My Wishlist",
                        isEmpty: isEmpty,
                        emptyMessage:
                        "No favourite properties yet",
                        child: SizedBox(
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
                              final fav =
                              favSnap.data!.docs[index];

                              return StreamBuilder<DocumentSnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("properties")
                                    .doc(fav.id)
                                    .snapshots(),
                                builder: (context, propSnap) {

                                  if (!propSnap.hasData ||
                                      !propSnap.data!.exists) {
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
                        ),
                      );
                    },
                  ),

                if (userType == "dealer" || userType == "owner")
                  StreamBuilder<QuerySnapshot>(
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

                      final isEmpty =
                          !snapshot.hasData || snapshot.data!.docs.isEmpty;

                      return ExpandableSectionWidget(
                        title: "Interested Users",
                        isEmpty: isEmpty,
                        emptyMessage: "No interested users yet",
                        child: SizedBox(
                          height: 350,
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
                                  color: const Color(0xFF2A2A2E),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: const Color(0xFF9144FF).withOpacity(.4)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    /// 🔹 Buyer Name + Time
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          d["buyerName"] ?? "",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          d["createdAt"] != null
                                              ? DateFormat('dd MMM, hh:mm a').format(
                                            (d["createdAt"] as Timestamp)
                                                .toDate()
                                                .toLocal(),
                                          )
                                              : "",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    /// 🔹 Property Title
                                    Text(
                                      d["propertyTitle"] ?? "",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFFA684FF),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),

                                    const SizedBox(height: 10),

                                    /// 🔹 Contact Info
                                    Row(
                                      children: [
                                        const Icon(Icons.email,
                                            size: 16, color: Color(0xFFB974FF)),
                                        const SizedBox(width: 6),
                                        Expanded(
                                          child: Text(
                                            d["buyerEmail"] ?? "",
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            size: 16, color: Color(0xFFB974FF)),
                                        const SizedBox(width: 6),
                                        Text(
                                          d["buyerMobile"] ?? "",
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                            ),
                        ),
                            );
                    },
                  ),

                if (userType == "dealer" || userType == "owner")
                  StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("enquiries")
                        .orderBy("createdAt", descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Padding(
                          padding: EdgeInsets.all(12),
                          child: CircularProgressIndicator(),
                        );
                      }

                      final isEmpty =
                          !snapshot.hasData || snapshot.data!.docs.isEmpty;

                      return ExpandableSectionWidget(
                        title: "Property Enquiries",
                        isEmpty: isEmpty,
                        emptyMessage: "No enquiries yet",
                        child: SizedBox(
                          height: 380,
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
                                margin: const EdgeInsets.only(bottom: 16),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF2A2A2E),
                                      Color(0xFF1F1F23),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      color: const Color(0xFF9144FF).withOpacity(.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [

                                    /// 🔹 Header
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          d["name"] ?? "",
                                          style: const TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(
                                          d["createdAt"] != null
                                              ? DateFormat('dd MMM, hh:mm a').format(
                                            (d["createdAt"] as Timestamp)
                                                .toDate()
                                                .toLocal(),
                                          )
                                              : "",
                                          style: const TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF9CA3AF),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 12),

                                    /// 🔹 Contact
                                    Row(
                                      children: [
                                        const Icon(Icons.phone,
                                            size: 16,
                                            color: Color(0xFFB974FF)),
                                        const SizedBox(width: 6),
                                        Text(
                                          d["mobile"] ?? "",
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 6),

                                    Row(
                                      children: [
                                        const Icon(Icons.email,
                                            size: 16,
                                            color: Color(0xFFB974FF)),
                                        const SizedBox(width: 6),
                                        Text(
                                          d["email"] ?? "",
                                          style: const TextStyle(
                                              color: Colors.white70),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 14),

                                    /// 🔹 Property Info Box
                                    Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1D1D20),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const Icon(Icons.home_work,
                                              color: Color(0xFFA684FF),
                                              size: 18),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Text(
                                              "${d["propertyTitle"] ?? ""}\n"
                                                  "${d["propertyAddress"] ?? ""}",
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const SizedBox(height: 12),

                                    /// 🔹 Message Box
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF141416),
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        d["message"]?.toString().isNotEmpty == true
                                            ? d["message"]
                                            : "Buyer enquired for this property.",
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontStyle: FontStyle.italic,
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