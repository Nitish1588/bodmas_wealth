import 'dart:io';
import 'package:bodmas_wealth/core/colors.dart';
import 'package:bodmas_wealth/property_management/widgets/property_form_widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditPropertyScreen extends StatefulWidget {
  final DocumentSnapshot propertyDoc;
  const EditPropertyScreen({super.key, required this.propertyDoc});

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();

  // Text Controllers
  final titleCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final localityCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final bhkCtrl = TextEditingController();
  final bathCtrl = TextEditingController();
  final ownerCtrl = TextEditingController();

  // Dropdowns & switches
  String listingType = "Buy";
  String propertyType = "Apartment";
  String furnishing = "Semi Furnished";
  String facing = "East";
  String postedBy = "Agent";

  bool isNew = false;
  bool readyToMove = true;
  bool verified = false;

  List<String> amenities = [];

  // Images
  List<File> newImages = [];
  List<String> existingImages = [];
  final ImagePicker picker = ImagePicker();

  bool loading = false;

  @override
  void initState() {
    super.initState();
    final data = widget.propertyDoc;

    // Initialize fields
    titleCtrl.text = data["title"];
    cityCtrl.text = data["city"];
    localityCtrl.text = data["locality"];
    priceCtrl.text = data["price"].toString();
    areaCtrl.text = data["areaSqft"].toString();
    bhkCtrl.text = data["bhk"].toString();
    bathCtrl.text = data["bathrooms"].toString();
    ownerCtrl.text = data["ownerName"];

    listingType = data["listingType"];
    propertyType = data["propertyType"];
    furnishing = data["furnishing"];
    facing = data["facing"];
    postedBy = data["postedBy"];

    isNew = data["isNew"];
    readyToMove = data["readyToMove"];
    verified = data["verified"];

    amenities = List<String>.from(data["amenities"] ?? []);

    existingImages = data["coverImage"] != null ? List<String>.from(data["coverImage"]) : [];
  }

  /// Pick new images
  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage(imageQuality: 70);
    if (images.isNotEmpty) {
      setState(() {
        newImages = images.map((e) => File(e.path)).toList();
      });
    }
  }

  /// Upload new images to Firebase Storage
  Future<List<String>> uploadImagesToStorage() async {
    List<String> urls = [];
    for (var img in newImages) {
      final fileName = "properties/${DateTime.now().millisecondsSinceEpoch}.jpg";
      final ref = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = ref.putFile(img);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      urls.add(downloadUrl);
    }
    return urls;
  }

  /// Update property
  Future<void> updateProperty() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    List<String> uploadedUrls = [];
    if (newImages.isNotEmpty) {
      try {
        uploadedUrls = await uploadImagesToStorage();
      } catch (e) {
        debugPrint("Image upload failed: $e");
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image upload failed, updating without new images")),
        );
      }
    }

    // Merge existing and newly uploaded images
    List<String> finalImages = [...existingImages, ...uploadedUrls];

    await FirebaseFirestore.instance
        .collection("properties")
        .doc(widget.propertyDoc.id)
        .update({
      "title": titleCtrl.text.trim(),
      "city": cityCtrl.text.trim(),
      "locality": localityCtrl.text.trim(),
      "price": int.parse(priceCtrl.text),
      "areaSqft": int.parse(areaCtrl.text),
      "bhk": int.parse(bhkCtrl.text),
      "bathrooms": int.parse(bathCtrl.text),
      "ownerName": ownerCtrl.text.trim(),
      "listingType": listingType,
      "propertyType": propertyType,
      "furnishing": furnishing,
      "facing": facing,
      "postedBy": postedBy,
      "isNew": isNew,
      "readyToMove": readyToMove,
      "verified": false, // re-approval
      "amenities": amenities,
      "coverImage": finalImages,
      "updatedAt": FieldValue.serverTimestamp(),
    });

    setState(() => loading = false);
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Property Updated Successfully")),
    );
    Navigator.pop(context);
  }

  /// Remove existing image
  void removeExistingImage(int index) {
    setState(() {
      existingImages.removeAt(index);
    });
  }

  /// Remove newly selected image
  void removeNewImage(int index) {
    setState(() {
      newImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary,
      appBar: AppBar(title: const Text("Edit Property")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Property Images", style: TextStyle(color: Colors.white)),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: pickImages,
                child: Container(
                  height: 160,
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFB974FF)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: (existingImages.isEmpty && newImages.isEmpty)
                      ? const Center(
                    child: Text(
                      "Tap to select images",
                      style: TextStyle(color: Color(0xFFD2D2DC)),
                    ),
                  )
                      : ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      // Show existing images
                      ...existingImages.asMap().entries.map((e) {
                        int idx = e.key;
                        String url = e.value;
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 160,
                              height: 160,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(url, fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => removeExistingImage(idx),
                                child: const Icon(Icons.cancel, color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      }),
                      // Show new images
                      ...newImages.asMap().entries.map((e) {
                        int idx = e.key;
                        File file = e.value;
                        return Stack(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 8),
                              width: 160,
                              height: 160,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(file, fit: BoxFit.cover),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: GestureDetector(
                                onTap: () => removeNewImage(idx),
                                child: const Icon(Icons.cancel, color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Dropdowns & TextFields
              darkDropdown("Listing Type", listingType, ["Buy", "Rent", "PG"], (v) {
                setState(() => listingType = v);
              }),
              darkDropdown("Property Type", propertyType, ["Apartment", "Villa", "Plot", "Studio Apartment"],
                      (v) => setState(() => propertyType = v)),
              darkTextField("Title", titleCtrl),
              darkTextField("City", cityCtrl),
              darkTextField("Locality", localityCtrl),
              darkTextField("Price", priceCtrl, keyboard: TextInputType.number),
              darkTextField("Area (sqft)", areaCtrl, keyboard: TextInputType.number),
              darkTextField("BHK", bhkCtrl, keyboard: TextInputType.number),
              darkTextField("Bathrooms", bathCtrl, keyboard: TextInputType.number),
              darkDropdown("Furnishing", furnishing, ["Unfurnished", "Semi Furnished", "Fully Furnished"],
                      (v) => setState(() => furnishing = v)),
              darkDropdown("Facing", facing, ["East", "West", "North", "South"],
                      (v) => setState(() => facing = v)),
              darkTextField("Owner / Agent Name", ownerCtrl),

              darkCheckbox("New Property", isNew, (v) => setState(() => isNew = v)),
              darkCheckbox("Ready to Move", readyToMove, (v) => setState(() => readyToMove = v)),
              darkCheckbox("Verified", verified, (v) => setState(() => verified = v)),

              const SizedBox(height: 10),
              const Text("Amenities", style: TextStyle(color: Colors.white)),
              Wrap(
                spacing: 8,
                children: ["Lift", "Security", "Garden", "Parking", "Club House"].map((a) {
                  final selected = amenities.contains(a);
                  return FilterChip(
                    label: Text(a, style: const TextStyle(color: Colors.white)),
                    selected: selected,
                    selectedColor: const Color(0xFF9144FF),
                    backgroundColor: const Color(0xFF3B4143),
                    onSelected: (v) {
                      setState(() {
                        v ? amenities.add(a) : amenities.remove(a);
                      });
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: updateProperty,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF9144FF),
                  foregroundColor: Color(0xFFFFFFFF),
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text("Update Property"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
