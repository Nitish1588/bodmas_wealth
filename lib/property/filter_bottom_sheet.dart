import 'package:flutter/material.dart';
import 'property_filter.dart';

class FilterBottomSheet extends StatefulWidget {
  final PropertyFilter filter;
  final Function(PropertyFilter) onApply;

  const FilterBottomSheet({
    super.key,
    required this.filter,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late PropertyFilter temp;

  @override
  void initState() {
    super.initState();
    temp = widget.filter.copy();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// BUY / RENT / PG
            Row(
              children: ["Buy", "Rent", "PG"].map((e) {
                final active = temp.listingType == e;
                return Expanded(
                  child: ChoiceChip(
                    label: Text(e),
                    selected: active,
                    onSelected: (_) =>
                        setState(() => temp.listingType = e),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            /// LOCALITY (CLIENT SIDE)
            TextField(
              decoration: const InputDecoration(
                hintText: "Enter locality",
              ),
              onChanged: (v) => temp.locality = v.isEmpty ? null : v,
            ),

            const SizedBox(height: 12),

            /// BHK
            DropdownButtonFormField<int>(
              hint: const Text("Any BHK"),
              value: temp.bhk,
              items: [1, 2, 3, 4, 5]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text("$e BHK")))
                  .toList(),
              onChanged: (v) => setState(() => temp.bhk = v),
            ),

            const SizedBox(height: 12),

            /// PROPERTY TYPE
            DropdownButtonFormField<String>(
              hint: const Text("Property Type"),
              value: temp.propertyType,
              items: [
                "Apartment",
                "Villa",
                "Plot",
                "Studio Apartment"
              ]
                  .map((e) =>
                  DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (v) => setState(() => temp.propertyType = v),
            ),

            const SizedBox(height: 16),

            /// PRICE RANGE (FIRESTORE)
            const Text("Price Range"),
            RangeSlider(
              min: 0,
              max: 100000000,
              values: RangeValues(
                temp.minPrice.toDouble(),
                temp.maxPrice.toDouble(),
              ),
              onChanged: (r) {
                setState(() {
                  temp.minPrice = r.start.toInt();
                  temp.maxPrice = r.end.toInt();
                });
              },
            ),

            /// AREA RANGE (CLIENT SIDE)
            const Text("Area Range (sqft)"),
            RangeSlider(
              min: 0,
              max: 100000,
              values: RangeValues(
                temp.minArea.toDouble(),
                temp.maxArea.toDouble(),
              ),
              onChanged: (r) {
                setState(() {
                  temp.minArea = r.start.toInt();
                  temp.maxArea = r.end.toInt();
                });
              },
            ),

            CheckboxListTile(
              title: const Text("Verified Properties"),
              value: temp.verifiedOnly,
              onChanged: (v) =>
                  setState(() => temp.verifiedOnly = v ?? false),
            ),

            CheckboxListTile(
              title: const Text("With Photos & Videos"),
              value: temp.withMedia,
              onChanged: (v) =>
                  setState(() => temp.withMedia = v ?? false),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                widget.onApply(temp);
              },
              child: const Text("Apply Filters"),
            ),
          ],
        ),
      ),
    );
  }
}
