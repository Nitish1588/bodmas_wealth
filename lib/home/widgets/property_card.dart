import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
class PropertyCard extends StatelessWidget {
  final QueryDocumentSnapshot doc;
  const PropertyCard({required this.doc, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(1,5,1,15),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          ClipRRect(
            borderRadius: BorderRadius.circular(10.0), // Adjust the radius as needed
            child: Image.network(
              doc['image'],
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['propertyname'],
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xFF9144FF),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${doc['city']}, ${doc['state']} - ${doc['pincode']}",
                  style: const TextStyle(color: Color(0xFF444444)),
                ),
                const SizedBox(height: 6),
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
                Text("Owner: ${doc['Owner']}"),


              ],
            ),
          ),
        ],
      ),
    );
  }
}
