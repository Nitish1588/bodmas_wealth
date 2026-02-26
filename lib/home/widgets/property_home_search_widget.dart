import 'package:bodmas_wealth/property/widgets/property_browse_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PropertyHomeSearchWidget extends StatefulWidget {
  const PropertyHomeSearchWidget({super.key});

  @override
  State<PropertyHomeSearchWidget> createState() =>
      _PropertyHomeSearchWidgetState();
}

class _PropertyHomeSearchWidgetState
    extends State<PropertyHomeSearchWidget> {
  final FocusNode _locationFocus = FocusNode();
  final TextEditingController _locationController =
  TextEditingController();


  List<String> suggestions = [];
  bool showSuggestions = false;

  String searchLocation = "";
  String? selectedBudget;
  String? selectedBhk;

  bool showResults = false;

  final List<String> budgetOptions = [
    "Under 20L",
    "20L - 50L",
    "50L - 1Cr",
    "1Cr+",
  ];

  final List<String> bhkOptions = [
    "1",
    "2",
    "3",
    "4+",
  ];
  Future<void> _fetchSuggestions(String input) async {
    final value = input.trim().toLowerCase();

    // ❌ Ignore very short input
    if (value.length < 2) {
      setState(() {
        suggestions = [];
        showSuggestions = false;
      });
      return;
    }

    final snap = await FirebaseFirestore.instance
        .collection("properties")
        .limit(50) // performance safe
        .get();

    final set = <String>{};

    for (var doc in snap.docs) {
      final data = doc.data();

      final locality =
      (data["locality"] ?? "").toString().toLowerCase();
      final city =
      (data["city"] ?? "").toString().toLowerCase();

      final combined = "$locality $city";

      if (combined.contains(value)) {
        set.add(combined);
      }
    }

    setState(() {
      suggestions = set.take(6).toList(); // max 6 items
      showSuggestions = suggestions.isNotEmpty;
    });
  }
  void _applySuggestion(String value) {
    setState(() {
      searchLocation = value.toLowerCase();
      suggestions.clear();
      showSuggestions = false;
    });

    _locationController.text = value;
    _locationController.selection = TextSelection.fromPosition(
      TextPosition(offset: value.length),
    );

    _locationFocus.unfocus(); // 🔥 hide keyboard
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        /// 🔍 LOCATION SEARCH
        TextField(
          focusNode: _locationFocus,
          controller: _locationController,
          style: const TextStyle(color: Colors.white),
          onChanged: (value) {
            setState(() {
              searchLocation = value.trim().toLowerCase();
              if (searchLocation.isEmpty) {
                selectedBudget = null;
                selectedBhk = null;
                showResults = false;
              }
            });

            _fetchSuggestions(value);
            },
          onTap: () {
            if (_locationController.text.length >= 2) {
              setState(() => showSuggestions = true);
            }
            },
          decoration: InputDecoration(
            hintText: "Enter Location",
            hintStyle: const TextStyle(
              color: Color(0x80DDDDDD),
            ),
            prefixIcon: const Icon(Icons.search, color: Color(0x80DDDDDD)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFD9D9D9),
                width: 2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: Color(0xFFB974FF),
                width: 2,
              ),
            ),
          ),
        ),
        if (showSuggestions)
          Container(
            margin: const EdgeInsets.only(top: 6),
            constraints: const BoxConstraints(maxHeight: 120),
             decoration: BoxDecoration(
               color: const Color(0xFF1E1E1E),
               borderRadius: BorderRadius.circular(10),
               border: Border.all(color: const Color(0xFF2A2A2A)),
             ),
            child: ScrollbarTheme(
              data: ScrollbarThemeData(
                thumbColor: WidgetStateProperty.all(
                  const Color(0xFF9144FF),
                   ),
                thickness: WidgetStateProperty.all(4),
                radius: const Radius.circular(6),
              ),
              child: Scrollbar(
                thumbVisibility: false,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: suggestions.length,
                  itemBuilder: (_, i) {
                    return ListTile(
                      dense: true,
                      title: Text(
                        suggestions[i],
                        style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFFFFFFFF)),
                      ),
                      onTap: () => _applySuggestion(suggestions[i]),
                      );
                    },
                  ),
                ),
    ),),



        const SizedBox(height: 10),

        /// 💰 + 🏠 DROPDOWN ROW
        Row(
          children: [
            Expanded(
              child: _buildDropdown(
                hint: "Budget",
                value: selectedBudget,
                items: budgetOptions,
                onChanged: (searchLocation.isEmpty)
                    ? null // ❌ disable if location empty
                    : (val) { _locationFocus.unfocus();
                  setState(() {
                    selectedBudget = val;
                    showResults = true;
                    showSuggestions = false;
                  });
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildDropdown(
                hint: "BHK",
                value: selectedBhk,
                items: bhkOptions,
                onChanged: (searchLocation.isEmpty)
                    ? null
                    : (val) { _locationFocus.unfocus();
                  setState(() {
                    selectedBhk = val;
                    showResults = true;
                    showSuggestions = false;
                  });
                },

              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        /// 🔥 RESULT BOX (ONLY 300px)
        if (showResults)
          Container(
            height: 300,
            decoration: BoxDecoration(
              color: const Color(0xFF181818),
              borderRadius: BorderRadius.circular(12),
            ),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("properties")
                  .orderBy("createdAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                      child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                final filtered = docs.where((doc) {
                  final data =
                  doc.data() as Map<String, dynamic>;


                  /// LOCATION (Improved Search)
                  if (searchLocation.length >= 2) {
                    final locality =
                    (data["locality"] ?? "").toString().toLowerCase();

                    final city =
                    (data["city"] ?? "").toString().toLowerCase();

                    // Combine locality + city
                    final combined = "$locality $city";

                    // Split search words (e.g. "phase 1 delhi")
                    final words = searchLocation.split(" ");

                    // Every word must match somewhere
                    for (final w in words) {
                      if (!combined.contains(w)) {
                        return false;
                      }
                    }
                  }


                  /// BHK
                  if (selectedBhk != null) {
                    if (selectedBhk == "4+") {
                      if (data["bhk"] < 4) return false;
                    } else {
                      if (data["bhk"].toString() != selectedBhk) {
                        return false;
                      }
                    }
                  }

                  /// BUDGET
                  if (selectedBudget != null) {
                    final price = data["price"] ?? 0;

                    switch (selectedBudget) {
                      case "Under 20L":
                        if (price > 2000000) return false;
                        break;
                      case "20L - 50L":
                        if (price < 2000000 ||
                            price > 5000000) {
                          return false;
                        }
                        break;
                      case "50L - 1Cr":
                        if (price < 5000000 ||
                            price > 10000000) {
                          return false;
                        }
                        break;
                      case "1Cr+":
                        if (price < 10000000) return false;
                        break;
                    }
                  }

                  return true;
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      "No properties found",
                      style:
                      TextStyle(color: Colors.white70),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) =>
                      PropertyBrowseCard(data: filtered[i]),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildDropdown({
    required String hint,
    required String? value,
    required List<String> items,
    required ValueChanged<String?>? onChanged,
  }) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      isExpanded: true,
      dropdownColor: const Color(0xFF272727),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(color: Color(0x80DDDDDD)),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFD9D9D9),
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(
            color: Color(0xFFB974FF),
            width: 2,
          ),
        ),
      ),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      style: const TextStyle(color: Colors.white),
      items: items
          .map(
            (e) =>
            DropdownMenuItem<String>(
              value: e,
              child: Text(e),
            ),
      )
          .toList(),
      onChanged: onChanged,
    );
  }
}