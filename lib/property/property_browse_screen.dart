import 'package:bodmas_wealth/core/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'property_browse_card.dart';
import 'filter_bottom_sheet.dart';
import 'property_filter.dart';

class PropertyBrowseScreen extends StatefulWidget {
  const PropertyBrowseScreen({super.key});

  @override
  State<PropertyBrowseScreen> createState() => _PropertyBrowseScreenState();
}

class _PropertyBrowseScreenState extends State<PropertyBrowseScreen> {
  PropertyFilter activeFilter = PropertyFilter();
  bool filterApplied = false; // 🔥 IMPORTANT FLAG

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("Properties"),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => FilterBottomSheet(
                  filter: activeFilter,
                  onApply: (newFilter) {
                    setState(() {
                      activeFilter = newFilter;
                      filterApplied = true; // ✅ filter ON
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),

          /// 🔄 CLEAR FILTER BUTTON
          if (filterApplied)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                setState(() {
                  activeFilter = PropertyFilter();
                  filterApplied = false; // ❌ filter OFF
                });
              },
            ),
        ],
      ),

      /// 🔥 SINGLE FIRESTORE STREAM (NEVER CHANGES)
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("properties")
            .orderBy("createdAt", descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          // First time loader only
          if (snapshot.connectionState == ConnectionState.waiting &&
              snapshot.data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final allDocs = snapshot.data?.docs ?? [];

          if (allDocs.isEmpty) {
            return const Center(child: Text("No Properties Found"));
          }

          /// 🔥 APPLY FILTER ONLY WHEN USER APPLIES
          final visibleDocs = filterApplied
              ? _applyClientSideFilter(allDocs)
              : allDocs;

          if (visibleDocs.isEmpty) {
            return const Center(child: Text("No Properties Found"));
          }

          return ListView.builder(
            key: const PageStorageKey("property_list"),
            padding: const EdgeInsets.all(12),
            itemCount: visibleDocs.length,
            itemBuilder: (_, i) =>
                PropertyBrowseCard(data: visibleDocs[i]),
          );
        },
      ),
    );
  }

  /// ===============================
  /// CLIENT-SIDE FILTER FUNCTION
  /// ===============================
  List<QueryDocumentSnapshot> _applyClientSideFilter(
      List<QueryDocumentSnapshot> docs) {
    return docs.where((doc) {
      final d = doc.data() as Map<String, dynamic>;

      // LISTING TYPE
      if (d["listingType"] != activeFilter.listingType) {
        return false;
      }

      // BHK
      if (activeFilter.bhk != null &&
          d["bhk"] != activeFilter.bhk) {
        return false;
      }

      // PROPERTY TYPE
      if (activeFilter.propertyType != null &&
          d["propertyType"] != activeFilter.propertyType) {
        return false;
      }

      // VERIFIED
      if (activeFilter.verifiedOnly && d["verified"] != true) {
        return false;
      }

      // MEDIA
      if (activeFilter.withMedia && d["hasMedia"] != true) {
        return false;
      }

      // PRICE RANGE
      final price = d["price"] ?? 0;
      if (price < activeFilter.minPrice ||
          price > activeFilter.maxPrice) {
        return false;
      }

      // AREA RANGE
      final area = d["areaSqft"] ?? 0;
      if (area < activeFilter.minArea ||
          area > activeFilter.maxArea) {
        return false;
      }

      // LOCALITY SEARCH
      if (activeFilter.locality != null &&
          !d["locality"]
              .toString()
              .toLowerCase()
              .contains(activeFilter.locality!.toLowerCase())) {
        return false;
      }

      return true;
    }).toList();
  }
}
