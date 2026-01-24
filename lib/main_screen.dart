import 'package:bodmas_wealth/add_property_screen.dart';
import 'package:bodmas_wealth/home/home_screen.dart';
import 'package:bodmas_wealth/loans_screen.dart';
import 'package:bodmas_wealth/property/property_browse_screen.dart';
import 'package:bodmas_wealth/user_profile_screen.dart';
import 'package:flutter/material.dart';

/// ===========================
/// MAIN SCREEN
/// ===========================
/// Root screen with BottomNavigationBar
/// to switch between main sections of the app
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  // Currently selected bottom navigation index
  int _currentIndex = 0;

  /// ===========================
  /// STYLES
  /// ===========================
  static const Color _selectedColor = Color(0xFF9144FF);       // Active tab color
  static const Color _unSelectedColor = Color(0xFFA684FF);     // Inactive tab color

  static const double _selectedIconSize = 24;                  // Active icon size
  static const double _unSelectedIconSize = 20;                // Inactive icon size

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
  /// IndexedStack allows maintaining state of each screen
  /// instead of rebuilding each time a tab is selected
  final List<Widget> _screens = const [
    HomeScreen(),            // Home tab
    LoansScreen(),           // Loans tab
    PropertyBrowseScreen(),  // Property browse tab
    AddPropertyScreen(),     // Add new property tab
    UserProfileScreen(),     // User profile tab
    // ProfileScreen(),       // Optional / future screen
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// ===========================
      /// BODY
      /// ===========================
      /// Using IndexedStack to keep the state of each screen
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),

      /// ===========================
      /// BOTTOM NAVIGATION BAR
      /// ===========================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index), // Change tab

        // Colors
        selectedItemColor: _selectedColor,
        unselectedItemColor: _unSelectedColor,

        // Label styles
        selectedLabelStyle: _selectedLabelStyle,
        unselectedLabelStyle: _unSelectedLabelStyle,

        // Icon sizes
        selectedIconTheme: const IconThemeData(
          size: _selectedIconSize,
        ),
        unselectedIconTheme: const IconThemeData(
          size: _unSelectedIconSize,
        ),

        type: BottomNavigationBarType.fixed, // Keep all tabs visible

        // Bottom navigation items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",       // Home tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.square),
            label: "demo",       // Loans tab (placeholder label)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.square),
            label: "Property",   // Property browse tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "listing",    // Add property tab
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",    // User profile tab
          ),
        ],
      ),
    );
  }
}
