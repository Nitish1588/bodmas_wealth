import 'package:bodmas_wealth/home/home_screen.dart';
import 'package:bodmas_wealth/property/property_browse_screen.dart';
import 'package:bodmas_wealth/property_management/add_property_screen.dart';
import 'package:bodmas_wealth/user_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ===========================
/// MAIN SCREEN
/// ===========================
/// Root screen with BottomNavigationBar
/// This is shown AFTER user is logged in
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  /// Currently selected bottom navigation index
  int _currentIndex = 0;

  /// ===========================
  /// STYLES
  /// ===========================
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

  /// ===========================
  /// SCREENS
  /// ===========================
  /// IndexedStack keeps each tab state alive
  final List<Widget> _screens = const [
    HomeScreen(),
    PropertyBrowseScreen(),
    AddPropertyScreen(),
    UserProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // System back is handled manually
      canPop: false,

      // Android back button callback (Flutter 3.22+)
      onPopInvokedWithResult: (didPop, result) {

        // If not on Home tab → go to Home
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return;
        }

        // If already on Home tab → exit app
        SystemNavigator.pop();
      },

      child: Scaffold(
        /// ===========================
        /// BODY
        /// ===========================
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),

        /// ===========================
        /// BOTTOM NAVIGATION BAR
        /// ===========================
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },

          // Colors
          selectedItemColor: _selectedColor,
          unselectedItemColor: _unSelectedColor,

          // Label styles
          selectedLabelStyle: _selectedLabelStyle,
          unselectedLabelStyle: _unSelectedLabelStyle,

          // Icon sizes
          selectedIconTheme: const IconThemeData(size: _selectedIconSize),
          unselectedIconTheme: const IconThemeData(size: _unSelectedIconSize),

          type: BottomNavigationBarType.fixed,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.square),
              label: "Property",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: "Listing",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
}
