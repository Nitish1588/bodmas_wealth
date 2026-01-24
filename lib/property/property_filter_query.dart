import 'package:cloud_firestore/cloud_firestore.dart';
import 'property_filter.dart';

Query buildFirestoreQuery(PropertyFilter f) {
  Query q = FirebaseFirestore.instance
      .collection("properties")
      .where("listingType", isEqualTo: f.listingType);

  if (f.bhk != null) {
    q = q.where("bhk", isEqualTo: f.bhk);
  }

  if (f.propertyType != null) {
    q = q.where("propertyType", isEqualTo: f.propertyType);
  }

  if (f.verifiedOnly) {
    q = q.where("verified", isEqualTo: true);
  }

  if (f.withMedia) {
    q = q.where("hasMedia", isEqualTo: true);
  }

  // ONLY ONE RANGE → PRICE
  q = q
      .where("price", isGreaterThanOrEqualTo: f.minPrice)
      .where("price", isLessThanOrEqualTo: f.maxPrice)
      .orderBy("price");

  return q;
}
