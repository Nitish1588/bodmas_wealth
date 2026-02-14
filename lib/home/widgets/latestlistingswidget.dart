import 'package:bodmas_wealth/property/widgets/property_browse_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
//import 'lib/property/property_browse_card.dart'; // reuse your card
class LatestListingsWidget extends StatelessWidget {
  const LatestListingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('properties')                // Firestore collection
          .orderBy('createdAt', descending: true) // Latest first
          .limit(5)                               // Only show 5 latest
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // Loading state
          return const Center(child: CircularProgressIndicator());
        }

        final properties = snapshot.data!.docs;

        if (properties.isEmpty) {
          // No data
          return const Text("No latest listings available");
        }

        // Build list of PropertyBrowseCard widgets
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ...properties.map((doc) {
              final data = doc.data() as Map<String, dynamic>;

              // Optional: Format creation date
              final Timestamp? createdAt = data['createdAt'];
              final _ = createdAt != null
                  ? "${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}"
                  : "Unknown Date";

              return Column(
                children: [
                  PropertyBrowseCard(data: doc), // Reusable card widget
                  // Optional: show listing date
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 12.0, bottom: 15.0),
                  //   child: Align(
                  //     alignment: Alignment.centerLeft,
                  //     child: Text(
                  //       "Listed on: $dateString",
                  //       style: const TextStyle(
                  //           fontSize: 12, color: Color(0xFF99A1AF)),
                  //     ),
                  //   ),
                  // ),
                ],
              );
            }).toList(),
          ],
        );
      },
    );
  }
}
