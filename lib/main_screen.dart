import 'package:bodmas_wealth/add_property_screen.dart';
import 'package:bodmas_wealth/home/home_screen.dart';
import 'package:bodmas_wealth/loans_screen.dart';
import 'package:bodmas_wealth/property/property_browse_screen.dart';
import 'package:bodmas_wealth/user_profile_screen.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  int _currentIndex = 0;

  //  STYLES
  static const Color _selectedColor = Color(0xFF9144FF);
  static const Color _unSelectedColor = Color(0xFFA684FF);

  static const double _selectedIconSize = 24;
  static const double _unSelectedIconSize = 20;
  static const TextStyle _selectedLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle _unSelectedLabelStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
  );

  final List<Widget> _screens = const [
    HomeScreen(),   //  existing code
    LoansScreen(),
    PropertyBrowseScreen(),
    AddPropertyScreen(),
    UserProfileScreen(),
   // ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),

        selectedItemColor: _selectedColor,
        unselectedItemColor: _unSelectedColor,

        selectedLabelStyle: _selectedLabelStyle,
        unselectedLabelStyle: _unSelectedLabelStyle,

        selectedIconTheme: const IconThemeData(
          size: _selectedIconSize,
        ),
        unselectedIconTheme: const IconThemeData(
          size: _unSelectedIconSize,
        ),

        type: BottomNavigationBarType.fixed,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.square),
            label: "demo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Property",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "listing",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}
