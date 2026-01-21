import 'package:bodmas_wealth/auth/auth_service.dart';
import 'package:bodmas_wealth/home/widgets/property_list.dart';
import 'package:bodmas_wealth/home/widgets/property_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LoansScreen extends StatefulWidget {
  const LoansScreen({Key? key}) : super(key: key);

  @override
  State<LoansScreen> createState() => _LoansScreenState();
}

class _LoansScreenState extends State<LoansScreen> {

  Query? _query;
  int? _budget;
  String? _type;
  bool _showResult = false;

  void onSearch(Query q, int budget, String? type) {
    setState(() {
      _query = q;
      _budget = budget;
      _type = type;
      _showResult = true;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loans'),
      ),
      body:  Column(
    children: [
    // Optional: you can keep your 'Loans Screen' text at the top
    Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
    child: const Text(
    'Loans Screeyifgggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggggg'
        'ggggggggggggggggggggggggggggggggggggggggggggggggggggggggggn',
    style: TextStyle(fontSize: 18),
    ),
    ),
    ),

      PropertySearch(onSearch: onSearch), // 👈 SINGLE SEARCH BAR

      if (_showResult && _query != null && _budget != null)
        Expanded(
          child: PropertyList(
            query: _query!,     // 🔥 yahin se aata hai
            budget: _budget!,   // 🔥 yahin se aata hai
            type: _type,        // 🔥 optional
          ),
        ),
      const SizedBox(height: 10),

      SizedBox(
        width: 200, // Sets the width
        height: 50, //
        child: ElevatedButton(
          onPressed: () async{

            await AuthService().logout();



            //Navigator.pushNamed(context, AppRoutes.home);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Log Out Successfully")),
            );
          },

          style: ElevatedButton.styleFrom(
            // Set the background color of the button
            backgroundColor: Color(0xFF9144FF),

            // Set the text color (foreground color)
            foregroundColor: Color(0xFFDDDDDD),
            textStyle: TextStyle(
              fontSize: 15.0, //  font size here
              fontWeight: FontWeight.w500,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text("Log Out"),
        ),
      ),

    ],
    ),

    );
  }
}
