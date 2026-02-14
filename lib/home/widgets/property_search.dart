import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// PropertySearch widget
/// Allows user to:
/// - Enter location (with suggestions)
/// - Select budget
/// - Select property type
/// - Press Enter to trigger search
class PropertySearch extends StatefulWidget {
  final void Function(Query query, int budget, String? type) onSearch;

  const PropertySearch({required this.onSearch, super.key});

  @override
  State<PropertySearch> createState() => _PropertySearchState();
}

class _PropertySearchState extends State<PropertySearch> {
  /// Controller for location input field
  final TextEditingController _locationController = TextEditingController();

  /// Selected dropdown values
  int? _selectedBudget;
  String? _selectedType;

  /// Suggestion list for location
  List<String> _suggestions = [];

  /// Budget options (in rupees)
  final List<int> _budgetOptions = [
    1000000, // 10L
    2000000, // 20L
    5000000, // 50L
  ];

  /// Property type options
  final List<String> _typeOptions = [
    "1RK",
    "1BHK",
    "2BHK",
    "3BHK",
  ];

  /// Fetch location suggestions from Firestore
  Future<void> _fetchSuggestions(String value) async {
    if (value.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    final snap = await FirebaseFirestore.instance
        .collection('location')
        .get();

    final set = <String>{};
    final v = value.toLowerCase();

    for (var doc in snap.docs) {
      for (var key in doc['searchKeys']) {
        if (key.toString().toLowerCase().contains(v)) {
          set.add(key.toString());
        }
      }
    }

    setState(() {
      _suggestions = set.take(8).toList(); // Limit to 8 suggestions
    });
  }

  /// Try triggering search when required fields are available
  void _trySearch() {
    final location = _locationController.text.trim().toLowerCase();

    // Search only if location and budget are selected
    if (location.isNotEmpty && _selectedBudget != null) {
      final query = FirebaseFirestore.instance
          .collection('location')
          .where('searchKeys', arrayContains: location);

      widget.onSearch(query, _selectedBudget!, _selectedType);

      // Optional: clear suggestions after search
      setState(() => _suggestions.clear());
    }
  }



  /// Trigger search when user presses Enter
  void _searchNow(String value) {
    final location = value.trim().toLowerCase();

    if (location.isEmpty || _selectedBudget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter location and select budget"),
        ),
      );
      return;
    }

    /// Build Firestore query using selected location
    final query = FirebaseFirestore.instance
        .collection('location')
        .where('searchKeys', arrayContains: location);

    widget.onSearch(query, _selectedBudget!, _selectedType);

    /// Clear suggestions after search
    setState(() => _suggestions.clear());
  }

  /// Format budget into Lakh display
  String _formatBudget(int value) {
    return "${value ~/ 100000}L";
  }

  /// Apply suggestion into text field
  void _applySuggestion(String suggestion) {
    _locationController.text = suggestion;
    _locationController.selection = TextSelection.fromPosition(
      TextPosition(offset: suggestion.length),
    );

    setState(() => _suggestions.clear());
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        /// 🔍 Location Input Field
        TextField(
          controller: _locationController,
          style: const TextStyle(
            color: Color(0xFFDDDDDD),
            fontSize: 16,
          ),
          onChanged: _fetchSuggestions,     // Fetch suggestions on typing
          //onSubmitted: _searchNow,          // Trigger search on Enter
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

        /// Suggestion list below location field
        if (_suggestions.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              itemBuilder: (_, i) {
                return ListTile(
                  title: Text(
                    _suggestions[i],
                    style: const TextStyle(
                      color: Color(0xFFC7CED5),
                      fontSize: 14,
                    ),
                  ),
                  onTap: () => _applySuggestion(_suggestions[i]),
                );
              },
            ),
          ),

        const SizedBox(height: 10),

        /// 💰 Budget and 🏠 Type in Same Row
        Row(
          children: [

            /// Budget Dropdown
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedBudget,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Color(0xFFDDDDDD)),
                decoration: InputDecoration(
                  labelText: "Budget",
                  labelStyle: const TextStyle(color: Color(0x80DDDDDD)),
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
                ),
                items: _budgetOptions.map((budget) {
                  return DropdownMenuItem<int>(
                    value: budget,
                    child: Text(_formatBudget(budget)),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedBudget = value;
                  });

                  _trySearch(); // Trigger auto search
                },

              ),
            ),

            const SizedBox(width: 10),

            /// Type Dropdown
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedType,
                dropdownColor: const Color(0xFF1E1E1E),
                style: const TextStyle(color: Color(0xFFDDDDDD)),
                decoration: InputDecoration(
                  labelText: "Type",
                  labelStyle: const TextStyle(color: Color(0x80DDDDDD)),
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
                ),
                items: _typeOptions.map((type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });

                  _trySearch(); // Trigger auto search
                },

              ),
            ),
          ],
        ),
      ],
    );
  }
}
