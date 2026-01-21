import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyDetailsScreen extends StatefulWidget {
  final DocumentSnapshot property;

  const PropertyDetailsScreen({super.key, required this.property});

  @override
  State<PropertyDetailsScreen> createState() =>
      _PropertyDetailsScreenState();
}
class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  List<String> _parseCoverImages(dynamic coverImage) {
    if (coverImage is List && coverImage.isNotEmpty) {
      return coverImage.map((e) => e.toString()).toList();
    }

    if (coverImage is String && coverImage.trim().isNotEmpty) {
      return [coverImage];
    }

    return [];
  }


  Widget coverImageWidget(dynamic coverImage) {
    final images = _parseCoverImages(coverImage);

    if (images.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(
          child: Icon(Icons.image_not_supported, size: 40),
        ),
      );
    }

    if (images.length == 1) {
      return Image.network(
        images.first,
        height: 220,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

    return SizedBox(
      height: 240,
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
              return Image.network(
                images[index],
                width: double.infinity,
                fit: BoxFit.cover,
              );
            },
          ),

          /// 🔵 DOTS
          Positioned(
            bottom: 10,
            child: Row(
              children: List.generate(images.length, (index) {
                final isActive = index == _currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: isActive ? 10 : 6,
                  height: isActive ? 10 : 6,
                  decoration: BoxDecoration(
                    color: isActive ? Color(0xFFB974FF) : Color(0xFFDDDDDD),
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

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.property.data() as Map<String, dynamic>;

    return Scaffold(
      appBar: AppBar(title: Text(d["title"])),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            coverImageWidget(d["coverImage"]),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    d["title"],
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text("${d["locality"]}, ${d["city"]}"),

                  const SizedBox(height: 10),

                  Text("₹ ${d["price"]}",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),

                  const Divider(height: 30),

                  Wrap(
                    spacing: 20,
                    children: [
                      Text("${d["bhk"]} BHK"),
                      Text("${d["bathrooms"]} Bath"),
                      Text("${d["areaSqft"]} sqft"),
                      Text(d["facing"]),
                    ],
                  ),

                  const Divider(height: 30),

                  const Text("Amenities",
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Wrap(
                    spacing: 8,
                    children: (d["amenities"] as List)
                        .map((a) => Chip(label: Text(a)))
                        .toList(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}


