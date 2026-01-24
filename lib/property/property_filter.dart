class PropertyFilter {
  String listingType; // Buy / Rent / PG

  int? bhk;
  String? propertyType;
  bool verifiedOnly;
  bool withMedia;

  // Firestore range (ONLY PRICE)
  int minPrice;
  int maxPrice;

  // Client-side
  int minArea;
  int maxArea;
  String? locality;

  PropertyFilter({
    this.listingType = "Buy",
    this.bhk,
    this.propertyType,
    this.verifiedOnly = false,
    this.withMedia = false,
    this.minPrice = 0,
    this.maxPrice = 100000000,
    this.minArea = 0,
    this.maxArea = 100000,
    this.locality,
  });

  PropertyFilter copy() {
    return PropertyFilter(
      listingType: listingType,
      bhk: bhk,
      propertyType: propertyType,
      verifiedOnly: verifiedOnly,
      withMedia: withMedia,
      minPrice: minPrice,
      maxPrice: maxPrice,
      minArea: minArea,
      maxArea: maxArea,
      locality: locality,
    );
  }
}
