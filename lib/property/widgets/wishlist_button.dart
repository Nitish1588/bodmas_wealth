import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WishlistButton extends StatelessWidget {
  final String propertyId; // Property ID

  const WishlistButton({super.key, required this.propertyId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return StreamBuilder<DocumentSnapshot>(
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
            isFav ? Icons.favorite : Icons.favorite_border,
            color: Colors.red,
            size: 22,
          ),
          onPressed: () async {
            final buyerId = FirebaseAuth.instance.currentUser!.uid;

            final buyerDoc = await FirebaseFirestore.instance
                .collection("users")
                .doc(buyerId)
                .get();

            final wishlistRef = FirebaseFirestore.instance
                .collection("users")
                .doc(buyerId)
                .collection("wishlist")
                .doc(propertyId);

            if (isFav) {
              // ❌ Remove wishlist
              await wishlistRef.delete();

            } else {
              // ✅ Add wishlist
              await wishlistRef.set({
                "createdAt": FieldValue.serverTimestamp(),
              });

              // 🔥 PROPERTY DATA
              final propertyDoc = await FirebaseFirestore.instance
                  .collection("properties")
                  .doc(propertyId)
                  .get();

              final ownerId = propertyDoc["postedById"]; // 👈 THIS IS THE KEY

              // 🔥 SEND DATA TO OWNER PROFILE
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(ownerId)
                  .collection("interestedProperties")
                  .add({

                // Property info
                "propertyId": propertyId,
                "propertyTitle": propertyDoc["title"],
                "propertyAddress":
                "${propertyDoc["locality"]}, ${propertyDoc["city"]}",

                // Buyer info
                "buyerId": buyerId,
                "buyerName": buyerDoc["name"],
                "buyerEmail": buyerDoc["email"],
                "buyerMobile": buyerDoc["mobile"],
                //"buyerOccupation": buyerDoc["occupation"],

                // Meta
                "createdAt": FieldValue.serverTimestamp(),
              });
            }
          },

        );
      },
    );
  }
}
