import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class PropertyCard extends StatelessWidget {
  final QueryDocumentSnapshot doc; // Firestore document containing property data

  const PropertyCard({required this.doc, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(1, 5, 1, 15), // spacing around the card
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // rounded corners
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // Image at the top of the card
          ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              doc['image'],       // property image URL from Firestore
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover, // cover entire width
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Property name
                Text(
                  doc['propertyname'],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF9144FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                // Location
                Text(
                  "${doc['city']}, ${doc['state']} - ${doc['pincode']}",
                  style: const TextStyle(color: Color(0xFF444444)),
                ),

                const SizedBox(height: 6),

                // Type and Price
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Type: ${doc['type']}"),
                    Text(
                      doc['price'],
                      style: const TextStyle(
                        color: Color(0xFF1B7304),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Owner
                Text("Owner: ${doc['Owner']}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
