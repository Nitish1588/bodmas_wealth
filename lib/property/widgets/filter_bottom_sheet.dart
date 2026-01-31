import 'package:flutter/material.dart';
import '../property_filter.dart';

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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF333333),
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HANDLE
            Center(
              child: Container(
                width: 50,
                height: 5,
                margin: const EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            /// LISTING TYPE
            Text("Listing Type",
                style:
                TextStyle(color:Color(0xFFFFFFFF),
                    fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: ["Buy", "Rent", "PG"].map((e) {
                final active = temp.listingType == e;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2), // small gap between chips

                    child: ChoiceChip(
                      label: Text(
                        e,
                        style: TextStyle(
                          fontSize: 16,
                          color: active ? Colors.white : Color(0xFF9144FF),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      selectedColor: Color(0xff9144ff),
                      backgroundColor: Color(0xffffffff),
                      selected: active,
                      showCheckmark: false,
                      onSelected: (_) => setState(() => temp.listingType = e),
                    ),
                  ),
                );
              }).toList(),
            ),


            const SizedBox(height: 15),

            /// LOCALITY
            TextField(
              decoration: InputDecoration(
                hintText: "Enter locality",
                prefixIcon: const Icon(Icons.location_on_outlined),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (v) => temp.locality = v.isEmpty ? null : v,
            ),

            const SizedBox(height: 15),

            /// BHK & PROPERTY TYPE
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: DropdownButtonFormField<int>(
                    decoration: _dropdownDecoration(),
                    hint: const Text("Any BHK"),
                    initialValue: temp.bhk,
                    isExpanded: true, // Important! Forces the dropdown to use full width
                    items: [1, 2, 3, 4, 5]
                        .map((e) => DropdownMenuItem(value: e, child: Text("$e BHK")))
                        .toList(),
                    onChanged: (v) => setState(() => temp.bhk = v),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  fit: FlexFit.tight,
                  child: DropdownButtonFormField<String>(
                    decoration: _dropdownDecoration(),
                    hint: const Text("Property Type"),
                    initialValue: temp.propertyType,
                    isExpanded: true, // Important!
                    items: ["Apartment", "Villa", "Plot", "Studio Apartment"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setState(() => temp.propertyType = v),
                  ),
                ),
              ],
            ),


            const SizedBox(height: 10),

            /// PRICE RANGE
            Text("Price Range", style: _sectionTitleStyle()),
            const SizedBox(height: 8),
            _buildRangeSlider(
              min: 0,
              max: 100000000,
              divisions: 100,
              start: temp.minPrice,
              end: temp.maxPrice,
              onChanged: (start, end) {
                setState(() {
                  temp.minPrice = start;
                  temp.maxPrice = end;
                });
              },
              prefix: "₹",
            ),

            const SizedBox(height: 10),

            /// AREA RANGE
            Text("Area Range (sqft)", style: _sectionTitleStyle()),
            const SizedBox(height: 8),
            _buildRangeSlider(
              min: 0,
              max: 100000,
              divisions: 100,
              start: temp.minArea,
              end: temp.maxArea,
              onChanged: (start, end) {
                setState(() {
                  temp.minArea = start;
                  temp.maxArea = end;
                });
              },
            ),

            const SizedBox(height: 2),

            /// CHECKBOXES
            CheckboxListTile(
              title: const Text("Verified Properties",
                  style: TextStyle(color:Color(0xffffffff) )),
              value: temp.verifiedOnly,
              onChanged: (v) => setState(() => temp.verifiedOnly = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Color(0xffb974ff), // Color of the checkbox when checked
              checkColor: Colors.white,
              side: BorderSide(
                color: Colors.grey,
                width: 2,
              ),// Color of the check icon inside the checkbox
            ),
            CheckboxListTile(
              title: const Text("Ready To Move",
                  style: TextStyle(color:Color(0xffffffff) )),
              value: temp.readyToMove,
              onChanged: (v) => setState(() => temp.readyToMove = v ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              activeColor: Color(0xffb974ff), // Color of the checkbox when checked
              checkColor: Colors.white,
              side: BorderSide(
                color: Colors.grey,
                width: 2,
              ),// Color of the check icon inside the checkbox
            ),

            const SizedBox(height: 10),

            /// APPLY BUTTON
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  // Set the background color of the button
                  backgroundColor: Color(0xFFFFFFFF),

                  // Set the text color (foreground color)
                  foregroundColor: Color(0xFF9144FF),
                  textStyle: TextStyle(
                    fontSize: 15.0, //  font size here
                    fontWeight: FontWeight.w500,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                onPressed: () {
                  widget.onApply(temp);
                },
                child: const Text(
                  "Apply Filters",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),


          ],
        ),
      ),
    );
  }

  /// Section title style
  TextStyle _sectionTitleStyle() =>
      const TextStyle(color:Color(0xFFFFFFFF),
          fontWeight: FontWeight.bold, fontSize: 16);

  /// Dropdown decoration
  InputDecoration _dropdownDecoration() => InputDecoration(
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  );

  /// Custom Range Slider
  Widget _buildRangeSlider({
    required double min,
    required double max,
    required int divisions,
    required int start,
    required int end,
    required Function(int, int) onChanged,
    String prefix = "",
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("$prefix$start",
                style: TextStyle(color:Color(0xffffffff) )),
            Text("$prefix$end",
                style: TextStyle(color:Color(0xffffffff) )),

          ],
        ),
        const SizedBox(height: 1),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 6,
            activeTrackColor: Color(0xffb974ff),
            inactiveTrackColor: Colors.grey[300],
            thumbColor: Color(0xffb974ff),
            overlayColor: Color(0x32b974ff),
            showValueIndicator: ShowValueIndicator.onDrag,
            valueIndicatorTextStyle:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          child: RangeSlider(
            min: min,
            max: max,
            divisions: divisions,
            values: RangeValues(start.toDouble(), end.toDouble()),
            labels: RangeLabels("$prefix$start", "$prefix$end"),
            onChanged: (r) => onChanged(r.start.toInt(), r.end.toInt()),
          ),
        ),
      ],
    );
  }
}
