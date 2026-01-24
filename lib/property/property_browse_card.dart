import 'package:bodmas_wealth/property/property_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Date formatting
import 'package:intl/intl.dart';

/// =======================
/// PROPERTY BROWSE CARD
/// =======================
/// Displays a single property in a card with:
/// - Image slider / cover image
/// - Wishlist (favorite) button
/// - Property details (title, location, BHK, area, price)
/// - Action buttons: Call Agent, View Details
class PropertyBrowseCard extends StatefulWidget {
  // Firestore property document
  final DocumentSnapshot data;

  const PropertyBrowseCard({super.key, required this.data});

  @override
  State<PropertyBrowseCard> createState() => _PropertyBrowseCardState();
}

class _PropertyBrowseCardState extends State<PropertyBrowseCard> {
  // Current logged-in user's UID
  final uid = FirebaseAuth.instance.currentUser!.uid;

  // Controller for image slider (PageView)
  final PageController _pageController = PageController();

  // Track currently active image index
  int _currentPage = 0;

  /// Convert Firestore Timestamp to readable date
  /// Example: Jan 10 2025
  String formatDate(DateTime date) {
    return DateFormat('MMM dd yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    // Unique ID of the property document
    final propertyId = widget.data.id;

    // Convert Firestore data to Map
    final dataMap = widget.data.data() as Map<String, dynamic>? ?? {};

    // Cover image (can be single URL string or list of URLs)
    final coverImage = dataMap['coverImage'];

    // Property listing creation date
    DateTime? createdAt;
    if (dataMap.containsKey('createdAt') && dataMap['createdAt'] != null) {
      createdAt = (dataMap['createdAt'] as Timestamp).toDate();
    }

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.only(bottom: 16),

      /// Card background gradient
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFE6E8FF),
              Color(0xFFF1FFED),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        child: Column(
          children: [
            /// =======================
            /// IMAGE + WISHLIST ICON
            /// =======================
            Stack(
              children: [
                // Image container with rounded corners
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    // Call image slider builder
                    child: _buildImageSlider(coverImage),
                  ),
                ),

                /// ❤️ Wishlist button at top-right
                Positioned(
                  top: 10,
                  right: 10,
                  child: StreamBuilder<DocumentSnapshot>(
                    // Listen to user's wishlist for this property
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("wishlist")
                        .doc(propertyId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      // Check if property is in wishlist
                      final isFav = snapshot.data?.exists ?? false;

                      return IconButton(
                        icon: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final ref = FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .collection("wishlist")
                              .doc(propertyId);

                          // Toggle wishlist: remove if exists, add if not
                          if (isFav) {
                            await ref.delete();
                          } else {
                            await ref.set({
                              "createdAt": FieldValue.serverTimestamp()
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            /// =======================
            /// PROPERTY DETAILS
            /// =======================
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Property title
                  Text(
                    widget.data["title"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB974FF),
                    ),
                  ),

                  const SizedBox(height: 4),

                  // Location text
                  // Text("${widget.data["locality"]}, ${widget.data["city"]}"),
                  //
                  // const SizedBox(height: 4),

                  // Listed date and location row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Location (left)
                      Text("${widget.data["locality"]}, ${widget.data["city"]}"),
                      // Listing date (right)
                      if (createdAt != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 1.0),
                          child: Text(
                            "Listed on: ${formatDate(createdAt)}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF222836),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  /// BHK | Area | Price row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.data["bhk"]} BHK"),
                      Text("${widget.data["areaSqft"]} sqft"),
                      Text(
                        "₹${widget.data["price"]}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF104E08),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  /// =======================
                  /// ACTION BUTTONS
                  /// =======================
                  Row(
                    children: [
                      /// Call Agent Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              // TODO: Call agent logic
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: const Color(0xFF9144FF),
                            ),
                            child: const Text("Call Agent"),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      /// View Details Button
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Navigate to Property Details screen
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PropertyDetailsScreen(property: widget.data),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF9144FF),
                              foregroundColor: const Color(0xFFDDDDDD),
                            ),
                            child: const Text("View Details"),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /// ====================================
  /// IMAGE SLIDER FUNCTION
  /// ====================================
  /// - If multiple images, create PageView slider with dots indicator
  /// - If single image, display it
  /// - If no image, fallback icon
  Widget _buildImageSlider(dynamic coverImage) {
    // Multiple images case
    if (coverImage is List && coverImage.isNotEmpty) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Swipeable image slider
          PageView.builder(
            controller: _pageController,
            itemCount: coverImage.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Image.network(
                coverImage[index],
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
              );
            },
          ),

          /// DOT INDICATOR (bottom)
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(
                coverImage.length,
                    (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentPage == index ? 10 : 8,
                  height: _currentPage == index ? 10 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Color(0xFFB974FF)
                        : Color(0xFFdddddd),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Single image case
    if (coverImage is String && coverImage.isNotEmpty) {
      return Image.network(
        coverImage,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
      );
    }

    // Fallback (no image)
    return const Center(
      child: Icon(Icons.image, size: 40),
    );
  }
}
