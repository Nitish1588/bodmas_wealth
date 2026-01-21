import 'package:bodmas_wealth/property/property_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PropertyBrowseCard extends StatefulWidget {
  final DocumentSnapshot data;
  const PropertyBrowseCard({super.key, required this.data});

  @override
  State<PropertyBrowseCard> createState() => _PropertyBrowseCardState();
}

class _PropertyBrowseCardState extends State<PropertyBrowseCard> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final propertyId = widget.data.id;
    final dataMap =
        widget.data.data() as Map<String, dynamic>? ?? {};
    final coverImage = dataMap['coverImage'];

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      margin: const EdgeInsets.only(bottom: 16),
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

            /// IMAGE + HEART + DOTS
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(14)),
                  child: SizedBox(
                    height: 200,
                    width: double.infinity,
                    child: _buildImageSlider(coverImage),
                  ),
                ),

                /// ❤️ Wishlist
                Positioned(
                  top: 10,
                  right: 10,
                  child: StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("users")
                        .doc(uid)
                        .collection("wishlist")
                        .doc(propertyId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      final isFav = snapshot.data?.exists ?? false;

                      return IconButton(
                        icon: Icon(
                          isFav
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          final ref = FirebaseFirestore.instance
                              .collection("users")
                              .doc(uid)
                              .collection("wishlist")
                              .doc(propertyId);

                          if (isFav) {
                            await ref.delete();
                          } else {
                            await ref.set({
                              "createdAt":
                              FieldValue.serverTimestamp()
                            });
                          }
                        },
                      );
                    },
                  ),
                ),
              ],
            ),

            /// DETAILS
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.data["title"],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFB974FF),
                    ),
                  ),
                  Text(
                      "${widget.data["locality"]}, ${widget.data["city"]}"),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
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

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              // CALL AGENT
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor:
                              const Color(0xFF9144FF),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            child: const Text("Call Agent"),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      PropertyDetailsScreen(
                                          property:
                                          widget.data),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF9144FF),
                              foregroundColor:
                              const Color(0xFFDDDDDD),
                              textStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
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

  /// IMAGE SLIDER + DOTS
  Widget _buildImageSlider(dynamic coverImage) {
    // MULTIPLE IMAGES
    if (coverImage is List && coverImage.isNotEmpty) {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: [
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
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.image_not_supported),
              );
            },
          ),

          /// DOT INDICATOR
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(
                coverImage.length,
                    (index) => AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 300),
                  margin:
                  const EdgeInsets.symmetric(horizontal: 4),
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

    // SINGLE IMAGE
    if (coverImage is String && coverImage.isNotEmpty) {
      return Image.network(
        coverImage,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
        const Icon(Icons.image_not_supported),
      );
    }

    // FALLBACK
    return const Center(
      child: Icon(Icons.image, size: 40),
    );
  }
}
