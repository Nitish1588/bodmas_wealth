import 'package:bodmas_wealth/home/widgets/property_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class PropertyList extends StatelessWidget {
  final Query query;       // Firestore query for properties
  final int budget;        // max budget filter
  final String? type;      // optional type filter

  const PropertyList({
    super.key,
    required this.query,
    required this.budget,
    this.type,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) return const SizedBox();

        // Client-side filtering
        final filteredDocs = snapshot.data!.docs.where((doc) {
          final price = doc['priceValue'];       // price in integer
          final matchesBudget = price <= budget;

          final matchesType = type == null || doc['type'] == type;

          return matchesBudget && matchesType;
        }).toList();

        if (filteredDocs.isEmpty) {
          return const Center(
            child: Text(
              "No properties found",
              style: TextStyle(color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: filteredDocs.length,
          itemBuilder: (_, i) {
            return PropertyCard(doc: filteredDocs[i]);
          },
        );
      },
    );
  }
}
