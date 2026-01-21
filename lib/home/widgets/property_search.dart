import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PropertySearch extends StatefulWidget {
  final void Function(Query query, int budget, String? type) onSearch;

  const PropertySearch({required this.onSearch, super.key});

  @override
  State<PropertySearch> createState() => _PropertySearchState();
}

class _PropertySearchState extends State<PropertySearch> {
  bool _isBudget(String text) {
    return RegExp(r'\d').hasMatch(text);
  }

  int? _parseBudget(String text) {
    final match = RegExp(r'\d+').stringMatch(text);
    if (match == null) return null;

    int value = int.parse(match);
    if (text.toLowerCase().contains('l')) {
      value *= 100000; // lakh
    }
    return value;
  }
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

  String? _extractType(String text) {
    final match = RegExp(r'\d+\s*(bhk|rk)', caseSensitive: false)
        .firstMatch(text);
    return match?.group(0)?.toUpperCase();
  }
  void _applySuggestion(String suggestion) {
    final text = _search.text.trim();

    // split existing text
    final parts = text.split(' ');

    // remove last word (jo user type kar raha tha)
    if (parts.isNotEmpty) {
      parts.removeLast();
    }

    parts.add(suggestion);

    _search.text = parts.join(' ') + ' ';
  }

  final _search = TextEditingController();
  List<String> _suggestions = [];

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

    // 💰 Budget suggestions
    if (_isBudget(value)) {
      set.add("10L");
      set.add("20L");
      set.add("50L");
    }

    // 🏠 Type suggestions
    if (v.contains('b') || v.contains('r')) {
      set.add("1RK");
      set.add("1BHK");
      set.add("2BHK");
      set.add("3BHK");
    }

    setState(() {
      _suggestions = set.take(8).toList(); // limit suggestions
    });
  }


  void _searchNow(String text) {
    final lower = text.toLowerCase();

    final budget = _parseBudget(lower);
    final type = _extractType(lower);
    final location = _extractLocation(lower);

    if (location.isEmpty || budget == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Enter location and budget"),
        ),
      );
      return;
    }

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
          TextField(
              style: const TextStyle(
                color: Color (0xFFDDDDDD), // INPUT text color
                fontSize: 16,),
            controller: _search,
            onChanged: _fetchSuggestions,
            decoration: InputDecoration(
              hintText: "Please Enter location, budget, type",
              hintStyle: const TextStyle(
                color: Color (0x80DDDDDD), // suggestion / hint text color
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
            onSubmitted: _searchNow,
          ),

          if (_suggestions.isNotEmpty)
            Container(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _suggestions.length,
                itemBuilder: (_, i) {
                  return ListTile(
                    title: Text(_suggestions[i],
                      style: TextStyle(
                      color: Color(0xFFC7CED5), // or a specific color code like Color(0xFF42A5F5)
                      fontSize: 14.0, // size in logical pixels
                    ),),

                    onTap: () {
                      _applySuggestion(_suggestions[i]);
                      setState(() => _suggestions.clear());
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
