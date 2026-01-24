import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// PropertySearch widget allows users to search properties based on
/// location, budget, and type (e.g., BHK/RK).
/// It provides suggestions as the user types.
class PropertySearch extends StatefulWidget {
  /// Callback to return the constructed Firestore query along with
  /// budget and type
  final void Function(Query query, int budget, String? type) onSearch;

  const PropertySearch({required this.onSearch, super.key});

  @override
  State<PropertySearch> createState() => _PropertySearchState();
}

class _PropertySearchState extends State<PropertySearch> {
  /// Checks if the input string contains any number (used for budget detection)
  bool _isBudget(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  /// Extract numeric budget from string and convert L (lakh) to integer
  int? _parseBudget(String text) {
    final match = RegExp(r'\d+').stringMatch(text); // find first number
    if (match == null) return null;

    int value = int.parse(match);
    if (text.toLowerCase().contains('l')) {
      value *= 100000; // Convert lakhs to actual value
    }
    return value;
  }

  /// Extract location by removing digits, BHK/RK keywords, etc.
  String _extractLocation(String text) {
    final parts = text.split(' ');
    final buffer = <String>[];

    for (var p in parts) {
      if (!RegExp(r'\d|bhk|rk').hasMatch(p)) {
        buffer.add(p);
      }
    }

    return buffer.join(' ').trim();
  }

  /// Extract property type from input (e.g., "1BHK", "1RK")
  String? _extractType(String text) {
    final match = RegExp(r'\d+\s*(bhk|rk)', caseSensitive: false)
        .firstMatch(text);
    return match?.group(0)?.toUpperCase();
  }

  /// Applies suggestion selected by the user to the search input
  void _applySuggestion(String suggestion) {
    final text = _search.text.trim();

    // Remove last word typed by user
    final parts = text.split(' ');
    if (parts.isNotEmpty) {
      parts.removeLast();
    }

    parts.add(suggestion);

    _search.text = parts.join(' ') + ' '; // Add trailing space for next word
  }

  final _search = TextEditingController(); // Controller for search input
  List<String> _suggestions = [];          // Autocomplete suggestions list

  /// Fetch suggestions from Firestore based on user input
  Future<void> _fetchSuggestions(String value) async {
    if (value.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    // Fetch all location docs (consider optimizing in future)
    final snap = await FirebaseFirestore.instance
        .collection('location')
        .get();

    final set = <String>{};
    final v = value.toLowerCase();

    // Search for location matches
    for (var doc in snap.docs) {
      for (var key in doc['searchKeys']) {
        if (key.toString().toLowerCase().contains(v)) {
          set.add(key.toString());
        }
      }
    }

    // Add fixed budget suggestions if input contains numbers
    if (_isBudget(value)) {
      set.add("10L");
      set.add("20L");
      set.add("50L");
    }

    // Add property type suggestions if user types letters like b/r
    if (v.contains('b') || v.contains('r')) {
      set.add("1RK");
      set.add("1BHK");
      set.add("2BHK");
      set.add("3BHK");
    }

    setState(() {
      _suggestions = set.take(8).toList(); // Limit to 8 suggestions
    });
  }

  /// Trigger search by parsing input and calling the callback
  void _searchNow(String text) {
    final lower = text.toLowerCase();

    final budget = _parseBudget(lower);
    final type = _extractType(lower);
    final location = _extractLocation(lower);

    // Require both location and budget to perform search
    if (location.isEmpty || budget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter location and budget"),
        ),
      );
      return;
    }

    // Build Firestore query
    final q = FirebaseFirestore.instance
        .collection('location')
        .where('searchKeys', arrayContains: location);

    widget.onSearch(q, budget, type);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Column(
        children: [
          // Search input field
          TextField(
            style: const TextStyle(
              color: Color(0xFFDDDDDD), // User input text color
              fontSize: 16,
            ),
            controller: _search,
            onChanged: _fetchSuggestions, // Fetch suggestions as user types
            onSubmitted: _searchNow,      // Trigger search on Enter/Submit
            decoration: InputDecoration(
              hintText: "Please Enter location, budget, type",
              hintStyle: const TextStyle(
                color: Color(0x80DDDDDD), // Hint/suggestion text color
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

          // Suggestion list under search field
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
                        fontSize: 14.0,
                      ),
                    ),
                    onTap: () {
                      _applySuggestion(_suggestions[i]); // Apply selected suggestion
                      setState(() => _suggestions.clear()); // Clear suggestions
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
