import 'package:bodmas_wealth/core/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// ===========================
/// ADD PROPERTY SCREEN
/// ===========================
/// Screen for adding new properties with images, details, and amenities
class AddPropertyScreen extends StatefulWidget {
  const AddPropertyScreen({super.key});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  // Selected property images from device
  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final titleCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final localityCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final bhkCtrl = TextEditingController();
  final bathCtrl = TextEditingController();
  final ownerCtrl = TextEditingController();

  // Dropdown / Switch default values
  String listingType = "Buy";
  String propertyType = "Apartment";
  String furnishing = "Semi Furnished";
  String facing = "East";
  String postedBy = "Agent";

  bool isNew = false; // Indicates if property is newly constructed
  bool readyToMove = true; // Indicates if property is ready to move
  bool verified = false; // Indicates if property is verified by admin

  List<String> amenities = []; // Selected amenities

  bool loading = false; // Loading state during submission or upload

  /// ===========================
  /// IMAGE PICKING FUNCTION
  /// ===========================
  /// Opens device gallery to pick multiple images
  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);

    if (images.isNotEmpty) {
      setState(() {
        selectedImages = images.map((e) => File(e.path)).toList();
      });
    }
  }

  /// ===========================
  /// IMAGE UPLOAD FUNCTION
  /// ===========================
  /// Uploads selected images to Firebase Storage and returns download URLs
  Future<List<String>> uploadImagesToStorage() async {
    List<String> urls = [];

    for (var image in selectedImages) {
      final fileName =
          "properties/${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(image);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      urls.add(downloadUrl);
      debugPrint("IMAGE UPLOADED: $downloadUrl");
    }

    return urls;
  }

  /// ===========================
  /// SUBMIT PROPERTY FUNCTION
  /// ===========================
  /// Validates form, uploads images, and adds property to Firestore
  Future<void> submitProperty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    List<String> imageUrls = [];
    if (selectedImages.isNotEmpty) {
      try {
        imageUrls = await uploadImagesToStorage();
      } catch (e) {
        debugPrint("Image upload failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image upload failed, proceeding without images")),
        );
      }
    }

    // Add property document to Firestore
    await FirebaseFirestore.instance.collection("properties").add({
      "title": titleCtrl.text.trim(),
      "city": cityCtrl.text.trim(),
      "locality": localityCtrl.text.trim(),
      "price": int.parse(priceCtrl.text),
      "areaSqft": int.parse(areaCtrl.text),
      "coverImage": imageUrls.isEmpty ? null : imageUrls,  // Can be null
      "hasMedia": imageUrls.isNotEmpty,
      "createdAt": FieldValue.serverTimestamp(),
      "listingType": listingType,
      "propertyType": propertyType,
      "bhk": int.parse(bhkCtrl.text),
      "bathrooms": int.parse(bathCtrl.text),
      "furnishing": furnishing,
      "facing": facing,
      "isNew": isNew,
      "readyToMove": readyToMove,
      "verified": verified,
      "amenities": amenities,
      "postedBy": postedBy,
      "postedById": FirebaseAuth.instance.currentUser!.uid,

      "ownerName": ownerCtrl.text.trim(),
      "availability": "Available"
    });

    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Property Added Successfully")),
    );

    clearForm(); // Clear form after submission
  }

  /// ===========================
  /// CLEAR FORM
  /// ===========================
  /// Resets all input fields, dropdowns, checkboxes, and images
  void clearForm() {
    FocusScope.of(context).unfocus();

    titleCtrl.clear();
    cityCtrl.clear();
    localityCtrl.clear();
    priceCtrl.clear();
    areaCtrl.clear();
    bhkCtrl.clear();
    bathCtrl.clear();
    ownerCtrl.clear();

    setState(() {
      selectedImages.clear();
      listingType = "Buy";
      propertyType = "Apartment";
      furnishing = "Semi Furnished";
      facing = "East";
      postedBy = "Agent";

      isNew = false;
      readyToMove = true;
      verified = false;

      amenities.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(
        title: const Text("Add Property"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section: Property Images
              const Text(
                "Property Images",
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: pickImages,
                child: Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFB974FF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: selectedImages.isEmpty
                      ? const Center(
                    child: Text(
                      "Tap to select images",
                      style: TextStyle(color: Color(0xFFD2D2DC)),
                    ),
                  )
                      : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.file(
                            selectedImages[index],
                            width: 160,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Dropdowns: Listing Type, Property Type
              darkDropdown("Listing Type", listingType,
                  ["Buy", "Rent", "PG"], (v) {
                    setState(() => listingType = v);
                  }),
              darkDropdown("Property Type", propertyType,
                  ["Apartment", "Villa", "Plot", "Studio Apartment"],
                      (v) {
                    setState(() => propertyType = v);
                  }),

              // Text fields: Title, City, Locality, Price, Area, BHK, Bathrooms, Owner Name
              darkTextField("Title", titleCtrl),
              darkTextField("City", cityCtrl),
              darkTextField("Locality", localityCtrl),
              darkTextField("Price", priceCtrl,
                  keyboard: TextInputType.number),
              darkTextField("Area (sqft)", areaCtrl,
                  keyboard: TextInputType.number),
              darkTextField("BHK", bhkCtrl,
                  keyboard: TextInputType.number),
              darkTextField("Bathrooms", bathCtrl,
                  keyboard: TextInputType.number),

              // Dropdowns: Furnishing, Facing
              darkDropdown("Furnishing", furnishing,
                  ["Unfurnished", "Semi Furnished", "Fully Furnished"],
                      (v) {
                    setState(() => furnishing = v);
                  }),
              darkDropdown("Facing", facing,
                  ["East", "West", "North", "South"], (v) {
                    setState(() => facing = v);
                  }),

              // Owner Name
              darkTextField("Owner / Agent Name", ownerCtrl),

              // Checkboxes: New Property, Ready to Move, Verified
              darkCheckbox("New Property", isNew,
                      (v) => setState(() => isNew = v)),
              darkCheckbox("Ready to Move", readyToMove,
                      (v) => setState(() => readyToMove = v)),
              darkCheckbox("Verified", verified,
                      (v) => setState(() => verified = v)),

              const SizedBox(height: 10),

              // Amenities
              const Text(
                "Amenities",
                style: TextStyle(color: Color(0xFFFFFFFF)),
              ),
              Wrap(
                spacing: 8,
                children: [
                  "Lift",
                  "Security",
                  "Garden",
                  "Parking",
                  "Club House"
                ].map((a) {
                  final selected = amenities.contains(a);
                  return FilterChip(
                    label: Text(
                      a,
                      style: const TextStyle(color: Color(0xFFFFFFFF)),
                    ),
                    selected: selected,
                    selectedColor: Color(0xFF9144FF),
                    backgroundColor: Color(0xFF3B4143),
                    onSelected: (v) {
                      setState(() {
                        v ? amenities.add(a) : amenities.remove(a);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 15),

              // Submit Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9144FF),
                  foregroundColor: Color(0xFFFFFFFF),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: submitProperty,
                child: const Text("Submit Property"),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// ===========================
  /// TEXT FIELD WIDGET
  /// ===========================
  Widget darkTextField(String label, TextEditingController ctrl,
      {TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        style: const TextStyle(color: Color(0xFFFFFFFF)),
        controller: ctrl,
        keyboardType: keyboard,
        validator: (v) => v!.isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFD2D2DC)),
          hintText: 'Enter $label',
          hintStyle: const TextStyle(color: Color(0xFF99A1AF)),
          filled: true,
          fillColor: const Color(0x1AFFFFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0x3499A1AF), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF9144FF), width: 2),
          ),
        ),
      ),
    );
  }

  /// ===========================
  /// DROPDOWN WIDGET
  /// ===========================
  Widget darkDropdown(String label, String value, List<String> items,
      Function(String) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: DropdownButtonFormField(
        value: value,
        isExpanded: true,
        dropdownColor: Color(0xFF181625),
        style: const TextStyle(color: Color(0xFFFFFFFF)),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Color(0xFFD2D2DC)),
          filled: true,
          fillColor: const Color(0x1AFFFFFF),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0x1A99A1AF), width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFF9144FF), width: 2),
          ),
        ),
        items: items
            .map((e) => DropdownMenuItem(
          value: e,
          child: Text(e, style: const TextStyle(color: Color(0xFFFFFFFF))),
        ))
            .toList(),
        onChanged: (v) => onChanged(v!),
      ),
    );
  }

  /// ===========================
  /// CHECKBOX WIDGET
  /// ===========================
  Widget darkCheckbox(String title, bool value, Function(bool) onChanged) {
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(color: Color(0xFFFFFFFF))),
      value: value,
      activeColor: Color(0xFFB974FF),
      checkColor: Color(0xFFFFFFFF),
      onChanged: (v) => onChanged(v!),
    );
  }
}
