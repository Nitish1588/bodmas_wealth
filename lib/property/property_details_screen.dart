import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// ==============================
/// PROPERTY DETAILS SCREEN
/// ==============================
/// Shows detailed information of a single property, including:
/// - Image slider / gallery
/// - Property info (BHK, area, price, facing)
/// - Amenities
/// - Contact owner button
class PropertyDetailsScreen extends StatefulWidget {
  final DocumentSnapshot property; // Firestore property document

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  // PageController for image slider
  final PageController _pageController = PageController();
  int _currentIndex = 0; // currently active image index

  /// Parses the `coverImage` field which can be a list or a single string
  List<String> _parseCoverImages(dynamic coverImage) {
    if (coverImage is List && coverImage.isNotEmpty) {
      return coverImage.map((e) => e.toString()).toList();
    }
    if (coverImage is String && coverImage.trim().isNotEmpty) {
      return [coverImage];
    }
    return []; // fallback
  }

  /// Builds the top cover image widget (single image or swipeable slider)
  Widget coverImageWidget(dynamic coverImage) {
    final images = _parseCoverImages(coverImage);

    // No image fallback
    if (images.isEmpty) {
      return SizedBox(
        height: 250,
        child: Center(
          child: Icon(Icons.image_not_supported,
              size: 60, color: Color(0xFF99A1AF)),
        ),
      );
    }

    // Single image
    if (images.length == 1) {
      return ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        child: Image.network(
          images.first,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    // Multiple images (slider)
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: images.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
                child: Image.network(
                  images[index],
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
          // Dot indicators
          Positioned(
            bottom: 14,
            child: Row(
              children: List.generate(images.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 12 : 6,
                  height: isActive ? 12 : 6,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Color(0xFFA684FF)
                        : Color(0x6299A1AF),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds info cards for BHK, Bath, Area, Facing, etc.
  Widget infoCard(String title, String value, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFF353535),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0x4D090210),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Color(0xFFA684FF)),
            const SizedBox(width: 6),
          ],
          Text(
            "$value $title",
            style: TextStyle(color: Color(0xFFF5F6FA), fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose(); // dispose page controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.property.data() as Map<String, dynamic>; // Firestore data

    return Scaffold(
      backgroundColor: Color(0xFF1D1D20),
      appBar: AppBar(
        title: Text(d["title"]),
        elevation: 0,
      ),

      // Contact owner floating button
      floatingActionButton: Container(
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          onPressed: () {}, // TODO: implement call/contact logic
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFA684FF), Color(0xFF9144FF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              alignment: Alignment.center,
              child: Text(
                "Contact Owner",
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

      // Main content
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 1),

            // Property images
            coverImageWidget(d["coverImage"]),

            // Property details
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    d["title"],
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5F6FA)),
                  ),
                  const SizedBox(height: 6),

                  // Location
                  Text(
                    "${d["locality"]}, ${d["city"]}",
                    style: TextStyle(fontSize: 15, color: Color(0xFF99A1AF)),
                  ),
                  const SizedBox(height: 14),

                  // Price card
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xFFA684FF), Color(0xFF9144FF)]),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0x34FFFFFF),
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      "₹ ${d["price"]}",
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Property info cards
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      infoCard("BHK", d["bhk"].toString(), icon: Icons.bed),
                      infoCard("Bath", d["bathrooms"].toString(), icon: Icons.bathtub),
                      infoCard("sqft", d["areaSqft"].toString(), icon: Icons.square_foot),
                      infoCard("Facing", d["facing"].toString(), icon: Icons.north_sharp),
                    ],
                  ),
                  const SizedBox(height: 22),

                  // Amenities
                  Text(
                    "Amenities",
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF5F6FA)),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 5,
                    children: (d["amenities"] as List)
                        .map(
                          (a) => Chip(
                        label: Text(a),
                        backgroundColor: Color(0xFF99A1AF),
                        labelStyle: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    )
                        .toList(),
                  ),
                  const SizedBox(height: 100), // space for FAB
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
